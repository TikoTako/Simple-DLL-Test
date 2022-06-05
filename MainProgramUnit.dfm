object MainProgramForm: TMainProgramForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MainProgramForm'
  ClientHeight = 236
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
    Width = 566
    Height = 129
    ItemHeight = 13
    TabOrder = 0
  end
  object LoadUnloadButton: TButton
    Left = 499
    Top = 143
    Width = 75
    Height = 25
    Caption = 'Load DLL'
    TabOrder = 1
    OnClick = LoadUnloadButtonClick
  end
  object GetVersionButton: TButton
    Left = 499
    Top = 174
    Width = 75
    Height = 25
    Caption = 'GetVersion'
    Enabled = False
    TabOrder = 2
    OnClick = GetVersionButtonClick
  end
  object ShowWindowButton: TButton
    Left = 499
    Top = 205
    Width = 75
    Height = 25
    Caption = 'ShowWindow'
    Enabled = False
    TabOrder = 3
    OnClick = ShowWindowButtonClick
  end
end
