object FAuditoriaXmlSpedFiscal: TFAuditoriaXmlSpedFiscal
  Left = 0
  Top = 0
  Caption = 'Auditoria Xml NF-e/Sped Fiscal'
  ClientHeight = 670
  ClientWidth = 801
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 801
    Height = 121
    Align = alTop
    Caption = ' '
    TabOrder = 0
    object Label2: TLabel
      Left = 24
      Top = 63
      Width = 61
      Height = 13
      Caption = 'Arquivos Xml'
    end
    object Label1: TLabel
      Left = 24
      Top = 17
      Width = 98
      Height = 13
      Caption = 'Arquivos Sped Fiscal'
    end
    object EditPathSpedFiscal: TSearchBox
      Left = 24
      Top = 36
      Width = 745
      Height = 21
      TabOrder = 0
      OnInvokeSearch = EditPathSpedFiscalInvokeSearch
    end
    object EditPathArquivosXml: TSearchBox
      Left = 24
      Top = 82
      Width = 745
      Height = 21
      TabOrder = 1
      OnInvokeSearch = EditPathArquivosXmlInvokeSearch
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 121
    Width = 801
    Height = 280
    Align = alTop
    Caption = ' '
    TabOrder = 1
    object ComboboxRegimeTributario: TLabeledComboBox
      Left = 24
      Top = 205
      Width = 745
      Height = 21
      Style = csDropDownList
      ItemIndex = 1
      TabOrder = 0
      Text = '1 - Simples Nacional'
      Items.Strings = (
        '0 - Todos'
        '1 - Simples Nacional'
        '2 - Simples Nacional - excesso de sublimite da receita bruta'
        '3 - Regime Normal ')
      ComboBoxLabel.Width = 84
      ComboBoxLabel.Height = 13
      ComboBoxLabel.Caption = 'Regime Tribut'#225'rio'
    end
    object EditHistorico: TLabeledEdit
      Left = 24
      Top = 248
      Width = 745
      Height = 21
      EditLabel.Width = 41
      EditLabel.Height = 13
      EditLabel.Caption = 'Hist'#243'rico'
      TabOrder = 1
      Text = 
        'Icms Creditado em arquivos xml diverge de icms credito no arquiv' +
        'o sped fiscal'
    end
    object GroupBox4: TGroupBox
      Left = 2
      Top = 15
      Width = 797
      Height = 81
      Align = alTop
      Caption = ' '
      TabOrder = 2
      object Label3: TLabel
        Left = 2
        Top = 15
        Width = 793
        Height = 16
        Align = alTop
        Caption = 
          '                                                             Cam' +
          'pos XML a serem auditados com Sped Fiscal'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 553
      end
      object Label6: TLabel
        Left = 22
        Top = 37
        Width = 37
        Height = 13
        Caption = 'Tag Xml'
      end
      object EditTagXml: TJvDBSearchComboBox
        Left = 22
        Top = 54
        Width = 222
        Height = 21
        DataField = 'TAGXML'
        DataSource = DataModuleRegras.DsTagXml
        TabOrder = 0
        Text = 'ICMS'
      end
      object EditCampoXml: TLabeledEdit
        Left = 247
        Top = 54
        Width = 169
        Height = 21
        EditLabel.Width = 52
        EditLabel.Height = 13
        EditLabel.Caption = 'Campo Xml'
        TabOrder = 1
        Text = 'vCredICMSSN'
      end
      object ComboboxIdentificadorCondicaoXml: TLabeledComboBox
        Left = 422
        Top = 54
        Width = 188
        Height = 21
        Style = csDropDownList
        TabOrder = 2
        OnChange = ComboboxIdentificadorCondicaoXmlChange
        Items.Strings = (
          'Sem Condi'#231#227'o'
          'Igual a'
          'Diferente de'
          'Menor que'
          'Maior que'
          'Maior ou Igual a'
          'Menor ou igual a')
        ComboBoxLabel.Width = 102
        ComboBoxLabel.Height = 13
        ComboBoxLabel.Caption = 'Condi'#231#227'o Campo XML'
      end
      object EditValorXml: TLabeledEdit
        Left = 616
        Top = 54
        Width = 153
        Height = 21
        EditLabel.Width = 24
        EditLabel.Height = 13
        EditLabel.Caption = 'Valor'
        TabOrder = 3
        Visible = False
      end
    end
    object GroupBox5: TGroupBox
      Left = 2
      Top = 96
      Width = 797
      Height = 89
      Align = alTop
      Caption = ' '
      TabOrder = 3
      object Label5: TLabel
        Left = 22
        Top = 40
        Width = 59
        Height = 13
        Caption = 'Tabela Sped'
      end
      object Label4: TLabel
        Left = 2
        Top = 15
        Width = 793
        Height = 16
        Align = alTop
        Caption = 
          '                                                   Campos do Spe' +
          'd Fiscal a serem auditados com arquivos XML'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 593
      end
      object EditTabelaSped: TJvDBSearchComboBox
        Left = 22
        Top = 59
        Width = 222
        Height = 21
        DataField = 'TABELA_SPED'
        DataSource = DataModuleRegras.DsTabelaSped
        CharCase = ecUpperCase
        TabOrder = 0
        Text = 'C170'
      end
      object EditCampoSped: TLabeledEdit
        Left = 247
        Top = 59
        Width = 169
        Height = 21
        EditLabel.Width = 60
        EditLabel.Height = 13
        EditLabel.Caption = 'Campo Sped'
        TabOrder = 1
        Text = 'VL_ICMS'
      end
      object ComboboxIdentificadorCondicaoSped: TLabeledComboBox
        Left = 422
        Top = 59
        Width = 188
        Height = 21
        Style = csDropDownList
        TabOrder = 2
        OnChange = ComboboxIdentificadorCondicaoSpedChange
        Items.Strings = (
          'Sem Condi'#231#227'o'
          'Igual a'
          'Diferente de'
          'Menor que'
          'Maior que'
          'Maior ou Igual a'
          'Menor ou igual a'
          '')
        ComboBoxLabel.Width = 107
        ComboBoxLabel.Height = 13
        ComboBoxLabel.Caption = 'Condi'#231#227'o Campo Sped'
      end
      object EditValorEsperadoSped: TLabeledEdit
        Left = 616
        Top = 59
        Width = 151
        Height = 21
        EditLabel.Width = 24
        EditLabel.Height = 13
        EditLabel.Caption = 'Valor'
        TabOrder = 3
        Visible = False
      end
    end
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 401
    Width = 801
    Height = 66
    Align = alTop
    Caption = ' '
    TabOrder = 2
    object BotaoCruzaDados: TButton
      Left = 24
      Top = 23
      Width = 745
      Height = 25
      Caption = 'Auditar Regra Acima'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = BotaoCruzaDadosClick
    end
  end
  object GridAdvertencias: TDBGrid
    Left = 0
    Top = 467
    Width = 801
    Height = 203
    Align = alClient
    DataSource = DataModuleRegras.DSRelErrosAdvertencias
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnCellClick = GridAdvertenciasCellClick
    OnDrawColumnCell = GridAdvertenciasDrawColumnCell
    OnTitleClick = GridAdvertenciasTitleClick
  end
end
