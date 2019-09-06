unit uFrmConsulta;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TResultado = record
    Confirmou: Boolean;
    Chave: string;
  end;

  TfrmConsulta = class(TForm)
    dbgConsulta: TDBGrid;
    fdConsulta: TFDQuery;
    dsConsulta: TDataSource;
    procedure dbgConsultaDblClick(Sender: TObject);
  private
    FTabela: string;
    FChave: string;
    FFiltro: string;
    FRetorno: TResultado;
    { Private declarations }
    procedure CarregarDados;
  public
    { Public declarations }
    class function Exibir(ATabela, AChave: string; AFiltro: string = ''): TResultado;
  end;

implementation

{$R *.dfm}

uses dmConexao;

{ TfrmConsulta }

procedure TfrmConsulta.CarregarDados;
begin
  fdConsulta.Open('SELECT * FROM ' + FTabela + FFiltro);
end;

procedure TfrmConsulta.dbgConsultaDblClick(Sender: TObject);
begin
  if not fdConsulta.IsEmpty then
  begin
    FRetorno.Confirmou := True;
    FRetorno.Chave := fdConsulta.FieldByName(FChave).AsString;
    ModalResult := mrOk;
  end;
end;

class function TfrmConsulta.Exibir(ATabela, AChave, AFiltro: string): TResultado;
var
  vForm: TfrmConsulta;
begin
  vForm := TfrmConsulta.Create(nil);
  try
    vForm.FTabela := ATabela;
    vForm.FChave := AChave;
    vForm.FFiltro := AFiltro;
    vForm.CarregarDados;
    if vForm.ShowModal = mrOk then
      Result := vForm.FRetorno
    else
      Result.Confirmou := False;
  finally
    FreeAndNil(vForm);
  end;
end;

end.
