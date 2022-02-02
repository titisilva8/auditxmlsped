object DataModuleRegras: TDataModuleRegras
  OldCreateOrder = False
  Height = 310
  Width = 600
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
end
