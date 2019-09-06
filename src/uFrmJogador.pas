unit uFrmJogador;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ufrmBaseCrud, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Actions,
  Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids;

type
  TfrmJogador = class(TfrmBaseCrud)
    edtCodigo: TDBEdit;
    edtNome: TDBEdit;
    DBGrid1: TDBGrid;
    lblCodigo: TLabel;
    lblNome: TLabel;
    Label1: TLabel;
    edtNick: TDBEdit;
    procedure FormCreate(Sender: TObject);
    procedure fdPadraoNewRecord(DataSet: TDataSet);
  private
  protected
    function GetSQLPadrao: string; override;
  public
  end;

implementation

{$R *.dfm}

uses uUtilDB;
{ TfrmJogador }

procedure TfrmJogador.fdPadraoNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('PLA_ID').AsInteger := GetNewSequence('GEN_PLAYER_ID');
end;

procedure TfrmJogador.FormCreate(Sender: TObject);
begin
  inherited;
  FFocus := edtNome;
end;

function TfrmJogador.GetSQLPadrao: string;
begin
  Result := 'SELECT PLAYER.PLA_ID, PLAYER.PLA_NOME, PLAYER.PLA_NICK FROM PLAYER ';
end;

initialization

RegisterClass(TfrmJogador);

finalization

UnRegisterClass(TfrmJogador);

end.
