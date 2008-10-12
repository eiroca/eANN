inherited fmANNEditor: TfmANNEditor
  Left = 207
  Top = 115
  Caption = 'fmANNEditor'
  ClientHeight = 204
  ClientWidth = 462
  ExplicitWidth = 470
  ExplicitHeight = 238
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnMain: TPanel
    Width = 462
    Height = 204
    ExplicitWidth = 462
    ExplicitHeight = 204
    object pcEditor: TPageControl
      Left = 0
      Top = 0
      Width = 462
      Height = 204
      ActivePage = tsProp
      Align = alClient
      TabOrder = 0
      object tsProp: TTabSheet
        Caption = 'Properties'
        object ScrollBox3: TScrollBox
          Left = 0
          Top = 0
          Width = 454
          Height = 176
          Align = alClient
          BorderStyle = bsNone
          TabOrder = 0
          object bProp: TBevel
            Left = 5
            Top = 10
            Width = 441
            Height = 81
            Shape = bsFrame
          end
          object Label2: TLabel
            Left = 15
            Top = 140
            Width = 43
            Height = 13
            Caption = 'Iterations'
          end
          object Label3: TLabel
            Left = 140
            Top = 140
            Width = 107
            Height = 13
            Caption = 'Progress update factor'
          end
          object Label4: TLabel
            Left = 15
            Top = 65
            Width = 29
            Height = 13
            Caption = 'Inputs'
          end
          object Label5: TLabel
            Left = 225
            Top = 65
            Width = 37
            Height = 13
            Caption = 'Outputs'
          end
          object lbDimInp: TLabel
            Left = 175
            Top = 65
            Width = 41
            Height = 13
            Caption = 'lbDimInp'
          end
          object lbDimOut: TLabel
            Left = 390
            Top = 65
            Width = 43
            Height = 13
            Caption = 'lbDimOut'
          end
          object lbDesc: TLabel
            Left = 15
            Top = 5
            Width = 33
            Height = 13
            Caption = 'lbDesc'
          end
          object Label18: TLabel
            Left = 15
            Top = 30
            Width = 28
            Height = 13
            Caption = 'Name'
          end
          object bOpts: TBevel
            Left = 5
            Top = 100
            Width = 441
            Height = 66
            Shape = bsFrame
          end
          object lbOptions: TLabel
            Left = 15
            Top = 95
            Width = 36
            Height = 13
            Caption = 'Options'
          end
          object btClearDataIn: TSpeedButton
            Left = 150
            Top = 60
            Width = 21
            Height = 21
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              04000000000000010000120B0000120B00001000000000000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
              55555FFFFFFF5F55FFF5777777757559995777777775755777F7555555555550
              305555555555FF57F7F555555550055BB0555555555775F777F55555550FB000
              005555555575577777F5555550FB0BF0F05555555755755757F555550FBFBF0F
              B05555557F55557557F555550BFBF0FB005555557F55575577F555500FBFBFB0
              B05555577F555557F7F5550E0BFBFB00B055557575F55577F7F550EEE0BFB0B0
              B05557FF575F5757F7F5000EEE0BFBF0B055777FF575FFF7F7F50000EEE00000
              B0557777FF577777F7F500000E055550805577777F7555575755500000555555
              05555777775555557F5555000555555505555577755555557555}
            NumGlyphs = 2
            OnClick = btClearDataInClick
          end
          object btCleadDataOut: TSpeedButton
            Left = 365
            Top = 60
            Width = 21
            Height = 21
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              04000000000000010000120B0000120B00001000000000000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
              55555FFFFFFF5F55FFF5777777757559995777777775755777F7555555555550
              305555555555FF57F7F555555550055BB0555555555775F777F55555550FB000
              005555555575577777F5555550FB0BF0F05555555755755757F555550FBFBF0F
              B05555557F55557557F555550BFBF0FB005555557F55575577F555500FBFBFB0
              B05555577F555557F7F5550E0BFBFB00B055557575F55577F7F550EEE0BFB0B0
              B05557FF575F5757F7F5000EEE0BFBF0B055777FF575FFF7F7F50000EEE00000
              B0557777FF577777F7F500000E055550805577777F7555575755500000555555
              05555777775555557F5555000555555505555577755555557555}
            NumGlyphs = 2
            OnClick = btCleadDataOutClick
          end
          object cbErrMode: TCheckBox
            Left = 15
            Top = 115
            Width = 136
            Height = 17
            Caption = 'Ignore error lower than'
            TabOrder = 0
            OnClick = cbErrModeClick
          end
          object iErrParam: TRxSpinEdit
            Left = 145
            Top = 113
            Width = 76
            Height = 21
            Alignment = taRightJustify
            Decimal = 4
            Increment = 0.010000000000000000
            ValueType = vtFloat
            TabOrder = 1
            OnChange = iErrParamChange
          end
          object iIter: TRxSpinEdit
            Left = 65
            Top = 138
            Width = 66
            Height = 21
            Alignment = taRightJustify
            Decimal = 4
            MaxValue = 99999.000000000000000000
            MinValue = 1.000000000000000000
            Value = 1.000000000000000000
            TabOrder = 2
            OnChange = iIterChange
          end
          object iProgStep: TRxSpinEdit
            Left = 255
            Top = 138
            Width = 66
            Height = 21
            Alignment = taRightJustify
            Decimal = 4
            MaxValue = 99999.000000000000000000
            MinValue = 1.000000000000000000
            Value = 99999.000000000000000000
            TabOrder = 3
            OnChange = iProgStepChange
          end
          object cbDataIn: TComboBox
            Left = 50
            Top = 60
            Width = 100
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 4
            OnChange = cbDataInChange
          end
          object cbDataOut: TComboBox
            Left = 265
            Top = 60
            Width = 100
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 5
            OnChange = cbDataOutChange
          end
          object iName: TEdit
            Left = 50
            Top = 26
            Width = 121
            Height = 21
            TabOrder = 6
            Text = 'iName'
            OnChange = iNameChange
            OnKeyPress = iNameKeyPress
          end
          object btRename: TBitBtn
            Left = 175
            Top = 24
            Width = 81
            Height = 28
            Caption = 'Rename'
            TabOrder = 7
            OnClick = btRenameClick
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
          end
        end
      end
      object tsInfo: TTabSheet
        Caption = 'Informations'
        object ScrollBox2: TScrollBox
          Left = 0
          Top = 0
          Width = 454
          Height = 176
          Align = alClient
          BorderStyle = bsNone
          TabOrder = 0
          object bNetOpe: TBevel
            Left = 5
            Top = 60
            Width = 281
            Height = 116
            Shape = bsFrame
          end
          object bNetCan: TBevel
            Left = 290
            Top = 60
            Width = 156
            Height = 116
            Shape = bsFrame
          end
          object bNetIs: TBevel
            Left = 5
            Top = 10
            Width = 441
            Height = 41
            Shape = bsFrame
          end
          object Label6: TLabel
            Left = 35
            Top = 27
            Width = 53
            Height = 13
            Caption = 'Supervised'
          end
          object Label7: TLabel
            Left = 125
            Top = 27
            Width = 36
            Height = 13
            Caption = 'Trained'
          end
          object Label8: TLabel
            Left = 195
            Top = 27
            Width = 55
            Height = 13
            Caption = 'Progressive'
          end
          object Label9: TLabel
            Left = 35
            Top = 77
            Width = 163
            Height = 13
            Caption = 'Network can reset to default value'
          end
          object Label10: TLabel
            Left = 35
            Top = 102
            Width = 212
            Height = 13
            Caption = 'Network can be trained with a set of patterns'
          end
          object Label11: TLabel
            Left = 35
            Top = 127
            Width = 208
            Height = 13
            Caption = 'Network can predict a set of output patterns'
          end
          object Label12: TLabel
            Left = 35
            Top = 152
            Width = 238
            Height = 13
            Caption = 'Network can be used to calculate prediction errors'
          end
          object Label1: TLabel
            Left = 15
            Top = 5
            Width = 56
            Height = 13
            Caption = ' Network is '
          end
          object Label19: TLabel
            Left = 300
            Top = 55
            Width = 67
            Height = 13
            Caption = ' Network can '
          end
          object lbFindCluster: TLabel
            Left = 320
            Top = 127
            Width = 80
            Height = 13
            Caption = 'Classify a pattern'
          end
          object lbLearn: TLabel
            Left = 320
            Top = 77
            Width = 102
            Height = 13
            Caption = 'Learn a single pattern'
          end
          object lbAcquire: TLabel
            Left = 320
            Top = 102
            Width = 111
            Height = 13
            Caption = 'Acquire a single pattern'
          end
          object Label20: TLabel
            Left = 15
            Top = 55
            Width = 91
            Height = 13
            Caption = ' Operation allowed '
          end
          object lbSimul: TLabel
            Left = 320
            Top = 152
            Width = 108
            Height = 13
            Caption = 'Predict a single pattern'
          end
          object cbSuper: TCheckBox
            Left = 15
            Top = 25
            Width = 16
            Height = 17
            Caption = 'cbSuper'
            Enabled = False
            TabOrder = 0
          end
          object cbTrained: TCheckBox
            Left = 105
            Top = 25
            Width = 16
            Height = 17
            Caption = 'cbTrained'
            Enabled = False
            TabOrder = 1
          end
          object cbProgressive: TCheckBox
            Left = 175
            Top = 25
            Width = 16
            Height = 17
            Caption = 'cbProgressive'
            Enabled = False
            TabOrder = 2
          end
          object cbReset: TCheckBox
            Left = 15
            Top = 75
            Width = 16
            Height = 17
            Caption = 'cbReset'
            Enabled = False
            TabOrder = 3
          end
          object cbTrain: TCheckBox
            Left = 15
            Top = 100
            Width = 16
            Height = 17
            Caption = 'cbTrain'
            Enabled = False
            TabOrder = 4
          end
          object cbApply: TCheckBox
            Left = 15
            Top = 125
            Width = 16
            Height = 17
            Caption = 'cbProgressive'
            Enabled = False
            TabOrder = 5
          end
          object cbError: TCheckBox
            Left = 15
            Top = 150
            Width = 16
            Height = 17
            Caption = 'cbProgressive'
            Enabled = False
            TabOrder = 6
          end
          object cbLearn: TCheckBox
            Left = 300
            Top = 73
            Width = 16
            Height = 17
            Caption = 'CheckBox2'
            Enabled = False
            TabOrder = 7
          end
          object cbFindCluster: TCheckBox
            Left = 300
            Top = 125
            Width = 16
            Height = 17
            Caption = 'cbProgressive'
            Enabled = False
            TabOrder = 8
          end
          object cbAcquire: TCheckBox
            Left = 300
            Top = 100
            Width = 16
            Height = 17
            Caption = 'cbProgressive'
            Enabled = False
            TabOrder = 9
          end
          object cbSimul: TCheckBox
            Left = 300
            Top = 150
            Width = 16
            Height = 17
            Caption = 'cbProgressive'
            Enabled = False
            TabOrder = 10
          end
        end
      end
      object tsActions: TTabSheet
        Caption = 'Actions'
        object ScrollBox1: TScrollBox
          Left = 0
          Top = 0
          Width = 454
          Height = 176
          Align = alClient
          BorderStyle = bsNone
          TabOrder = 0
          object Bevel4: TBevel
            Left = 10
            Top = 10
            Width = 140
            Height = 96
            Shape = bsFrame
          end
          object Bevel5: TBevel
            Left = 300
            Top = 10
            Width = 140
            Height = 96
            Shape = bsFrame
          end
          object Bevel6: TBevel
            Left = 155
            Top = 10
            Width = 140
            Height = 96
            Shape = bsFrame
          end
          object Bevel7: TBevel
            Left = 10
            Top = 120
            Width = 431
            Height = 51
            Shape = bsFrame
          end
          object btStop: TBitBtn
            Left = 327
            Top = 132
            Width = 100
            Height = 25
            Caption = 'Stop Oper'
            TabOrder = 0
            OnClick = btStopClick
          end
          object btReset: TBitBtn
            Left = 32
            Top = 131
            Width = 100
            Height = 25
            Caption = 'Reset'
            TabOrder = 1
            OnClick = btResetClick
          end
          object btApply: TBitBtn
            Left = 177
            Top = 20
            Width = 100
            Height = 25
            Caption = 'Apply'
            TabOrder = 2
            OnClick = btApplyClick
          end
          object btError: TBitBtn
            Left = 322
            Top = 20
            Width = 100
            Height = 25
            Caption = 'Error'
            TabOrder = 3
            OnClick = btErrorClick
          end
          object btTrain: TBitBtn
            Left = 32
            Top = 20
            Width = 100
            Height = 25
            Caption = 'Train'
            TabOrder = 4
            OnClick = btTrainClick
          end
          object cbNewErrSet: TCheckBox
            Left = 307
            Top = 60
            Width = 130
            Height = 17
            Caption = 'Make new Error set'
            Checked = True
            State = cbChecked
            TabOrder = 5
          end
          object cbMakeNewDataList: TCheckBox
            Left = 162
            Top = 60
            Width = 130
            Height = 17
            Caption = 'Make new Data List'
            Checked = True
            State = cbChecked
            TabOrder = 6
          end
        end
      end
    end
  end
end
