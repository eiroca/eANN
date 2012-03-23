inherited fmDataPatternEditor: TfmDataPatternEditor
  Caption = 'fmDataPatternEditor'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnMain: TPanel
    inherited pcEditor: TPageControl
      ActivePage = tsData
      inherited tsProp: TTabSheet
        inherited ScrollBox1: TScrollBox
          object Label3: TLabel [2]
            Left = 5
            Top = 170
            Width = 48
            Height = 13
            Caption = 'Read only'
          end
          object Label2: TLabel [3]
            Left = 5
            Top = 140
            Width = 44
            Height = 13
            Caption = 'FileName'
          end
          object lbDim: TLabel [4]
            Left = 85
            Top = 195
            Width = 26
            Height = 13
            Caption = 'lbDim'
          end
          object cbKind: TComboBox [10]
            Left = 70
            Top = 165
            Width = 91
            Height = 21
            Style = csDropDownList
            TabOrder = 3
            OnChange = cbKindChange
            Items.Strings = (
              'Input'
              'Output')
          end
          object cbAutoLoad: TCheckBox [11]
            Left = 170
            Top = 165
            Width = 86
            Height = 17
            Caption = 'AutoLoad'
            TabOrder = 4
            OnClick = cbAutoLoadClick
          end
          object iFileName: TJvFilenameEdit [12]
            Left = 70
            Top = 135
            Width = 186
            Height = 21
            TabOrder = 5
            Text = 'iFileName'
            OnChange = iFileNameChange
          end
          object btLoadPattern: TBitBtn [13]
            Left = 0
            Top = 190
            Width = 75
            Height = 25
            Caption = 'Load Pattern'
            TabOrder = 9
            OnClick = btLoadPatternClick
          end
          inherited iDim: TJvSpinEdit
            TabOrder = 7
          end
          inherited iCount: TJvSpinEdit
            TabOrder = 8
          end
          inherited btSave: TBitBtn
            TabOrder = 10
          end
        end
      end
    end
  end
end
