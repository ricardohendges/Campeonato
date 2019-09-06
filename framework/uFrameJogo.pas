unit uFrameJogo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uUtilCampeonato;

type
  TFrameJogo = class(TFrame)
    edtNome1: TEdit;
    edtNome2: TEdit;
    edtResultado11: TEdit;
    edtResultado12: TEdit;
    edtResultado21: TEdit;
    edtResultado22: TEdit;
    edtResultado31: TEdit;
    edtResultado32: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
    //procedure SetJogo(AJogo: TJogo);
  end;

implementation

{$R *.dfm}

{ TFrame1 }

//procedure TFrameJogo.SetJogo(AJogo: TJogo);
//begin
//  edtNome1.Text := AJogo.Times.Time1;
//  edtNome2.Text := AJogo.Times.Time2;
//
//  edtResultado11.Text := AJogo.Resultado1.Time1;
//  edtResultado12.Text := AJogo.Resultado1.Time2;
//
//  edtResultado21.Text := AJogo.Resultado2.Time1;
//  edtResultado22.Text := AJogo.Resultado2.Time2;
//
//  edtResultado31.Text := AJogo.Resultado3.Time1;
//  edtResultado32.Text := AJogo.Resultado3.Time2;
//end;

end.
