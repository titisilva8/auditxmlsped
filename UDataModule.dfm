object DataModuleRegras: TDataModuleRegras
  OldCreateOrder = False
  Height = 245
  Width = 687
  object DSRelErrosAdvertencias: TDataSource
    DataSet = CdsRelErrosAdvertencias
    Left = 79
    Top = 104
  end
  object CdsRelErrosAdvertencias: TClientDataSet
    PersistDataPacket.Data = {
      B30100009619E0BD01000000180000000C000000000003000000B30112544950
      4F5F454E54524144415F53414944410100490000000100055749445448020002
      000A00104E554D45524F5F444F43554D454E544F010049000000010005574944
      5448020002000A00044954454D01004900000001000557494454480200020004
      0012464F524E454345444F525F434C49454E5445010049000000010005574944
      5448020002003C000D524553554C5441444F5F584D4C01004900000001000557
      4944544802000200640017524553554C5441444F5F455350455241444F5F5350
      454401004900000001000557494454480200020064000E524553554C5441444F
      5F53504544010049000000010005574944544802000200640009484953544F52
      49434F010049000000010005574944544802000200C8000C43484156455F4143
      4553534F01004900000001000557494454480200020064001E4944454E544946
      494341444F525F4552524F5F414456455254454E434941010049000000010005
      57494454480200020001000C444154415F454D495353414F0400060000000000
      0C444154415F454E545241444104000600000000000000}
    Active = True
    Aggregates = <>
    Params = <>
    Left = 80
    Top = 40
    object CdsRelErrosAdvertenciasTIPO_ENTRADA_SAIDA: TStringField
      DisplayLabel = 'Tipo'
      DisplayWidth = 10
      FieldName = 'TIPO_ENTRADA_SAIDA'
      Size = 10
    end
    object CdsRelErrosAdvertenciasNUMERO_DOCUMENTO: TStringField
      DisplayLabel = 'N'#186' Documento'
      DisplayWidth = 13
      FieldName = 'NUMERO_DOCUMENTO'
      Size = 10
    end
    object CdsRelErrosAdvertenciasITEM: TStringField
      DisplayLabel = 'Item'
      DisplayWidth = 4
      FieldName = 'ITEM'
      Size = 4
    end
    object CdsRelErrosAdvertenciasFORNECEDOR_CLIENTE: TStringField
      DisplayLabel = 'Fornecedor/Cliente'
      DisplayWidth = 46
      FieldName = 'FORNECEDOR_CLIENTE'
      Size = 60
    end
    object CdsRelErrosAdvertenciasRESULTADO_XML: TStringField
      DisplayLabel = 'Resultado Campo XMl'
      DisplayWidth = 20
      FieldName = 'RESULTADO_XML'
      Size = 100
    end
    object CdsRelErrosAdvertenciasRESULTADO_ESPERADO_SPED: TStringField
      DisplayLabel = 'Resultado Esperado'
      DisplayWidth = 19
      FieldName = 'RESULTADO_ESPERADO_SPED'
      Size = 100
    end
    object CdsRelErrosAdvertenciasRESULTADO_SPED: TStringField
      DisplayLabel = 'Resultado Sped'
      DisplayWidth = 20
      FieldName = 'RESULTADO_SPED'
      Size = 100
    end
    object CdsRelErrosAdvertenciasHISTORICO: TStringField
      DisplayLabel = 'Hist'#243'rico'
      DisplayWidth = 78
      FieldName = 'HISTORICO'
      Size = 200
    end
    object CdsRelErrosAdvertenciasCHAVE_ACESSO: TStringField
      DisplayLabel = 'Chave Acesso'
      DisplayWidth = 50
      FieldName = 'CHAVE_ACESSO'
      Size = 100
    end
    object CdsRelErrosAdvertenciasDATA_EMISSAO: TDateField
      DisplayLabel = 'Emiss'#227'o'
      DisplayWidth = 10
      FieldName = 'DATA_EMISSAO'
    end
    object CdsRelErrosAdvertenciasDATA_ENTRADA: TDateField
      DisplayLabel = 'Entrada Sped'
      DisplayWidth = 10
      FieldName = 'DATA_ENTRADA'
    end
    object CdsRelErrosAdvertenciasIDENTIFICADOR_ERRO_ADVERTENCIA: TStringField
      DisplayLabel = 'Corrigido?'
      DisplayWidth = 6
      FieldName = 'IDENTIFICADOR_ERRO_ADVERTENCIA'
      Size = 1
    end
  end
  object ACBrSPEDFiscal1: TACBrSPEDFiscal
    Path = 'C:\Program Files (x86)\Embarcadero\Studio\21.0\bin\'
    Delimitador = '|'
    ReplaceDelimitador = False
    TrimString = True
    CurMascara = '#0.00'
    Left = 584
    Top = 16
  end
  object ACBrSpedFiscal: TACBrSpedFiscalImportar
    ACBrSpedFiscal = ACBrSPEDFiscal1
    Left = 584
    Top = 80
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
    Left = 584
    Top = 150
  end
  object CdsTabelaSped: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 240
    Top = 40
    object CdsTabelaSpedTABELA_SPED: TStringField
      FieldName = 'TABELA_SPED'
      Size = 30
    end
    object CdsTabelaSpedNIVEL: TIntegerField
      FieldName = 'NIVEL'
    end
  end
  object DsTabelaSped: TDataSource
    DataSet = CdsTabelaSped
    Left = 240
    Top = 120
  end
  object CdsTagXml: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 368
    Top = 40
    object CdsTagXmlTAGXML: TStringField
      FieldName = 'TAGXML'
      Size = 60
    end
    object CdsTagXmlNIVEL: TIntegerField
      FieldName = 'NIVEL'
    end
  end
  object DsTagXml: TDataSource
    DataSet = CdsTagXml
    Left = 368
    Top = 120
  end
  object OpenDialogSped: TOpenDialog
    Left = 476
    Top = 48
  end
end
