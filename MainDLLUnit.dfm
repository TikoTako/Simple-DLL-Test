object DLLForm: TDLLForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Telegram bot setup.'
  ClientHeight = 65
  ClientWidth = 345
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 181
    Top = 35
    Width = 75
    Height = 21
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 0
  end
  object BitBtn2: TBitBtn
    Left = 262
    Top = 35
    Width = 75
    Height = 21
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 1
  end
  object BotKeyEdit: TEdit
    Left = 8
    Top = 8
    Width = 329
    Height = 21
    TabOrder = 2
    Text = '** BOT KEY **'
  end
  object ChatIDEdit: TEdit
    Left = 8
    Top = 35
    Width = 169
    Height = 21
    TabOrder = 3
    Text = '** CHAT ID **'
  end
end
