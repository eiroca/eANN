object fmMain: TfmMain
  Left = 169
  Top = 126
  Caption = 'fmMain'
  ClientHeight = 364
  ClientWidth = 504
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  WindowMenu = Windows1
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sbStatus: TSpeedBar
    Left = 0
    Top = 339
    Width = 504
    Height = 25
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Align = alBottom
    BtnOffsetHorz = 4
    BtnOffsetVert = 4
    BtnWidth = 24
    BtnHeight = 23
    IniStorage = fp
    BevelInner = bvLowered
    TabOrder = 0
    OnApplyAlign = sbStatusApplyAlign
    InternalVer = 1
    object lbStatus: TLabel
      Left = 5
      Top = 6
      Width = 38
      Height = 13
      Caption = 'lbStatus'
    end
    object Progress: TGauge
      Left = 362
      Top = 2
      Width = 140
      Height = 21
      Hint = 'Progress bar'
      Align = alRight
      Color = clBlue
      ForeColor = clBlue
      ParentColor = False
      Progress = 0
    end
  end
  object sbMain: TSpeedBar
    Left = 0
    Top = 0
    Width = 504
    Height = 31
    Hint = 'Double click to customize'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    BtnOffsetHorz = 4
    BtnOffsetVert = 4
    BtnWidth = 24
    BtnHeight = 23
    BevelInner = bvLowered
    TabOrder = 1
    OnDblClick = miToolsToolbarClick
    InternalVer = 1
    object ssFile: TSpeedbarSection
      Caption = 'File'
    end
    object ssWorkSpace: TSpeedbarSection
      Caption = 'Workspace'
    end
    object ssTools: TSpeedbarSection
      Caption = 'Tools'
    end
    object siLoad: TSpeedItem
      Caption = 'Open Workspace'
      Glyph.Data = {
        56070000424D5607000000000000360400002800000028000000140000000100
        0800000000002003000000000000000000000001000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A600000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        030303030303030303FFFFFFFFFFFFFFFFFFFFFFFFFFFF0303030303F8000000
        00000000000000000000030303030303F8F8F8F8F8F8F8F8F8F8F8F8F8F803FF
        03030303000007FB07FB07FB07FB07FB07FB000303030303F8F803FF03030303
        030303030303F8FF0303030300FF0007FB07FB07FB07FB07FB07000303030303
        F8FFF8FF03030303030303030303F803FF03030300FB00FB07FB07FB07FB07FB
        07FB070003030303F8FFF803FF03030303030303030303F8FF03030300FFFB00
        FB07FB07FB07FB07FB07FB0003030303F8FF03F8FF03030303030303030303F8
        03FF030300FBFF0007FB07FB07FB07FB07FB07FB00030303F8FF03F803FFFFFF
        FFFF030303030303F8FF030300FFFBFF000000000007FB07FB07FB0700030303
        F8FF0303F8F8F8F8F803FFFFFFFFFFFFF803030300FBFFFBFFFBFFFBFF000000
        0000000003030303F8FF03030303030303F8F8F8F8F8F8F80303030300FFFBFF
        FBFFFBFFFBFFFBFFFB00030303030303F8FF0303030303030303030303F8FF03
        0303030300FBFFFBFFFBFFFBFFFBFFFBFF00030303030303F8FF0303030303FF
        FFFFFFFFFFF803030303030300FFFBFFFBFF0000000000000003030303030303
        F807FFFFFFFFF8F8F8F8F8F8F803030303030303030000000000030303030303
        030303030303030303F8F8F8F8F8030303030303030303030303030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303030303030303030303030303030303030303030303030303}
      Hint = 'Open Workspace|'
      NumGlyphs = 2
      Spacing = 1
      Left = 12
      Top = 4
      Visible = True
      OnClick = miFileOpenClick
      SectionName = 'File'
    end
    object siSave: TSpeedItem
      Caption = 'Save Workspace'
      Glyph.Data = {
        56070000424D5607000000000000360400002800000028000000140000000100
        0800000000002003000000000000000000000001000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A600000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        030303FFFFFFFFFFFFFFFFFFFFFFFF030303030303F800000000000000000000
        0000F803030303030303F8F8F8F8F8F8F8F8F8F8F8F803FF030303030300FCFC
        00F8FCFCFF070700FCFC00030303030303F8FF03F8FF0303030303F8FF03F8FF
        030303030300FCFC00F8FCFCFF070700FCFC00030303030303F8FF03F8FF0303
        030303F8FF03F8FF030303030300FCFC0007F8F807070700FCFC000303030303
        03F8FF03F8FFFFFFFFFFFFF80303F8FF030303030300FCFC0600000000000006
        FCFC00030303030303F8FF0303F8F8F8F8F8F8030303F8FF030303030300FCFC
        FCFCFCFCFCFCFCFCFCFC00030303030303F8FF0303FFFFFFFFFFFFFFFF03F8FF
        030303030300FC06000000000000000006FC00030303030303F8FF03F8F8F8F8
        F8F8F8F803FFF8FF030303030300FC00FFFFFFFFFFFFFFFF00FC000303030303
        03F8FFF8FF03030303030303F8FFF8FF030303030300FC00FFFFFFFFFFFFFFFF
        00FC00030303030303F8FFF8FF03030303030303F8FFF8FF030303030300FC00
        FFFFFFFFFFFFFFFF00FC00030303030303F8FFF8FF03030303030303F8FFF8FF
        030303030300FC00FFFFFFFFFFFFFFFF00FC00030303030303F8FFF8FF030303
        03030303F8FFF8FF0303030303000000FFFFFFFFFFFFFFFF0000000303030303
        03F8FFF8FF03030303030303F8FFF8FF030303030300FC00FFFFFFFFFFFFFFFF
        00FC00030303030303F8FFF8FFFFFFFFFFFFFFFFF8FFF8030303030303F80000
        00000000000000000000F803030303030303F8F8F8F8F8F8F8F8F8F8F8F80303
        0303030303030303030303030303030303030303030303030303030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303030303030303030303030303030303030303030303030303}
      Hint = 'Save Workspace|'
      NumGlyphs = 2
      Spacing = 1
      Left = 36
      Top = 4
      Visible = True
      OnClick = miFileSaveClick
      SectionName = 'File'
    end
    object siNew: TSpeedItem
      Caption = 'New WorkSpace'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
        333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
        0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
        07333337F33333337F333330FFFFFFFF07333337F33333337F333330FFFFFFFF
        07333FF7F33333337FFFBBB0FFFFFFFF0BB37777F3333333777F3BB0FFFFFFFF
        0BBB3777F3333FFF77773330FFFF000003333337F333777773333330FFFF0FF0
        33333337F3337F37F3333330FFFF0F0B33333337F3337F77FF333330FFFF003B
        B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
        3BB33773333773333773B333333B3333333B7333333733333337}
      Hint = 'New WorkSpace|'
      NumGlyphs = 2
      Spacing = 1
      Left = 4
      Top = 4
      OnClick = miFileNewClick
      SectionName = 'File'
    end
    object siExit: TSpeedItem
      Caption = 'Exit program'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00330000000000
        03333377777777777F333301BBBBBBBB033333773F3333337F3333011BBBBBBB
        0333337F73F333337F33330111BBBBBB0333337F373F33337F333301110BBBBB
        0333337F337F33337F333301110BBBBB0333337F337F33337F333301110BBBBB
        0333337F337F33337F333301110BBBBB0333337F337F33337F333301110BBBBB
        0333337F337F33337F333301110BBBBB0333337F337FF3337F33330111B0BBBB
        0333337F337733337F333301110BBBBB0333337F337F33337F333301110BBBBB
        0333337F3F7F33337F333301E10BBBBB0333337F7F7F33337F333301EE0BBBBB
        0333337F777FFFFF7F3333000000000003333377777777777333}
      Hint = 'Exit program|'
      NumGlyphs = 2
      Spacing = 1
      Left = 4
      Top = 4
      OnClick = miFileExitClick
      SectionName = 'File'
    end
    object siWSDelete: TSpeedItem
      Caption = 'Delete Workspace Object'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333FF33333333333330003333333333333777333333333333
        300033FFFFFF3333377739999993333333333777777F3333333F399999933333
        3300377777733333337733333333333333003333333333333377333333333333
        3333333333333333333F333333333333330033333F33333333773333C3333333
        330033337F3333333377333CC3333333333333F77FFFFFFF3FF33CCCCCCCCCC3
        993337777777777F77F33CCCCCCCCCC399333777777777737733333CC3333333
        333333377F33333333FF3333C333333330003333733333333777333333333333
        3000333333333333377733333333333333333333333333333333}
      Hint = 'Delete Workspace Object|'
      NumGlyphs = 2
      Spacing = 1
      Left = 68
      Top = 4
      Visible = True
      OnClick = siWSDeleteClick
      SectionName = 'Workspace'
    end
    object siCalculator: TSpeedItem
      Caption = 'Calculator'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00337000000000
        73333337777777773F333308888888880333337F3F3F3FFF7F33330808089998
        0333337F737377737F333308888888880333337F3F3F3F3F7F33330808080808
        0333337F737373737F333308888888880333337F3F3F3F3F7F33330808080808
        0333337F737373737F333308888888880333337F3F3F3F3F7F33330808080808
        0333337F737373737F333308888888880333337F3FFFFFFF7F33330800000008
        0333337F7777777F7F333308000E0E080333337F7FFFFF7F7F33330800000008
        0333337F777777737F333308888888880333337F333333337F33330888888888
        03333373FFFFFFFF733333700000000073333337777777773333}
      Hint = 'Calculator|'
      NumGlyphs = 2
      Spacing = 1
      Top = 4
      OnClick = miToolsCalcultatorClick
      SectionName = 'Tools'
    end
    object siCustomize: TSpeedItem
      Caption = 'Customize Toolbar'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555550FF0559
        1950555FF75F7557F7F757000FF055591903557775F75557F77570FFFF055559
        1933575FF57F5557F7FF0F00FF05555919337F775F7F5557F7F700550F055559
        193577557F7F55F7577F07550F0555999995755575755F7FFF7F5570F0755011
        11155557F755F777777555000755033305555577755F75F77F55555555503335
        0555555FF5F75F757F5555005503335505555577FF75F7557F55505050333555
        05555757F75F75557F5505000333555505557F777FF755557F55000000355557
        07557777777F55557F5555000005555707555577777FF5557F55553000075557
        0755557F7777FFF5755555335000005555555577577777555555}
      Hint = 'Customize Toolbar|'
      NumGlyphs = 2
      Spacing = 1
      Top = 4
      OnClick = miToolsToolbarClick
      SectionName = 'Tools'
    end
  end
  object MainMenu1: TMainMenu
    Left = 80
    Top = 40
    object mnFile: TMenuItem
      Caption = '&File'
      Hint = 'File operations'
      object miFileNew: TMenuItem
        Caption = '&New'
        OnClick = miFileNewClick
      end
      object miFileOpen: TMenuItem
        Caption = '&Open'
        OnClick = miFileOpenClick
      end
      object miFileClose: TMenuItem
        Caption = '&Close'
        OnClick = miFileCloseClick
      end
      object miFileSave: TMenuItem
        Caption = '&Save'
        OnClick = miFileSaveClick
      end
      object miFileSaveAs: TMenuItem
        Caption = 'Save &As...'
        OnClick = miFileSaveAsClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object miFileExit: TMenuItem
        Caption = '&Exit'
        Hint = 'Stop the program execution'
        OnClick = miFileExitClick
      end
    end
    object miToolCalc: TMenuItem
      Caption = '&Tools'
      GroupIndex = 200
      object miToolsCalcultator: TMenuItem
        Caption = '&Calculator'
        OnClick = miToolsCalcultatorClick
      end
      object miToolsToolbar: TMenuItem
        Caption = 'Customize &Toolbar'
        OnClick = miToolsToolbarClick
      end
    end
    object Windows1: TMenuItem
      Caption = '&Windows'
      GroupIndex = 210
      object miWindowCascade: TMenuItem
        Caption = '&Cascade'
        OnClick = miWindowCascadeClick
      end
      object miWindowTile: TMenuItem
        Caption = '&Tile'
        OnClick = miWindowTileClick
      end
      object miWindowArrange: TMenuItem
        Caption = '&Arrange Icons'
        OnClick = miWindowArrangeClick
      end
      object miWindowMinimize: TMenuItem
        Caption = '&Minimize All'
        OnClick = miWindowMinimizeClick
      end
    end
    object mnHelp: TMenuItem
      Caption = '&Help'
      GroupIndex = 250
      Hint = 'Help? What is means?'
      object miAbout: TMenuItem
        Caption = '&About...'
        Hint = 'Give an example of where NN are used'
        OnClick = miAboutClick
      end
    end
  end
  object fp: TFormPlacement
    IniSection = 'ShellWindow'
    UseRegistry = False
    OnSavePlacement = SetINIPath
    OnRestorePlacement = SetINIPath
    Left = 110
    Top = 40
  end
  object dlgCalc: TRxCalculator
    Left = 50
    Top = 40
  end
  object AppEvents1: TAppEvents
    OnHint = AppEvents1Hint
    Left = 20
    Top = 40
  end
  object sdWorkspace: TSaveDialog
    DefaultExt = 'nnw'
    Filter = 'Workspace files|*.nnw|All files|*.*'
    Options = [ofOverwritePrompt, ofExtensionDifferent, ofPathMustExist]
    Left = 17
    Top = 75
  end
  object odWorkSpace: TOpenDialog
    DefaultExt = 'nnw'
    Filter = 'Workspace files|*.nnw|All files|*.*'
    Options = [ofExtensionDifferent, ofPathMustExist, ofFileMustExist]
    Left = 17
    Top = 105
  end
end
