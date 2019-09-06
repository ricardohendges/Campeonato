unit uGerCampeonato;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uUtilCampeonato, Vcl.ExtCtrls,
  uFrameJogo, Vcl.Buttons, System.Actions, Vcl.ActnList, System.ImageList,
  Vcl.ImgList, uCampeonatoHandler;

type
  TfrmGerCampeonato = class(TForm)
    pnlPrincipal: TPanel;
    imgHabilitado: TImageList;
    actCrud: TActionList;
    actSair: TAction;
    pnlInfos: TPanel;
    SpeedButton1: TSpeedButton;
    actPegarCamp: TAction;
    procedure FormCreate(Sender: TObject);
    procedure actSairExecute(Sender: TObject);
    procedure actPegarCampExecute(Sender: TObject);
  private
    FCampeonato: IControlaCampeonato;
    { Private declarations }
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
    FCampeonato := TControlaCampeonato.GetCampeonato(vResult.Chave.ToInteger);
end;

procedure TfrmGerCampeonato.actSairExecute(Sender: TObject);
begin
  Self.Close;
  Self.Destroy;
end;

procedure TfrmGerCampeonato.FormCreate(Sender: TObject);
begin
  actPegarCamp.Execute;
end;

initialization

RegisterClass(TfrmGerCampeonato);

finalization

UnRegisterClass(TfrmGerCampeonato);

end.


uses uCampeonatoHandler;
