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

      class function TagXmlVinculadaaUmaLista(TagXml:String):boolean;
      class function TabelaSpedVinculadaaUmaLista(TabelaSped:String):boolean;
      class function GetQuantidadeItensListaXml(TagXml:String):Integer;
      class function GetQuantidadeItensListaSped(TabelaSped:String;IndiceTabelaMestreSpedFiscal:Integer):Integer;


      class procedure RegistraErrosAdvertencias(NumeroNf,ChaveAcesso,ResultadoXml,ResultadoEsperadoSped,ResultadoSped,Historico: String);
      class procedure VerificaDivergencias_Xml_X_Sped(Regra:TRegra;IndiceMestreSped,IndiceDetalheDetalheSped_Xml:Integer);

      class function GetValorFieldXml(pTag, pNomeField: String;IndiceFilho:Integer): Variant;
      class function GetObjetoXml(TagXml:String;IndiceFilho:Integer):TObject;
      class function GetObjetoSped(TabelaSped:String;IndicePai,IndiceFilho:Integer):TObject;


      class function GetValorFieldSped(pTabela, pCampo: String;IndicePai,IndiceFilho:Integer): Variant;

       // tags que apresentam apenas um registros no xml
      const TagXmlNivel1:array[1..23] of string = ('ide','emit','enderEmit','avulsa','dest','enderDest',
      'retirada','entrega','ICMSTot','ISSQNtot','retTrib','transp','transporta','retTransp','veicTransp',
      'fat','infAdic','obsCont','obsFisco','procRef','exporta','compra','cana');

      // tags que apresentam registros de listas no xml Nivel 1 (Mestre-Detalhe)
      const TagXmlListasNivel2 :array[1..48] of string = ('prod','DI','veicProd','med','arma','comb','CIDE',//7
      'ICMS00','ICMS10','ICMS20','ICMS30','ICMS40','ICMS51','ICMS60','ICMS70','ICMS90','ICMSPart','ICMSST',//18
      'ICMSSN101','ICMSSN102','ICMSSN201','ICMSSN202','ICMSSN500','ICMSSN900',//24
      'IPI','IPITrib','IPINT','II',//28
      'PISAliq','PISQtde','PISNT','PISOutr','PISST',//33
      'COFINSAliq','COFINSQtde','COFINSNT','COFINSOutr','COFINSST',//38
      'ISSQN','NFref','refNF','refNFP','refECF','reboque','vol','dup','forDia','deduc'); //48

      // tags que apresentam registros de listas Nivel 2 (mestre detalhe dentro de outro mestre detalhe)
      const TagXmlListasNivel3:array[1..2] of string  = ('adi','lacres');


      const TabelaSpedItens :array[1..2] of string =('C100','C170');

       //todo: Mapear todas tabelas sped

      {const TabelaSpedRegistroUnico :array[1..2] of string =
      ('0000','0001','0002','0005','0100','0990',
      'B001','B470','B500','B510','B990',
      'E001','','','','','','','','',);}

      {const TabelaSpedItens :array[1..2] of string =
      ('0015','0150','0175','0190','0200','0205','0206','0210','0220','0300','0305','0400','0450','0460','0500','0600',
      'B020','B025','B030','B035','B350','B420','B440','B460',
      'C100','C101','C105','C111','C112','C113','C115','C116','C120','C140','C141','C160','C170','C185','C186','C190','C191','C300','C350','C370','C400',
      'C470','C510','C990',
      'D001','D100','D101','D110','D130','D140','D150','D160','D161','D162','D170','D180','D190','D195','D197','D300','D301',
      'D310','D350','D355','D360','D370','D390','D410','D411','D420','D500','D510','D530','D590','D610','D690','D695','D696','D697','D990',
      'E100','E110','E111','E112','E113','E115','E116','E200','E210','E220','E300','E310','E311','E312','E313','E316','E500','E510','E520',
      'E530','E531','E990','G001','G110','G125','G126','G130','G140','G990',
      'H001','H005','H010','H020','H030','H990',
      'K001','K100','K200','K210','K215','K220','K230','K235','K255','K265','K270','K210','K220','K230','K250','K260','K291','K292','K301','K302',
      'K275','K280','K290','K291','K292','K300','K301','K302','K990',
      '1001','1010','1100','1105','1110','1200','1210','1250','1300','1310','1320','1350','1360','1390','1391','1400',
      '1500','1510','1600','1601','1700','1710','1800','1900','1910','1920','1921','1923','1925','1926','1960','1970','1975',
      '1980','1990',
      '9001','9900','9990','9999',C171,C172,C173,C174,C175,C176,C177,C178,C179,C180,C181,C310,C321,'C380','C390','C405','C410','C420','C460','C465','C480','C495','C500',
      'C590','C591','C595','C597','C600','C601','C610','C690','C700','C790','C791','C800','C810','C815','C860','C870','C880','E230','E240','E250',
      'C330','C425','C430');}





      class procedure AplicaRegraComCondicao(Regra:TRegra;IndiceMestreSped,IndiceDetalheDetalheSped_Xml:Integer;ValorCampoXmlRetornado:Variant);
      class procedure AplicaRegraSemCondicao(Regra:TRegra;IndiceMestreSped,IndiceDetalheDetalheSped_Xml:Integer;ValorCampoXmlRetornado:Variant);
      class function ValidaInformacoesRegraAntesDeAplicarRegra(Regra:TRegra;IndiceTabelaMestreSped:Variant;ObjetoListaXmlSpedFiscal:TRetornoTamanhoLista):boolean;
      class function VerificaExistenciaNfeNoSpedFiscal(IndiceTabelaMestreSped:Variant):boolean;
      class function VerificaQuantidadeItensNfeXml_x_NfeSpedFiscal(ObjetoListaXmlSpedFiscal:TRetornoTamanhoLista):boolean;
      class function VerificaTipoEmpresaAplicadaARegra(Regra:TRegra):boolean;

      class procedure CruzaDadosNfeXml_x_NfeSpedFiscal(Regra:TRegra;OpenDialogXml:TOpenDialog);
  end;


implementation

{ TRegrasController }

{$Region 'Infra'}

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

class procedure TRegrasController.LimpaCdsAdvertencias;
begin
  try
    DataModuleRegras.CdsRelErrosAdvertencias.EmptyDataSet;
  except on E:Exception do
    Showmessage('Erro ao limpar Painel de advertências! '+E.Message);
  end;
end;

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

{$EndRegion 'Infra'}

{$Region 'Funçoes de Verificação Padronizadas'}

class function TRegrasController.GetValorPesquisaParaEncontrarIndice(Tabela: String): String;
begin
  // Percorre Arquivo sped para verificar se o arquivo xml se encontra no sped. Caso seja encontrado retorna em qual indice ele está
  Result:='';
  if (Tabela = 'C100') or (Tabela = 'C170')  then
  begin
    Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.procNFe.chNFe;
  end;
end;

class function TRegrasController.VerificaQuantidadeItensXmltoSped(TagXml,TabelaSped: String;
IndiceTabelaMestreSpedFiscal:Integer): TRetornoTamanhoLista;
begin
  // Cruza informações entre sped e arquivo xml para verificar se existe a mesma quantidade de itens entre o sped e os arquivos xml
  Result.QuantidadeItensEntreListasIguais:=True;

  if TagXmlVinculadaaUmaLista(TagXml) then
  Result.QuatidadeListaXml:= GetQuantidadeItensListaXml(TagXml)
  else
  Result.QuatidadeListaXml:=1;

  if TabelaSpedVinculadaaUmaLista(TabelaSped) then
  Result.QuantidadeListaSped:=GetQuantidadeItensListaSped(TabelaSped,IndiceTabelaMestreSpedFiscal)
  else
  Result.QuantidadeListaSped:=1;

  if Result.QuatidadeListaXml <> Result.QuantidadeListaSped then
  begin
    RegistraErrosAdvertencias(DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Ide.nNF.ToString,
    DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.procNFe.chNFe,'','','','Quantidade de Itens diferentes entre xml e sped');
    Result.QuantidadeItensEntreListasIguais:=false;
  end
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

class function TRegrasController.TagXmlVinculadaaUmaLista(TagXml:String):boolean;
begin
    //Verifica se a tag xml passada como parametro é uma lista ou um um item unico
  Result:=False;
  for TagXml in TagXmlListasNivel2 do
  Exit(true);
end;

class function TRegrasController.TabelaSpedVinculadaaUmaLista(TabelaSped:String):boolean;
begin
  //Verifica se a tabela sped passada como parametro é uma lista ou um um item unico
  Result:=False;
  for TabelaSped in TabelaSpedItens do
  Exit(true);
end;

class function TRegrasController.GetQuantidadeItensListaXml(TagXml:String):Integer;
begin
  // Esta função Retorna a quantidade de itens na lista que o sistema deve percorrer conforme a tag xml passada como parametro
  Result:=0;
  for TagXml in TagXmlListasNivel2 do
  Exit(DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det.Count);
end;

class function TRegrasController.GetQuantidadeItensListaSped(TabelaSped:String;IndiceTabelaMestreSpedFiscal:Integer):Integer;
begin
  // Esta função Retorna a quantidade de itens na lista que o sistema deve percorrer conforme a Tabela sped passada como parametro
  Result:=0;
  for TabelaSped in TabelaSpedItens do
  Exit(DataModuleRegras.AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[IndiceTabelaMestreSpedFiscal].RegistroC170.Count);
end;


{$EndRegion 'Funçoes de Verificação Padronizadas' }




{$Region 'Funções para retornar valores de arquivos magneticos'}

class function TRegrasController.GetValorFieldSped(pTabela, pCampo: String;IndicePai,IndiceFilho:Integer): Variant;
var
  Contexto: TRttiContext;
  TipoTag: TRttiType;
  PropriedadeTag: TRttiProperty;
  NomeTipo: String;
  i: Integer;
  Objeto:TObject;
begin
  try
    Contexto := TRttiContext.Create;
    Objeto:=GetObjetoSped(pTabela,IndicePai,IndiceFilho);
    TipoTag:= Contexto.GetType(Objeto.ClassInfo);
    PropriedadeTag := TipoTag.GetProperty(pCampo);
    NomeTipo := LowerCase(PropriedadeTag.PropertyType.Name);

    if NomeTipo = 'tdatetime' then
    begin
      Result:=QuotedStr(FormatDateTime('dd/mm/yyyy hh:mm:ss',PropriedadeTag.GetValue(Objeto).AsExtended));
    end
    else
    begin
      case   PropriedadeTag.PropertyType.TypeKind of // Retorna o valor do campo passado como parametro
      tkString:Result:=PropriedadeTag.GetValue(Objeto).AsString;
      tkUString:Result:=PropriedadeTag.GetValue(Objeto).AsString;
      tkFloat:Result:=PropriedadeTag.GetValue(Objeto).AsExtended;
      tkInteger:Result:=PropriedadeTag.GetValue(Objeto).AsInteger;
      tkEnumeration:Result:=PropriedadeTag.GetValue(Objeto).AsVariant;
      tkVariant:Result:=PropriedadeTag.GetValue(Objeto).AsVariant;
      end;
    end;

  finally
    Contexto.Free;
    //Objeto.Free;;
  end;

end;

class function TRegrasController.GetObjetoSped(TabelaSped:String;IndicePai,IndiceFilho:Integer):TObject;
begin
  case AnsiIndexStr(TabelaSped,['C100','C170']) of
  0:Result:= DataModuleRegras.AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[IndicePai];
  1:Result:= DataModuleRegras.AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[IndicePai].RegistroC170.Items[IndiceFilho];
  end;
end;

class function TRegrasController.GetValorFieldXml(pTag, pNomeField: String;IndiceFilho:Integer): Variant;
var
  Contexto: TRttiContext;
  TipoTag: TRttiType;
  PropriedadeTag: TRttiProperty;
  NomeTipo: String;
  Objeto:TObject;
begin

  try
    Contexto := TRttiContext.Create;
    Objeto:= GetObjetoXml(pTag,IndiceFilho); //Intancia o objeto do componente acbrnfe conforme tag passada como parametro
    TipoTag:= Contexto.GetType(Objeto.ClassInfo); //Instancia o tipo de objeto
    PropriedadeTag := TipoTag.GetProperty(pNomeField);//Instancia a propriedade/campo passado como parametro
    NomeTipo := LowerCase(PropriedadeTag.PropertyType.Name);//Retorna o nome do tipo da variavel. Exempos:String,integer etc.

    if NomeTipo = 'tdatetime' then  // caso o tipo do campo seja data o sistema precisa realizar uma conversão
    begin
      Result:=QuotedStr(FormatDateTime('dd/mm/yyyy hh:mm:ss',PropriedadeTag.GetValue(Objeto).AsExtended));
    end
    else
    begin
      case   PropriedadeTag.PropertyType.TypeKind of // Retorna o valor do campo passado como parametro
      tkString:Result:=PropriedadeTag.GetValue(Objeto).AsString;
      tkUString:Result:=PropriedadeTag.GetValue(Objeto).AsString;
      tkFloat:Result:=PropriedadeTag.GetValue(Objeto).AsExtended;
      tkInteger:Result:=PropriedadeTag.GetValue(Objeto).AsInteger;
      tkEnumeration:Result:=PropriedadeTag.GetValue(Objeto).AsVariant;
      tkVariant:Result:=PropriedadeTag.GetValue(Objeto).AsVariant;
      end;
    end;
  finally
    Contexto.Free;
    //Objeto.Free;;
  end;
end;

class function TRegrasController.GetObjetoXml(TagXml:String;IndiceFilho:Integer):TObject;
begin
  case AnsiIndexStr(TagXml,['Ide','Emit','ICMSTot','prod','ICMSSN101']) of
  0:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Ide;
  1:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Emit;
  2:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Total.ICMSTot;
  3:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det.Items[IndiceFilho].Prod;
  4:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det.Items[IndiceFilho].Imposto.ICMS;
  end;
end;




{$EndRegion 'Funções para retornar valores de arquivos magneticos'}



{$Region 'Funções para cruzar dados xml x sped fiscal'}


class function TRegrasController.ValidaInformacoesRegraAntesDeAplicarRegra(Regra:TRegra;IndiceTabelaMestreSped:Variant;ObjetoListaXmlSpedFiscal:TRetornoTamanhoLista):boolean;
begin

  if not VerificaExistenciaNfeNoSpedFiscal(IndiceTabelaMestreSped) then
  Exit(False);
  if not VerificaQuantidadeItensNfeXml_x_NfeSpedFiscal(ObjetoListaXmlSpedFiscal) then
  Exit(False);
  if not VerificaTipoEmpresaAplicadaARegra(Regra) then
  Exit(False);
  Exit(True);
end;


class function TRegrasController.VerificaExistenciaNfeNoSpedFiscal(IndiceTabelaMestreSped:Variant):boolean;
begin
  //Registra advertências caso nota fiscal não seja encontrada
  if IndiceTabelaMestreSped = false then
  begin
    TRegrasController.RegistraErrosAdvertencias(DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Ide.nNF.ToString,
    DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.procNFe.chNFe,'','','','Nota Fiscal não encontrada em arquivo Sped Fiscal');
    Exit(False);
  end
  else
  Exit(true);
end;

class function TRegrasController.VerificaQuantidadeItensNfeXml_x_NfeSpedFiscal(ObjetoListaXmlSpedFiscal:TRetornoTamanhoLista):boolean;
begin
   // Verifica se a quantidade de itens lançados no xml é igual do sped
   if ObjetoListaXmlSpedFiscal.QuantidadeItensEntreListasIguais then
   Exit(True)
   else
   Exit(False);

end;

class function TRegrasController.VerificaTipoEmpresaAplicadaARegra(Regra:TRegra):boolean;
begin
   if (Regra.Crt = '0') or (Regra.Crt =  CRTToStr(DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Emit.CRT) ) then
   Exit(True)
   else
   Exit(False);
end;



class procedure TRegrasController.CruzaDadosNfeXml_x_NfeSpedFiscal(Regra:TRegra;OpenDialogXml:TOpenDialog);
var IndiceArqXml,IndiceQuantItens:Integer;
ObjetoListaXmlSpedFiscal:TRetornoTamanhoLista;
IndiceTabelaMestreSped:Variant;
begin
  for IndiceArqXml := 0 to OpenDialogXml.Files.Count-1 do
  begin
    //Carrega Arquivo Xml
    TRegrasController.CarregaArquivoXml(OpenDialogXml.Files[IndiceArqXml]);

    // Retorna o Registro Sped que se refere a nota fiscal xml carregada acima
    IndiceTabelaMestreSped:=TRegrasController.GetIndiceTabelaSped(Regra.TabelaSped,
    TRegrasController.GetValorPesquisaParaEncontrarIndice(Regra.TabelaSped));

    // Se Existe a nota fiscal carregada no arquivo sped então continua fazendo validação dos dados
    if IndiceTabelaMestreSped <> false then
    begin

      // Retorna um objeto Com dados que identificam se a quantiade de itens na nota fiscal sped é igual a quantidade de itens do xml
      ObjetoListaXmlSpedFiscal:=TRegrasController.VerificaQuantidadeItensXmltoSped(Regra.TagXml,Regra.TabelaSped,IndiceTabelaMestreSped);

      //Faz validação dos dados antes de cruzar as informações
      if ValidaInformacoesRegraAntesDeAplicarRegra(Regra,IndiceTabelaMestreSped,ObjetoListaXmlSpedFiscal) then
      begin
        for IndiceQuantItens := 0 to ObjetoListaXmlSpedFiscal.QuatidadeListaXml-1 do
        TRegrasController.VerificaDivergencias_Xml_X_Sped(Regra,IndiceTabelaMestreSped,IndiceQuantItens);
      end;
    end;

  end;
end;


class procedure TRegrasController.VerificaDivergencias_Xml_X_Sped(Regra:TRegra;IndiceMestreSped,IndiceDetalheDetalheSped_Xml:Integer);
var ValorCampoXmlRetornado:Variant;
begin
  ValorCampoXmlRetornado:=GetValorFieldXml(Regra.TagXml,Regra.CampoXml,IndiceDetalheDetalheSped_Xml);
  if Regra.CondicaoCampoXml<>'' then
  AplicaRegraComCondicao(Regra,IndiceMestreSped,IndiceDetalheDetalheSped_Xml,ValorCampoXmlRetornado);
  if Regra.CondicaoCampoXml = '' then
  AplicaRegraSemCondicao(Regra,IndiceMestreSped,IndiceDetalheDetalheSped_Xml,ValorCampoXmlRetornado);
end;


class procedure TRegrasController.AplicaRegraComCondicao(Regra:TRegra;IndiceMestreSped,IndiceDetalheDetalheSped_Xml:Integer;ValorCampoXmlRetornado:Variant);
var ValorCampoSpedRetornado:Variant;
begin
  if VarToStr(ValorCampoXmlRetornado) = Regra.CondicaoCampoXml then
  begin
    ValorCampoSpedRetornado:=GetValorFieldSped(Regra.TabelaSped,Regra.CampoSped,IndiceMestreSped,IndiceDetalheDetalheSped_Xml);
    if Regra.ValorSperadoSped <> VarToStr(ValorCampoSpedRetornado) then
    RegistraErrosAdvertencias(DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Ide.nNF.ToString,
    DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.procNFe.chNFe,VarToStr(ValorCampoXmlRetornado),
    VarToStr(Regra.ValorSperadoSped),VarToStr(ValorCampoSpedRetornado),Regra.Historico);
  end;
end;


class procedure TRegrasController.AplicaRegraSemCondicao(Regra:TRegra;IndiceMestreSped,IndiceDetalheDetalheSped_Xml:Integer;ValorCampoXmlRetornado:Variant);
var ValorCampoSpedRetornado:Variant;
begin
  ValorCampoSpedRetornado:=GetValorFieldSped(Regra.TabelaSped,Regra.CampoSped,IndiceMestreSped,IndiceDetalheDetalheSped_Xml);
  if ValorCampoXmlRetornado <> ValorCampoSpedRetornado then
  TRegrasController.RegistraErrosAdvertencias(DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Ide.nNF.ToString,
  DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.procNFe.chNFe,VarToStr(ValorCampoXmlRetornado),
  VarToStr(ValorCampoXmlRetornado),VarToStr(ValorCampoSpedRetornado),Regra.Historico);
end;

{$EndRegion 'Funções para cruzar dados xml x sped fiscal'}





end.
