object ViewBindSourceBase: TViewBindSourceBase
  Left = 0
  Top = 0
  Width = 300
  Height = 500
  TabOrder = 0
  object ViewPanelTop: TPanel
    Left = 0
    Top = 0
    Width = 300
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object ButtonPreviousPage: TSpeedButton
      Left = 3
      Top = 26
      Width = 70
      Height = 21
      Caption = 'Prev. page'
    end
    object ButtonNextPage: TSpeedButton
      Left = 76
      Top = 26
      Width = 70
      Height = 21
      Caption = 'Next page'
    end
    object LabelTitle: TLabel
      Left = 0
      Top = 0
      Width = 300
      Height = 20
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'Title'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlBottom
    end
  end
  object MBSArticles: TioModelBindSource
    AutoActivate = True
    AutoPost = False
    FieldDefs = <
      item
        Name = 'ID'
        FieldType = ftInteger
        Generator = 'Integers'
        ReadOnly = False
      end
      item
        Name = 'Description'
        Generator = 'ContactNames'
        ReadOnly = False
      end
      item
        Name = 'Price'
        FieldType = ftCurrency
        Generator = 'Currency'
        ReadOnly = False
      end>
    ScopeMappings = <>
    ViewModelBridge = VMBridge
    ModelPresenter = 'MPArticles'
    Left = 224
    Top = 128
  end
  object VMBridge: TioViewModelBridge
    Left = 224
    Top = 72
  end
end
