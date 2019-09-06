unit uFrmCampeonato;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ufrmBaseCrud, System.Actions,
  Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.Buttons, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.Grids,
  Vcl.DBGrids;

type
  TfrmCampeonato = class(TfrmBaseCrud)
    Panel1: TPanel;
    edtInserirItem: TSpeedButton;
    btnExcluirItem: TSpeedButton;
    Label1: TLabel;
    DBGrid2: TDBGrid;
    fdItens: TFDQuery;
    dsItens: TDataSource;
    fdItensTIM_ID: TIntegerField;
    fdItensCAM_ID: TIntegerField;
    fdItensTIM_NOME: TStringField;
    edtQtdeTimes: TDBEdit;
    fdItensQtde_Times: TAggregateField;
    Label3: TLabel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    edtCodigo: TDBEdit;
    edtNome: TDBEdit;
    lblNome: TLabel;
    Label2: TLabel;
    cbTipo: TDBComboBox;
    lblCodigo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnExcluirItemClick(Sender: TObject);
    procedure edtInserirItemClick(Sender: TObject);
    procedure fdPadraoNewRecord(DataSet: TDataSet);
  private
  protected
    function GetSQLPadrao: string; override;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses uFrmConsulta, uUtilDB;

{ TfrmCampeonato }

procedure TfrmCampeonato.btnExcluirItemClick(Sender: TObject);
begin
  if not fdItens.IsEmpty then
  begin
    if MessageDlg('Deseja realmente excluir?', mtConfirmation, [mbYes, mbNo],
      -1) = mrYes then
      fdItens.Delete;
  end;
end;

procedure TfrmCampeonato.edtInserirItemClick(Sender: TObject);
var
  vResult: TResultado;
begin
  if not fdPadrao.IsEmpty then
  begin
    fdItens.Append;
    fdItens.FieldByName('CAM_ID').AsInteger :=
      fdPadrao.FieldByName('CAM_ID').AsInteger;
    vResult := TfrmConsulta.Exibir('TIMES', 'TIM_ID');
    if vResult.Confirmou then
      fdItens.FieldByName('TIM_ID').AsString := vResult.Chave
    else
    begin
      fdItens.Cancel;
      Exit;
    end;
    fdItens.Post;
  end;
  fdItens.Refresh;
end;

procedure TfrmCampeonato.fdPadraoNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('CAM_ID').AsInteger :=
    GetNewSequence('GEN_CAMPEONATO_ID');
end;

procedure TfrmCampeonato.FormCreate(Sender: TObject);
begin
  inherited;
  FFocus := edtNome;
  fdItens.Open;
end;

function TfrmCampeonato.GetSQLPadrao: string;
begin
  Result :=
    'SELECT CAMPEONATO.CAM_ID, ' +
    '       CAMPEONATO.CAM_NOME, ' +
    '       CAMPEONATO.CAM_TIPO ' +
    '  FROM CAMPEONATO ';
end;

initialization

RegisterClass(TfrmCampeonato);

finalization

UnRegisterClass(TfrmCampeonato);

end.
