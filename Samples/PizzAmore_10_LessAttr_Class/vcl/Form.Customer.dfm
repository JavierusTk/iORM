object CustomerForm: TCustomerForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Pizz'#39'Amore'
  ClientHeight = 303
  ClientWidth = 584
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  Visible = True
  OnClose = FormClose
  TextHeight = 15
  object Label1: TLabel
    Left = 10
    Top = 61
    Width = 100
    Height = 25
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'ID'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 10
    Top = 101
    Width = 100
    Height = 25
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 10
    Top = 140
    Width = 100
    Height = 25
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Phone'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 10
    Top = 179
    Width = 100
    Height = 25
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'City'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 8
    Top = 218
    Width = 100
    Height = 25
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Address'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 584
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    Color = clNavy
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 580
    DesignSize = (
      584
      40)
    object ButtonBack: TSpeedButton
      Left = 0
      Top = 0
      Width = 50
      Height = 40
      Align = alLeft
      Caption = 'Back'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      OnClick = ButtonBackClick
    end
    object LabelTitle: TLabel
      Left = 56
      Top = 7
      Width = 477
      Height = 21
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = ' Customer'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 481
    end
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 263
    Width = 584
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    Color = clMenu
    ParentBackground = False
    TabOrder = 1
    ExplicitTop = 262
    ExplicitWidth = 580
    object ButtonRevert: TSpeedButton
      Left = 0
      Top = 0
      Width = 50
      Height = 40
      Align = alLeft
      Caption = 'Revert'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      OnClick = ButtonRevertClick
      ExplicitLeft = 334
      ExplicitTop = -6
    end
    object ButtonPersist: TSpeedButton
      Left = 534
      Top = 0
      Width = 50
      Height = 40
      Align = alRight
      Caption = 'Persist'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = ButtonPersistClick
      ExplicitLeft = 334
      ExplicitTop = -6
    end
  end
  object DBEditID: TDBEdit
    Left = 122
    Top = 61
    Width = 55
    Height = 25
    BorderStyle = bsNone
    Color = clInactiveBorder
    DataField = 'ID'
    DataSource = SourceCustomer
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object DBEditName: TDBEdit
    Left = 122
    Top = 101
    Width = 447
    Height = 25
    BorderStyle = bsNone
    Color = clInactiveBorder
    DataField = 'Name'
    DataSource = SourceCustomer
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object DBEditPhone: TDBEdit
    Left = 122
    Top = 140
    Width = 447
    Height = 25
    BorderStyle = bsNone
    Color = clInactiveBorder
    DataField = 'PhoneNumber'
    DataSource = SourceCustomer
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object DBEditCity: TDBEdit
    Left = 122
    Top = 179
    Width = 447
    Height = 25
    BorderStyle = bsNone
    Color = clInactiveBorder
    DataField = 'City'
    DataSource = SourceCustomer
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
  end
  object DBEditAddress: TDBEdit
    Left = 120
    Top = 218
    Width = 449
    Height = 25
    BorderStyle = bsNone
    Color = clInactiveBorder
    DataField = 'Address'
    DataSource = SourceCustomer
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
  end
  object DSCustomer: TioDataSetMaster
    AsDefault = True
    TypeName = 'TCustomer'
    LoadType = ltFromBSAsIs
    TypeOfCollection = tcSingleObject
    VirtualFields = True
    Paging.CurrentPageOfFormat = '%d/%d'
    Paging.PageSize = 10
    Left = 320
    Top = 48
    object DSCustomerID: TIntegerField
      FieldName = 'ID'
    end
    object DSCustomerName: TStringField
      FieldName = 'Name'
      Size = 100
    end
    object DSCustomerPhoneNumber: TStringField
      FieldName = 'PhoneNumber'
      Size = 100
    end
    object DSCustomerCity: TStringField
      FieldName = 'City'
      Size = 100
    end
    object DSCustomerAddress: TStringField
      FieldName = 'Address'
      Size = 100
    end
  end
  object SourceCustomer: TDataSource
    DataSet = DSCustomer
    Left = 320
    Top = 104
  end
end
