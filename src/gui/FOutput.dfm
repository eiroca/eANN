object fmOutput: TfmOutput
  Left = 130
  Top = 157
  Hint = 'Output Window'
  Caption = 'Output Window'
  ClientHeight = 170
  ClientWidth = 646
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object meOut: TMemo
    Left = 0
    Top = 58
    Width = 646
    Height = 112
    Hint = 'Neural Network Shell Outputs'
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    HideSelection = False
    Lines.Strings = (
      'meOut')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object MainMenu1: TMainMenu
    Left = 110
    Top = 20
    object mnEdit: TMenuItem
      Caption = '&Edit'
      GroupIndex = 10
      object Savetextfile1: TMenuItem
        Caption = '&Save text file'
        OnClick = Savetextfile1Click
      end
      object Loadtextfile1: TMenuItem
        Caption = '&Load text file'
        OnClick = Loadtextfile1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object miEditCopy: TMenuItem
        Caption = '&Copy'
        Hint = 'Copy text form NN Shell output'
        ShortCut = 16451
        OnClick = miEditCopyClick
      end
      object miEditCut: TMenuItem
        Caption = 'Cu&t'
        Hint = 'Cut text form NN Shell output'
        ShortCut = 16472
        OnClick = miEditCutClick
      end
      object miEditPaste: TMenuItem
        Caption = '&Paste'
        Hint = 'Insert text Into NN Shell output'
        ShortCut = 16470
        OnClick = miEditPasteClick
      end
      object miEditSelect: TMenuItem
        Caption = '&Select All'
        Hint = 'Select all NN Shell Output'
        ShortCut = 16449
        OnClick = miEditSelectClick
      end
      object miFiler2: TMenuItem
        Caption = '-'
      end
      object miEditClear: TMenuItem
        Caption = 'C&lear Output'
        Hint = 'Clear NN Shell Output'
        ShortCut = 16474
        OnClick = miEditClearClick
      end
      object ChangeFont1: TMenuItem
        Caption = 'Change &Font'
        OnClick = ChangeFont1Click
      end
    end
  end
  object fdFontScr: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    Left = 305
    Top = 25
  end
  object odLoadScr: TOpenDialog
    DefaultExt = 'SCR'
    Filter = 'Script file|*.SCR|All Files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofExtensionDifferent, ofFileMustExist]
    Left = 245
    Top = 25
  end
  object odSaveScr: TSaveDialog
    DefaultExt = 'SCR'
    Filter = 'Script file|*.SCR|All Files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofExtensionDifferent, ofPathMustExist]
    Left = 275
    Top = 25
  end
  object AppEvents1: TAppEvents
    OnIdle = AppEvents1Idle
    Left = 165
    Top = 20
  end
end
