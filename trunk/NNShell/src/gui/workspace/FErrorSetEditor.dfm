inherited fmErrorSetEditor: TfmErrorSetEditor
  Left = 262
  Caption = 'fmErrorSetEditor'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnMain: TPanel
    object meOut: TMemo
      Left = 0
      Top = 41
      Width = 456
      Height = 272
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        'meOut')
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      WordWrap = False
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 456
      Height = 41
      Align = alTop
      TabOrder = 1
      object Label7: TLabel
        Left = 5
        Top = 15
        Width = 28
        Height = 13
        Caption = 'Name'
      end
      object iName: TEdit
        Left = 50
        Top = 11
        Width = 121
        Height = 21
        TabOrder = 0
        Text = 'iName'
        OnChange = iNameChange
        OnKeyPress = iNameKeyPress
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
      object BitBtn1: TBitBtn
        Left = 260
        Top = 7
        Width = 101
        Height = 28
        Caption = 'Write in Output'
        TabOrder = 2
        OnClick = BitBtn1Click
      end
    end
  end
end
