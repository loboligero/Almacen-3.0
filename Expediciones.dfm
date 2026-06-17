object FrmExpediciones: TFrmExpediciones
  Left = 0
  Top = 0
  Caption = 'Listado Expediciones'
  ClientHeight = 436
  ClientWidth = 1026
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 41
    Width = 1026
    Height = 354
    Align = alClient
    DataSource = DM.DataSource6
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ParentFont = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDrawColumnCell = DBGrid1DrawColumnCell
    Columns = <
      item
        Expanded = False
        FieldName = 'SERIE'
        ReadOnly = True
        Width = 50
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NUMERO'
        ReadOnly = True
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NUMEXPEDICION'
        Width = 134
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NOMBRE'
        ReadOnly = True
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NOMBRECOMERCIAL'
        ReadOnly = True
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'POBLACION'
        ReadOnly = True
        Width = 145
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PROVINCIA'
        ReadOnly = True
        Width = 122
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PAIS'
        ReadOnly = True
        Width = 100
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1026
    Height = 41
    Align = alTop
    TabOrder = 1
    object DateTimePicker1: TDateTimePicker
      Left = 24
      Top = 8
      Width = 105
      Height = 24
      Date = 43951.000000000000000000
      Format = 'dd/MM/yyyy'
      Time = 0.845861423607857400
      TabOrder = 0
      OnChange = DateTimePicker1Change
    end
    object DBLookupComboBox1: TDBLookupComboBox
      Left = 151
      Top = 8
      Width = 186
      Height = 21
      KeyField = 'NOMBRE'
      ListField = 'NOMBRE'
      ListSource = DM.DataSource5
      TabOrder = 1
      OnClick = DBLookupComboBox1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 395
    Width = 1026
    Height = 41
    Align = alBottom
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 12
      Width = 70
      Height = 13
      Caption = 'N'#186' Expedici'#243'n:'
    end
    object Edit1: TEdit
      Left = 104
      Top = 10
      Width = 185
      Height = 21
      TabOrder = 0
    end
    object Button1: TButton
      Tag = 10
      Left = 424
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Envio Correo'
      TabOrder = 1
      OnClick = Button1Click
    end
    object BitBtn1: TBitBtn
      Left = 320
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Grabar'
      Glyph.Data = {
        36050000424D3605000000000000360400002800000010000000100000000100
        08000100000000010000220B0000220B00000001000000010000842121008C21
        2100942929006B3131008431310084393900AD393900C65252009C636300B563
        6300AD736300B57B7B00BD8484009C8C8C009C9C9C00A5A5A500BDA5A500C6A5
        A500D6A5A500ADADAD00B5B5B500BDBDBD00D6BDBD00DEBDBD00CEC6C600D6D6
        D600DEDEDE00EFEFEF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00101900001019
        0000001019130305040F0F0F0E0F0F000005051900000010190A0707050D0912
        1C1B19000007051900000010190A07070510060B181C1B000007051900000010
        190A0707051602080F181C000007051900000010190A070705160C100D0F1800
        0007051900000119010A0C070105011900000004190A0707080B000407070519
        00000010190A070B1C1B1C1B1C1B1C1B0B07051900000010190A070B1B141414
        1514151C0B07051900000010190A070B1B1C1B1C1B1C1B1C0B07041900000006
        190A070B1C1304140006151C0B07051900000010190A070B1B1C1C1B1C1C1B1C
        0B07051900000004190A050B081400040B051319000010190001}
      TabOrder = 2
      OnClick = BitBtn1Click
    end
    object Button2: TButton
      Tag = 20
      Left = 520
      Top = 6
      Width = 129
      Height = 25
      Caption = 'Envio Todos Correos'
      TabOrder = 3
      OnClick = Button1Click
    end
  end
end
