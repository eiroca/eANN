inherited fmANNPLNEditor: TfmANNPLNEditor
  Left = 177
  Top = 181
  Caption = 'fmANNPLNEditor'
  ClientHeight = 331
  ExplicitWidth = 320
  ExplicitHeight = 365
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnMain: TPanel
    Height = 331
    ExplicitHeight = 331
    inherited pcEditor: TPageControl
      Height = 331
      ExplicitHeight = 331
      inherited tsProp: TTabSheet
        ExplicitHeight = 303
        inherited sbProp: TScrollBox
          Height = 303
          ExplicitHeight = 303
          object Label26: TLabel [0]
            Left = 295
            Top = 25
            Width = 98
            Height = 13
            Caption = 'Number of Nueron(s)'
          end
          object lbNumNeu1: TLabel [1]
            Left = 400
            Top = 25
            Width = 24
            Height = 13
            Caption = '9999'
          end
          object Bevel11: TGroupBox [2]
            Left = 290
            Top = 10
            Width = 156
            Height = 41
            TabOrder = 4
          end
          object Bevel1: TGroupBox [3]
            Left = 291
            Top = 102
            Width = 156
            Height = 41
            Caption = 'Size'
            TabOrder = 5
            object Label1: TLabel
              Left = 3
              Top = 21
              Width = 98
              Height = 13
              Caption = 'Number of Nueron(s)'
            end
            object Label6: TLabel
              Left = 118
              Top = 21
              Width = 24
              Height = 13
              Caption = '9999'
            end
          end
          inherited gSize: TGroupBox
            Top = 50
            TabOrder = 6
            ExplicitTop = 50
          end
        end
      end
      inherited tsTrain: TTabSheet
        ExplicitHeight = 303
        inherited sbTrain: TScrollBox
          Height = 303
          ExplicitHeight = 303
          object gTrnPrm: TGroupBox [0]
            Left = 3
            Top = 56
            Width = 443
            Height = 51
            Caption = 'Learning parameters'
            TabOrder = 5
            object Label21: TLabel
              Left = 7
              Top = 23
              Width = 34
              Height = 13
              Caption = 'Epsilon'
            end
            object Label22: TLabel
              Left = 139
              Top = 24
              Width = 16
              Height = 13
              Caption = 'Eta'
            end
            object Label15: TLabel
              Left = 287
              Top = 25
              Width = 34
              Height = 13
              Caption = 'Spread'
            end
            object iEps: TJvSpinEdit
              Left = 52
              Top = 19
              Width = 76
              Height = 21
              Alignment = taRightJustify
              Decimal = 4
              Increment = 0.010000000000000000
              ValueType = vtFloat
              TabOrder = 0
              OnChange = iEpsChange
            end
            object iEta: TJvSpinEdit
              Left = 184
              Top = 20
              Width = 76
              Height = 21
              Alignment = taRightJustify
              Decimal = 4
              Increment = 0.010000000000000000
              ValueType = vtFloat
              TabOrder = 1
              OnChange = iEtaChange
            end
            object iSpr: TJvSpinEdit
              Left = 332
              Top = 21
              Width = 76
              Height = 21
              Alignment = taRightJustify
              Decimal = 4
              Increment = 0.010000000000000000
              ValueType = vtFloat
              TabOrder = 2
              OnChange = iSprChange
            end
          end
          object Bevel9: TGroupBox [1]
            Left = 3
            Top = 113
            Width = 443
            Height = 74
            Caption = 'Neurons properties'
            TabOrder = 4
            object Label24: TLabel
              Left = 11
              Top = 43
              Width = 24
              Height = 13
              Alignment = taCenter
              Caption = 'Input'
            end
            object Label25: TLabel
              Left = 123
              Top = 46
              Width = 32
              Height = 13
              Alignment = taCenter
              Caption = 'Output'
            end
            object Label23: TLabel
              Left = 311
              Top = 47
              Width = 38
              Height = 13
              Caption = 'Lambda'
            end
            object Label13: TLabel
              Left = 11
              Top = 24
              Width = 70
              Height = 13
              Alignment = taCenter
              Caption = 'Influence zone'
            end
            object iRoI: TJvSpinEdit
              Left = 41
              Top = 43
              Width = 76
              Height = 21
              Alignment = taRightJustify
              Decimal = 4
              Increment = 0.010000000000000000
              ValueType = vtFloat
              TabOrder = 0
              OnChange = iRoIChange
            end
            object iRoO: TJvSpinEdit
              Left = 161
              Top = 43
              Width = 76
              Height = 21
              Alignment = taRightJustify
              Decimal = 4
              Increment = 0.010000000000000000
              MaxValue = 1.000000000000000000
              ValueType = vtFloat
              TabOrder = 1
              OnChange = iRoOChange
            end
            object iLmd: TJvSpinEdit
              Left = 355
              Top = 44
              Width = 76
              Height = 21
              Alignment = taRightJustify
              Decimal = 4
              Increment = 0.010000000000000000
              ValueType = vtFloat
              TabOrder = 2
              OnChange = iLmdChange
            end
          end
          inherited gTrnOpt: TGroupBox
            Top = 193
            ExplicitTop = 193
          end
          inherited btTrain: TBitBtn
            Top = 272
            ExplicitTop = 272
          end
          inherited btStopTrn: TBitBtn
            Top = 272
            ExplicitTop = 272
          end
        end
      end
      inherited tsApply: TTabSheet
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 303
        inherited sbApply: TScrollBox
          Height = 303
          ExplicitHeight = 303
          inherited btApply: TBitBtn
            Top = 144
            ExplicitTop = 144
          end
          inherited btStopApl: TBitBtn
            Top = 144
            TabOrder = 2
            ExplicitTop = 144
          end
          object Bevel10: TGroupBox [2]
            Left = 3
            Top = 87
            Width = 443
            Height = 51
            Caption = 'Options'
            TabOrder = 1
            object Label14: TLabel
              Left = 6
              Top = 22
              Width = 94
              Height = 13
              Caption = 'Number of winnners'
            end
            object iWin: TJvSpinEdit
              Left = 112
              Top = 17
              Width = 59
              Height = 21
              CheckMaxValue = False
              Alignment = taRightJustify
              Decimal = 4
              MinValue = 1.000000000000000000
              Value = 1.000000000000000000
              TabOrder = 0
              OnChange = iWinChange
            end
          end
          inherited gDataSourceApl: TGroupBox
            TabOrder = 3
          end
        end
      end
      inherited tsError: TTabSheet
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 303
        inherited sbError: TScrollBox
          Height = 303
          ExplicitHeight = 303
          inherited gErrOpt: TGroupBox
            Height = 66
            ExplicitHeight = 66
            object Label19: TLabel [0]
              Left = 6
              Top = 21
              Width = 94
              Height = 13
              Caption = 'Number of winnners'
            end
            inherited cbNewErrSet: TJvCheckBox
              Top = 42
              ExplicitTop = 42
            end
            object JvSpinEdit1: TJvSpinEdit
              Left = 112
              Top = 16
              Width = 59
              Height = 21
              CheckMaxValue = False
              Alignment = taRightJustify
              Decimal = 4
              MinValue = 1.000000000000000000
              Value = 1.000000000000000000
              TabOrder = 1
              OnChange = iWinChange
            end
          end
          inherited btError: TBitBtn
            Top = 127
            ExplicitTop = 127
          end
          inherited btStopErr: TBitBtn
            Top = 127
            ExplicitTop = 127
          end
        end
      end
    end
  end
end
