inherited fmANNMLPEditor: TfmANNMLPEditor
  Caption = 'fmANNMLPEditor'
  ClientHeight = 249
  OnCreate = FormCreate
  ExplicitWidth = 320
  ExplicitHeight = 283
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnMain: TPanel
    Height = 249
    ExplicitHeight = 249
    inherited pcEditor: TPageControl
      Height = 249
      ActivePage = tsLayers
      OnChange = pcEditorChange
      ExplicitHeight = 249
      inherited tsProp: TTabSheet
        ExplicitLeft = 4
        ExplicitTop = 24
        ExplicitWidth = 454
        ExplicitHeight = 221
        inherited ScrollBox3: TScrollBox
          Height = 221
          ExplicitHeight = 221
          object Bevel8: TBevel [13]
            Left = 5
            Top = 175
            Width = 441
            Height = 46
            Shape = bsFrame
          end
          object Label21: TLabel [14]
            Left = 10
            Top = 194
            Width = 13
            Height = 13
            Caption = 'LC'
          end
          object Label22: TLabel [15]
            Left = 115
            Top = 194
            Width = 16
            Height = 13
            Caption = 'MC'
          end
          object Label23: TLabel [16]
            Left = 230
            Top = 194
            Width = 50
            Height = 13
            Caption = 'Tollerance'
          end
          object Label30: TLabel [17]
            Left = 15
            Top = 170
            Width = 102
            Height = 13
            Caption = ' Learning parameters '
          end
          object iLC: TRxSpinEdit
            Left = 30
            Top = 190
            Width = 76
            Height = 21
            Alignment = taRightJustify
            Decimal = 4
            Increment = 0.010000000000000000
            ValueType = vtFloat
            TabOrder = 8
            OnChange = iLCChange
          end
          object iMC: TRxSpinEdit
            Left = 140
            Top = 190
            Width = 76
            Height = 21
            Alignment = taRightJustify
            Decimal = 4
            Increment = 0.010000000000000000
            ValueType = vtFloat
            TabOrder = 9
            OnChange = iMCChange
          end
          object iTol: TRxSpinEdit
            Left = 285
            Top = 190
            Width = 76
            Height = 21
            Alignment = taRightJustify
            Decimal = 4
            Increment = 0.010000000000000000
            ValueType = vtFloat
            TabOrder = 10
            OnChange = iTolChange
          end
          object cbNorm: TCheckBox
            Left = 375
            Top = 190
            Width = 61
            Height = 17
            Caption = 'outliers'
            TabOrder = 11
            OnClick = cbNormClick
          end
        end
      end
      object tsLayers: TTabSheet [1]
        Caption = 'Layers'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object ScrollBox4: TScrollBox
          Left = 0
          Top = 0
          Width = 454
          Height = 221
          Align = alClient
          BorderStyle = bsNone
          TabOrder = 0
          object Panel1: TPanel
            Left = 0
            Top = 0
            Width = 454
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
          object dgLayers: TRxDrawGrid
            Left = 0
            Top = 41
            Width = 454
            Height = 180
            Align = alClient
            ColCount = 3
            DefaultColWidth = 100
            RowCount = 4
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goEditing]
            TabOrder = 1
            OnDrawCell = dgLayersDrawCell
            OnGetEditText = dgLayersGetEditText
            OnSetEditText = dgLayersSetEditText
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
      inherited tsInfo: TTabSheet
        ExplicitLeft = 4
        ExplicitTop = 24
        ExplicitWidth = 454
        ExplicitHeight = 221
        inherited ScrollBox2: TScrollBox
          Height = 221
          ExplicitHeight = 221
        end
      end
      inherited tsActions: TTabSheet
        ExplicitLeft = 4
        ExplicitTop = 24
        ExplicitWidth = 454
        ExplicitHeight = 221
        inherited ScrollBox1: TScrollBox
          Height = 221
          ExplicitHeight = 221
        end
      end
    end
  end
end
