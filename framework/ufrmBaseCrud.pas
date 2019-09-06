unit ufrmBaseCrud;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Buttons, Vcl.ExtCtrls, System.Actions, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.DBCtrls,
  System.ImageList, Vcl.ImgList, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, dmConexao;

type
  TfrmBaseCrud = class(TForm)
    imgHabilitado: TImageList;
    pnlButtons: TPanel;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton1: TSpeedButton;
    actCrud: TActionList;
    actInserir: TAction;
    actEditar: TAction;
    actCancelar: TAction;
    actSalvar: TAction;
    actExcluir: TAction;
    actSair: TAction;
    pnlBase: TPanel;
    dsPadrao: TDataSource;
    fdPadrao: TFDQuery;
    procedure actInserirExecute(Sender: TObject);
    procedure actEditarExecute(Sender: TObject);
    procedure actCancelarExecute(Sender: TObject);
    procedure actSalvarExecute(Sender: TObject);
    procedure actExcluirExecute(Sender: TObject);
    procedure actSairExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  protected
    FFocus, FFocusEdit: TDBEdit;
    function GetSQLPadrao: string; virtual; abstract;
  public
  end;

implementation

{$R *.dfm}

procedure TfrmBaseCrud.actCancelarExecute(Sender: TObject);
begin
  fdPadrao.Cancel;
end;

procedure TfrmBaseCrud.actEditarExecute(Sender: TObject);
begin
  fdPadrao.Edit;
end;

procedure TfrmBaseCrud.actExcluirExecute(Sender: TObject);
begin
  if not fdPadrao.IsEmpty then
  begin
    if MessageDlg('Deseja realmente excluir?', mtConfirmation, [mbYes, mbNo],
      -1) = mrYes then
      fdPadrao.Delete;
  end;
end;

procedure TfrmBaseCrud.actInserirExecute(Sender: TObject);
begin
  fdPadrao.Insert;
  if Assigned(FFocus) then
    FFocus.SetFocus;
end;

procedure TfrmBaseCrud.actSairExecute(Sender: TObject);
begin
  Self.Close;
  Self.Destroy;
end;

procedure TfrmBaseCrud.actSalvarExecute(Sender: TObject);
begin
  if fdPadrao.State in [dsInsert, dsEdit] then
  begin
    fdPadrao.Post;
    ShowMessage('Salvo com sucesso!');
  end;
end;

procedure TfrmBaseCrud.FormCreate(Sender: TObject);
begin
  fdPadrao.SQL.Text := GetSQLPadrao;
  fdPadrao.Open;
end;

end.
