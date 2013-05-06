object InputNameDialog: TInputNameDialog
  Left = 0
  Top = 0
  Caption = #28216#25103#32467#26463
  ClientHeight = 223
  ClientWidth = 368
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object NameLabel: TLabel
    Left = 48
    Top = 64
    Width = 36
    Height = 13
    Caption = #21517#23383#65306
  end
  object inputNameLabel: TLabel
    Left = 104
    Top = 16
    Width = 132
    Height = 13
    Caption = #28216#25103#32467#26463#65292#36755#20837#20320#30340#22823#21517
  end
  object NameInputText: TEdit
    Left = 90
    Top = 61
    Width = 217
    Height = 21
    TabOrder = 0
    Text = #21311#21517
  end
  object inputNameConfirm: TButton
    Left = 72
    Top = 120
    Width = 89
    Height = 41
    Caption = #30830#23450
    TabOrder = 1
    OnClick = inputNameConfirmClick
  end
  object inputNameCacel: TButton
    Left = 194
    Top = 120
    Width = 89
    Height = 41
    Caption = #21462#28040
    TabOrder = 2
    OnClick = inputNameCacelClick
  end
end
