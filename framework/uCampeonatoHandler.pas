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
    function Rodadas: TList<TRodada>;
    function Equipes: TList<TEquipe>;
    function Partidas(ARodada: TRodada): TList<TPartida>; overload;
    procedure SetPartida(APartida: TPartida);
  end;

  TControlaCampeonato = class(TInterfacedObject, IControlaCampeonato)
  strict private
    FIDCamp: Integer;
    FNome: string;
    FStatus: TStatus;
    FRodadas: TList<TRodada>;
    FEquipes: TList<TEquipe>;
    FEquipesJogando: TList<TEquipe>;
    constructor Create(AIDCampeonato: Integer); reintroduce;
    destructor Destroy; override;
  private
    procedure CarregarRodadas;
    procedure CriarRodadas(const AEquipes: TList<TEquipe>);

    procedure GerarSemiFinal(AEquipes: TList<TEquipe>);

    procedure CarregarEquipes;

    procedure CarregarCampeonato;
  public
    function Rodadas: TList<TRodada>;
    function Equipes: TList<TEquipe>;
    function Partidas(ARodada: TRodada): TList<TPartida>;
    procedure SetPartida(APartida: TPartida);

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

  CarregarCampeonato;
end;

procedure TControlaCampeonato.CriarRodadas(const AEquipes: TList<TEquipe>);
var
  vRodada: TRodada;
begin
  vRodada.Status := tsAguardando;
  case TTipoCampeonato(AEquipes.Count) of
    tcFinal:
      vRodada.Descricao := 'FINAL';
    tcTodos3:
      begin
        vRodada.Descricao := '1 Grupo de 3';
        vRodada.Observacao := 'Todos x Todos, saem os dois melhores!';
      end;
    tcSemiFinal:
      begin
        vRodada.Descricao := 'SEMI FINAL';
        GerarSemiFinal(AEquipes);
      end;
    tcTodos5:
      begin
        vRodada.Descricao := '';
        GerarSemiFinal(AEquipes);
      end;
    tcTodos2x3:
      begin
        vRodada.Descricao := 'SEMI FINAL';
        GerarSemiFinal(AEquipes);
      end;
    tcTodos1x3e1x4:
      begin
        vRodada.Descricao := 'SEMI FINAL';
        GerarSemiFinal(AEquipes);
      end;
    tcQuartas:
      begin
        vRodada.Descricao := 'SEMI FINAL';
        GerarSemiFinal(AEquipes);
      end;
    tcTodos3x3:
      begin
        vRodada.Descricao := 'SEMI FINAL';
        GerarSemiFinal(AEquipes);
      end;
    tcTodos2x3e1x4:
      begin
        vRodada.Descricao := 'SEMI FINAL';
        GerarSemiFinal(AEquipes);
      end;
    tcTodos1x3e2x4:
      begin
        vRodada.Descricao := 'SEMI FINAL';
        GerarSemiFinal(AEquipes);
      end;
    tcTodos3x4:
      begin
        vRodada.Descricao := 'SEMI FINAL';
        GerarSemiFinal(AEquipes);
      end;
    tcTodos3x3e1x4:
      begin
        vRodada.Descricao := 'SEMI FINAL';
        GerarSemiFinal(AEquipes);
      end;
    tcETC:
      begin
        vRodada.Descricao := 'SEMI FINAL';
        GerarSemiFinal(AEquipes);
      end;
  else
    raise Exception.Create('Quantidade de Equipes não tratada.');
  end;
  FRodadas.Add(vRodada);
end;

destructor TControlaCampeonato.Destroy;
begin
  FreeAndNil(FRodadas);
  FreeAndNil(FEquipes);
  FreeAndNil(FEquipesJogando);
  inherited;
end;

function TControlaCampeonato.Equipes: TList<TEquipe>;
begin
  if not Assigned(FEquipes) then
    FEquipes := TList<TEquipe>.Create;
  Result := FEquipes;
end;

procedure TControlaCampeonato.GerarSemiFinal(const AEquipes: TList<TEquipe>);
var
  vPartida: TPartida;
begin
  while AEquipes.Count > 0 do
  begin
    Random(Pred(AEquipes.Count));
    vPartida.AEquipes.Delete();
  end;
end;

class function TControlaCampeonato.GetCampeonato(AIDCamp: Integer)
  : IControlaCampeonato;
begin
  Result := TControlaCampeonato.Create(AIDCamp);
end;

function TControlaCampeonato.Partidas(ARodada: TRodada): TList<TPartida>;
begin

end;

function TControlaCampeonato.Rodadas: TList<TRodada>;
begin
  if not Assigned(FRodadas) then
    FRodadas := TList<TRodada>.Create;
  Result := FRodadas;
end;

procedure TControlaCampeonato.SetPartida(APartida: TPartida);
begin

end;

end.
