unit uGerCampeonato;

interface

uses System.Classes, System.Actions, Vcl.ActnList, System.ImageList,
  Vcl.ImgList, Vcl.Controls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Forms,
  uCampeonatoHandler, uFrameJogo, uUtilFrame, System.sysutils,
  System.Generics.Collections, System.UITypes, Vcl.Menus, uUtilCampeonato,
  uUtilDB, FireDAC.Comp.Client, Data.DB;

type
  TfrmGerCampeonato = class(TForm)
    pnlPrincipal: TPanel;
    imgHabilitado: TImageList;
    actCrud: TActionList;
    actSair: TAction;
    pnlInfos: TPanel;
    SpeedButton1: TSpeedButton;
    actPegarCamp: TAction;
    PP1: TPopupMenu;
    FinalizarRodada1: TMenuItem;
    PP2: TPopupMenu;
    MenuItem1: TMenuItem;
    PP3: TPopupMenu;
    MenuItem2: TMenuItem;
    pnlFase1: TPanel;
    pnlTop1: TPanel;
    pnlFase2: TPanel;
    pnlTop2: TPanel;
    pnlFase3: TPanel;
    pnlTop3: TPanel;
    imgCampeao: TImage;
    procedure FormCreate(Sender: TObject);
    procedure actSairExecute(Sender: TObject);
    procedure actPegarCampExecute(Sender: TObject);
    procedure FinalizarRodada1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
  private
    FCampeonato: IControlaCampeonato;
    FEquipesRestantes: TList<TEquipe>;
    procedure ConfigurarTela;
    function PartidasFinalizadas(APanel: TPanel): Boolean;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses uFrmConsulta;

procedure TfrmGerCampeonato.actPegarCampExecute(Sender: TObject);
var
  vResult: TResultado;
begin
  vResult := TfrmConsulta.Exibir('CAMPEONATO', 'CAM_ID');
  if vResult.Confirmou then
  begin
    FCampeonato := TControlaCampeonato.GetCampeonato(vResult.Chave.ToInteger);
    ConfigurarTela;
  end;
end;

procedure TfrmGerCampeonato.actSairExecute(Sender: TObject);
begin
  Self.Close;
  Self.Destroy;
end;

procedure TfrmGerCampeonato.ConfigurarTela;
var
  vI: Integer;
begin
  pnlInfos.Caption := FCampeonato.Nome;

  pnlFase1.Width := 500;
  pnlFase2.Width := 500;
  pnlFase3.Width := 500;

  for vI := 1 to FCampeonato.Rodadas.Count do
  begin
    case vI of
      1:
        begin
          pnlTop1.Caption := FCampeonato.Rodadas.Items[vI - 1].Descricao;
          CriarFrames(FCampeonato.Partidas, pnlFase1);
        end;
      2:
        begin
          pnlTop2.Caption := FCampeonato.Rodadas.Items[vI - 1].Descricao;
          CriarFrames(FCampeonato.Partidas, pnlFase2);
        end;
      3:
        begin
          pnlTop3.Caption := FCampeonato.Rodadas.Items[vI - 1].Descricao;
          CriarFrames(FCampeonato.Partidas, pnlFase3);
        end;
    end;
  end;
end;

procedure TfrmGerCampeonato.FinalizarRodada1Click(Sender: TObject);
var
  vPartida: TPartida;
begin
  if PartidasFinalizadas(pnlFase1) then
  begin
    FCampeonato.CriarRodadas(FEquipesRestantes);
    pnlFase1.Enabled := False;
    for vPartida in FCampeonato.Partidas do
    begin
      if vPartida.Rodada.Descricao = 'Semi' then
        CriarFrames(1, 2, pnlFase2, vPartida);
    end;
  end;
end;

procedure TfrmGerCampeonato.FormCreate(Sender: TObject);
begin
  actPegarCamp.Execute;
  FEquipesRestantes := TList<TEquipe>.Create;
end;

procedure TfrmGerCampeonato.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FEquipesRestantes);
end;

procedure TfrmGerCampeonato.MenuItem1Click(Sender: TObject);
var
  vPartida: TPartida;
begin
  if PartidasFinalizadas(pnlFase2) then
  begin
    FCampeonato.CriarRodadas(FEquipesRestantes);
    pnlFase2.Enabled := False;
    for vPartida in FCampeonato.Partidas do
    begin
      if vPartida.Rodada.Descricao = 'Final' then
        CriarFrames(1, 3, pnlFase3, vPartida);
    end;
  end;
end;

procedure TfrmGerCampeonato.MenuItem2Click(Sender: TObject);
var
  vSQL: string;
  vQuery: TFDQuery;
  vStream: TMemoryStream;
begin
  if PartidasFinalizadas(pnlFase3) then
  begin
    vSQL := 'SELECT TIM_IMAGEM FROM TIMES WHERE TIM_ID = ' +
      FEquipesRestantes.Items[0].ID.ToString;
    vQuery := GetConsulta(vSQL);

    vStream := TMemoryStream.Create;
    try
      TBlobField(vQuery.FieldByName('TIM_IMAGEM')).SaveToStream(vStream);
      vStream.Position := 0;
      imgCampeao.Picture.LoadFromStream(vStream);
    finally
      FreeAndNil(vQuery);
      FreeAndNil(vStream);
    end;
  end;
end;

function TfrmGerCampeonato.PartidasFinalizadas(APanel: TPanel): Boolean;
var
  I: Integer;
begin
  FEquipesRestantes.Clear;
  Result := True;
  for I := 0 to APanel.ComponentCount - 1 do
  begin
    if APanel.Components[I].ClassName = 'TFrameJogo' then
    begin
      if TFrameJogo(APanel.Components[I]).Terminou then
        FEquipesRestantes.Add(TFrameJogo(APanel.Components[I]).GetVencedor)
      else
        Exit(False);
    end;
  end;
end;

initialization

RegisterClass(TfrmGerCampeonato);

finalization

UnRegisterClass(TfrmGerCampeonato);

end.
