inherited fmANNPRBEditor: TfmANNPRBEditor
  Caption = 'fmANNPRBEditor'
  ClientHeight = 386
  ClientWidth = 464
  ExplicitWidth = 480
  ExplicitHeight = 425
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnMain: TPanel
    Width = 464
    Height = 386
    ExplicitWidth = 464
    ExplicitHeight = 386
    inherited pcEditor: TPageControl
      Width = 464
      Height = 386
      ExplicitWidth = 464
      ExplicitHeight = 386
      inherited tsProp: TTabSheet
        ExplicitWidth = 456
        ExplicitHeight = 358
        inherited sbProp: TScrollBox
          Width = 456
          Height = 358
          ExplicitWidth = 456
          ExplicitHeight = 358
          object Bevel11: TGroupBox [4]
            Left = 291
            Top = 49
            Width = 155
            Height = 41
            Caption = 'Size'
            TabOrder = 4
            object Label33: TLabel
              Left = 3
              Top = 26
              Width = 81
              Height = 13
              Caption = 'Number of Aux(s)'
            end
            object Label26: TLabel
              Left = 3
              Top = 11
              Width = 98
              Height = 13
              Caption = 'Number of Nueron(s)'
            end
            object lbNumNeu: TLabel
              Left = 107
              Top = 11
              Width = 24
              Height = 13
              Caption = '9999'
            end
            object lbNumAux: TLabel
              Left = 107
              Top = 26
              Width = 24
              Height = 13
              Caption = '9999'
            end
          end
          object Bevel13: TGroupBox [5]
            Left = 3
            Top = 209
            Width = 282
            Height = 75
            Caption = 'Activation statistics'
            TabOrder = 5
            object Label37: TLabel
              Left = 10
              Top = 18
              Width = 41
              Height = 13
              Caption = 'Minimum'
            end
            object lbAttMin: TLabel
              Left = 65
              Top = 17
              Width = 63
              Height = 13
              Caption = '99999.99999'
            end
            object Label40: TLabel
              Left = 145
              Top = 18
              Width = 40
              Height = 13
              Caption = 'Average'
            end
            object lbAttAve: TLabel
              Left = 200
              Top = 17
              Width = 63
              Height = 13
              Caption = '99999.99999'
            end
            object lbAttVar: TLabel
              Left = 200
              Top = 34
              Width = 63
              Height = 13
              Caption = '99999.99999'
            end
            object lbAttNum: TLabel
              Left = 200
              Top = 52
              Width = 30
              Height = 13
              Caption = '99999'
            end
            object Label42: TLabel
              Left = 144
              Top = 52
              Width = 45
              Height = 13
              Caption = 'Pop. Size'
            end
            object Label39: TLabel
              Left = 145
              Top = 35
              Width = 42
              Height = 13
              Caption = 'Variance'
            end
            object lbAttMax: TLabel
              Left = 65
              Top = 35
              Width = 63
              Height = 13
              Caption = '99999.99999'
            end
            object Label38: TLabel
              Left = 10
              Top = 35
              Width = 44
              Height = 13
              Caption = 'Maximum'
            end
            object Label41: TLabel
              Left = 10
              Top = 53
              Width = 49
              Height = 13
              Caption = 'Last value'
            end
            object lbAttLst: TLabel
              Left = 65
              Top = 53
              Width = 63
              Height = 13
              Caption = '99999.99999'
            end
          end
          object Bevel12: TGroupBox [6]
            Left = 291
            Top = 208
            Width = 158
            Height = 76
            Caption = 'Network stats'
            TabOrder = 6
            object Label34: TLabel
              Left = 8
              Top = 19
              Width = 72
              Height = 13
              Caption = 'Killed neuron(s)'
            end
            object lbKilled: TLabel
              Left = 108
              Top = 19
              Width = 24
              Height = 13
              Caption = '9999'
            end
            object Label35: TLabel
              Left = 8
              Top = 38
              Width = 72
              Height = 13
              Caption = 'Peak neuron(s)'
            end
            object lbPeak: TLabel
              Left = 108
              Top = 38
              Width = 24
              Height = 13
              Caption = '9999'
            end
            object Label36: TLabel
              Left = 8
              Top = 57
              Width = 91
              Height = 13
              Caption = 'Radius reduction(s)'
            end
            object lbReduction: TLabel
              Left = 108
              Top = 57
              Width = 24
              Height = 13
              Caption = '9999'
            end
          end
          inherited gSize: TGroupBox
            Top = 67
            Width = 0
            Height = 0
            TabOrder = 7
            ExplicitTop = 67
            ExplicitWidth = 0
            ExplicitHeight = 0
          end
        end
      end
      inherited tsTrain: TTabSheet
        ExplicitWidth = 456
        ExplicitHeight = 358
        inherited sbTrain: TScrollBox
          Width = 456
          Height = 358
          ExplicitWidth = 456
          ExplicitHeight = 358
          inherited gTrnOpt: TGroupBox
            Top = 160
            ExplicitTop = 160
          end
          inherited btTrain: TBitBtn
            Left = 226
            Top = 323
            Width = 220
            ExplicitLeft = 226
            ExplicitTop = 323
            ExplicitWidth = 220
          end
          inherited btStopTrn: TBitBtn
            Top = 323
            TabOrder = 6
            ExplicitTop = 323
          end
          inherited gDataSource: TGroupBox
            TabOrder = 7
          end
          object gLrnPrm: TGroupBox
            Left = 3
            Top = 52
            Width = 443
            Height = 49
            Caption = 'Learning error'
            TabOrder = 2
            object Label21: TLabel
              Left = 9
              Top = 21
              Width = 48
              Height = 13
              Caption = 'Total error'
            end
            object Label23: TLabel
              Left = 139
              Top = 20
              Width = 68
              Height = 13
              Caption = 'Maximum error'
            end
            object iTotErr: TJvSpinEdit
              Left = 63
              Top = 17
              Width = 70
              Height = 21
              Alignment = taRightJustify
              Decimal = 4
              Increment = 0.010000000000000000
              ValueType = vtFloat
              TabOrder = 0
              OnChange = iTotErrChange
            end
            object iMaxErr: TJvSpinEdit
              Left = 213
              Top = 17
              Width = 70
              Height = 21
              Alignment = taRightJustify
              Decimal = 4
              Increment = 0.100000000000000000
              ValueType = vtFloat
              TabOrder = 1
              OnChange = iMaxErrChange
            end
          end
          object gNeuPrm: TGroupBox
            Left = 3
            Top = 107
            Width = 443
            Height = 50
            Caption = 'Neurons properties'
            TabOrder = 3
            object Label24: TLabel
              Left = 15
              Top = 22
              Width = 70
              Height = 13
              Alignment = taCenter
              Caption = 'Influence zone'
            end
            object Label13: TLabel
              Left = 97
              Top = 22
              Width = 14
              Height = 13
              Caption = 'Ro'
            end
            object Label25: TLabel
              Left = 223
              Top = 22
              Width = 87
              Height = 13
              Alignment = taCenter
              Caption = 'Overlapping factor'
            end
            object Label14: TLabel
              Left = 323
              Top = 22
              Width = 25
              Height = 13
              Caption = 'Delta'
            end
            object iRo: TJvSpinEdit
              Left = 127
              Top = 17
              Width = 76
              Height = 21
              Alignment = taRightJustify
              Decimal = 5
              Increment = 0.010000000000000000
              ValueType = vtFloat
              TabOrder = 0
              OnChange = iRoChange
            end
            object iDelta: TJvSpinEdit
              Left = 353
              Top = 17
              Width = 76
              Height = 21
              Alignment = taRightJustify
              Decimal = 5
              Increment = 0.010000000000000000
              MaxValue = 1.000000000000000000
              ValueType = vtFloat
              TabOrder = 1
              OnChange = iDeltaChange
            end
          end
          object gDynamic: TGroupBox
            Left = 3
            Top = 237
            Width = 443
            Height = 80
            Caption = 'Dynamic network'
            TabOrder = 4
            object Label27: TLabel
              Left = 8
              Top = 47
              Width = 47
              Height = 13
              Caption = 'Dead age'
            end
            object Label28: TLabel
              Left = 142
              Top = 48
              Width = 34
              Height = 13
              Caption = 'Spread'
            end
            object Label29: TLabel
              Left = 267
              Top = 49
              Width = 31
              Height = 13
              Caption = 'Decay'
            end
            object iDeadAge: TJvSpinEdit
              Left = 61
              Top = 45
              Width = 76
              Height = 21
              Alignment = taRightJustify
              Decimal = 5
              Increment = 0.010000000000000000
              ValueType = vtFloat
              TabOrder = 0
              OnChange = iDeadAgeChange
            end
            object iSpread: TJvSpinEdit
              Left = 182
              Top = 46
              Width = 76
              Height = 21
              Alignment = taRightJustify
              Decimal = 5
              Increment = 0.010000000000000000
              ValueType = vtFloat
              TabOrder = 1
              OnChange = iSpreadChange
            end
            object iDecay: TJvSpinEdit
              Left = 304
              Top = 47
              Width = 76
              Height = 21
              Alignment = taRightJustify
              Decimal = 5
              Increment = 0.010000000000000000
              ValueType = vtFloat
              TabOrder = 2
              OnChange = iDecayChange
            end
            object cbAged: TCheckBox
              Left = 12
              Top = 22
              Width = 221
              Height = 17
              Caption = 'Allow dinamic network'
              TabOrder = 3
            end
          end
          object btRecalcAtt: TBitBtn
            Left = 109
            Top = 323
            Width = 111
            Height = 25
            Caption = 'Recalc Activation'
            TabOrder = 5
            OnClick = btRecalcAttClick
          end
        end
      end
      inherited tsApply: TTabSheet
        ExplicitWidth = 456
        ExplicitHeight = 358
        inherited sbApply: TScrollBox
          Width = 456
          Height = 358
          ExplicitWidth = 456
          ExplicitHeight = 358
        end
      end
      inherited tsError: TTabSheet
        ExplicitWidth = 456
        ExplicitHeight = 358
        inherited sbError: TScrollBox
          Width = 456
          Height = 358
          ExplicitWidth = 456
          ExplicitHeight = 358
        end
      end
    end
  end
end
