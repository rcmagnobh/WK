inherited frmPesqProduto: TfrmPesqProduto
  Caption = 'Pesquisar Produto'
  ClientWidth = 508
  ExplicitWidth = 514
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    Width = 508
    ExplicitWidth = 508
    inherited Button1: TButton
      OnClick = Button1Click
    end
  end
  inherited Panel2: TPanel
    Width = 508
    Height = 99
    ExplicitWidth = 508
    ExplicitHeight = 99
    inherited btnLocalizar: TButton
      OnClick = btnLocalizarClick
    end
    object rdOp: TRadioGroup
      Left = 8
      Top = 48
      Width = 393
      Height = 41
      Caption = 'Pesquisar por'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Produto'
        'Descri'#231#227'o')
      TabOrder = 2
    end
  end
  inherited Panel3: TPanel
    Top = 99
    Width = 508
    Height = 117
    ExplicitTop = 99
    ExplicitWidth = 508
    ExplicitHeight = 117
    inherited DBGrid1: TDBGrid
      Width = 508
      Height = 117
      Columns = <
        item
          Expanded = False
          FieldName = 'PRODUTO'
          Title.Caption = 'Produto'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DESCRICAO'
          Title.Caption = 'Descri'#231#227'o'
          Width = 330
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PRECO'
          Title.Caption = 'Pre'#231'o de Venda'
          Visible = True
        end>
    end
  end
  inherited cdsDados: TClientDataSet
    object cdsDadosPRODUTO: TIntegerField
      FieldName = 'PRODUTO'
    end
    object cdsDadosDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 80
    end
    object cdsDadosPRECO: TFloatField
      FieldName = 'PRECO'
      DisplayFormat = '#0.00'
    end
  end
end
