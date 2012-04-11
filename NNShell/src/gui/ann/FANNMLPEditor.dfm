inherited fmANNMLPEditor: TfmANNMLPEditor
  Caption = 'fmANNMLPEditor'
  ClientHeight = 255
  ExplicitHeight = 289
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnMain: TPanel
    Height = 255
    ExplicitHeight = 255
    inherited pcEditor: TPageControl
      Height = 255
      ActivePage = tsTrain
      ExplicitHeight = 255
      inherited tsProp: TTabSheet
        ExplicitHeight = 227
        inherited sbProp: TScrollBox
          Height = 227
          ExplicitHeight = 227
          inherited gSize: TJvGroupBox
            Top = 50
            ExplicitTop = 50
          end
        end
      end
      object tsLayers: TTabSheet [1]
        Caption = 'Layers'
        object ScrollBox4: TScrollBox
          Left = 0
          Top = 0
          Width = 453
          Height = 227
          Align = alClient
          BorderStyle = bsNone
          TabOrder = 0
          object Panel1: TPanel
            Left = 0
            Top = 0
            Width = 453
            Height = 41
            Align = alTop
            TabOrder = 0
            object btAddLayer: TBitBtn
              Left = 10
              Top = 10
              Width = 75
              Height = 25
              Caption = 'Add Layer'
              TabOrder = 0
              OnClick = btAddLayerClick
            end
            object BitBtn2: TBitBtn
              Left = 90
              Top = 10
              Width = 75
              Height = 25
              Caption = 'Delete Layer'
              TabOrder = 1
              OnClick = BitBtn2Click
            end
            object btModifyNet: TBitBtn
              Left = 170
              Top = 10
              Width = 101
              Height = 25
              Caption = 'Modify Network'
              TabOrder = 2
              OnClick = btModifyNetClick
            end
          end
          object dgLayers: TJvDrawGrid
            Left = 0
            Top = 41
            Width = 453
            Height = 186
            Align = alClient
            ColCount = 3
            DefaultColWidth = 100
            RowCount = 4
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goEditing]
            TabOrder = 1
            OnDrawCell = dgLayersDrawCell
            OnGetEditText = dgLayersGetEditText
            OnSetEditText = dgLayersSetEditText
            DrawButtons = False
            OnShowEditor = dgLayersShowEditor
            OnGetEditAlign = dgLayersGetEditAlign
            OnGetEditStyle = dgLayersGetEditStyle
            OnGetPicklist = dgLayersGetPicklist
            ColWidths = (
              100
              55
              220)
          end
        end
      end
      inherited tsTrain: TTabSheet
        ExplicitHeight = 227
        inherited sbTrain: TScrollBox
          Height = 227
          ExplicitHeight = 227
          object Bevel8: TJvGroupBox [0]
            Left = 3
            Top = 55
            Width = 441
            Height = 54
            Caption = 'Learning parameters'
            TabOrder = 4
            object Label21: TLabel
              Left = 10
              Top = 26
              Width = 13
              Height = 13
              Caption = 'LC'
            end
            object Label22: TLabel
              Left = 118
              Top = 26
              Width = 16
              Height = 13
              Caption = 'MC'
            end
            object Label23: TLabel
              Left = 226
              Top = 26
              Width = 50
              Height = 13
              Caption = 'Tollerance'
            end
            object iLC: TJvSpinEdit
              Left = 30
              Top = 20
              Width = 76
              Height = 21
              Alignment = taRightJustify
              Decimal = 4
              Increment = 0.010000000000000000
              ValueType = vtFloat
              TabOrder = 0
              OnChange = iLCChange
            end
            object iMC: TJvSpinEdit
              Left = 140
              Top = 20
              Width = 76
              Height = 21
              Alignment = taRightJustify
              Decimal = 4
              Increment = 0.010000000000000000
              ValueType = vtFloat
              TabOrder = 1
              OnChange = iMCChange
            end
            object iTol: TJvSpinEdit
              Left = 282
              Top = 20
              Width = 76
              Height = 21
              Alignment = taRightJustify
              Decimal = 4
              Increment = 0.010000000000000000
              ValueType = vtFloat
              TabOrder = 2
              OnChange = iTolChange
            end
            object cbNorm: TCheckBox
              Left = 370
              Top = 23
              Width = 68
              Height = 17
              Caption = 'Normalize'
              TabOrder = 3
              OnClick = cbNormClick
            end
          end
          inherited gTrnOpt: TJvGroupBox
            Top = 114
            ExplicitTop = 114
          end
          inherited btTrain: TBitBtn
            Top = 193
            ExplicitTop = 193
          end
          inherited btStopTrn: TBitBtn
            Top = 194
            ExplicitTop = 194
          end
        end
      end
      inherited tsApply: TTabSheet
        ExplicitHeight = 227
        inherited sbApply: TScrollBox
          Height = 227
          ExplicitHeight = 227
        end
      end
      inherited tsError: TTabSheet
        ExplicitHeight = 227
        inherited sbError: TScrollBox
          Height = 227
          ExplicitHeight = 227
        end
      end
    end
  end
end
