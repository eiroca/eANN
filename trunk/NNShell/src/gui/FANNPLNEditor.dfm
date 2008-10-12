inherited fmANNPLNEditor: TfmANNPLNEditor
  Left = 177
  Top = 181
  Caption = 'fmANNPLNEditor'
  ClientHeight = 302
  ExplicitHeight = 336
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnMain: TPanel
    Height = 302
    ExplicitHeight = 302
    inherited pcEditor: TPageControl
      Height = 302
      ActivePage = tsActions
      OnChange = pcEditorChange
      ExplicitHeight = 302
      inherited tsProp: TTabSheet
        ExplicitHeight = 274
        inherited ScrollBox3: TScrollBox
          Height = 274
          ExplicitHeight = 274
          object Bevel8: TBevel [13]
            Left = 5
            Top = 175
            Width = 141
            Height = 96
            Shape = bsFrame
          end
          object Label21: TLabel [14]
            Left = 15
            Top = 194
            Width = 34
            Height = 13
            Caption = 'Epsilon'
          end
          object Label22: TLabel [15]
            Left = 15
            Top = 219
            Width = 16
            Height = 13
            Caption = 'Eta'
          end
          object Label30: TLabel [16]
            Left = 15
            Top = 170
            Width = 102
            Height = 13
            Caption = ' Learning parameters '
          end
          object Label15: TLabel [17]
            Left = 15
            Top = 244
            Width = 34
            Height = 13
            Caption = 'Spread'
          end
          object Bevel9: TBevel [18]
            Left = 153
            Top = 175
            Width = 203
            Height = 96
            Shape = bsFrame
          end
          object Label23: TLabel [19]
            Left = 160
            Top = 239
            Width = 38
            Height = 13
            Caption = 'Lambda'
          end
          object Label24: TLabel [20]
            Left = 160
            Top = 193
            Width = 96
            Height = 13
            Alignment = taCenter
            Caption = 'Input influence zone'
          end
          object Label25: TLabel [21]
            Left = 161
            Top = 218
            Width = 104
            Height = 13
            Alignment = taCenter
            Caption = 'Output influence zone'
          end
          object Label31: TLabel [22]
            Left = 160
            Top = 170
            Width = 95
            Height = 13
            Caption = ' Neurons properties '
          end
          object Bevel10: TBevel [23]
            Left = 365
            Top = 175
            Width = 81
            Height = 96
            Shape = bsFrame
          end
          object Label13: TLabel [24]
            Left = 370
            Top = 170
            Width = 54
            Height = 13
            Caption = ' Simulation '
          end
          object Label14: TLabel [25]
            Left = 375
            Top = 194
            Width = 51
            Height = 13
            Caption = 'Winnner(s)'
          end
          object iEps: TRxSpinEdit
            Left = 60
            Top = 190
            Width = 76
            Height = 21
            Alignment = taRightJustify
            Decimal = 4
            Increment = 0.010000000000000000
            ValueType = vtFloat
            TabOrder = 8
            OnChange = iEpsChange
          end
          object iEta: TRxSpinEdit
            Left = 60
            Top = 215
            Width = 76
            Height = 21
            Alignment = taRightJustify
            Decimal = 4
            Increment = 0.010000000000000000
            ValueType = vtFloat
            TabOrder = 9
            OnChange = iEtaChange
          end
          object iSpr: TRxSpinEdit
            Left = 60
            Top = 240
            Width = 76
            Height = 21
            Alignment = taRightJustify
            Decimal = 4
            Increment = 0.010000000000000000
            ValueType = vtFloat
            TabOrder = 10
            OnChange = iSprChange
          end
          object iLmd: TRxSpinEdit
            Left = 270
            Top = 240
            Width = 76
            Height = 21
            Alignment = taRightJustify
            Decimal = 4
            Increment = 0.010000000000000000
            ValueType = vtFloat
            TabOrder = 11
            OnChange = iLmdChange
          end
          object iRoI: TRxSpinEdit
            Left = 270
            Top = 190
            Width = 76
            Height = 21
            Alignment = taRightJustify
            Decimal = 4
            Increment = 0.010000000000000000
            ValueType = vtFloat
            TabOrder = 12
            OnChange = iRoIChange
          end
          object iRoO: TRxSpinEdit
            Left = 270
            Top = 215
            Width = 76
            Height = 21
            Alignment = taRightJustify
            Decimal = 4
            Increment = 0.010000000000000000
            MaxValue = 1.000000000000000000
            ValueType = vtFloat
            TabOrder = 13
            OnChange = iRoOChange
          end
          object iWin: TRxSpinEdit
            Left = 375
            Top = 210
            Width = 59
            Height = 21
            Alignment = taRightJustify
            Decimal = 4
            TabOrder = 14
            OnChange = iWinChange
          end
        end
      end
      inherited tsInfo: TTabSheet
        ExplicitHeight = 274
        inherited ScrollBox2: TScrollBox
          Height = 274
          ExplicitHeight = 274
          inherited bNetIs: TBevel
            Width = 281
            ExplicitWidth = 281
          end
          object Bevel11: TBevel [17]
            Left = 290
            Top = 10
            Width = 156
            Height = 41
            Shape = bsFrame
          end
          object lbNumNeu: TLabel [18]
            Left = 400
            Top = 25
            Width = 24
            Height = 13
            Caption = '9999'
          end
          object Label26: TLabel [19]
            Left = 295
            Top = 25
            Width = 98
            Height = 13
            Caption = 'Number of Nueron(s)'
          end
        end
      end
      inherited tsActions: TTabSheet
        ExplicitHeight = 274
        inherited ScrollBox1: TScrollBox
          Height = 274
          ExplicitHeight = 274
        end
      end
    end
  end
end
