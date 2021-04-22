inherited frmPesqCliente: TfrmPesqCliente
  Caption = 'Pesquisar cliente'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    inherited Button1: TButton
      OnClick = Button1Click
    end
  end
  inherited Panel2: TPanel
    Height = 91
    ExplicitHeight = 91
    inherited btnLocalizar: TButton
      Left = 415
      Top = 19
      ExplicitLeft = 415
      ExplicitTop = 19
    end
    object rgOp: TRadioGroup
      Left = 8
      Top = 45
      Width = 393
      Height = 41
      Caption = 'Pesquisar por'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'C'#243'digo'
        'Nome')
      TabOrder = 2
    end
  end
  inherited Panel3: TPanel
    Top = 91
    Height = 125
    ExplicitTop = 91
    ExplicitHeight = 125
    inherited DBGrid1: TDBGrid
      Height = 125
      Columns = <
        item
          Expanded = False
          FieldName = 'CODIGO'
          Title.Caption = 'C'#243'digo'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NOME'
          Title.Caption = 'Nome'
          Width = 276
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CIDADE'
          Title.Caption = 'Cidade'
          Width = 112
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'UF'
          Width = 20
          Visible = True
        end>
    end
  end
  inherited cdsDados: TClientDataSet
    object cdsDadosCODIGO: TIntegerField
      FieldName = 'CODIGO'
    end
    object cdsDadosNOME: TStringField
      FieldName = 'NOME'
      Size = 80
    end
    object cdsDadosCIDADE: TStringField
      FieldName = 'CIDADE'
      Size = 40
    end
    object cdsDadosUF: TStringField
      FieldName = 'UF'
      Size = 2
    end
  end
end
