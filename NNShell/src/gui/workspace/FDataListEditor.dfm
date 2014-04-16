inherited fmDataListEditor: TfmDataListEditor
  Left = 182
  Top = 117
  Caption = 'fmDataListEditor'
  ClientHeight = 291
  ClientWidth = 447
  OnCreate = FormCreate
  ExplicitWidth = 463
  ExplicitHeight = 330
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnMain: TPanel
    Width = 447
    Height = 291
    ExplicitWidth = 447
    ExplicitHeight = 291
    object pcEditor: TPageControl
      Left = 0
      Top = 0
      Width = 447
      Height = 291
      ActivePage = tsProp
      Align = alClient
      TabOrder = 0
      OnChange = pcEditorChange
      OnChanging = pcEditorChanging
      object tsProp: TTabSheet
        Caption = 'Properties'
        object ScrollBox1: TScrollBox
          Left = 0
          Top = 0
          Width = 439
          Height = 263
          Align = alClient
          BorderStyle = bsNone
          TabOrder = 0
          object Label7: TLabel
            Left = 5
            Top = 15
            Width = 28
            Height = 13
            Caption = 'Name'
          end
          object Label5: TLabel
            Left = 5
            Top = 45
            Width = 53
            Height = 13
            Caption = 'Description'
          end
          object Label1: TLabel
            Left = 275
            Top = 15
            Width = 49
            Height = 13
            Caption = 'Dimension'
          end
          object Label8: TLabel
            Left = 275
            Top = 40
            Width = 28
            Height = 13
            Caption = 'Count'
          end
          object iName: TEdit
            Left = 50
            Top = 11
            Width = 121
            Height = 21
            TabOrder = 0
            Text = 'iName'
            OnChange = iNameChange
          end
          object btRename: TBitBtn
            Left = 175
            Top = 7
            Width = 81
            Height = 28
            Caption = 'Rename'
            Glyph.Data = {
              06020000424D0602000000000000760000002800000028000000140000000100
              0400000000009001000000000000000000001000000000000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
              3333333333FFFFFFFF333FFFFF3330000000033300000333377777777F337777
              7FF330EFEFEF03307333703337F3FFFF7F37733377F330F4444E033333333033
              37F777737F333333F7F33099999903333330703337F333337F33333777FF309F
              FFF903333330000337F333337F33333777733099999903333330003337F3FF3F
              7F333337773330F44E0003333330033337F7737773333337733330EFEF003333
              3330333337FFFF7733333337333330000003333333333333377777733333FFFF
              FFFF3333333333300000000333333F3333377777777F333303333330EFEFEF03
              33337F333337F3FFFF7F333003333330F4444E0333377F333337F777737F3300
              03333330EFEFEF0333777F333337F3FFFF7F300003333330F4444E0337777F33
              3337F777737F330703333330EFEFEF03337773333337F3FF3F7F330333333330
              F44E0003337FF333FF37F7737773330733370330EFEF00333377FFF77337FFFF
              7733333000003330000003333337777733377777733333333333333333333333
              33333333333333333333}
            NumGlyphs = 2
            Spacing = 5
            TabOrder = 1
            OnClick = btRenameClick
          end
          object iDesc: TEdit
            Left = 70
            Top = 40
            Width = 186
            Height = 21
            TabOrder = 2
            Text = 'iDesc'
            OnChange = iDescChange
          end
          object iDim: TJvSpinEdit
            Left = 335
            Top = 8
            Width = 66
            Height = 21
            CheckMinValue = True
            Alignment = taRightJustify
            TabOrder = 3
            OnChange = iDimChange
          end
          object iCount: TJvSpinEdit
            Left = 335
            Top = 35
            Width = 66
            Height = 21
            CheckMinValue = True
            Alignment = taRightJustify
            TabOrder = 4
            OnChange = iCountChange
          end
          object btSave: TBitBtn
            Left = 95
            Top = 70
            Width = 80
            Height = 25
            Caption = 'Save...'
            TabOrder = 5
            OnClick = btSaveClick
          end
          object btLoad: TBitBtn
            Left = 5
            Top = 70
            Width = 80
            Height = 25
            Caption = 'Load...'
            TabOrder = 6
            OnClick = btLoadClick
          end
        end
      end
      object tsData: TTabSheet
        Caption = 'Data'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 439
          Height = 31
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Label4: TLabel
            Left = 5
            Top = 10
            Width = 26
            Height = 13
            Caption = 'Digits'
          end
          object Label6: TLabel
            Left = 105
            Top = 10
            Width = 43
            Height = 13
            Caption = 'Decimals'
          end
          object iNumCif: TJvSpinEdit
            Left = 35
            Top = 5
            Width = 61
            Height = 21
            Alignment = taRightJustify
            MaxValue = 20.000000000000000000
            MinValue = 1.000000000000000000
            Value = 9.000000000000000000
            TabOrder = 0
            OnChange = iNumCifChange
          end
          object iNumDec: TJvSpinEdit
            Left = 155
            Top = 5
            Width = 61
            Height = 21
            Alignment = taRightJustify
            MaxValue = 18.000000000000000000
            Value = 4.000000000000000000
            TabOrder = 1
            OnChange = iNumDecChange
          end
        end
        object dgDati: TJvDrawGrid
          Left = 0
          Top = 31
          Width = 439
          Height = 232
          Align = alClient
          DefaultColWidth = 80
          DefaultRowHeight = 17
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSizing, goColSizing, goEditing]
          ParentFont = False
          TabOrder = 1
          OnDrawCell = dgDatiDrawCell
          OnGetEditText = dgDatiGetEditText
          OnSelectCell = dgDatiSelectCell
          OnSetEditText = dgDatiSetEditText
          DrawButtons = False
          OnAcceptEditKey = dgDatiAcceptEditKey
          ColWidths = (
            80
            80
            80
            80
            80)
          RowHeights = (
            17
            17
            17
            17
            17)
        end
      end
    end
  end
  object sdSave: TSaveDialog
    DefaultExt = 'dlf'
    Filter = 'Data List Binary Files|*.dlf|Text Files|*.txt|Any Files|*.*'
    Options = [ofOverwritePrompt, ofExtensionDifferent, ofPathMustExist]
    Left = 189
    Top = 94
  end
  object odOpen: TOpenDialog
    DefaultExt = 'dlf'
    Filter = 'Data List Binary Files|*.dlf|Text Files|*.txt|Any Files|*.*'
    Options = [ofOverwritePrompt, ofExtensionDifferent, ofPathMustExist]
    Left = 224
    Top = 95
  end
end
