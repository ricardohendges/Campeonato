unit uFrmTime;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ufrmBaseCrud, System.Actions,
  Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.Buttons, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Mask,
  Vcl.DBCtrls;

type
  TfrmTime = class(TfrmBaseCrud)
    Panel1: TPanel;
    edtInserirItem: TSpeedButton;
    btnExcluirItem: TSpeedButton;
    Label1: TLabel;
    Label3: TLabel;
    DBGrid2: TDBGrid;
    edtQtdeTimes: TDBEdit;
    dsItens: TDataSource;
    fdItens: TFDQuery;
    fdItensQtde_Times: TAggregateField;
    fdItensPLA_ID: TIntegerField;
    fdItensTIM_ID: TIntegerField;
    Splitter1: TSplitter;
    pnlTop: TPanel;
    DBGrid1: TDBGrid;
    edtCodigo: TDBEdit;
    edtNome: TDBEdit;
    lblNome: TLabel;
    lblCodigo: TLabel;
    DBImage1: TDBImage;
    fodImagem: TFileOpenDialog;
    fdItensPLA_NICK: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure fdPadraoNewRecord(DataSet: TDataSet);
    procedure edtInserirItemClick(Sender: TObject);
    procedure btnExcluirItemClick(Sender: TObject);
    procedure DBImage1DblClick(Sender: TObject);
  private
  protected
    function GetSQLPadrao: string; override;
  public
  end;

implementation

{$R *.dfm}

uses uUtilDB, uFrmConsulta;

{ TfrmTime }

procedure TfrmTime.btnExcluirItemClick(Sender: TObject);
begin
  inherited;
  if not fdItens.IsEmpty then
  begin
    if MessageDlg('Deseja realmente excluir?', mtConfirmation, [mbYes, mbNo],
      -1) = mrYes then
      fdItens.Delete;
  end;
end;

procedure TfrmTime.DBImage1DblClick(Sender: TObject);
begin
  inherited;
  if fodImagem.Execute then
  begin
    if not (fdPadrao.State in dsEditModes) then
      fdPadrao.Edit;
    TBlobField(fdPadrao.FieldByName('TIM_IMAGEM')).LoadFromFile(fodImagem.FileName);
    fdPadrao.Post;
  end;
end;

procedure TfrmTime.edtInserirItemClick(Sender: TObject);
var
  vResult: TResultado;
begin
  if not fdPadrao.IsEmpty then
  begin
    fdItens.Append;
    fdItens.FieldByName('TIM_ID').AsInteger := fdPadrao.FieldByName('TIM_ID')
      .AsInteger;
    vResult := TfrmConsulta.Exibir('PLAYER', 'PLA_ID',
      ' WHERE NOT EXISTS(SELECT * FROM PLAYER_TIME ' +
      ' WHERE PLAYER.PLA_ID = PLA_ID) ');
    if vResult.Confirmou then
      fdItens.FieldByName('PLA_ID').AsString := vResult.Chave
    else
    begin
      fdItens.Cancel;
      Exit;
    end;
    fdItens.Post;
  end;
  fdItens.Refresh;
end;

procedure TfrmTime.fdPadraoNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('TIM_ID').AsInteger := GetNewSequence('GEN_TIMES_ID');
end;

procedure TfrmTime.FormCreate(Sender: TObject);
begin
  inherited;
  FFocus := edtNome;
  fdItens.Open;
end;

function TfrmTime.GetSQLPadrao: string;
begin
  Result := 'SELECT TIMES.TIM_ID, TIMES.TIM_NOME, TIMES.TIM_IMAGEM FROM TIMES ';
end;

initialization

RegisterClass(TfrmTime);

finalization

UnRegisterClass(TfrmTime);

end.
