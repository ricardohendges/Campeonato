program Campeonato;

uses
  Vcl.Forms,
  Unit1 in '..\Unit1.pas' {Form1},
  dmConexao in '..\framework\dmConexao.pas' {Conexao: TDataModule},
  uCampeonatoHandler in '..\framework\uCampeonatoHandler.pas',
  uFrameJogo in '..\framework\uFrameJogo.pas' {FrameJogo: TFrame},
  ufrmBaseCrud in '..\framework\ufrmBaseCrud.pas' {frmBaseCrud},
  uFrmConsulta in '..\framework\uFrmConsulta.pas' {frmConsulta},
  uUtilCampeonato in '..\framework\uUtilCampeonato.pas',
  uUtilForm in '..\framework\uUtilForm.pas',
  uUtilFrame in '..\framework\uUtilFrame.pas',
  uFrmCampeonato in '..\src\uFrmCampeonato.pas' {frmCampeonato},
  UfrmMain in '..\src\UfrmMain.pas' {frmPrincipal},
  uFrmTime in '..\src\uFrmTime.pas' {frmTime},
  uGerCampeonato in '..\src\uGerCampeonato.pas' {frmGerCampeonato},
  uFrmJogador in '..\src\uFrmJogador.pas' {frmJogador},
  uUtilDB in '..\framework\uUtilDB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ReportMemoryLeaksOnShutdown := True;
  Application.CreateForm(TConexao, Conexao);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
