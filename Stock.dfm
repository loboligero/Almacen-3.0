object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'Form4'
  ClientHeight = 439
  ClientWidth = 666
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 49
    Width = 666
    Height = 390
    Align = alClient
    DataSource = DM.DataSource8
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Refproveedor'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Descripcion'
        Width = 400
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'STOCK'
        Width = 70
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 666
    Height = 49
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 40
      Top = 14
      Width = 56
      Height = 13
      Caption = 'Referencia:'
    end
    object Button1: TButton
      Left = 256
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Buscar'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Edit1: TEdit
      Left = 120
      Top = 11
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object RadioGroup1: TRadioGroup
      Left = 352
      Top = 3
      Width = 305
      Height = 31
      Columns = 4
      ItemIndex = 0
      Items.Strings = (
        'Empieza'
        'Contiene'
        'Igual'
        'Termina')
      TabOrder = 2
    end
  end
end
