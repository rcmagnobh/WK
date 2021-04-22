object DMConexaoDB: TDMConexaoDB
  OldCreateOrder = False
  Height = 92
  Width = 183
  object SQLConnection1: TSQLConnection
    ConnectionName = 'Teste_Wk'
    DriverName = 'MYSQL'
    GetDriverFunc = 'getSQLDriverMYSQL'
    LibraryName = 'dbxmys.dll'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=MYSQL'
      'LibraryNameOsx=libsqlmys.dylib'
      'VendorLibWin64=libmysql.dll'
      'VendorLibOsx=libmysqlclient.dylib'
      'BlobSize=-1'
      'Database=teste_wk'
      'HostName=localhost'
      'LocaleCode=0000'
      'Password=123456'
      'User_Name=root'
      'Compressed=False'
      'Encrypted=False')
    VendorLib = 'LIBMYSQL.dll'
    Left = 56
    Top = 16
  end
end
