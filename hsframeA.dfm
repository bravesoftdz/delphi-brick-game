object highScoreForm: ThighScoreForm
  Left = 0
  Top = 0
  Caption = 'HighScoreForm'
  ClientHeight = 388
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object highscoreText: TMemo
    Left = 104
    Top = 40
    Width = 233
    Height = 281
    Lines.Strings = (
      'highscoreText')
    TabOrder = 0
  end
  object confirm: TButton
    Left = 104
    Top = 336
    Width = 89
    Height = 33
    Caption = #30830#23450
    TabOrder = 1
    OnClick = confirmClick
  end
  object clear: TButton
    Left = 248
    Top = 336
    Width = 89
    Height = 33
    Caption = #28165#38500
    TabOrder = 2
  end
end
