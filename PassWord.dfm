object PasswordDlg: TPasswordDlg
  Left = 245
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Contrase'#241'a configuraci'#243'n'
  ClientHeight = 93
  ClientWidth = 233
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 9
    Width = 132
    Height = 16
    Caption = 'Introduzca contrase'#241'a:'
  end
  object Password: TEdit
    Left = 8
    Top = 27
    Width = 217
    Height = 24
    PasswordChar = '*'
    TabOrder = 0
  end
  object OKBtn: TButton
    Left = 8
    Top = 57
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object CancelBtn: TButton
    Left = 150
    Top = 59
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
