object MainProgramForm: TMainProgramForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MainProgramForm'
  ClientHeight = 260
  ClientWidth = 582
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
  object LogBox: TListBox
    Left = 8
    Top = 8
    Width = 485
    Height = 220
    ItemHeight = 13
    TabOrder = 0
  end
  object LoadUnloadButton: TButton
    Left = 499
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Load DLL'
    TabOrder = 1
    OnClick = LoadUnloadButtonClick
  end
  object GetVersionButton: TButton
    Left = 499
    Top = 39
    Width = 75
    Height = 25
    Caption = 'GetVersion'
    Enabled = False
    TabOrder = 2
    OnClick = GetVersionButtonClick
  end
  object ShowWindowButton: TButton
    Left = 499
    Top = 70
    Width = 75
    Height = 25
    Caption = 'ShowWindow'
    Enabled = False
    TabOrder = 3
    OnClick = ShowWindowButtonClick
  end
  object StartThreadButton: TButton
    Left = 499
    Top = 101
    Width = 75
    Height = 25
    Caption = 'Start Thread'
    Enabled = False
    TabOrder = 4
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 234
    Width = 485
    Height = 17
    TabOrder = 5
  end
  object SendMessageButton: TButton
    Left = 499
    Top = 132
    Width = 75
    Height = 25
    Caption = 'Send Message'
    Enabled = False
    TabOrder = 6
  end
end
