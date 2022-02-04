object DataModuleRegras: TDataModuleRegras
  OldCreateOrder = False
  Height = 369
  Width = 818
  object DSRelErrosAdvertencias: TDataSource
    DataSet = CdsRelErrosAdvertencias
    Left = 303
    Top = 128
  end
  object CdsRelErrosAdvertencias: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 88
    Top = 144
    object CdsRelErrosAdvertenciasID: TIntegerField
      FieldName = 'ID'
      Visible = False
    end
    object CdsRelErrosAdvertenciasNUMERO_DOCUMENTO: TStringField
      DisplayLabel = 'N'#186' Documento'
      DisplayWidth = 18
      FieldName = 'NUMERO_DOCUMENTO'
      Size = 10
    end
    object CdsRelErrosAdvertenciasCHAVE_ACESSO: TStringField
      DisplayLabel = 'Chave Acesso'
      DisplayWidth = 54
      FieldName = 'CHAVE_ACESSO'
      Size = 100
    end
    object CdsRelErrosAdvertenciasRESULTADO_XML: TStringField
      DisplayLabel = 'Resultado Campo XMl'
      DisplayWidth = 30
      FieldName = 'RESULTADO_XML'
      Size = 100
    end
    object CdsRelErrosAdvertenciasRESULTADO_ESPERADO_SPED: TStringField
      DisplayLabel = 'Resultado Esperado'
      DisplayWidth = 30
      FieldName = 'RESULTADO_ESPERADO_SPED'
      Size = 100
    end
    object CdsRelErrosAdvertenciasRESULTADO_SPED: TStringField
      DisplayLabel = 'Resultado Sped'
      DisplayWidth = 30
      FieldName = 'RESULTADO_SPED'
      Size = 100
    end
    object CdsRelErrosAdvertenciasHISTORICO: TStringField
      DisplayLabel = 'Hist'#243'rico'
      DisplayWidth = 200
      FieldName = 'HISTORICO'
      Size = 200
    end
    object CdsRelErrosAdvertenciasIDENTIFICADOR_ERRO_ADVERTENCIA: TStringField
      DisplayLabel = 'Status'
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
    Left = 568
    Top = 96
  end
  object ACBrSpedFiscal: TACBrSpedFiscalImportar
    ACBrSpedFiscal = ACBrSPEDFiscal1
    Left = 568
    Top = 184
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
    Left = 568
    Top = 278
  end
end
