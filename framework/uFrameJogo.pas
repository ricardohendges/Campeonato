unit uFrameJogo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, uUtilCampeonato, Vcl.ExtCtrls, uUtilDB, FireDAC.Comp.Client;

type
  TResultP = record
    Time1: Integer;
    Time2: Integer;
    Empates: Integer;
  end;

  TFrameJogo = class(TFrame)
    pnlTime1: TPanel;
    pnlTime2: TPanel;
    edtNome1: TEdit;
    edtResultado11: TEdit;
    edtResultado31: TEdit;
    edtResultado21: TEdit;
    edtNome2: TEdit;
    edtResultado12: TEdit;
    edtResultado22: TEdit;
    edtResultado32: TEdit;
    imgTime1: TImage;
    imgTime2: TImage;
    procedure edtResultado12Exit(Sender: TObject);
    procedure edtResultado22Exit(Sender: TObject);
    procedure edtResultado32Exit(Sender: TObject);
  private
    FEquipe1: TEquipe;
    FEquipe2: TEquipe;
    function GetResultados: TResultP;
    procedure ValidaJogo(AT1, AT2: TEdit);
    procedure SetVencedor;

  public
    procedure SetPartida(APartida: TPartida);
    function GetVencedor: TEquipe;
    function Terminou: Boolean;
  end;

implementation

{$R *.dfm}

{ TFrameJogo }
uses Vcl.Imaging.JPEG, Data.DB;

procedure TFrameJogo.edtResultado12Exit(Sender: TObject);
begin
  ValidaJogo(edtResultado11, edtResultado12);
end;

procedure TFrameJogo.edtResultado22Exit(Sender: TObject);
begin
  ValidaJogo(edtResultado21, edtResultado22);
end;

procedure TFrameJogo.edtResultado32Exit(Sender: TObject);
begin
  ValidaJogo(edtResultado31, edtResultado32);
end;

function TFrameJogo.GetResultados: TResultP;
begin
  Result.Time1 := 0;
  Result.Time2 := 0;
  Result.Empates := 0;
  if StrToInt(edtResultado11.Text) > StrToInt(edtResultado12.Text) then
    Inc(Result.Time1)
  else if StrToInt(edtResultado11.Text) < StrToInt(edtResultado12.Text) then
    Inc(Result.Time2)
  else
    Inc(Result.Empates);

  if StrToInt(edtResultado21.Text) > StrToInt(edtResultado22.Text) then
    Inc(Result.Time1)
  else if StrToInt(edtResultado21.Text) < StrToInt(edtResultado22.Text) then
    Inc(Result.Time2)
  else
    Inc(Result.Empates);

  if StrToInt(edtResultado31.Text) > StrToInt(edtResultado32.Text) then
    Inc(Result.Time1)
  else if StrToInt(edtResultado31.Text) < StrToInt(edtResultado32.Text) then
    Inc(Result.Time2)
  else
    Inc(Result.Empates);
end;

function TFrameJogo.GetVencedor: TEquipe;
var
  vResult: TResultP;
begin
  if vResult.Time1 > vResult.Time2 then
    Result := FEquipe1
  else
    Result := FEquipe2;
end;

procedure TFrameJogo.SetPartida(APartida: TPartida);
var
  vSQL: string;
  vQuery: TFDQuery;

  vStream: TMemoryStream;
begin
  FEquipe1 := APartida.Equipe1;
  vSQL := 'SELECT TIM_IMAGEM FROM TIMES WHERE TIM_ID = ' + FEquipe1.ID.ToString;
  vQuery := GetConsulta(vSQL);

  vStream := TMemoryStream.Create;
  try
    TBlobField(vQuery.FieldByName('TIM_IMAGEM')).SaveToStream(vStream);
    vStream.Position := 0;
    imgTime1.Picture.LoadFromStream(vStream);
  finally
    FreeAndNil(vQuery);
    FreeAndNil(vStream);
  end;

  FEquipe2 := APartida.Equipe2;

  vSQL := 'SELECT TIM_IMAGEM FROM TIMES WHERE TIM_ID = ' + FEquipe2.ID.ToString;
  vQuery := GetConsulta(vSQL);

  vStream := TMemoryStream.Create;
  try
    TBlobField(vQuery.FieldByName('TIM_IMAGEM')).SaveToStream(vStream);
    vStream.Position := 0;
    imgTime2.Picture.LoadFromStream(vStream);
  finally
    FreeAndNil(vQuery);
    FreeAndNil(vStream);
  end;

  edtNome1.Text := APartida.Equipe1.Nome;
  edtNome2.Text := APartida.Equipe2.Nome;

  edtResultado11.Text := APartida.Pontuacao.Ponto11.ToString;
  edtResultado21.Text := APartida.Pontuacao.Ponto12.ToString;
  edtResultado31.Text := APartida.Pontuacao.Ponto13.ToString;

  edtResultado12.Text := APartida.Pontuacao.Ponto21.ToString;
  edtResultado22.Text := APartida.Pontuacao.Ponto22.ToString;
  edtResultado32.Text := APartida.Pontuacao.Ponto23.ToString;
end;

procedure TFrameJogo.SetVencedor;
var
  vResultados: TResultP;
begin
  vResultados := GetResultados;
  if vResultados.Empates > 0 then
  begin
    ParentBackground := True;
    Exit;
  end;

  if vResultados.Time1 > vResultados.Time2 then
  begin
    pnlTime1.Color := clLime;
    pnlTime2.Color := clRed;
    ParentBackground := False;
  end
  else
  begin
    pnlTime1.Color := clRed;
    pnlTime2.Color := clLime;
    ParentBackground := False;
  end;
end;

function TFrameJogo.Terminou: Boolean;
var
  vResult: TResultP;
begin
  vResult := GetResultados;
  Result := vResult.Empates = 0;
end;

procedure TFrameJogo.ValidaJogo(AT1, AT2: TEdit);
begin
  if StrToInt(AT2.Text) > StrToInt(AT1.Text) then
  begin
    AT1.Color := clRed;
    AT2.Color := clGreen;
  end
  else if StrToInt(AT2.Text) < StrToInt(AT1.Text) then
  begin
    AT1.Color := clGreen;
    AT2.Color := clRed;
  end
  else
  begin
    AT1.Color := clWindow;
    AT2.Color := clWindow;
  end;
  SetVencedor;
end;

end.
