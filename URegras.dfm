object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 451
  ClientWidth = 937
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 937
    Height = 451
    ActivePage = TabSheet5
    Align = alClient
    TabOrder = 0
    object TabSheet5: TTabSheet
      Caption = 'Arquivos Eletronicos'
      ImageIndex = 7
      object Label1: TLabel
        Left = 24
        Top = 17
        Width = 98
        Height = 13
        Caption = 'Arquivos Sped Fiscal'
      end
      object Label2: TLabel
        Left = 24
        Top = 73
        Width = 61
        Height = 13
        Caption = 'Arquivos Xml'
      end
      object SearchBox1: TSearchBox
        Left = 24
        Top = 32
        Width = 433
        Height = 21
        TabOrder = 0
        Text = 
          'D:\sped betoni e filgueiras\SpedEFD-17130078000123-0020549840087' +
          '-Remessa de arquivo original-set2021.txt'
        OnInvokeSearch = SearchBox1InvokeSearch
      end
      object SearchBox2: TSearchBox
        Left = 24
        Top = 88
        Width = 433
        Height = 21
        TabOrder = 1
        Text = 
          'D:\sped betoni e filgueiras\LAP9KdOS\312109004301750001395500200' +
          '00133741000134017.xml'
        OnInvokeSearch = SearchBox2InvokeSearch
      end
      object Button1: TButton
        Left = 24
        Top = 256
        Width = 137
        Height = 25
        Caption = 'Cruzar dados Sped'
        TabOrder = 2
        OnClick = Button1Click
      end
      object LabeledEdit2: TLabeledEdit
        Left = 183
        Top = 154
        Width = 128
        Height = 21
        EditLabel.Width = 52
        EditLabel.Height = 13
        EditLabel.Caption = 'Campo Xml'
        TabOrder = 3
        Text = 'serie'
      end
      object LabeledEdit3: TLabeledEdit
        Left = 24
        Top = 154
        Width = 153
        Height = 21
        EditLabel.Width = 37
        EditLabel.Height = 13
        EditLabel.Caption = 'Tag Xml'
        TabOrder = 4
        Text = 'Ide'
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Parametros'
      object LabeledEdit1: TLabeledEdit
        Left = 16
        Top = 24
        Width = 433
        Height = 21
        EditLabel.Width = 26
        EditLabel.Height = 13
        EditLabel.Caption = 'Titulo'
        TabOrder = 0
      end
      object LabeledMemo1: TLabeledMemo
        Left = 16
        Top = 64
        Width = 433
        Height = 89
        TabOrder = 1
        MemoLabel.Width = 78
        MemoLabel.Height = 13
        MemoLabel.Caption = 'Descri'#231#227'o Regra'
      end
      object CheckBox1: TCheckBox
        Left = 16
        Top = 184
        Width = 97
        Height = 17
        Caption = 'Entrada'
        TabOrder = 2
      end
      object CheckBox2: TCheckBox
        Left = 128
        Top = 184
        Width = 97
        Height = 17
        Caption = 'Saida'
        TabOrder = 3
      end
      object CheckBox3: TCheckBox
        Left = 248
        Top = 184
        Width = 97
        Height = 17
        Caption = 'Ativa'
        TabOrder = 4
      end
      object LabeledComboBox1: TLabeledComboBox
        Left = 16
        Top = 232
        Width = 433
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 5
        Text = '1 - Regra Sped Fiscal'
        Items.Strings = (
          '1 - Regra Sped Fiscal'
          '2 - Regra NF-e Xml'
          '3 - Regra para Cruzamento de Dados XML x Sped Fiscal')
        ComboBoxLabel.Width = 52
        ComboBoxLabel.Height = 13
        ComboBoxLabel.Caption = 'Tipo Regra'
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Grupo de Participantes'
      ImageIndex = 1
      object JvDBUltimGrid1: TJvDBUltimGrid
        Left = 0
        Top = 0
        Width = 929
        Height = 423
        Align = alClient
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        SelectColumnsDialogStrings.Caption = 'Select columns'
        SelectColumnsDialogStrings.OK = '&OK'
        SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
        EditControls = <>
        RowsHeight = 17
        TitleRowHeight = 17
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Participante Especifico'
      ImageIndex = 2
      object JvDBUltimGrid2: TJvDBUltimGrid
        Left = 0
        Top = 0
        Width = 929
        Height = 423
        Align = alClient
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        SelectColumnsDialogStrings.Caption = 'Select columns'
        SelectColumnsDialogStrings.OK = '&OK'
        SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
        EditControls = <>
        RowsHeight = 17
        TitleRowHeight = 17
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Grupo de Produtos'
      ImageIndex = 3
      object JvDBUltimGrid3: TJvDBUltimGrid
        Left = 0
        Top = 0
        Width = 929
        Height = 423
        Align = alClient
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        SelectColumnsDialogStrings.Caption = 'Select columns'
        SelectColumnsDialogStrings.OK = '&OK'
        SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
        EditControls = <>
        RowsHeight = 17
        TitleRowHeight = 17
      end
    end
    object produtosmercadorias: TTabSheet
      Caption = 'Produtos/Mercadorias Especificas'
      ImageIndex = 4
      object JvDBUltimGrid4: TJvDBUltimGrid
        Left = 0
        Top = 0
        Width = 929
        Height = 423
        Align = alClient
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        SelectColumnsDialogStrings.Caption = 'Select columns'
        SelectColumnsDialogStrings.OK = '&OK'
        SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
        EditControls = <>
        RowsHeight = 17
        TitleRowHeight = 17
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'NCM Especifico'
      ImageIndex = 5
      object JvDBUltimGrid5: TJvDBUltimGrid
        Left = 0
        Top = 0
        Width = 929
        Height = 423
        Align = alClient
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        SelectColumnsDialogStrings.Caption = 'Select columns'
        SelectColumnsDialogStrings.OK = '&OK'
        SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
        EditControls = <>
        RowsHeight = 17
        TitleRowHeight = 17
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'Campos para cruzamento'
      ImageIndex = 6
      object LabeledComboBox2: TLabeledComboBox
        Left = 296
        Top = 40
        Width = 99
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 0
        Text = 'Igual a'
        Items.Strings = (
          'Igual a'
          'Diferente de'
          'Menor que'
          'Maior  que'
          'Maior ou Igual a'
          'Menor ou igual a'
          '')
        ComboBoxLabel.Width = 52
        ComboBoxLabel.Height = 13
        ComboBoxLabel.Caption = 'Tipo Regra'
      end
      object EditTagXml: TLabeledEdit
        Left = 3
        Top = 40
        Width = 153
        Height = 21
        EditLabel.Width = 37
        EditLabel.Height = 13
        EditLabel.Caption = 'Tag Xml'
        TabOrder = 1
      end
      object EditValorTagXml: TLabeledEdit
        Left = 401
        Top = 40
        Width = 153
        Height = 21
        EditLabel.Width = 24
        EditLabel.Height = 13
        EditLabel.Caption = 'Valor'
        TabOrder = 2
      end
      object LabeledEdit4: TLabeledEdit
        Left = 3
        Top = 88
        Width = 153
        Height = 21
        EditLabel.Width = 59
        EditLabel.Height = 13
        EditLabel.Caption = 'Tabela Sped'
        TabOrder = 3
      end
      object LabeledComboBox3: TLabeledComboBox
        Left = 296
        Top = 88
        Width = 99
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 4
        Text = 'Igual a'
        Items.Strings = (
          'Igual a'
          'Diferente de'
          'Menor que'
          'Maior  que'
          'Maior ou Igual a'
          'Menor ou igual a'
          '')
        ComboBoxLabel.Width = 52
        ComboBoxLabel.Height = 13
        ComboBoxLabel.Caption = 'Tipo Regra'
      end
      object LabeledEdit5: TLabeledEdit
        Left = 401
        Top = 88
        Width = 153
        Height = 21
        EditLabel.Width = 24
        EditLabel.Height = 13
        EditLabel.Caption = 'Valor'
        TabOrder = 5
      end
      object LabeledEdit6: TLabeledEdit
        Left = 3
        Top = 136
        Width = 551
        Height = 21
        EditLabel.Width = 41
        EditLabel.Height = 13
        EditLabel.Caption = 'Hist'#243'rico'
        TabOrder = 6
      end
      object EditCampoXml: TLabeledEdit
        Left = 162
        Top = 40
        Width = 128
        Height = 21
        EditLabel.Width = 52
        EditLabel.Height = 13
        EditLabel.Caption = 'Campo Xml'
        TabOrder = 7
      end
      object LabeledEdit8: TLabeledEdit
        Left = 162
        Top = 88
        Width = 128
        Height = 21
        EditLabel.Width = 60
        EditLabel.Height = 13
        EditLabel.Caption = 'Campo Sped'
        TabOrder = 8
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 516
    Top = 48
  end
  object OpenDialog2: TOpenDialog
    Left = 524
    Top = 128
  end
  object ACBrNFe: TACBrNFe
    Configuracoes.Geral.SSLLib = libNone
    Configuracoes.Geral.SSLCryptLib = cryNone
    Configuracoes.Geral.SSLHttpLib = httpNone
    Configuracoes.Geral.SSLXmlSignLib = xsNone
    Configuracoes.Geral.FormatoAlerta = 'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.'
    Configuracoes.Arquivos.OrdenacaoPath = <>
    Configuracoes.WebServices.UF = 'SP'
    Configuracoes.WebServices.AguardarConsultaRet = 0
    Configuracoes.WebServices.QuebradeLinha = '|'
    Configuracoes.RespTec.IdCSRT = 0
    Left = 596
    Top = 304
  end
  object ACBrSpedFiscal: TACBrSpedFiscalImportar
    ACBrSpedFiscal = ACBrSPEDFiscal1
    Left = 596
    Top = 224
  end
  object ACBrSPEDFiscal1: TACBrSPEDFiscal
    Path = 'C:\Program Files (x86)\Embarcadero\Studio\21.0\bin\'
    Delimitador = '|'
    ReplaceDelimitador = False
    TrimString = True
    CurMascara = '#0.00'
    Left = 724
    Top = 208
  end
end
