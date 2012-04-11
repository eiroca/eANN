inherited fmANNComEditor: TfmANNComEditor
  Left = 254
  Top = 122
  Caption = 'fmANNComEditor'
  ClientHeight = 259
  ClientWidth = 464
  ExplicitWidth = 472
  ExplicitHeight = 293
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnMain: TPanel
    Width = 464
    Height = 259
    ExplicitWidth = 464
    ExplicitHeight = 259
    inherited pcEditor: TPageControl
      Width = 464
      Height = 259
      ActivePage = tsTrain
      ExplicitWidth = 464
      ExplicitHeight = 259
      inherited tsProp: TTabSheet
        ExplicitWidth = 456
        ExplicitHeight = 231
        inherited sbProp: TScrollBox
          Width = 456
          Height = 231
          ExplicitWidth = 456
          ExplicitHeight = 231
        end
      end
      inherited tsTrain: TTabSheet
        ExplicitWidth = 456
        ExplicitHeight = 231
        inherited sbTrain: TScrollBox
          Width = 456
          Height = 231
          ExplicitWidth = 456
          ExplicitHeight = 231
          object Bevel8: TJvGroupBox [0]
            Left = 3
            Top = 56
            Width = 444
            Height = 57
            Caption = 'Learning parameters'
            TabOrder = 0
            object Label13: TLabel
              Left = 10
              Top = 28
              Width = 42
              Height = 13
              Caption = 'NumNeu'
            end
            object Label22: TLabel
              Left = 145
              Top = 28
              Width = 16
              Height = 13
              Caption = 'Eta'
            end
            object iNumNeu: TJvSpinEdit
              Left = 60
              Top = 20
              Width = 76
              Height = 21
              Alignment = taRightJustify
              Decimal = 4
              MaxValue = 999999.000000000000000000
              MinValue = 1.000000000000000000
              Value = 1.000000000000000000
              TabOrder = 0
              OnChange = iNumNeuChange
            end
            object iEta: TJvSpinEdit
              Left = 170
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
          end
          inherited gTrnOpt: TJvGroupBox
            Top = 118
            TabOrder = 1
            ExplicitTop = 118
          end
          inherited btTrain: TBitBtn
            Top = 199
            TabOrder = 4
            ExplicitTop = 199
          end
          inherited btStopTrn: TBitBtn
            Top = 199
            ExplicitTop = 199
          end
        end
      end
      inherited tsApply: TTabSheet
        ExplicitWidth = 456
        ExplicitHeight = 231
        inherited sbApply: TScrollBox
          Width = 456
          Height = 231
          ExplicitWidth = 456
          ExplicitHeight = 231
        end
      end
      inherited tsError: TTabSheet
        ExplicitWidth = 456
        ExplicitHeight = 231
        inherited sbError: TScrollBox
          Width = 456
          Height = 231
          ExplicitWidth = 456
          ExplicitHeight = 231
        end
      end
    end
  end
end
