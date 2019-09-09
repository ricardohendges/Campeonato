object Conexao: TConexao
  OldCreateOrder = False
  Height = 249
  Width = 293
  object FDConexao: TFDConnection
    Params.Strings = (
      
        'Database=D:\Aula HORUS 2019\Delphi\Campeonato\Campeonato\db\PLAC' +
        'ARES.FDB'
      'User_Name=sysdba'
      'Password=masterkey'
      'DriverID=FB')
    LoginPrompt = False
    Left = 40
    Top = 32
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 208
    Top = 32
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 208
    Top = 88
  end
end
