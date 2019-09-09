unit uUtilFrame;

interface

uses
  Vcl.ExtCtrls, uUtilCampeonato, System.Generics.Collections;

procedure CriarFrames(AQtde, Nivel: Integer; APanel: TPanel; APartida: TPartida); overload;
procedure CriarFrames(APartidas: TList<TPartida>; APanel: TPanel); overload;

implementation

uses
  Vcl.Controls, System.SysUtils, uFrameJogo;

procedure CriarFrames(APartidas: TList<TPartida>; APanel: TPanel); overload;
var
  vPartida: TPartida;
begin
  for vPartida in APartidas do
    CriarFrames(1, vPartida.Rodada.ID, APanel, vPartida);
end;

procedure CriarFrames(AQtde, Nivel: Integer; APanel: TPanel; APartida: TPartida);
var
  I: Integer;
var
  vFrame: TFrameJogo;
begin
  for I := 1 to AQtde do
  begin
    vFrame := TFrameJogo.Create(APanel);
    vFrame.Name := 'TframePartida' + APartida.ID.ToString + I.ToString;
    vFrame.Align := alTop;
    vFrame.Height := 120;
    vFrame.Parent := APanel;
    vFrame.AlignWithMargins := True;
    case Nivel of
      1:
        vFrame.Margins.Top := 1;
      2:
        begin
          vFrame.Margins.Top := 65 + I;
          vFrame.Margins.Bottom := 70 + I;
        end;
      3:
        begin
          vFrame.Margins.Top := 158 + I;
          vFrame.Margins.Bottom := 158 + I;
        end;
      4:
        begin
          vFrame.Margins.Top := 268 + I;
          vFrame.Margins.Bottom := 268 + I;
        end;
    end;
    vFrame.Margins.Left := 15;
    vFrame.Margins.Right := 15;

    vFrame.SetPartida(APartida);
  end;
end;

end.
