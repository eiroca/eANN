inherited fmANNRBEditor: TfmANNRBEditor
  Caption = 'fmANNRBEditor'
  ClientHeight = 316
  ClientWidth = 460
  ExplicitWidth = 468
  ExplicitHeight = 350
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnMain: TPanel
    Width = 460
    Height = 316
    ExplicitWidth = 882
    ExplicitHeight = 669
    inherited pcEditor: TPageControl
      Width = 460
      Height = 316
      OnChange = pcEditorChange
      ExplicitWidth = 460
      ExplicitHeight = 669
      inherited tsProp: TTabSheet
        ExplicitWidth = 874
        ExplicitHeight = 641
        inherited sbProp: TScrollBox
          Width = 452
          Height = 288
          ExplicitWidth = 452
          ExplicitHeight = 288
          inherited gNetOpe: TJvGroupBox
            Left = 3
            ExplicitLeft = 3
          end
          inherited gNetCan: TJvGroupBox
            Left = 290
            ExplicitLeft = 290
          end
          object Bevel11: TJvGroupBox [4]
            Left = 291
            Top = 50
            Width = 155
            Height = 41
            Caption = 'Size'
            TabOrder = 4
            object Label26: TLabel
              Left = 6
              Top = 19
              Width = 98
              Height = 13
              Caption = 'Number of Nueron(s)'
            end
            object lbNumNeu: TLabel
              Left = 111
              Top = 19
              Width = 24
              Height = 13
              Caption = '9999'
            end
          end
          object Bevel13: TJvGroupBox [5]
            Left = 3
            Top = 209
            Width = 443
            Height = 71
            Caption = 'Activation statistics'
            TabOrder = 5
            object Label37: TLabel
              Left = 12
              Top = 21
              Width = 41
              Height = 13
              Caption = 'Minimum'
            end
            object lbAttMin: TLabel
              Left = 67
              Top = 21
              Width = 63
              Height = 13
              Caption = '99999.99999'
            end
            object Label40: TLabel
              Left = 147
              Top = 21
              Width = 40
              Height = 13
              Caption = 'Average'
            end
            object lbAttAve: TLabel
              Left = 202
              Top = 21
              Width = 63
              Height = 13
              Caption = '99999.99999'
            end
            object Label41: TLabel
              Left = 287
              Top = 21
              Width = 49
              Height = 13
              Caption = 'Last value'
            end
            object lbAttLst: TLabel
              Left = 342
              Top = 21
              Width = 63
              Height = 13
              Caption = '99999.99999'
            end
            object lbAttVar: TLabel
              Left = 202
              Top = 36
              Width = 63
              Height = 13
              Caption = '99999.99999'
            end
            object Label39: TLabel
              Left = 147
              Top = 36
              Width = 42
              Height = 13
              Caption = 'Variance'
            end
            object lbAttMax: TLabel
              Left = 67
              Top = 41
              Width = 63
              Height = 13
              Caption = '99999.99999'
            end
            object Label38: TLabel
              Left = 12
              Top = 41
              Width = 44
              Height = 13
              Caption = 'Maximum'
            end
            object Label42: TLabel
              Left = 147
              Top = 51
              Width = 45
              Height = 13
              Caption = 'Pop. Size'
            end
            object lbAttNum: TLabel
              Left = 202
              Top = 51
              Width = 30
              Height = 13
              Caption = '99999'
            end
          end
          inherited gSize: TJvGroupBox
            Left = 322
            Top = 249
            Width = 0
            Height = 0
            TabOrder = 6
            Visible = False
            ExplicitLeft = 322
            ExplicitTop = 249
            ExplicitWidth = 0
            ExplicitHeight = 0
          end
        end
      end
      inherited tsTrain: TTabSheet
        ExplicitWidth = 874
        ExplicitHeight = 641
        inherited sbTrain: TScrollBox
          Width = 452
          Height = 288
          ExplicitWidth = 874
          ExplicitHeight = 641
          inherited gTrnOpt: TJvGroupBox
            Top = 121
            ExplicitTop = 121
          end
          inherited btTrain: TBitBtn
            Left = 221
            Top = 211
            Width = 225
            ExplicitLeft = 221
            ExplicitTop = 211
            ExplicitWidth = 225
          end
          inherited btStopTrn: TBitBtn
            Top = 211
            TabOrder = 5
            ExplicitTop = 211
          end
          inherited gDataSource: TJvGroupBox
            TabOrder = 6
          end
          object Bevel8: TJvGroupBox
            Left = 3
            Top = 3
            Width = 443
            Height = 54
            Caption = 'Learning parameters'
            TabOrder = 2
            object Label23: TLabel
              Left = 6
              Top = 26
              Width = 68
              Height = 13
              Caption = 'Maximum error'
            end
            object Label21: TLabel
              Left = 332
              Top = 26
              Width = 44
              Height = 13
              Caption = 'neuron(s)'
            end
            object iMaxErr: TJvSpinEdit
              Left = 83
              Top = 22
              Width = 76
              Height = 21
              Alignment = taRightJustify
              Decimal = 4
              Increment = 0.010000000000000000
              ValueType = vtFloat
              TabOrder = 0
              OnChange = iMaxErrChange
            end
            object cbMaxNeu: TCheckBox
              Left = 177
              Top = 24
              Width = 76
              Height = 17
              Caption = 'Create only'
              TabOrder = 1
              OnClick = cbMaxNeuClick
            end
            object iMaxNeu: TJvSpinEdit
              Left = 252
              Top = 22
              Width = 76
              Height = 21
              Alignment = taRightJustify
              Decimal = 4
              TabOrder = 2
              OnChange = iMaxNeuChange
            end
          end
          object Bevel9: TJvGroupBox
            Left = 3
            Top = 63
            Width = 441
            Height = 55
            Caption = 'Neurons properties'
            TabOrder = 3
            object Label24: TLabel
              Left = 14
              Top = 25
              Width = 130
              Height = 13
              Alignment = taCenter
              Caption = 'Ro - Neuron influence zone'
            end
            object iRo: TJvSpinEdit
              Left = 150
              Top = 22
              Width = 86
              Height = 21
              Alignment = taRightJustify
              Decimal = 6
              Increment = 0.010000000000000000
              ValueType = vtFloat
              TabOrder = 0
              OnChange = iRoChange
            end
          end
          object btRecalcAtt: TBitBtn
            Left = 109
            Top = 211
            Width = 106
            Height = 25
            Caption = 'Recalc Activation'
            TabOrder = 4
            OnClick = btRecalcAttClick
          end
        end
      end
      inherited tsApply: TTabSheet
        ExplicitWidth = 874
        ExplicitHeight = 641
        inherited sbApply: TScrollBox
          Width = 452
          Height = 288
          ExplicitWidth = 874
          ExplicitHeight = 641
        end
      end
      inherited tsError: TTabSheet
        ExplicitWidth = 874
        ExplicitHeight = 641
        inherited sbError: TScrollBox
          Width = 452
          Height = 288
          ExplicitWidth = 874
          ExplicitHeight = 641
        end
      end
    end
  end
end
