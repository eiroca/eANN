inherited fmANNEditor: TfmANNEditor
  Left = 207
  Top = 115
  Caption = 'fmANNEditor'
  ClientHeight = 243
  ClientWidth = 461
  OnActivate = FormActivate
  OnCreate = FormCreate
  ExplicitWidth = 469
  ExplicitHeight = 277
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnMain: TPanel
    Width = 461
    Height = 243
    ExplicitWidth = 461
    ExplicitHeight = 243
    object pcEditor: TPageControl
      Left = 0
      Top = 0
      Width = 461
      Height = 243
      ActivePage = tsProp
      Align = alClient
      TabOrder = 0
      OnChange = pcEditorChange
      object tsProp: TTabSheet
        Caption = 'Properties'
        object sbProp: TScrollBox
          Left = 0
          Top = 0
          Width = 453
          Height = 215
          Align = alClient
          BorderStyle = bsNone
          TabOrder = 0
          object gDesc: TGroupBox
            Left = 3
            Top = 3
            Width = 443
            Height = 46
            Caption = 'gDesc'
            TabOrder = 0
            object Label18: TLabel
              Left = 10
              Top = 19
              Width = 28
              Height = 13
              Caption = 'Name'
            end
            object iName: TEdit
              Left = 44
              Top = 16
              Width = 121
              Height = 21
              TabOrder = 0
              Text = 'iName'
              OnChange = iNameChange
            end
            object btRename: TBitBtn
              Left = 171
              Top = 13
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
            object btReset: TBitBtn
              Left = 350
              Top = 13
              Width = 87
              Height = 25
              Caption = 'Reset'
              TabOrder = 2
              OnClick = btResetClick
            end
          end
          object gNetDesc: TGroupBox
            Left = 3
            Top = 49
            Width = 282
            Height = 41
            Caption = 'Network is'
            TabOrder = 1
            object cbSuper: TJvCheckBox
              Left = 8
              Top = 18
              Width = 74
              Height = 17
              Caption = 'Supervised'
              TabOrder = 0
              LinkedControls = <>
              ReadOnly = True
            end
            object cbTrained: TJvCheckBox
              Left = 108
              Top = 18
              Width = 57
              Height = 17
              Caption = 'Trained'
              TabOrder = 1
              LinkedControls = <>
              ReadOnly = True
            end
            object cbProgressive: TJvCheckBox
              Left = 191
              Top = 18
              Width = 76
              Height = 17
              Caption = 'Progressive'
              TabOrder = 2
              LinkedControls = <>
              ReadOnly = True
            end
          end
          object gNetOpe: TGroupBox
            Left = 4
            Top = 96
            Width = 281
            Height = 112
            Caption = 'Operation allowed'
            TabOrder = 2
            object cbReset: TJvCheckBox
              Left = 7
              Top = 21
              Width = 184
              Height = 17
              Caption = 'Network can reset to default value'
              TabOrder = 0
              LinkedControls = <>
              ReadOnly = True
            end
            object cbTrain: TJvCheckBox
              Left = 7
              Top = 44
              Width = 233
              Height = 17
              Caption = 'Network can be trained with a set of patterns'
              TabOrder = 1
              LinkedControls = <>
              ReadOnly = True
            end
            object cbApply: TJvCheckBox
              Left = 7
              Top = 67
              Width = 229
              Height = 17
              Caption = 'Network can predict a set of output patterns'
              TabOrder = 2
              LinkedControls = <>
              ReadOnly = True
            end
            object cbError: TJvCheckBox
              Left = 7
              Top = 90
              Width = 259
              Height = 17
              Caption = 'Network can be used to calculate prediction errors'
              TabOrder = 3
              LinkedControls = <>
              ReadOnly = True
            end
          end
          object gNetCan: TGroupBox
            Left = 291
            Top = 97
            Width = 156
            Height = 111
            Caption = 'Network can'
            TabOrder = 3
            object cbLearn: TJvCheckBox
              Left = 7
              Top = 17
              Width = 123
              Height = 17
              Caption = 'Learn a single pattern'
              TabOrder = 0
              LinkedControls = <>
              ReadOnly = True
            end
            object cbAcquire: TJvCheckBox
              Left = 7
              Top = 40
              Width = 132
              Height = 17
              Caption = 'Acquire a single pattern'
              TabOrder = 1
              LinkedControls = <>
              ReadOnly = True
            end
            object cbFindCluster: TJvCheckBox
              Left = 7
              Top = 63
              Width = 101
              Height = 17
              Caption = 'Classify a pattern'
              TabOrder = 2
              LinkedControls = <>
              ReadOnly = True
            end
            object cbSimul: TJvCheckBox
              Left = 7
              Top = 86
              Width = 129
              Height = 17
              Caption = 'Predict a single pattern'
              TabOrder = 3
              LinkedControls = <>
              ReadOnly = True
            end
          end
          object gSize: TGroupBox
            Left = 291
            Top = 49
            Width = 156
            Height = 41
            Caption = 'Size'
            TabOrder = 4
            object lbNetDim: TLabel
              Left = 7
              Top = 19
              Width = 128
              Height = 13
              Caption = 'Network maps 9999->9999'
            end
          end
        end
      end
      object tsTrain: TTabSheet
        Caption = 'Train'
        ImageIndex = 3
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object sbTrain: TScrollBox
          Left = 0
          Top = 0
          Width = 453
          Height = 215
          Align = alClient
          BorderStyle = bsNone
          TabOrder = 0
          object gTrnOpt: TGroupBox
            Left = 3
            Top = 56
            Width = 443
            Height = 73
            Caption = 'Options'
            TabOrder = 0
            object Label2: TLabel
              Left = 10
              Top = 47
              Width = 43
              Height = 13
              Caption = 'Iterations'
            end
            object Label3: TLabel
              Left = 142
              Top = 47
              Width = 107
              Height = 13
              Caption = 'Progress update factor'
            end
            object cbErrMode: TJvCheckBox
              Left = 10
              Top = 19
              Width = 127
              Height = 17
              Caption = 'Ignore error lower than'
              TabOrder = 0
              OnClick = cbErrModeClick
              LinkedControls = <>
            end
            object iErrParam: TJvSpinEdit
              Left = 142
              Top = 16
              Width = 76
              Height = 21
              Alignment = taRightJustify
              Decimal = 4
              Increment = 0.010000000000000000
              ValueType = vtFloat
              TabOrder = 1
              OnChange = iErrParamChange
            end
            object iIter: TJvSpinEdit
              Left = 59
              Top = 43
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
            object iProgStep: TJvSpinEdit
              Left = 255
              Top = 43
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
          end
          object btTrain: TBitBtn
            Left = 109
            Top = 135
            Width = 337
            Height = 25
            Caption = 'Train'
            Default = True
            NumGlyphs = 2
            TabOrder = 1
            OnClick = btTrainClick
          end
          object btStopTrn: TBitBtn
            Left = 3
            Top = 135
            Width = 100
            Height = 25
            Caption = 'Stop'
            TabOrder = 2
            OnClick = btStopTrnClick
          end
          object gDataSource: TGroupBox
            Left = 3
            Top = 3
            Width = 443
            Height = 47
            Caption = 'Datasource'
            TabOrder = 3
            object Label4: TLabel
              Left = 6
              Top = 19
              Width = 29
              Height = 13
              Caption = 'Inputs'
            end
            object btTrainIn: TSpeedButton
              Left = 144
              Top = 16
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
              OnClick = btDataClear
            end
            object lbTrainOut: TLabel
              Left = 223
              Top = 19
              Width = 37
              Height = 13
              Caption = 'Outputs'
            end
            object btTrainOut: TSpeedButton
              Left = 366
              Top = 16
              Width = 20
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
              OnClick = btDataClear
            end
            object cbTrainIn: TComboBox
              Left = 41
              Top = 16
              Width = 100
              Height = 21
              Style = csDropDownList
              TabOrder = 0
            end
            object cbTrainOut: TComboBox
              Left = 266
              Top = 16
              Width = 100
              Height = 21
              Style = csDropDownList
              TabOrder = 1
            end
          end
        end
      end
      object tsApply: TTabSheet
        Caption = 'Predict'
        ImageIndex = 4
        object sbApply: TScrollBox
          Left = 0
          Top = 0
          Width = 453
          Height = 215
          Align = alClient
          BorderStyle = bsNone
          TabOrder = 0
          object btApply: TBitBtn
            Left = 109
            Top = 87
            Width = 337
            Height = 25
            Caption = 'Predict outputs'
            TabOrder = 0
            OnClick = btApplyClick
          end
          object btStopApl: TBitBtn
            Left = 3
            Top = 87
            Width = 100
            Height = 25
            Caption = 'Stop'
            TabOrder = 1
            OnClick = btStopTrnClick
          end
          object gDataSourceApl: TGroupBox
            Left = 3
            Top = 3
            Width = 443
            Height = 78
            Caption = 'Datasource'
            TabOrder = 2
            object Label7: TLabel
              Left = 6
              Top = 19
              Width = 29
              Height = 13
              Caption = 'Inputs'
            end
            object btApplyIn: TSpeedButton
              Left = 143
              Top = 16
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
              OnClick = btDataClear
            end
            object btApplyOut: TSpeedButton
              Left = 297
              Top = 48
              Width = 20
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
              OnClick = btDataClear
            end
            object cbApplyIn: TComboBox
              Left = 41
              Top = 16
              Width = 100
              Height = 21
              Style = csDropDownList
              TabOrder = 0
            end
            object cbApplyOut: TComboBox
              Left = 194
              Top = 48
              Width = 100
              Height = 21
              Style = csDropDownList
              TabOrder = 1
            end
            object cbOvervriteDataList: TJvCheckBox
              Left = 9
              Top = 50
              Width = 182
              Height = 17
              Caption = 'Do not create a new dataset, use:'
              TabOrder = 2
              OnClick = cbOvervriteDataListClick
              LinkedControls = <>
            end
          end
        end
      end
      object tsError: TTabSheet
        Caption = 'Calc Errors'
        ImageIndex = 5
        object sbError: TScrollBox
          Left = 0
          Top = 0
          Width = 453
          Height = 215
          Align = alClient
          BorderStyle = bsNone
          TabOrder = 0
          object gErrOpt: TGroupBox
            Left = 3
            Top = 55
            Width = 443
            Height = 44
            Caption = 'Options'
            TabOrder = 0
            object cbNewErrSet: TJvCheckBox
              Left = 6
              Top = 20
              Width = 156
              Height = 17
              Caption = 'Save Error Set in workspace'
              Checked = True
              State = cbChecked
              TabOrder = 0
              LinkedControls = <>
            end
          end
          object btError: TBitBtn
            Left = 109
            Top = 105
            Width = 337
            Height = 25
            Caption = 'Calculate errors'
            TabOrder = 1
            OnClick = btErrorClick
          end
          object btStopErr: TBitBtn
            Left = 3
            Top = 105
            Width = 100
            Height = 25
            Caption = 'Stop'
            TabOrder = 2
            OnClick = btStopTrnClick
          end
          object JvGroupBox1: TGroupBox
            Left = 3
            Top = 3
            Width = 443
            Height = 46
            Caption = 'Datasource'
            TabOrder = 3
            object Label11: TLabel
              Left = 6
              Top = 19
              Width = 29
              Height = 13
              Caption = 'Inputs'
            end
            object btErrorIn: TSpeedButton
              Left = 141
              Top = 17
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
              OnClick = btDataClear
            end
            object Label16: TLabel
              Left = 223
              Top = 19
              Width = 37
              Height = 13
              Caption = 'Outputs'
            end
            object btErrorOut: TSpeedButton
              Left = 366
              Top = 16
              Width = 20
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
              OnClick = btDataClear
            end
            object cbErrorIn: TComboBox
              Left = 41
              Top = 16
              Width = 100
              Height = 21
              Style = csDropDownList
              TabOrder = 0
            end
            object cbErrorOut: TComboBox
              Left = 266
              Top = 16
              Width = 100
              Height = 21
              Style = csDropDownList
              TabOrder = 1
            end
          end
        end
      end
    end
  end
end
