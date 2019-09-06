inherited frmJogador: TfrmJogador
  Caption = 'Jogador'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlButtons: TPanel
    inherited SpeedButton1: TSpeedButton
      ExplicitLeft = 531
    end
  end
  inherited pnlBase: TPanel
    ExplicitWidth = 514
    ExplicitHeight = 418
    object lblCodigo: TLabel
      Left = 40
      Top = 6
      Width = 33
      Height = 13
      Caption = 'C'#243'digo'
    end
    object lblNome: TLabel
      Left = 167
      Top = 6
      Width = 27
      Height = 13
      Caption = 'Nome'
    end
    object Label1: TLabel
      Left = 40
      Top = 46
      Width = 19
      Height = 13
      Caption = 'Nick'
    end
    object edtCodigo: TDBEdit
      Left = 40
      Top = 24
      Width = 121
      Height = 21
      DataField = 'PLA_ID'
      DataSource = dsPadrao
      Enabled = False
      TabOrder = 0
    end
    object edtNome: TDBEdit
      Left = 167
      Top = 24
      Width = 323
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      DataField = 'PLA_NOME'
      DataSource = dsPadrao
      TabOrder = 1
    end
    object DBGrid1: TDBGrid
      Left = 16
      Top = 91
      Width = 474
      Height = 302
      Anchors = [akLeft, akTop, akRight, akBottom]
      DataSource = dsPadrao
      TabOrder = 2
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
    object edtNick: TDBEdit
      Left = 40
      Top = 64
      Width = 450
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      DataField = 'PLA_NICK'
      DataSource = dsPadrao
      TabOrder = 3
    end
  end
  inherited fdPadrao: TFDQuery
    OnNewRecord = fdPadraoNewRecord
  end
end
