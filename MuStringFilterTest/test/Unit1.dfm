object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 544
  ClientWidth = 862
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    862
    544)
  PixelsPerInch = 120
  TextHeight = 19
  object PageControl1: TPageControl
    Left = 8
    Top = 32
    Width = 833
    Height = 497
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #28304
      object E_Src: TSynMemo
        Left = 0
        Top = 0
        Width = 825
        Height = 463
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Courier New'
        Font.Style = []
        TabOrder = 0
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -13
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Gutter.LeftOffset = 2
        Gutter.ShowLineNumbers = True
        Highlighter = SynHTMLSyn1
        TabWidth = 4
        FontSmoothing = fsmNone
      end
    end
    object TabSheet2: TTabSheet
      Caption = #37197#32622
      ImageIndex = 1
      object E_Conf: TSynMemo
        Left = 0
        Top = 0
        Width = 825
        Height = 463
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Courier New'
        Font.Style = []
        TabOrder = 0
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -13
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Gutter.LeftOffset = 2
        Gutter.ShowLineNumbers = True
        Highlighter = SynJScriptSyn1
        TabWidth = 4
        FontSmoothing = fsmNone
      end
    end
    object TabSheet3: TTabSheet
      Caption = #32467#26524
      ImageIndex = 2
      object E_Result: TSynMemo
        Left = 0
        Top = 0
        Width = 825
        Height = 463
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Courier New'
        Font.Style = []
        TabOrder = 0
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -13
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Gutter.LeftOffset = 2
        Gutter.ShowLineNumbers = True
        Highlighter = SynHTMLSyn1
        FontSmoothing = fsmNone
      end
    end
  end
  object Button1: TButton
    Left = 104
    Top = 1
    Width = 75
    Height = 25
    Caption = #25191#34892
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 1
    Width = 75
    Height = 25
    Caption = 'save'
    TabOrder = 2
    OnClick = Button2Click
  end
  object SynHTMLSyn1: TSynHTMLSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    Left = 316
    Top = 238
  end
  object SynJScriptSyn1: TSynJScriptSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    NumberAttri.Foreground = clGreen
    SpaceAttri.Foreground = 10485760
    StringAttri.Foreground = 10485760
    Left = 148
    Top = 398
  end
end
