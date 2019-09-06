unit uUtilCampeonato;

interface

uses System.Generics.Collections;

type
  TStatus = (tsAguardando, tsAndamento, tsFinalizado);

  TPlayer = record
    ID: Integer;
    Nome: string;
  end;

  TEquipe = record
    ID: Integer;
    Nome: string;
  strict private
    FPlayers: TList<TPlayer>;
  private
    procedure CarregarPlayers;
    function GetPlayers: TList<TPlayer>;
  public
    function CarregarEquipes(AIDCampeonato: Integer): TList<TEquipe>;
    procedure Clear;

    property Players: TList<TPlayer> read GetPlayers;
  end;

  TPontuacao = record
    FPonto1: Integer;
    FPonto2: Integer;
  end;

  TPartida = record
    FEquipe1: TEquipe;
    FEquipe2: TEquipe;
    FPontuacao: TPontuacao;
    FStatus: TStatus;
    FHora: TDateTime;
  public
    function GetVencedor: TEquipe;
  end;

  TRodada = record
    ID: Integer;
    Descricao: string;
    Observacao: string;
    Status: TStatus;
  strict private
    FPartidas: TList<TPartida>;
    FVencedores: TList<TEquipe>;
  private
    function GetPartidas: TList<TPartida>;
    function GetVencedores: TList<TEquipe>;

    procedure SetPartidas(const Value: TList<TPartida>);
    procedure SetVencedores(const Value: TList<TEquipe>);

    procedure AlimentarVencedores;
  public
    procedure Clear;

    property Partidas: TList<TPartida> read GetPartidas write SetPartidas;
    property Vencedores: TList<TEquipe> read GetVencedores write SetVencedores;
  end;

  TCampeonato = record
    FID: Integer;
  end;

  TPontuacaoPlayer = record
    Player: TPlayer;
    Partida: TPartida;
    Kill: Integer;
    Death: Integer;
  end;
  
implementation

{ TPartida }

function TPartida.GetVencedor: TEquipe;
begin
  if FPontuacao.FPonto1 > FPontuacao.FPonto2 then
    Result := FEquipe1
  else
    Result := FEquipe2;
end;

{ TRodada }

procedure TRodada.AlimentarVencedores;
var
  vPartida: TPartida;
begin
  for vPartida in Partidas do
    FVencedores.Add(vPartida.GetVencedor);
end;

procedure TRodada.Clear;
begin
  FPartidas.Free;
  FVencedores.Free;
end;

function TRodada.GetPartidas: TList<TPartida>;
begin
  if not Assigned(FPartidas) then
    FPartidas := TList<TPartida>.Create;
  Result := FPartidas;
end;

function TRodada.GetVencedores: TList<TEquipe>;
begin
  if not Assigned(FVencedores) then
    FVencedores := TList<TEquipe>.Create;
  AlimentarVencedores;
  Result := FVencedores;
end;

procedure TRodada.SetPartidas(const Value: TList<TPartida>);
begin
  if Assigned(Value) then
  begin
    FPartidas.Free;
    FPartidas := Value;
  end;
end;

procedure TRodada.SetVencedores(const Value: TList<TEquipe>);
begin
  if Assigned(Value) then
  begin
    FVencedores.Free;
    FVencedores := Value;
  end;
end;

{ TEquipe }
function TEquipe.CarregarEquipes(AIDCampeonato: Integer): TList<TEquipe>;
begin
  Result := TList<TEquipe>.Create;
  // SQL IN ID CAMPEONATO!
  Self.ID := 1;
  Self.Nome := 'Gremio';
  Self.FPlayers := TList<TPlayer>.Create;
  CarregarPlayers;
  Result.Add(Self);
end;

procedure TEquipe.CarregarPlayers;
var
  vPlayer: TPlayer;
begin
  // SQL Players = Self.ID;
  vPlayer.ID := 1;
  vPlayer.Nome := 'Ricardo';
  Self.Players.Add(vPlayer);
end;

procedure TEquipe.Clear;
begin
  if FPlayers <> nil then
    FPlayers.Free;
end;

function TEquipe.GetPlayers: TList<TPlayer>;
begin
  if not Assigned(FPlayers) then
    FPlayers := TList<TPlayer>.Create;
  Result := FPlayers;
end;

end.
