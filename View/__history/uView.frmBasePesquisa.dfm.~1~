inherited frmBasePesquisa: TfrmBasePesquisa
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'frmBasePesquisa'
  ClientHeight = 249
  ClientWidth = 509
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 515
  ExplicitHeight = 275
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 216
    Width = 509
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object Button1: TButton
      Left = 342
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Con&firmar'
      TabOrder = 0
    end
    object Button2: TButton
      Left = 423
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Cance&lar'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 509
    Height = 57
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 4
      Width = 46
      Height = 13
      Caption = 'Pesquisar'
    end
    object edtValorProcurado: TEdit
      Left = 8
      Top = 21
      Width = 393
      Height = 21
      TabOrder = 0
      Text = 'edtValorProcurado'
      OnKeyDown = edtValorProcuradoKeyDown
      OnKeyPress = edtValorProcuradoKeyPress
    end
    object btnLocalizar: TButton
      Left = 420
      Top = 17
      Width = 75
      Height = 25
      Caption = 'Localizar'
      TabOrder = 1
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 57
    Width = 509
    Height = 159
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel3'
    TabOrder = 2
    object DBGrid1: TDBGrid
      Left = 0
      Top = 0
      Width = 509
      Height = 159
      Align = alClient
      DataSource = dtsDados
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object cdsDados: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 440
    Top = 24
  end
  object dtsDados: TDataSource
    DataSet = cdsDados
    Left = 440
    Top = 56
  end
end
