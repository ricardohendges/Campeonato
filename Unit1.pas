unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, System.Generics.Collections, Vcl.StdCtrls,
  Vcl.Samples.Spin;
type
  TTipoCampeonato =
    (tcSemTime, tcCampeao, tcFinal, tcTodos3, tcSemiFinal, tcTodos5, tcTodos6, tcTodos7,
     tcQuartas, tcTodos3x3, tcTodos2x5, tcTodos6x1e5x1, tcTodos4x3, tcTodos3x3e1x4, tcETC);

  TTime = record
    ID: integer;
    Nome: string;
  end;

  TResultado = record
    Time1: integer;
    Time2: integer;
    function GetVitorioso: integer;
  end;

  TPartida = record
    Campeonato: string;
    Etapa: string;
    Jogo: string;
    Time1: TTime;
    Time2: TTime;
    Result1: TResultado;
    Result2: TResultado;
    Result3: TResultado;
    function GetVitorioso: TTime;
  end;


  TForm1 = class(TForm)
    SpinEdit1: TSpinEdit;
    Button1: TButton;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FListaTime: TList<TTime>;
    procedure AlimentarLista(AQTDE: integer);
    procedure GerarCamp;

    procedure MostrarCampeao;
    procedure GerarFinal;
    procedure GerarSemiFinal;
    procedure GerarTodosXTodos3;
    procedure GerarTodosXTodos5;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

const
  FTImes: array[1..19] of TTime = (
      (ID: 1; Nome: 'Time1'),
      (ID: 2; Nome: 'Time2'),
      (ID: 3; Nome: 'Time3'),
      (ID: 4; Nome: 'Time4'),
      (ID: 5; Nome: 'Time5'),
      (ID: 6; Nome: 'Time6'),
      (ID: 7; Nome: 'Time7'),
      (ID: 8; Nome: 'Time8'),
      (ID: 9; Nome: 'Time9'),
      (ID: 10; Nome: 'Time10'),
      (ID: 11; Nome: 'Time11'),
      (ID: 12; Nome: 'Time12'),
      (ID: 13; Nome: 'Time13'),
      (ID: 14; Nome: 'Time14'),
      (ID: 15; Nome: 'Time15'),
      (ID: 16; Nome: 'Time16'),
      (ID: 17; Nome: 'Time17'),
      (ID: 18; Nome: 'Time18'),
      (ID: 19; Nome: 'Time19'));

implementation

uses
  uUtilFrame;

{$R *.dfm}

procedure TForm1.AlimentarLista(AQTDE: integer);
var
  i: integer;
  vTime: TTime;
begin
  FListaTime.Clear;
  for i := 1 to AQTDE do
  begin
    vTime.ID   := FTImes[I].ID;
    vTime.Nome := FTImes[I].Nome;
    FListaTime.Add(vTime);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  GerarCamp;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FListaTime := TList<TTime>.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FListaTime);
end;

procedure TForm1.GerarCamp;
begin
  Memo1.Lines.Clear;
  AlimentarLista(StrToIntDef(SpinEdit1.Text, 0));

  case TTipoCampeonato(FListaTime.Count) of
    tcSemTime:
      Memo1.Lines.Strings[0] := 'Nenhum Time Cadastrado';
    tcCampeao:
      MostrarCampeao;
    tcFinal:
      GerarFinal;
    tcTodos3:
      GerarTodosXTodos3;
    tcSemiFinal:
      GerarSemiFinal;
    tcTodos5:
      GerarTodosXTodos5;
    tcTodos6:
      begin
        GerarTodosXTodos3;
        GerarTodosXTodos3;
      end;
    tcTodos7:
      begin

      end;
    tcQuartas:
      begin

      end;
    tcTodos3x3:
      begin

      end;
    tcTodos2x5:
      begin

      end;
    tcTodos6x1e5x1:
      begin

      end;
    tcTodos4x3:
      begin

      end;
    tcTodos3x3e1x4:
      begin

      end;
    tcETC:
      begin

      end;
  end;
end;

procedure TForm1.GerarFinal;
begin
  Memo1.Lines.Add('Final');
  Memo1.Lines.Add(FListaTime.Items[0].Nome + ' x ' + FListaTime.Items[1].Nome);
  FListaTime.Delete(1);
  MostrarCampeao;
end;

procedure TForm1.GerarSemiFinal;
begin
  Memo1.Lines.Add('Semi Final');
  Memo1.Lines.Add(FListaTime.Items[0].Nome + ' x ' + FListaTime.Items[1].Nome);
  Memo1.Lines.Add(FListaTime.Items[2].Nome + ' x ' + FListaTime.Items[3].Nome);
  FListaTime.Delete(3);
  FListaTime.Delete(0);
  GerarFinal;
end;

procedure TForm1.GerarTodosXTodos3;
begin
  Memo1.Lines.Add('Todos X Todos');
  Memo1.Lines.Add(FListaTime.Items[0].Nome + ' x ' + FListaTime.Items[1].Nome);
  Memo1.Lines.Add(FListaTime.Items[0].Nome + ' x ' + FListaTime.Items[2].Nome);
  Memo1.Lines.Add(FListaTime.Items[1].Nome + ' x ' + FListaTime.Items[2].Nome);
  FListaTime.Delete(1);
  GerarFinal;
end;

procedure TForm1.GerarTodosXTodos5;
begin
  Memo1.Lines.Add('Todos X Todos');
  Memo1.Lines.Add('Rodada 1');
  Memo1.Lines.Add('Jogo 1:' + FListaTime.Items[0].Nome + ' x ' + FListaTime.Items[1].Nome + ' || ' + 'Jogo 2:' + FListaTime.Items[2].Nome + ' x ' + FListaTime.Items[3].Nome);
  Memo1.Lines.Add('Time Fora:' + FListaTime.Items[4].Nome);
  Memo1.Lines.Add('-----------------');
  Memo1.Lines.Add('Rodada 2');
  Memo1.Lines.Add('Jogo 1:' + FListaTime.Items[0].Nome + ' x ' + FListaTime.Items[2].Nome + ' || ' + 'Jogo 2:' + FListaTime.Items[4].Nome + ' x ' + FListaTime.Items[1].Nome);
  Memo1.Lines.Add('Time Fora:' + FListaTime.Items[3].Nome);
  Memo1.Lines.Add('-----------------');
  Memo1.Lines.Add('Rodada 3');
  Memo1.Lines.Add('Jogo 1:' + FListaTime.Items[0].Nome + ' x ' + FListaTime.Items[4].Nome + ' || ' + 'Jogo 2:' + FListaTime.Items[3].Nome + ' x ' + FListaTime.Items[1].Nome);
  Memo1.Lines.Add('Time Fora:' + FListaTime.Items[2].Nome);
  Memo1.Lines.Add('-----------------');
  Memo1.Lines.Add('Rodada 4');
  Memo1.Lines.Add('Jogo 1:' + FListaTime.Items[0].Nome + ' x ' + FListaTime.Items[3].Nome + ' || ' + 'Jogo 2:' + FListaTime.Items[4].Nome + ' x ' + FListaTime.Items[2].Nome);
  Memo1.Lines.Add('Time Fora:' + FListaTime.Items[1].Nome);
  Memo1.Lines.Add('-----------------');
  Memo1.Lines.Add('Rodada 5');
  Memo1.Lines.Add('Jogo 1:' + FListaTime.Items[2].Nome + ' x ' + FListaTime.Items[1].Nome + ' || ' + 'Jogo 2:' + FListaTime.Items[4].Nome + ' x ' + FListaTime.Items[3].Nome);
  Memo1.Lines.Add('Time Fora:' + FListaTime.Items[0].Nome);


  GerarFinal;
end;

procedure TForm1.MostrarCampeao;
begin
  Memo1.Lines.Add('Time Campeão: ' + FListaTime.Items[0].Nome);
end;

{ TPartida }

function TPartida.GetVitorioso: TTime;
var
  T1, T2: integer;
begin
  T1 := 0;
  T2 := 0;
  if Result1.GetVitorioso = 1 then
    Inc(T1)
  else
    Inc(T2);

  if Result2.GetVitorioso = 1 then
    Inc(T1)
  else
    Inc(T2);

  if Result3.GetVitorioso = 1 then
    Inc(T1)
  else
    Inc(T2);

  if T1 > T2 then
    Result := Time1
  else
    Result := Time2;
end;

{ TResultado }

function TResultado.GetVitorioso: integer;
begin
  if Time1 > Time2 then
    Result := 1
  else
    Result := 2;
end;

end.
