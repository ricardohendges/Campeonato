object frmConsulta: TfrmConsulta
  Left = 0
  Top = 0
  Caption = 'Consulta'
  ClientHeight = 306
  ClientWidth = 360
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object dbgConsulta: TDBGrid
    Left = 0
    Top = 0
    Width = 360
    Height = 306
    Align = alClient
    DataSource = dsConsulta
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = dbgConsultaDblClick
  end
  object fdConsulta: TFDQuery
    Connection = Conexao.FDConexao
    Left = 288
    Top = 64
  end
  object dsConsulta: TDataSource
    DataSet = fdConsulta
    Left = 216
    Top = 64
  end
end
