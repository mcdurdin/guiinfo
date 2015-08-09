object GUIThreadInfoForm: TGUIThreadInfoForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSizeToolWin
  Caption = 'GUI Thread Info'
  ClientHeight = 92
  ClientWidth = 412
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  GlassFrame.Enabled = True
  GlassFrame.SheetOfGlass = True
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblFocus: TLabel
    Left = 0
    Top = 45
    Width = 32
    Height = 13
    Caption = 'Focus'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    OnMouseEnter = lblFocusMouseEnter
    OnMouseLeave = lblMouseLeave
  end
  object lblActive: TLabel
    Left = 0
    Top = 30
    Width = 36
    Height = 13
    Caption = 'Active'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    OnMouseEnter = lblActiveMouseEnter
    OnMouseLeave = lblMouseLeave
  end
  object lblCapture: TLabel
    Left = 0
    Top = 60
    Width = 45
    Height = 13
    Caption = 'Capture'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    OnMouseEnter = lblCaptureMouseEnter
    OnMouseLeave = lblMouseLeave
  end
  object lblFocusHandle: TLabel
    Left = 118
    Top = 45
    Width = 28
    Height = 13
    Caption = 'Focus'
    Transparent = True
  end
  object lblActiveHandle: TLabel
    Left = 118
    Top = 30
    Width = 30
    Height = 13
    Caption = 'Active'
    Transparent = True
  end
  object lblCaptureHandle: TLabel
    Left = 118
    Top = 60
    Width = 56
    Height = 13
    Caption = 'Foreground'
    Transparent = True
  end
  object lblFocusClass: TLabel
    Left = 200
    Top = 45
    Width = 28
    Height = 13
    Caption = 'Focus'
    Transparent = True
  end
  object lblActiveClass: TLabel
    Left = 200
    Top = 30
    Width = 30
    Height = 13
    Caption = 'Active'
    Transparent = True
  end
  object lblCaptureClass: TLabel
    Left = 200
    Top = 60
    Width = 56
    Height = 13
    Caption = 'Foreground'
    Transparent = True
  end
  object lblThread: TLabel
    Left = 0
    Top = 0
    Width = 108
    Height = 13
    Caption = 'Foreground Thread'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    OnMouseLeave = lblMouseLeave
  end
  object lblThreadName: TLabel
    Left = 200
    Top = 0
    Width = 28
    Height = 13
    Caption = 'Focus'
    Transparent = True
  end
  object lblForeground: TLabel
    Left = 0
    Top = 15
    Width = 112
    Height = 13
    Caption = 'Foreground Window'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    OnMouseEnter = lblForegroundMouseEnter
    OnMouseLeave = lblMouseLeave
  end
  object lblForegroundHandle: TLabel
    Left = 118
    Top = 15
    Width = 28
    Height = 13
    Caption = 'Focus'
    Transparent = True
  end
  object lblForegroundClass: TLabel
    Left = 200
    Top = 15
    Width = 28
    Height = 13
    Caption = 'Focus'
    Transparent = True
  end
  object lblThreadHandle: TLabel
    Left = 118
    Top = 0
    Width = 28
    Height = 13
    Caption = 'Focus'
    Transparent = True
  end
  object lblStatus: TLabel
    Left = 1
    Top = 79
    Width = 31
    Height = 13
    Caption = 'Status'
  end
  object tmrUpdateLabels: TTimer
    Interval = 100
    OnTimer = tmrUpdateLabelsTimer
    Left = 288
    Top = 24
  end
end
