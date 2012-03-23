inherited fmANNRBEditor: TfmANNRBEditor
  Caption = 'fmANNRBEditor'
  ClientHeight = 282
  ClientWidth = 458
  ExplicitWidth = 466
  ExplicitHeight = 316
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnMain: TPanel
    Width = 458
    Height = 282
    ExplicitWidth = 458
    ExplicitHeight = 282
    inherited pcEditor: TPageControl
      Width = 458
      Height = 282
      ActivePage = tsInfo
      OnChange = pcEditorChange
      ExplicitWidth = 458
      ExplicitHeight = 282
      inherited tsProp: TTabSheet
        ExplicitLeft = 4
        ExplicitTop = 24
        ExplicitWidth = 450
        ExplicitHeight = 254
        inherited ScrollBox3: TScrollBox
          Width = 450
          Height = 254
          ExplicitWidth = 450
          ExplicitHeight = 254
          object Bevel9: TBevel [13]
            Left = 295
            Top = 175
            Width = 149
            Height = 71
            Shape = bsFrame
          end
          object Bevel8: TBevel [14]
            Left = 5
            Top = 175
            Width = 271
            Height = 71
            Shape = bsFrame
          end
          object Label21: TLabel [15]
            Left = 180
            Top = 219
            Width = 44
            Height = 13
            Caption = 'neuron(s)'
          end
          object Label23: TLabel [16]
            Left = 20
            Top = 194
            Width = 68
            Height = 13
            Caption = 'Maximum error'
          end
          object Label24: TLabel [17]
            Left = 305
            Top = 193
            Width = 130
            Height = 13
            Alignment = taCenter
            Caption = 'Ro - Neuron influence zone'
          end
          object Label30: TLabel [18]
            Left = 10
            Top = 170
            Width = 102
            Height = 13
            Caption = ' Learning parameters '
          end
          object Label31: TLabel [19]
            Left = 300
            Top = 170
            Width = 95
            Height = 13
            Caption = ' Neurons properties '
          end
          object iMaxNeu: TJvSpinEdit
            Left = 100
            Top = 215
            Width = 76
            Height = 21
            Alignment = taRightJustify
            Decimal = 4
            TabOrder = 8
            OnChange = iMaxNeuChange
          end
          object iMaxErr: TJvSpinEdit
            Left = 100
            Top = 190
            Width = 76
            Height = 21
            Alignment = taRightJustify
            Decimal = 4
            Increment = 0.010000000000000000
            ValueType = vtFloat
            TabOrder = 9
            OnChange = iMaxErrChange
          end
          object iRo: TJvSpinEdit
            Left = 330
            Top = 215
            Width = 86
            Height = 21
            Alignment = taRightJustify
            Decimal = 6
            Increment = 0.010000000000000000
            ValueType = vtFloat
            TabOrder = 10
            OnChange = iRoChange
          end
          object cbMaxNeu: TCheckBox
            Left = 20
            Top = 217
            Width = 76
            Height = 17
            Caption = 'Create only'
            TabOrder = 11
            OnClick = cbMaxNeuClick
          end
        end
      end
      inherited tsInfo: TTabSheet
        ExplicitHeight = 254
        inherited ScrollBox2: TScrollBox
          Width = 450
          Height = 254
          ExplicitWidth = 450
          ExplicitHeight = 254
          inherited bNetIs: TBevel
            Width = 281
            ExplicitWidth = 281
          end
          object Bevel11: TBevel [17]
            Left = 290
            Top = 11
            Width = 156
            Height = 41
            Shape = bsFrame
          end
          object Label26: TLabel [18]
            Left = 295
            Top = 25
            Width = 98
            Height = 13
            Caption = 'Number of Nueron(s)'
          end
          object lbNumNeu: TLabel [19]
            Left = 400
            Top = 25
            Width = 24
            Height = 13
            Caption = '9999'
          end
          object Bevel13: TBevel [20]
            Left = 5
            Top = 185
            Width = 441
            Height = 66
            Shape = bsFrame
          end
          object lbAttMin: TLabel [21]
            Left = 70
            Top = 200
            Width = 63
            Height = 13
            Caption = '99999.99999'
          end
          object lbAttMax: TLabel [22]
            Left = 70
            Top = 220
            Width = 63
            Height = 13
            Caption = '99999.99999'
          end
          object lbAttLst: TLabel [23]
            Left = 345
            Top = 200
            Width = 63
            Height = 13
            Caption = '99999.99999'
          end
          object lbAttNum: TLabel [24]
            Left = 205
            Top = 230
            Width = 30
            Height = 13
            Caption = '99999'
          end
          object lbAttVar: TLabel [25]
            Left = 205
            Top = 215
            Width = 63
            Height = 13
            Caption = '99999.99999'
          end
          object lbAttAve: TLabel [26]
            Left = 205
            Top = 200
            Width = 63
            Height = 13
            Caption = '99999.99999'
          end
          object Label37: TLabel [27]
            Left = 15
            Top = 200
            Width = 41
            Height = 13
            Caption = 'Minimum'
          end
          object Label38: TLabel [28]
            Left = 15
            Top = 220
            Width = 44
            Height = 13
            Caption = 'Maximum'
          end
          object Label39: TLabel [29]
            Left = 150
            Top = 215
            Width = 42
            Height = 13
            Caption = 'Variance'
          end
          object Label40: TLabel [30]
            Left = 150
            Top = 200
            Width = 40
            Height = 13
            Caption = 'Average'
          end
          object Label41: TLabel [31]
            Left = 290
            Top = 200
            Width = 49
            Height = 13
            Caption = 'Last value'
          end
          object Label42: TLabel [32]
            Left = 150
            Top = 230
            Width = 45
            Height = 13
            Caption = 'Pop. Size'
          end
          object Label43: TLabel [33]
            Left = 15
            Top = 180
            Width = 96
            Height = 13
            Caption = ' Activation statistics '
          end
        end
      end
      inherited tsActions: TTabSheet
        ExplicitHeight = 247
        inherited ScrollBox1: TScrollBox
          Width = 450
          Height = 254
          ExplicitWidth = 450
          ExplicitHeight = 247
          inherited cbMakeNewDataList: TCheckBox
            TabOrder = 7
          end
          object btRecalcAtt: TBitBtn
            Left = 175
            Top = 131
            Width = 106
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
