object Form78: TForm78
  Left = 0
  Top = 0
  Caption = 'Download de XML'
  ClientHeight = 121
  ClientWidth = 465
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label9: TLabel
    Left = 8
    Top = 3
    Width = 132
    Height = 16
    Caption = 'Chave da Nota Fiscal'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 208
    Top = 80
    Width = 146
    Height = 37
    Caption = 'Aguarde...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -33
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object EditChave: TEdit
    Left = 6
    Top = 20
    Width = 449
    Height = 29
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnKeyPress = EditChaveKeyPress
  end
  object ButBaixar: TBitBtn
    Left = 0
    Top = 76
    Width = 192
    Height = 41
    Caption = 'Baixar XML NFe'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    Glyph.Data = {
      EE070000424DEE070000000000003600000028000000190000001A0000000100
      180000000000B8070000120B0000120B00000000000000000000DBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDB00DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB00DBDBDBDBDBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB1CAC66DBDBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB00DBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB1C
      AC662FBD7D1CAC66DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDB00DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDBDBDBDB1CAC662CBC7B48D69D30BE7E1CAC66DBDBDBDBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB00DBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB1CAC6629BB7740D29544D49949D69E
      30BE7F1CAC66DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB
      DB00DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB1CAC6625BA75
      38CF8D3CD19241D39646D59B4BD69F31BE7F1CAC66DBDBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDB00DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB
      DBDBDB1CAC6623B97230CC8734CD8B39CF8E29CC8142D39747D59C4CD6A031BE
      801CAC66DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB00DBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDBDBDBDB1CAC6622B8712BCB822ECC8431CC8822C97A25C7
      7D2BCC8343D49949D69E4DD7A132BF801CAC66DBDBDBDBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDB00DBDBDBDBDBDBDBDBDBDBDBDBDBDBDB1CAC6622B8712ACA812ACA
      812CCB831BC6741EC57622C57926C77E2DCC8445D49A4AD69E4ED7A332BF811C
      AC66DBDBDBDBDBDBDBDBDBDBDBDBDBDBDB00DBDBDBDBDBDBDBDBDBDBDBDB1CAC
      661CAC661CAC661CAC6622B87116C46F18C2701BC4731FC57624C67B28C87F2E
      CD852DBD7C1CAC661CAC661CAC661CAC66DBDBDBDBDBDBDBDBDBDBDBDB00DBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB1CAC6615C16D16C16E19
      C3711CC47420C57724C77C3ED2941CAC66DBDBDBDBDBDBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDBCCDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB
      DBDB1CAC662ACA812ACA8117C26F1AC37232CC8837CE8C3BD0901CAC66DBDBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB00DBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDBDB1CAC662ACA812ACA8115C16D18C26F30CC86
      33CD8A38CF8D1CAC66DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB
      DB00DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB1CAC662ACA81
      2ACA8115C16D16C16E2DCB8330CC8734CD8B1CAC66DBDBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDB00DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDBDB1CAC662ACA812ACA8116C46F16C46F17C5702ECC8431CC881CAC
      66DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB00DBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB1CAC662ACA812ACA812ACA812ACA
      812ACA812CCB832FCC851CAC66DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDB00DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB1CAC
      662AC97F2ACA812ACA812ACA812ACA812ACA812DCB831CAC66DBDBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB00DBDBDBDBDBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDBDB1CAC6628C67C2ACA802ACA812ACA812ACA812ACA812B
      CA821CAC66DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB00DBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB1CAC6627C37829C77D2A
      CA812ACA812ACA812ACA812ACA811CAC66DBDBDBDBDBDBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDB00DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB
      DBDB1CAC6627BF7328C47A29C87F2ACA812ACA812ACA812ACA811CAC66DBDBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB00DBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDBDB1CAC6625BC7027C17528C57B2AC9802ACA81
      2ACA812ACA811CAC66DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB
      DB00DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB1CAC6624BA6C
      26BD7127C27729C67D2ACA812ACA812ACA811CAC66DBDBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDB00DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDBDB1CAC661CAC661CAC661CAC661CAC661CAC661CAC661CAC661CAC
      66DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB00DBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDB00DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB
      DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBFF}
    ParentFont = False
    TabOrder = 1
    OnClick = ButBaixarClick
    OnKeyPress = ButBaixarKeyPress
  end
end