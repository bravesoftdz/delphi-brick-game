object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #25171#30742#22359'_By_Mapz_Chen'
  ClientHeight = 296
  ClientWidth = 544
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object statusText: TLabel
    Left = 16
    Top = 16
    Width = 52
    Height = 13
    Caption = 'statusText'
    OnClick = statusTextClick
  end
  object scoreLabel: TLabel
    Left = 16
    Top = 52
    Width = 30
    Height = 13
    Caption = 'score:'
  end
  object Stage: TLabel
    Left = 16
    Top = 80
    Width = 36
    Height = 13
    Caption = #31532#19968#20851
  end
  object brickleftlabel: TLabel
    Left = 16
    Top = 112
    Width = 28
    Height = 13
    Caption = #21097#20313':'
  end
  object SpeedButton1: TSpeedButton
    Left = 264
    Top = 152
    Width = 23
    Height = 22
  end
  object ButtonBackground: TImage
    Left = 224
    Top = 112
    Width = 105
    Height = 105
  end
  object gamePanel: TPanel
    Left = 128
    Top = 0
    Width = 417
    Height = 297
    TabOrder = 0
    OnMouseEnter = gamePanelEnter
    OnMouseLeave = gamePanelExit
    OnMouseMove = gamePanelMouseMove
    object board: TButton
      Left = 0
      Top = 0
      Width = 9
      Height = 65
      TabOrder = 0
    end
  end
  object highScoreButton: TButton
    Left = 8
    Top = 131
    Width = 65
    Height = 41
    Caption = #39640#20998
    TabOrder = 1
    OnClick = highScoreButtonClick
  end
  object Button1: TButton
    Left = 8
    Top = 184
    Width = 65
    Height = 33
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
  object frameControl: TTimer
    Interval = 1
    OnTimer = frameControlTimer
    Left = 16
    Top = 256
  end
  object cnnSqlite: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Persist Security Info=False;Data Source=SQLit' +
      'e3 Datasource'
    Provider = 'MSDASQL.1'
    Left = 48
    Top = 256
  end
  object sQry: TADOQuery
    Connection = cnnSqlite
    Parameters = <>
    Left = 48
    Top = 224
  end
end
