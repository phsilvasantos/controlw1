object lancContasPagar: TlancContasPagar
  Left = 256
  Top = 123
  Caption = 'Lan'#231'amento de Contas a Pagar'
  ClientHeight = 359
  ClientWidth = 670
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 670
    Height = 359
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 72
      Top = 16
      Width = 39
      Height = 13
      Caption = 'Grupo:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 144
      Top = 16
      Width = 45
      Height = 13
      Caption = 'Vencto:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 232
      Top = 16
      Width = 49
      Height = 13
      Caption = 'Nr. Doc:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 536
      Top = 16
      Width = 34
      Height = 13
      Caption = 'Valor:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 16
      Top = 16
      Width = 31
      Height = 13
      Caption = 'C'#243'd.:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object GroupBox2: TGroupBox
      Left = 40
      Top = 256
      Width = 265
      Height = 40
      Caption = 'Grupo de Caixa'
      TabOrder = 0
      object nomegrupo: TLabel
        Left = 8
        Top = 17
        Width = 11
        Height = 16
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object GroupBox3: TGroupBox
      Left = 361
      Top = 256
      Width = 270
      Height = 40
      Caption = 'Hist'#243'rico'
      TabOrder = 1
      object nomehis: TLabel
        Left = 6
        Top = 17
        Width = 11
        Height = 16
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object cod: JsEditInteiro
      Left = 16
      Top = 35
      Width = 49
      Height = 21
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnEnter = codEnter
      OnKeyDown = codKeyDown
      OnKeyPress = codKeyPress
      FormularioComp = 'Form27'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object codgru: JsEdit
      Left = 72
      Top = 35
      Width = 65
      Height = 21
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnKeyPress = codgruKeyPress
      FormularioComp = 'Form27'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object vencimento: JsEditData
      Left = 144
      Top = 35
      Width = 81
      Height = 21
      EditMask = '!99/99/0000;1;_'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 10
      ParentFont = False
      TabOrder = 4
      Text = '  /  /    '
      ValidaCampo = False
      CompletaData = False
      ColorOnEnter = clSkyBlue
    end
    object documento: JsEditInteiro
      Left = 232
      Top = 35
      Width = 65
      Height = 21
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 9
      ParentFont = False
      TabOrder = 5
      OnKeyPress = documentoKeyPress
      FormularioComp = 'Form27'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object GroupBox1: TGroupBox
      Left = 304
      Top = 19
      Width = 217
      Height = 49
      Caption = 'Hist'#243'rico'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      object codhis: JsEditInteiro
        Left = 8
        Top = 16
        Width = 41
        Height = 21
        CharCase = ecUpperCase
        TabOrder = 0
        OnKeyPress = codhisKeyPress
        FormularioComp = 'Form27'
        ColorOnEnter = clSkyBlue
        Indice = 0
        TipoDeDado = teNumero
      end
      object historico: JsEdit
        Left = 56
        Top = 16
        Width = 153
        Height = 21
        CharCase = ecUpperCase
        MaxLength = 60
        TabOrder = 1
        OnEnter = historicoEnter
        OnKeyPress = historicoKeyPress
        FormularioComp = 'Form27'
        ColorOnEnter = clSkyBlue
        Indice = 0
        TipoDeDado = teNumero
      end
    end
    object valor: JsEditNumero
      Left = 534
      Top = 35
      Width = 65
      Height = 21
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      Text = '0,00'
      OnKeyPress = valorKeyPress
      FormularioComp = 'Form27'
      ColorOnEnter = clSkyBlue
      ValidaCampo = True
      Indice = 0
      TipoDeDado = teNumero
      CasasDecimais = 2
    end
    object ToolBar1: TPanel
      Left = 1
      Top = 318
      Width = 668
      Height = 40
      Align = alBottom
      TabOrder = 8
      object info: TLabel
        Left = 168
        Top = 8
        Width = 76
        Height = 13
        Caption = 'F5 - Consulta'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object JsBotao1: JsBotao
        Left = 0
        Top = 2
        Width = 75
        Height = 35
        Caption = 'Gravar'
        Glyph.Data = {
          F6060000424DF606000000000000360000002800000018000000180000000100
          180000000000C0060000EB0A0000EB0A00000000000000000000CCCCCCCACACA
          C8C8C8C4C4C4BEBEBEBABABAB4B4B4AEAEAEA7A7A7A2A2A29E9E9E9E9E9EA2A2
          A2AAAAAAB0B0B0B6B6B6BDBDBDC2C2C2C7C7C7CACACACCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCC8C8C8BCBCBCB3B3B3ACACACA5A5A59E9E9E969696919191979797
          8C8C8C8D8D8D9393939A9A9AA0A0A0A8A8A8B0B0B0B7B7B7BFBFBFC7C7C7CCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCBCBCBC9C9C9C7C7C7C6C6C6C4C4C4C6
          C6C6BFC1C06B9880ADB8B2C7C7C7C3C3C3C3C3C3C5C5C5C6C6C6C8C8C8CACACA
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCC669D80298355549472C4C9C6CCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCC6A9B822984552C905E2A8959549271C2C7
          C4CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC739F882886552B955F2B945F
          2C9660298C59599475C7C9C8CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC79A28C2888562B
          9B622B9B612B9A612B9A612B9C62298F5961977ACBCBCBCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC81A6
          922988562BA0642BA1642BA0642BA0642BA0642BA0642BA26529915B63987CCB
          CBCBCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          CCCCCC88A897278A5527A5652AA6672AA5672AA5672AA5672AA5672AA5672AA5
          672AA76828925B699B80CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCC8CAA9A3791624AB67F30AF6F24A96626AA6729AB6929AB69
          29AB6929AB6929AB6929AB6A29AC6B27935C6E9D84CCCCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCC99B0A438916267C69679CFA466C79648BC8130
          B47124B06926B06A28B16C28B16C28B16C28B16C29B26D29B36D27955C75A089
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC8FAC9D3C946768CA987BD5A871CF
          A071CFA06FCE9E60C9944FC3893ABD7B2AB77027B66E26B66E25B66D26B66D27
          B76F27B86F27945C7AA28DCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC3F89625DB98A
          83DFB174D3A371D3A16DD19F69D19C69D09B67D09B61D09858CE9247C6853CC2
          7E32BF772CBD7428BC7125BD7025BA6E25935B80A491CCCCCCCCCCCCCCCCCCCC
          CCCCB7C0BB609D7E6FCA9C78DDAA70D6A26CD6A068D49E68D69F59CB91379966
          50BF875CD69856CF9252CF8F49CB8940C98438C77E32C77B2DC3772A955D89A9
          97CCCCCCCCCCCCCCCCCCCCCCCCB7BEB955987468CB9973E0A96CD9A26DDDA55B
          D39639986782A0914A956E4EC38756D9974FD38F4CD18D49D18C47D08B41CE87
          3BD08637CA803197638EAB9BCCCCCCCCCCCCCCCCCCCCCCCCAEBAB44B956E64D0
          9975E7AE5DDA9A349A6596ACA0CCCCCCA9B9B03E93674BCA8A50DB954AD58F47
          D58D43D38B3FD3893DD28739D48734CC8033956297AEA2CCCCCCCCCCCCCCCCCC
          CCCCCCACB9B248966E52CD8F35A06990AA9CCCCCCCCCCCCCCCCCCCA7B8AF3C95
          6749D08D4CDF9546D99042D88D3ED88B3BD78937D68733D98630CF7E36986593
          AD9FCCCCCCCCCCCCCCCCCCCCCCCCA5B7AD36895D83A794CCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCA0B3A936966546D58D48E49642DE903EDD8D3BDD8B37DC8933DB
          8730E68B29B66F3D8860CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCBDC3BFCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC9AB0A5339B6443DC8F42E7943DE28E
          3AE28C36E18A34E88D2DC97A43956BB2BCB6CCCCCCCCCCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC95ADA032
          9D6540E3913FEB943AE68F37EA9030D07F409368B8BEBBCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCC90A99B2EA1663DE5903CF29734D5833B9365B2BAB5CCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC8DA8992FA76835D484399665ADB6
          B1CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC82A894
          3D8F64ACB8B1CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCBAC0BCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC}
        TabOrder = 0
        OnClick = JsBotao1Click
      end
      object JsBotao2: JsBotao
        Left = 81
        Top = 2
        Width = 75
        Height = 35
        Caption = 'Excluir'
        Glyph.Data = {
          F6060000424DF606000000000000360000002800000018000000180000000100
          180000000000C0060000EB0A0000EB0A00000000000000000000CCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC3C3C3CCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC3C3C3CCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC86868610102262
          6262CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC626262101022
          868686CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC7979
          790000410202E50000675C5C5CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC5C
          5C5C0000670202E5000041797979CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          CCCCCC6A6A6A0000500505FB0A0AFF0606FF00006C555555CCCCCCCCCCCCCCCC
          CCCCCCCC54545400006C0606FF0A0AFF0505FB0000506A6A6ACCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCC6666660000610909FF0F0FFF0E0EFE0F0FFF0A0AFF000074
          4D4D4DCCCCCCCCCCCC4D4D4D0000740A0AFF0F0FFF0E0EFE0F0FFF0909FF0000
          62666666CCCCCCCCCCCCCCCCCCCCCCCC3D3D3E0000CA0E0EFF1616FA1313FA13
          13FA1515FC0E0EFF00007C4E4E4E4E4E4E00007C0E0EFF1515FC1313FA1313FA
          1616FA0E0EFF0000CA3D3D3ECCCCCCCCCCCCCCCCCCCCCCCC9999990000350000
          E91212FF1D1DF61A1AF71A1AF71B1BF91414FF00007B00007B1414FF1B1BF91A
          1AF71A1AF71D1DF61212FF0000E9000035999999CCCCCCCCCCCCCCCCCCCCCCCC
          CCCCCC86868600002F0000DE1616FF2424F32020F32020F32222F41919FF1919
          FF2222F42020F32020F32424F31616FF0000DF00002F868686CCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCC8686860000280000D21B1BFC2C2CF12727F0
          2727F02929F12929F12727F02727F02C2CF11B1BFC0000D2000028868686CCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC89898903032600
          00C51D1DF13131EE2F2FED2F2FED2F2FED2F2FED3131EE1D1DF10000C6030326
          898989CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          CCCCCCCC7E7E7E00001D0707E03838EF3838EB3838EB3838EB3838EB3838EF07
          07E100001D7E7E7ECCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCB9B9B92D2D3109099E3B3BF14343E94141E94141E94141
          E94141E94343E93B3BF109099E2D2D31BABABACCCCCCCCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCB4B4B41D1D240C0CA44646FA4E4EE64A4AE6
          4A4AE64F4FE74F4FE74A4AE64A4AE64E4EE64646FA0C0CA41D1D24B4B4B4CCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCAFAFAF1818231010A95151F758
          58E55454E55454E55D5DE73232E63232E65D5DE75454E55454E55858E55151F7
          1010A9181823AFAFAFCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCAAAAAA1212211515
          AF5D5DF56262E45E5EE45E5EE46767E63A3AEA0000A20000A23A3AEA6767E65E
          5EE45E5EE46262E45D5DF51515AF121221AAAAAACCCCCCCCCCCCCCCCCCB3B3B3
          0C0C282020B76C6CF46C6CE36868E46969E47373E64040E90000A80303140303
          140000AB4040E87373E56969E46868E46C6CE36C6CF42020B70C0C28B3B3B3CC
          CCCCCCCCCCB1B1B100002A2424DC7B7BE97777E37474E38080E54646E60000A6
          0303179A9A9A9A9A9A03031B0000B14646E68080E47474E37777E37B7BEA2424
          DC00002AB1B1B1CCCCCCCCCCCCCCCCCC7878780000372828D98787E99090E64D
          4DE40000AC020219929292CCCCCCCCCCCC9292920202200000BA4D4DE39090E5
          8787EA2828D9000036787878CCCCCCCCCCCCCCCCCCCCCCCCCCCCCC6E6E6E0000
          423737DE5454E50000B803031E929292CCCCCCCCCCCCCCCCCCCCCCCC92929203
          03250000C75454E63737DC0000406E6E6ECCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCC6767670000540000C9040426959595CCCCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCC95959504042E0000D200004F676767CCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC5E5E5E10101F959595CCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC95959510101F5E5E5ECCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC3C3C3CC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC3C3C3
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC}
        TabOrder = 1
        OnClick = JsBotao2Click
      end
    end
    object DBGrid1: TDBGrid
      Left = 14
      Top = 79
      Width = 635
      Height = 169
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnKeyDown = DBGrid1KeyDown
      OnKeyPress = DBGrid1KeyPress
    end
    object DATA: JsEditData
      Left = 128
      Top = 59
      Width = 81
      Height = 21
      EditMask = '!99/99/0000;1;_'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 10
      ParentFont = False
      TabOrder = 10
      Text = '  /  /    '
      Visible = False
      ValidaCampo = False
      CompletaData = False
      ColorOnEnter = clSkyBlue
    end
    object USUARIO: JsEditInteiro
      Left = 216
      Top = 56
      Width = 41
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 11
      Visible = False
      OnKeyPress = codhisKeyPress
      FormularioComp = 'Form27'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object pago: JsEditNumero
      Left = 278
      Top = 75
      Width = 65
      Height = 21
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 12
      Text = '0,00'
      Visible = False
      OnKeyPress = valorKeyPress
      FormularioComp = 'Form27'
      ColorOnEnter = clSkyBlue
      ValidaCampo = True
      Indice = 0
      TipoDeDado = teNumero
      CasasDecimais = 2
    end
    object total: JsEditNumero
      Left = 350
      Top = 67
      Width = 65
      Height = 21
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 13
      Text = '0,00'
      Visible = False
      OnKeyPress = valorKeyPress
      FormularioComp = 'Form27'
      ColorOnEnter = clSkyBlue
      ValidaCampo = True
      Indice = 0
      TipoDeDado = teNumero
      CasasDecimais = 2
    end
    object fornec: JsEditInteiro
      Left = 216
      Top = 88
      Width = 41
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 14
      Text = '0'
      Visible = False
      OnKeyPress = codhisKeyPress
      FormularioComp = 'Form27'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
  end
  object DataSource1: TDataSource
    Left = 200
    Top = 160
  end
end
