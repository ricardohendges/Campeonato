unit uCampeonatoHandler;

interface

uses uUtilCampeonato, System.Generics.Collections, uUtilDB;

type
  TTipoCampeonato = (tcFinal = 2, tcTodos3 = 3, tcSemiFinal = 4, tcTodos5 = 5,
    tcTodos2x3 = 6, tcTodos1x3e1x4 = 7, tcQuartas = 8, tcTodos3x3 = 9,
    tcTodos2x3e1x4 = 10, tcTodos1x3e2x4 = 11, tcTodos3x4 = 12,
    tcTodos3x3e1x4 = 13, tcETC);

  IControlaCampeonato = interface
    ['{409E4335-664C-409F-A45E-9A0E7BD63BE8}']
    function Nome: string;
    function Rodadas: TList<TRodada>;
    function Equipes: TList<TEquipe>;
    function Partidas: TList<TPartida>;
    procedure SetPartida(APartida: TPartida);
    procedure CriarRodadas(const AEquipes: TList<TEquipe>);
  end;

  TControlaCampeonato = class(TInterfacedObject, IControlaCampeonato)
  strict private
    FIDCamp: Integer;
    FNome: string;
    FStatus: TStatus;
    FRodadas: TList<TRodada>;
    FEquipes: TList<TEquipe>;
    FEquipesJogando: TList<TEquipe>;
    FPartidas: TList<TPartida>;
    constructor Create(AIDCampeonato: Integer); reintroduce;
    destructor Destroy; override;
  private
    procedure GerarQuartasFinal(AEquipes: TList<TEquipe>);
    procedure GerarSemiFinal(AEquipes: TList<TEquipe>);
    procedure GerarFinal(AEquipes: TList<TEquipe>);

    procedure CarregarCampeonato;
    procedure CarregarEquipes;
    procedure CarregarRodadas;

    procedure CriarPartidasRodada(AEquipes: TList<TEquipe>; ARodada: TRodada);
  public
    function Nome: string;

    function Rodadas: TList<TRodada>;
    function Equipes: TList<TEquipe>;
    function Partidas: TList<TPartida>;
    procedure SetPartida(APartida: TPartida);

    procedure CriarRodadas(const AEquipes: TList<TEquipe>);

    class function GetCampeonato(AIDCamp: Integer): IControlaCampeonato; static;
  end;

implementation

uses SysUtils, FireDAC.Comp.Client;

{ TControlaCampeonato }

procedure TControlaCampeonato.CarregarCampeonato;
var
  vQuery: TFDQuery;
  vSQL: string;
begin
  vSQL := 'SELECT CAMPEONATO.CAM_ID, CAMPEONATO.CAM_NOME, ' +
    ' CAMPEONATO.CAM_TIPO, CAMPEONATO.CAM_STATUS FROM CAMPEONATO ' +
    ' WHERE CAMPEONATO.CAM_ID = ' + FIDCamp.ToString;
  vQuery := GetConsulta(vSQL);
  try
    FNome := vQuery.FieldByName('CAM_NOME').AsString;
    FStatus := TStatus(vQuery.FieldByName('CAM_STATUS').AsInteger);
  finally
    vQuery.Free;
  end;
  CarregarEquipes;
  CarregarRodadas;
end;

procedure TControlaCampeonato.CarregarEquipes;
var
  vEquipe: TEquipe;

  vQuery: TFDQuery;
  vSQL: string;
begin
  vSQL := 'SELECT TIMES.TIM_ID, TIMES.TIM_NOME FROM TIMES ' +
    ' LEFT JOIN TIME_CAMPEONATO ON (TIMES.TIM_ID = TIME_CAMPEONATO.TIM_ID) ' +
    ' WHERE TIME_CAMPEONATO.CAM_ID = ' + FIDCamp.ToString;
  vQuery := GetConsulta(vSQL);
  try
    vQuery.First;
    while not vQuery.Eof do
    begin
      vEquipe.ID := vQuery.FieldByName('TIM_ID').AsInteger;
      vEquipe.Nome := vQuery.FieldByName('TIM_NOME').AsString;
      Self.FEquipes.Add(vEquipe);
      vQuery.Next;
    end;
  finally
    vQuery.Free;
  end;
end;

procedure TControlaCampeonato.CarregarRodadas;
var
  vRodada: TRodada;

  vQuery: TFDQuery;
  vSQL: string;
begin
  vSQL := 'SELECT RODADA.ROD_ID, RODADA.ROD_NOME, RODADA.ROD_STATUS ' +
    ' FROM RODADA WHERE RODADA.CAM_ID = ' + FIDCamp.ToString;
  vQuery := GetConsulta(vSQL);
  try
    if not vQuery.IsEmpty then
    begin
      vQuery.First;
      while not vQuery.Eof do
      begin
        vRodada.ID := vQuery.FieldByName('ROD_ID').AsInteger;
        vRodada.Descricao := vQuery.FieldByName('ROD_NOME').AsString;
        vRodada.Status := TStatus(vQuery.FieldByName('ROD_STATUS').AsInteger);
        Self.FRodadas.Add(vRodada);
        vQuery.Next;
      end;
    end
    else
      CriarRodadas(FEquipes);
  finally
    vQuery.Free;
  end;
end;

constructor TControlaCampeonato.Create(AIDCampeonato: Integer);
begin
  inherited Create;
  FIDCamp := AIDCampeonato;
  FRodadas := TList<TRodada>.Create;
  FEquipes := TList<TEquipe>.Create;
  FEquipesJogando := TList<TEquipe>.Create;
  FPartidas := TList<TPartida>.Create;

  CarregarCampeonato;
end;

procedure TControlaCampeonato.CriarPartidasRodada(AEquipes: TList<TEquipe>;
  ARodada: TRodada);
var
  vPartida: TPartida;
  vEquipeSelecionada: Integer;
begin
  while AEquipes.Count > 0 do
  begin
    vPartida.ID := GetNewSequence('GEN_PARTIDA_ID');
    vPartida.Rodada := ARodada;

    vEquipeSelecionada := Random(AEquipes.Count);
    vPartida.Equipe1 := AEquipes.Items[vEquipeSelecionada];
    AEquipes.Delete(vEquipeSelecionada);

    vEquipeSelecionada := Random(AEquipes.Count);
    vPartida.Equipe2 := AEquipes.Items[vEquipeSelecionada];
    AEquipes.Delete(vEquipeSelecionada);

    vPartida.Status := tsAguardando;
    vPartida.Pontuacao.Ponto11 := 0;
    vPartida.Pontuacao.Ponto12 := 0;
    vPartida.Pontuacao.Ponto13 := 0;
    vPartida.Pontuacao.Ponto21 := 0;
    vPartida.Pontuacao.Ponto22 := 0;
    vPartida.Pontuacao.Ponto23 := 0;

    FPartidas.Add(vPartida);
  end;
end;

procedure TControlaCampeonato.CriarRodadas(const AEquipes: TList<TEquipe>);
begin
  case TTipoCampeonato(AEquipes.Count) of
    tcFinal:
      GerarFinal(AEquipes);
    tcSemiFinal:
      GerarSemiFinal(AEquipes);
    tcQuartas:
      GerarQuartasFinal(AEquipes);
  else
    raise Exception.Create('Quantidade de Equipes não tratada.');
  end;
end;

function TControlaCampeonato.Nome: string;
begin
  Result := FNome;
end;

destructor TControlaCampeonato.Destroy;
begin
  FreeAndNil(FRodadas);
  FreeAndNil(FEquipes);
  FreeAndNil(FEquipesJogando);
  FreeAndNil(FPartidas);
  inherited;
end;

function TControlaCampeonato.Equipes: TList<TEquipe>;
begin
  Result := FEquipes;
end;

procedure TControlaCampeonato.GerarFinal(AEquipes: TList<TEquipe>);
var
  vRodada: TRodada;
begin
  vRodada.ID := GetNewSequence('GEN_RODADA_ID');
  vRodada.Descricao := 'Final';
  vRodada.Observacao := '';
  vRodada.Status := tsAguardando;

  CriarPartidasRodada(AEquipes, vRodada);
  FRodadas.Add(vRodada);
end;

procedure TControlaCampeonato.GerarQuartasFinal(AEquipes: TList<TEquipe>);
var
  vRodada: TRodada;
begin
  vRodada.ID := GetNewSequence('GEN_RODADA_ID');
  vRodada.Descricao := 'Quartas';
  vRodada.Observacao := '';
  vRodada.Status := tsAguardando;

  CriarPartidasRodada(AEquipes, vRodada);
  FRodadas.Add(vRodada);
end;

procedure TControlaCampeonato.GerarSemiFinal(AEquipes: TList<TEquipe>);
var
  vRodada: TRodada;
begin
  vRodada.ID := GetNewSequence('GEN_RODADA_ID');
  vRodada.Descricao := 'Semi';
  vRodada.Observacao := '';
  vRodada.Status := tsAguardando;

  CriarPartidasRodada(AEquipes, vRodada);
  FRodadas.Add(vRodada);
end;

class function TControlaCampeonato.GetCampeonato(AIDCamp: Integer)
  : IControlaCampeonato;
begin
  Result := TControlaCampeonato.Create(AIDCamp);
end;

function TControlaCampeonato.Partidas: TList<TPartida>;
begin
  Result := FPartidas;
end;

function TControlaCampeonato.Rodadas: TList<TRodada>;
begin
  Result := FRodadas;
end;

procedure TControlaCampeonato.SetPartida(APartida: TPartida);
var
  vPartida: TPartida;
begin
  for vPartida in FPartidas do
  begin
    if vPartida.ID = APartida.ID then
    begin
      FPartidas.Remove(vPartida);
      FPartidas.Add(APartida);
      Exit;
    end;
  end;
end;

end.
