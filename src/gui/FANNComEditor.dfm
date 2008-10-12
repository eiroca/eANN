inherited fmANNComEditor: TfmANNComEditor
  Left = 254
  Top = 122
  Caption = 'fmANNComEditor'
  ClientHeight = 253
  ClientWidth = 459
  ExplicitWidth = 467
  ExplicitHeight = 287
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnMain: TPanel
    Width = 459
    Height = 253
    ExplicitWidth = 459
    ExplicitHeight = 253
    inherited pcEditor: TPageControl
      Width = 459
      Height = 253
      OnChange = pcEditorChange
      ExplicitWidth = 459
      ExplicitHeight = 253
      inherited tsProp: TTabSheet
        ExplicitWidth = 451
        ExplicitHeight = 225
        inherited ScrollBox3: TScrollBox
          Width = 451
          Height = 225
          ExplicitWidth = 451
          ExplicitHeight = 225
          object Bevel8: TBevel [13]
            Left = 5
            Top = 175
            Width = 441
            Height = 46
            Shape = bsFrame
          end
          object Label22: TLabel [14]
            Left = 150
            Top = 194
            Width = 16
            Height = 13
            Caption = 'Eta'
          end
          object Label30: TLabel [15]
            Left = 15
            Top = 170
            Width = 102
            Height = 13
            Caption = ' Learning parameters '
          end
          object Label13: TLabel [16]
            Left = 15
            Top = 194
            Width = 42
            Height = 13
            Caption = 'NumNeu'
          end
          object iEta: TRxSpinEdit
            Left = 175
            Top = 190
            Width = 76
            Height = 21
            Alignment = taRightJustify
            Decimal = 4
            Increment = 0.010000000000000000
            ValueType = vtFloat
            TabOrder = 8
            OnChange = iEtaChange
          end
          object iNumNeu: TRxSpinEdit
            Left = 65
            Top = 190
            Width = 76
            Height = 21
            Alignment = taRightJustify
            Decimal = 4
            MaxValue = 999999.000000000000000000
            MinValue = 1.000000000000000000
            Value = 1.000000000000000000
            TabOrder = 9
            OnChange = iNumNeuChange
          end
        end
      end
      inherited tsInfo: TTabSheet
        ExplicitLeft = 4
        ExplicitTop = 24
        ExplicitWidth = 451
        ExplicitHeight = 225
        inherited ScrollBox2: TScrollBox
          Width = 451
          Height = 225
          ExplicitWidth = 451
          ExplicitHeight = 225
        end
      end
      inherited tsActions: TTabSheet
        ExplicitLeft = 4
        ExplicitTop = 24
        ExplicitWidth = 451
        ExplicitHeight = 225
        inherited ScrollBox1: TScrollBox
          Width = 451
          Height = 225
          ExplicitWidth = 451
          ExplicitHeight = 225
        end
      end
    end
  end
end
