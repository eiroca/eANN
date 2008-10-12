inherited fmANNPRBEditor: TfmANNPRBEditor
  Caption = 'fmANNPRBEditor'
  ClientHeight = 320
  ClientWidth = 464
  ExplicitWidth = 472
  ExplicitHeight = 354
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnMain: TPanel
    Width = 464
    Height = 320
    ExplicitWidth = 464
    ExplicitHeight = 320
    inherited pcEditor: TPageControl
      Width = 464
      Height = 320
      ActivePage = tsActions
      OnChange = pcEditorChange
      ExplicitWidth = 464
      ExplicitHeight = 320
      inherited tsProp: TTabSheet
        ExplicitWidth = 456
        ExplicitHeight = 292
        inherited ScrollBox3: TScrollBox
          Width = 456
          Height = 292
          ExplicitWidth = 456
          ExplicitHeight = 292
          object Bevel8: TBevel [13]
            Left = 5
            Top = 175
            Width = 156
            Height = 111
            Shape = bsFrame
          end
          object Label21: TLabel [14]
            Left = 10
            Top = 194
            Width = 48
            Height = 13
            Caption = 'Total error'
          end
          object Label22: TLabel [15]
            Left = 10
            Top = 224
            Width = 64
            Height = 13
            Caption = 'Average error'
          end
          object Label23: TLabel [16]
            Left = 10
            Top = 259
            Width = 68
            Height = 13
            Caption = 'Maximum error'
          end
          object Label30: TLabel [17]
            Left = 15
            Top = 170
            Width = 71
            Height = 13
            Caption = ' Learning error '
          end
          object Label28: TLabel [18]
            Left = 175
            Top = 234
            Width = 34
            Height = 13
            Caption = 'Spread'
          end
          object Label29: TLabel [19]
            Left = 175
            Top = 259
            Width = 31
            Height = 13
            Caption = 'Decay'
          end
          object Bevel10: TBevel [20]
            Left = 165
            Top = 175
            Width = 151
            Height = 111
            Shape = bsFrame
          end
          object Label27: TLabel [21]
            Left = 175
            Top = 209
            Width = 47
            Height = 13
            Caption = 'Dead age'
          end
          object Label32: TLabel [22]
            Left = 175
            Top = 170
            Width = 93
            Height = 13
            Caption = ' Network dynamics '
          end
          object Bevel9: TBevel [23]
            Left = 323
            Top = 175
            Width = 121
            Height = 111
            Shape = bsFrame
          end
          object Label24: TLabel [24]
            Left = 331
            Top = 188
            Width = 70
            Height = 13
            Alignment = taCenter
            Caption = 'Influence zone'
          end
          object Label25: TLabel [25]
            Left = 330
            Top = 233
            Width = 87
            Height = 13
            Alignment = taCenter
            Caption = 'Overlapping factor'
          end
          object Label31: TLabel [26]
            Left = 330
            Top = 170
            Width = 95
            Height = 13
            Caption = ' Neurons properties '
          end
          object Label13: TLabel [27]
            Left = 330
            Top = 210
            Width = 14
            Height = 13
            Caption = 'Ro'
          end
          object Label14: TLabel [28]
            Left = 330
            Top = 260
            Width = 25
            Height = 13
            Caption = 'Delta'
          end
          object iTotErr: TRxSpinEdit
            Left = 85
            Top = 190
            Width = 70
            Height = 21
            Alignment = taRightJustify
            Decimal = 4
            Increment = 0.010000000000000000
            ValueType = vtFloat
            TabOrder = 8
            OnChange = iTotErrChange
          end
          object iAveErr: TRxSpinEdit
            Left = 85
            Top = 220
            Width = 70
            Height = 21
            Alignment = taRightJustify
            Decimal = 4
            Increment = 0.010000000000000000
            ValueType = vtFloat
            TabOrder = 9
            OnChange = iAveErrChange
          end
          object iMaxErr: TRxSpinEdit
            Left = 85
            Top = 255
            Width = 70
            Height = 21
            Alignment = taRightJustify
            Decimal = 4
            Increment = 0.100000000000000000
            ValueType = vtFloat
            TabOrder = 10
            OnChange = iMaxErrChange
          end
          object cbAged: TCheckBox
            Left = 175
            Top = 185
            Width = 111
            Height = 17
            Caption = 'Networ is dynamic'
            TabOrder = 11
            OnClick = cbAgedClick
          end
          object iDeadAge: TRxSpinEdit
            Left = 230
            Top = 205
            Width = 76
            Height = 21
            Alignment = taRightJustify
            Decimal = 5
            Increment = 0.010000000000000000
            ValueType = vtFloat
            TabOrder = 12
            OnChange = iDeadAgeChange
          end
          object iSpread: TRxSpinEdit
            Left = 230
            Top = 230
            Width = 76
            Height = 21
            Alignment = taRightJustify
            Decimal = 5
            Increment = 0.010000000000000000
            ValueType = vtFloat
            TabOrder = 13
            OnChange = iSpreadChange
          end
          object iDecay: TRxSpinEdit
            Left = 230
            Top = 255
            Width = 76
            Height = 21
            Alignment = taRightJustify
            Decimal = 5
            Increment = 0.010000000000000000
            ValueType = vtFloat
            TabOrder = 14
            OnChange = iDecayChange
          end
          object iRo: TRxSpinEdit
            Left = 360
            Top = 205
            Width = 76
            Height = 21
            Alignment = taRightJustify
            Decimal = 5
            Increment = 0.010000000000000000
            ValueType = vtFloat
            TabOrder = 15
            OnChange = iRoChange
          end
          object iDelta: TRxSpinEdit
            Left = 360
            Top = 255
            Width = 76
            Height = 21
            Alignment = taRightJustify
            Decimal = 5
            Increment = 0.010000000000000000
            MaxValue = 1.000000000000000000
            ValueType = vtFloat
            TabOrder = 16
            OnChange = iDeltaChange
          end
        end
      end
      inherited tsInfo: TTabSheet
        ExplicitWidth = 456
        ExplicitHeight = 292
        inherited ScrollBox2: TScrollBox
          Width = 456
          Height = 292
          ExplicitWidth = 456
          ExplicitHeight = 292
          inherited bNetIs: TBevel
            Width = 281
            ExplicitWidth = 281
          end
          object Bevel13: TBevel [17]
            Left = 5
            Top = 185
            Width = 281
            Height = 71
            Shape = bsFrame
          end
          object lbAttMin: TLabel [18]
            Left = 70
            Top = 200
            Width = 63
            Height = 13
            Caption = '99999.99999'
          end
          object lbAttMax: TLabel [19]
            Left = 70
            Top = 215
            Width = 63
            Height = 13
            Caption = '99999.99999'
          end
          object lbAttLst: TLabel [20]
            Left = 70
            Top = 235
            Width = 63
            Height = 13
            Caption = '99999.99999'
          end
          object lbAttNum: TLabel [21]
            Left = 205
            Top = 230
            Width = 30
            Height = 13
            Caption = '99999'
          end
          object lbAttVar: TLabel [22]
            Left = 205
            Top = 215
            Width = 63
            Height = 13
            Caption = '99999.99999'
          end
          object lbAttAve: TLabel [23]
            Left = 205
            Top = 200
            Width = 63
            Height = 13
            Caption = '99999.99999'
          end
          object Label37: TLabel [24]
            Left = 15
            Top = 200
            Width = 41
            Height = 13
            Caption = 'Minimum'
          end
          object Label38: TLabel [25]
            Left = 15
            Top = 215
            Width = 44
            Height = 13
            Caption = 'Maximum'
          end
          object Label39: TLabel [26]
            Left = 150
            Top = 215
            Width = 42
            Height = 13
            Caption = 'Variance'
          end
          object Label40: TLabel [27]
            Left = 150
            Top = 200
            Width = 40
            Height = 13
            Caption = 'Average'
          end
          object Label41: TLabel [28]
            Left = 15
            Top = 235
            Width = 49
            Height = 13
            Caption = 'Last value'
          end
          object Label42: TLabel [29]
            Left = 150
            Top = 230
            Width = 45
            Height = 13
            Caption = 'Pop. Size'
          end
          object Label43: TLabel [30]
            Left = 15
            Top = 180
            Width = 96
            Height = 13
            Caption = ' Activation statistics '
          end
          object Bevel11: TBevel [31]
            Left = 290
            Top = 10
            Width = 156
            Height = 41
            Shape = bsFrame
          end
          object lbNumAux: TLabel [32]
            Left = 400
            Top = 30
            Width = 24
            Height = 13
            Caption = '9999'
          end
          object lbNumNeu: TLabel [33]
            Left = 400
            Top = 15
            Width = 24
            Height = 13
            Caption = '9999'
          end
          object Label26: TLabel [34]
            Left = 295
            Top = 15
            Width = 98
            Height = 13
            Caption = 'Number of Nueron(s)'
          end
          object Label33: TLabel [35]
            Left = 295
            Top = 30
            Width = 81
            Height = 13
            Caption = 'Number of Aux(s)'
          end
          object Bevel12: TBevel [36]
            Left = 290
            Top = 185
            Width = 156
            Height = 71
            Shape = bsFrame
          end
          object lbKilled: TLabel [37]
            Left = 400
            Top = 195
            Width = 24
            Height = 13
            Caption = '9999'
          end
          object lbReduction: TLabel [38]
            Left = 400
            Top = 235
            Width = 24
            Height = 13
            Caption = '9999'
          end
          object lbPeak: TLabel [39]
            Left = 400
            Top = 215
            Width = 24
            Height = 13
            Caption = '9999'
          end
          object Label34: TLabel [40]
            Left = 300
            Top = 195
            Width = 72
            Height = 13
            Caption = 'Killed neuron(s)'
          end
          object Label35: TLabel [41]
            Left = 300
            Top = 215
            Width = 72
            Height = 13
            Caption = 'Peak neuron(s)'
          end
          object Label36: TLabel [42]
            Left = 300
            Top = 235
            Width = 91
            Height = 13
            Caption = 'Radius reduction(s)'
          end
        end
      end
      inherited tsActions: TTabSheet
        ExplicitWidth = 456
        ExplicitHeight = 292
        inherited ScrollBox1: TScrollBox
          Width = 456
          Height = 292
          ExplicitWidth = 456
          ExplicitHeight = 292
          inherited cbMakeNewDataList: TCheckBox
            TabOrder = 7
          end
          object btRecalcAtt: TBitBtn
            Left = 175
            Top = 131
            Width = 101
            Height = 25
            Caption = 'Recalc Activation'
            TabOrder = 6
            OnClick = btRecalcAttClick
          end
        end
      end
    end
  end
end
