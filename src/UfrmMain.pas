unit UfrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, System.Actions, Vcl.ActnList,
  System.ImageList, Vcl.ImgList, Vcl.ExtCtrls, Vcl.Buttons, Vcl.Imaging.jpeg,
  Vcl.Imaging.pngimage;

type
  TfrmPrincipal = class(TForm)
    actList: TActionList;
    actCadastraTime: TAction;
    actCadastraCampeonato: TAction;
    actGerenciarCampeonato: TAction;
    ImgList: TImageList;
    imgList36: TImageList;
    actListGeral: TActionList;
    actSair: TAction;
    actCadastraJogador: TAction;
    imgFundo: TImage;
    pnlGerencia: TPanel;
    SpeedButton1: TSpeedButton;
    pnlButtons: TPanel;
    Image1: TImage;
    btnCampeonato: TSpeedButton;
    btnJogador: TSpeedButton;
    btnCamp: TSpeedButton;
    btnTimes: TSpeedButton;
    procedure actSairExecute(Sender: TObject);
    procedure actCadastraTimeExecute(Sender: TObject);
    procedure actCadastraCampeonatoExecute(Sender: TObject);
    procedure actGerenciarCampeonatoExecute(Sender: TObject);
    procedure actCadastraJogadorExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses uUtilForm;

{$R *.dfm}

procedure TfrmPrincipal.actCadastraCampeonatoExecute(Sender: TObject);
begin
  AbrirForm('TfrmCampeonato');
end;

procedure TfrmPrincipal.actCadastraJogadorExecute(Sender: TObject);
begin
  AbrirForm('TfrmJogador');
end;

procedure TfrmPrincipal.actCadastraTimeExecute(Sender: TObject);
begin
  AbrirForm('TfrmTime');
end;

procedure TfrmPrincipal.actGerenciarCampeonatoExecute(Sender: TObject);
begin
  AbrirForm('TfrmGerCampeonato');
end;

procedure TfrmPrincipal.actSairExecute(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmPrincipal.FormResize(Sender: TObject);
begin
  pnlButtons.Top := Trunc(Self.Height / 2) - Trunc(pnlButtons.Height/ 2);
  pnlButtons.Left := Trunc(Self.Width / 2) - Trunc(pnlButtons.Width/ 2);
end;

end.
