unit uUtilFrame;

interface

uses
  Vcl.ExtCtrls;

procedure CriarFrames(AQtde, Nivel: Integer; APanel: TPanel);

implementation

uses
  Vcl.Controls, System.SysUtils, uFrameJogo;

procedure CriarFrames(AQtde, Nivel: Integer; APanel: TPanel);
var
  I: Integer;
var
  vFrame: TFrameJogo;
begin
  for I := 1 to AQtde do
  begin
    vFrame := TFrameJogo.Create(APanel);
    vFrame.Name := 'TframePartida' + Nivel.ToString + I.ToString;
    vFrame.Align := alTop;
    vFrame.Height := 100;
    vFrame.edtNome1.Text := '';
    vFrame.edtNome2.Text := '';
    vFrame.Parent := APanel;
    vFrame.AlignWithMargins := True;
    case Nivel of
      1: vFrame.Margins.Top := 1;
      2:
      begin
        vFrame.Margins.Top := 51 + I;
        vFrame.Margins.Bottom := 51 + I;
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
  end;
end;

end.
