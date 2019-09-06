unit uUtilForm;

interface

uses
  Vcl.Forms, System.Classes;

procedure AbrirForm(AClasse: string);

implementation

procedure AbrirForm(AClasse: string);
var
  vFormClass: TFormClass;
  vForm: TForm;
  i: integer;
begin
  for i := 0 to Pred(Screen.FormCount) do
  begin
    if Screen.Forms[i].ClassName = AClasse then
    begin
      Screen.Forms[I].BringToFront;
      Screen.Forms[I].WindowState := wsNormal;
      Exit;
    end;
  end;
  vFormClass := TFormClass(FindClass(AClasse));
  vForm := vFormClass.Create(Application);
  vForm.Show;
end;

end.
