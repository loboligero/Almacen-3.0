object PreciosAgencias: TPreciosAgencias
  Left = 0
  Top = 0
  Caption = 'PreciosAgencias'
  ClientHeight = 392
  ClientWidth = 708
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 19
    Width = 27
    Height = 13
    Caption = 'Peso:'
  end
  object Label2: TLabel
    Left = 24
    Top = 59
    Width = 69
    Height = 13
    Caption = 'C'#243'digo Postal:'
  end
  object Edit1: TEdit
    Left = 112
    Top = 16
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 112
    Top = 56
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 272
    Top = 14
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
  object DBGrid1: TDBGrid
    Left = 24
    Top = 96
    Width = 633
    Height = 265
    DataSource = DM.DataSource10
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'AGENCIA'
        Width = 300
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PESO1'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PESO2'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PORTE'
        Width = 67
        Visible = True
      end>
  end
end
