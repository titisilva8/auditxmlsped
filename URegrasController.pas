unit URegrasController;
interface

uses  System.StrUtils,UDataModule,ACBrDFe, ACBrNFe, Data.DB,
Datasnap.DBClient, pcnConversao,Vcl.Dialogs,Winapi.Messages,System.SysUtils,Rtti,System.Variants,URegra;

 type TRetornoTamanhoLista = Record
    QuantidadeItensEntreListasIguais:boolean;
    QuatidadeListaXml:Integer;
    QuantidadeListaSped:Integer;
  End;

  Type TRegrasController = class
    private
    public
      class function GetIndiceTabelaSped(Tabela,Pesquisa:String):Variant;
      class procedure LimpaCdsAdvertencias;
      class function ImportaSpedFiscal(Path:String):boolean;
      class function GetValorPesquisaParaEncontrarIndice(Tabela:String):String;
      class function CarregaArquivoXml(PathArquivoXml:String):boolean;
      class function VerificaQuantidadeItensXmltoSped(TagXml,TabelaSped: String;IndiceTabelaMestreSpedFiscal:Integer):TRetornoTamanhoLista;
      class procedure RegistraErrosAdvertencias(NumeroNf,ChaveAcesso,ResultadoXml,ResultadoEsperadoSped,ResultadoSped,Historico: String);
      class procedure VerificaDivergencias_Xml_X_Sped(Regra:TRegra;IndiceMestreSped,IndiceDetalheDetalheSped_Xml:Integer);
      class function GetValorField(pTag, pNomeField: String;IndiceFilho:Integer): Variant;
      class function GetValorTagXml(TagXml, CamposTagXml: String;I:Integer): String;
      class function GetValorCampoSped(TabelaSped, CampoSped: String;I: Integer): String;
      class procedure VerificaTagIde(TagXml,CamposTagXml:String);
      class function GetValorFieldSped(pTabela, pCampo: String;IndicePai,IndiceFilho:Integer): Variant;

  end;


implementation

{ TRegrasController }

class function TRegrasController.CarregaArquivoXml(PathArquivoXml: String): boolean;
begin
  Result:=true;
  try
    DataModuleRegras.AcbrNfe.NotasFiscais.Clear;
    DataModuleRegras.AcbrNfe.NotasFiscais.LoadFromFile(PathArquivoXml);
    Except on E:Exception do
    begin
      Result:=False;
      ShowMessage('Erro ao importar arquivo xml '+PathArquivoXml+E.Message);
      Abort;
    end;
  end;
end;

class function TRegrasController.GetIndiceTabelaSped(Tabela,Pesquisa: String): Variant;
var i:Integer;
begin
  Result:=false;
  if (Tabela = 'C100') or (Tabela = 'C170')  then
  begin
    for i := 0 to DataModuleRegras.AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Count-1 do
    if DataModuleRegras.AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[I].CHV_NFE = Pesquisa then
    Exit(i);
  end;
end;

class function TRegrasController.ImportaSpedFiscal(Path:String): boolean;
begin
  try
    DataModuleRegras.AcbrSpedFiscal.Arquivo:=Path;
    DataModuleRegras.AcbrSpedFiscal.Importar;
    Result:=true;
  except on E:Exception do
    begin
      Result:=False;
      ShowMessage('Erro ao importar Sped Fiscal '+E.Message);
      Abort;
    end;
  end;
end;

class function TRegrasController.GetValorFieldSped(pTabela, pCampo: String;IndicePai,IndiceFilho:Integer): Variant;
var
  Contexto: TRttiContext;
  TipoTag: TRttiType;
  PropriedadeTag: TRttiProperty;
  NomeTipo: String;
  i: Integer;
  Objeto:TObject;
begin
  Contexto := TRttiContext.Create;
  try

    if pTabela = 'C100' then
    Objeto:= DataModuleRegras.AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[IndicePai];

    if pTabela = 'C170' then
    Objeto:= DataModuleRegras.AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[IndicePai].RegistroC170.Items[IndiceFilho];

    TipoTag:= Contexto.GetType(Objeto.ClassInfo);
    PropriedadeTag := TipoTag.GetProperty(pCampo);
    NomeTipo := LowerCase(PropriedadeTag.PropertyType.Name);

    if NomeTipo = 'tdatetime' then
    begin
      Result:=QuotedStr(FormatDateTime('dd/mm/yyyy hh:mm:ss',PropriedadeTag.GetValue(Objeto).AsExtended));
    end

    else
    if PropriedadeTag.PropertyType.TypeKind in [tkString,tkUString] then
    Result:=PropriedadeTag.GetValue(Objeto).AsString

    else if PropriedadeTag.PropertyType.TypeKind = tkFloat then
    Result:=PropriedadeTag.GetValue(Objeto).AsExtended

    else if PropriedadeTag.PropertyType.TypeKind = tkInteger then
    Result:=PropriedadeTag.GetValue(Objeto).AsInteger

    else if PropriedadeTag.PropertyType.TypeKind = tkEnumeration then
    Result:=PropriedadeTag.GetValue(Objeto).AsVariant

    else if PropriedadeTag.PropertyType.TypeKind = tkVariant then
    Result:=PropriedadeTag.GetValue(Objeto).AsVariant

  finally
    Contexto.Free;
  end;

end;

{class procedure TRegrasController.VerificaDivergencias_Xml_X_Sped(TagXml,CampoXml,ValorXml,TabelaSped,CampoSped,ValorEsperadoSped,Historico:String;IndiceMestreSped,IndiceDetalheDetalheSped_Xml:Integer);
var ValorCampoXmlRetornado,ValorCampoSpedRetornado:Variant;
begin
  ValorCampoXmlRetornado:=GetValorField(TagXml,CampoXml,IndiceDetalheDetalheSped_Xml);
  if ValorXml<>'' then
  if VarToStr(ValorCampoXmlRetornado) = ValorXml then
  begin
    ValorCampoSpedRetornado:=GetValorFieldSped(TabelaSped,CampoSped,IndiceMestreSped,IndiceDetalheDetalheSped_Xml);
    if ValorEsperadoSped <> VarToStr(ValorCampoSpedRetornado) then
    RegistraErrosAdvertencias(DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Ide.nNF.ToString,
    DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.procNFe.chNFe,VarToStr(ValorCampoXmlRetornado),
    VarToStr(ValorEsperadoSped),VarToStr(ValorCampoSpedRetornado),'Teste 1');
  end;

  if ValorXml = '' then
  begin
    ValorCampoSpedRetornado:=GetValorFieldSped(TabelaSped,CampoSped,IndiceMestreSped,IndiceDetalheDetalheSped_Xml);
    if ValorCampoXmlRetornado <> ValorCampoSpedRetornado then
    TRegrasController.RegistraErrosAdvertencias(DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Ide.nNF.ToString,
    DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.procNFe.chNFe,VarToStr(ValorCampoXmlRetornado),
    VarToStr(ValorCampoXmlRetornado),VarToStr(ValorCampoSpedRetornado),'Teste2');
  end;
end;}


class procedure TRegrasController.VerificaDivergencias_Xml_X_Sped(Regra:TRegra;IndiceMestreSped,IndiceDetalheDetalheSped_Xml:Integer);
var ValorCampoXmlRetornado,ValorCampoSpedRetornado:Variant;
begin
  ValorCampoXmlRetornado:=GetValorField(Regra.TagXml,Regra.CampoXml,IndiceDetalheDetalheSped_Xml);
  if Regra.CondicaoCampoXml<>'' then
  if VarToStr(ValorCampoXmlRetornado) = Regra.CondicaoCampoXml then
  begin
    ValorCampoSpedRetornado:=GetValorFieldSped(Regra.TabelaSped,Regra.CampoSped,IndiceMestreSped,IndiceDetalheDetalheSped_Xml);
    if Regra.ValorSperadoSped <> VarToStr(ValorCampoSpedRetornado) then
    RegistraErrosAdvertencias(DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Ide.nNF.ToString,
    DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.procNFe.chNFe,VarToStr(ValorCampoXmlRetornado),
    VarToStr(Regra.ValorSperadoSped),VarToStr(ValorCampoSpedRetornado),Regra.Historico);
  end;

  if Regra.CondicaoCampoXml = '' then
  begin
    ValorCampoSpedRetornado:=GetValorFieldSped(Regra.TabelaSped,Regra.CampoSped,IndiceMestreSped,IndiceDetalheDetalheSped_Xml);
    if ValorCampoXmlRetornado <> ValorCampoSpedRetornado then
    TRegrasController.RegistraErrosAdvertencias(DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Ide.nNF.ToString,
    DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.procNFe.chNFe,VarToStr(ValorCampoXmlRetornado),
    VarToStr(ValorCampoXmlRetornado),VarToStr(ValorCampoSpedRetornado),Regra.Historico);
  end;
end;


class function TRegrasController.GetValorPesquisaParaEncontrarIndice(Tabela: String): String;
begin
  Result:='';
  if (Tabela = 'C100') or (Tabela = 'C170')  then
  begin
    Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.procNFe.chNFe;
  end;
end;

class procedure TRegrasController.LimpaCdsAdvertencias;
begin
  DataModuleRegras.CdsRelErrosAdvertencias.EmptyDataSet;
end;


class function TRegrasController.VerificaQuantidadeItensXmltoSped(TagXml,TabelaSped: String;
IndiceTabelaMestreSpedFiscal:Integer): TRetornoTamanhoLista;
begin
  Result.QuantidadeItensEntreListasIguais:=True;

  if TagXml = 'prod' then
  Result.QuatidadeListaXml:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det.Count
  else
  Result.QuatidadeListaXml:=1;

  if TabelaSped = 'C170' then
  Result.QuantidadeListaSped:= DataModuleRegras.AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[IndiceTabelaMestreSpedFiscal].RegistroC170.Count
  else
  Result.QuantidadeListaSped:=1;


  if Result.QuatidadeListaXml <> Result.QuantidadeListaSped then
  begin
    RegistraErrosAdvertencias(DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Ide.nNF.ToString,
    DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.procNFe.chNFe,'','','','Quantidade de Itens diferentes entre xml e sped');
    Result.QuantidadeItensEntreListasIguais:=false;
  end

end;


class procedure TRegrasController.RegistraErrosAdvertencias(NumeroNf,ChaveAcesso,ResultadoXml,ResultadoEsperadoSped,
 ResultadoSped,Historico: String);
begin
  DataModuleRegras.CdsRelErrosAdvertencias.Append;
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('NUMERO_DOCUMENTO').AsString:=NumeroNf;
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('CHAVE_ACESSO').AsString:=ChaveAcesso;
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('HISTORICO').AsString:=Historico;
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('RESULTADO_XML').AsString:=ResultadoXml;
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('RESULTADO_ESPERADO_SPED').AsString:=ResultadoEsperadoSped;
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('RESULTADO_SPED').AsString:=ResultadoSped;
  DataModuleRegras.CdsRelErrosAdvertencias.Post;
end;


class function TRegrasController.GetValorField(pTag, pNomeField: String;IndiceFilho:Integer): Variant;
var
  Contexto: TRttiContext;
  TipoTag: TRttiType;
  PropriedadeTag: TRttiProperty;
  NomeTipo: String;
  i: Integer;
  Objeto:TObject;
begin
  Contexto := TRttiContext.Create;
  try

    if pTag = 'Ide' then
    Objeto:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Ide;

    if pTag = 'Emit' then
    Objeto:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Emit;

    if pTag = 'ICMSTot' then
    Objeto:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Total.ICMSTot;

    if pTag = 'prod' then
    Objeto:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det.Items[IndiceFilho].Prod;

    TipoTag:= Contexto.GetType(Objeto.ClassInfo);
    PropriedadeTag := TipoTag.GetProperty(pNomeField);
    NomeTipo := LowerCase(PropriedadeTag.PropertyType.Name);

    if NomeTipo = 'tdatetime' then
    begin
      Result:=QuotedStr(FormatDateTime('dd/mm/yyyy hh:mm:ss',PropriedadeTag.GetValue(Objeto).AsExtended));
    end

    else
    if PropriedadeTag.PropertyType.TypeKind in [tkString,tkUString] then
    Result:=PropriedadeTag.GetValue(Objeto).AsString

    else if PropriedadeTag.PropertyType.TypeKind = tkFloat then
    Result:=PropriedadeTag.GetValue(Objeto).AsExtended

    else if PropriedadeTag.PropertyType.TypeKind = tkInteger then
    Result:=PropriedadeTag.GetValue(Objeto).AsInteger

    else if PropriedadeTag.PropertyType.TypeKind = tkEnumeration then
    Result:=PropriedadeTag.GetValue(Objeto).AsVariant

    else if PropriedadeTag.PropertyType.TypeKind = tkVariant then
    Result:=PropriedadeTag.GetValue(Objeto).AsVariant

  finally
    Contexto.Free;
  end;

end;


class function TRegrasController.GetValorTagXml(TagXml, CamposTagXml: String;I:Integer): String;
var teste:string;
begin

  if TagXml = 'Ide' then
  begin
    case AnsiIndexStr(CamposTagXml,['serie','dEmi'])  of
    0:Result:=IntToStr(DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].Nfe.Ide.serie);
    1:Result:=DateTimeToStr(DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].Nfe.Ide.dEmi);
    end;
  end;


  if TagXml = 'Prod' then
  begin
    case AnsiIndexStr(CamposTagXml,['Ncm','Cfop'])  of
    0:Result:=DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].Nfe.Det.Items[i].Prod.Ncm;
    1:Result:=DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].Nfe.Det.Items[i].Prod.Cfop;
    end;
  end;


   if TagXml = 'Total' then
  begin
    case AnsiIndexStr(CamposTagXml,['vICMS'])  of
    0:Result:=FloattoStr(DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].Nfe.Total.ICMSTot.vICMS);
    end;
  end;

end;


class function TRegrasController.GetValorCampoSped(TabelaSped, CampoSped: String;I: Integer): String;
begin
  if TabelaSped = 'C100' then
  begin
    case AnsiIndexStr(CampoSped,['SER','DT_DOC'])  of
    0:Result:=DataModuleRegras.AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[I].SER;
    1:Result:=DateTimeToStr(DataModuleRegras.AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[I].DT_DOC);
    end;
  end;


  if TabelaSped = 'C170' then
  begin
    case AnsiIndexStr(CampoSped,['CFOP'])  of
    0:Result:=DataModuleRegras.AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[I].RegistroC170.Items[I].CFOP;
    //1:Result:=AcbrNfe.NotasFiscais.Items[0].Nfe.Det.Items[i].Prod.Cfop;
    end;
  end;


  //if TagXml = 'Total' then
  //begin
    //case AnsiIndexStr(CamposTagXml,['vICMS'])  of
    //0:Result:=FloattoStr(AcbrNfe.NotasFiscais.Items[0].Nfe.Total.ICMSTot.vICMS);
    //end;
  //end;
end;


class procedure TRegrasController.VerificaTagIde(TagXml,CamposTagXml:String);
var ValorCampo,ValorCampoSped:String;
begin
  if TagXml = 'Ide' then
  begin
    //if EditValorTagXml.Text = GetValorTagXml(TagXml,CamposTagXml,0) then
    //ValorCampo:= GetValorTagXml(TagXml,CamposTagXml,0);


 //   GetValorCampoSped(TabelaSped, CampoSped: String;I: Integer): String;


  end;
end;

end.
