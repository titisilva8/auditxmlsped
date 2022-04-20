unit URegrasController;
interface

uses  System.StrUtils,UDataModule,ACBrDFe, ACBrNFe, Data.DB,ACBrNFeNotasFiscais,
Datasnap.DBClient, pcnConversao,Vcl.Dialogs,Winapi.Messages,System.SysUtils,Rtti,System.Variants,URegra,
ACBrEFDImportar,pcnNFe,AcbrSpedFiscal,ACBrSpedReg,ACBrEFDBloco_C,ACBrEFDBlocos;

 type TRetornoTamanhoLista = Record
    QuantidadeItensEntreListasIguais:boolean;
    QuatidadeListaXml:Integer;
    QuantidadeListaSped:Integer;
  End;

  Type TRegrasController = class
    private
    public

      // tags que apresentam apenas um registros no xml
      const TagXmlNivel1:array[1..23] of string = ('ide','emit','enderEmit','avulsa','dest','enderDest',
      'retirada','entrega','ICMSTot','ISSQNtot','retTrib','transp','transporta','retTransp','veicTransp',
      'fat','infAdic','obsCont','obsFisco','procRef','exporta','compra','cana');
      // tags que apresentam registros de listas no xml Nivel 1 (Mestre-Detalhe)
      const TagXmlListasNivel2 :array[1..22] of string = ('prod','DI','veicProd','med','arma','comb','CIDE',//7
      'ICMS' ,//8
      'ICMSUFDest', // 9
      'IPI',//10
      'II',//11
      'PIS','PISST',//13
      'COFINS','COFINSST',//15
      'ISSQN','NFref','reboque','vol','dup','forDia','deduc'); //22}

      // tags que apresentam registros de listas Nivel 2 (mestre detalhe dentro de outro mestre detalhe)
      const TagXmlListasNivel3:array[1..2] of string  = ('adi','lacres');
      //Tabelas sped que possibilitam cruzamento de dados
      const TabelasSped :array[1..4] of string =('C100','C170','C100|0150','C170|0200');
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


      {$Region 'Function e procedures Xml'}
      class procedure PreencheCdsTagXml;
      class function LoadArquivoXml(PathArquivoXml:String):boolean;
      class function GetValorListaXml(pNomeField:String;ValorCampo:Variant):Variant;
      class function GetObjetoXml(TagXml:String;IndiceFilho:Integer):TObject;
      class procedure VerificaCarregamentoArquivosXml(ListaArquivos:TOpenDialog);
      class function VerificaGrupoTagPertencente(TagXml:String):String;
      class function GetValorPesquisaParaEncontrarIndice(Tabela:String):String;
      class function TagXmlVinculadaaUmaLista(TagXml:String):boolean;
      class function GetQuantidadeItensListaXml(TagXml:String):Integer;
      class function GetValorFieldXml(pTag, pNomeField: String;IndiceFilho:Integer): Variant;
      {$EndRegion}

      {$Region 'Function e procedures Sped'}
      class procedure PreencheCdsTabelasSped;
      class function GetIndiceTabelaSped(Tabela,Pesquisa:String):Variant;
      class function LoadSpedFiscal(Path:String):boolean;
      class function GetObjetoSped(TabelaSped:String;IndicePai,IndiceFilho:Integer):TObject;
      class function GetItemSpedVinculadoRegistroC170(CodigoItem:String):TObject;
      class function GetParticipanteSpedVinculadoRegistroC100(CodigoParticipante:String):TObject;
      class function GetValorFieldSped(pTabela, pCampo: String;IndicePai,IndiceFilho:Integer): Variant;
      class function VerificaExistenciaNfeNoSpedFiscal(IndiceTabelaMestreSped:Variant):boolean;
      class function TabelaSpedVinculadaaUmaLista(TabelaSped:String):boolean;
      class function GetQuantidadeItensListaSped(TabelaSped:String;IndiceTabelaMestreSpedFiscal:Integer):Integer;
      {$EndRegion}

      {$Region 'Function e procedures Infra'}
      class function VerificaTipoEmpresaAplicadaARegra(Regra:TRegra):boolean;
      class function SetIndicadorOperacao(IndOper:TACBrIndOper):String;

      {$EndRegion}

      {$Region 'Function e procedures Relatorio'}
      class procedure RegistraErrosAdvertencias(Nfe:TNfe;SpedFiscal:TAcbrSpedFiscal;IndiceNotaFiscal:Integer;
      IndiceItem,ResultadoXml,ResultadoEsperadoSped,ResultadoSped,Historico:String;AdvertenciaPadrao:boolean);


      class procedure RegistraErrosAdvertenciasRegra(Nfe:TNfe;SpedFiscal:TAcbrSpedFiscal;IndiceNotaFiscal:Integer;
      IndiceItem,ResultadoXml,ResultadoSped: String;AdvertenciaPadrao:boolean;Regra:TRegra);


      class procedure LimpaCdsAdvertencias;
      {$EndRegion}

      {$Region 'Function e procedures de Cruzamento de Dados'}
      class function VerificaQuantidadeItensXmltoSped(TagXml,TabelaSped: String;IndiceTabelaMestreSpedFiscal:Integer):TRetornoTamanhoLista;
      class function VerificaQuantidadeItensNfeXml_x_NfeSpedFiscal(ObjetoListaXmlSpedFiscal:TRetornoTamanhoLista):boolean;
      class procedure VerificaDivergencias_Xml_X_Sped(Regra:TRegra;IndiceMestreSped,IndiceDetalheDetalheSped_Xml:Integer);
      class procedure AplicaRegraComCondicao(Regra:TRegra;IndiceMestreSped,IndiceDetalheDetalheSped_Xml:Integer;ValorCampoXmlRetornado:Variant);
      class procedure AplicaRegraSemCondicao(Regra:TRegra;IndiceMestreSped,IndiceDetalheDetalheSped_Xml:Integer;ValorCampoXmlRetornado:Variant);
      class function ValidaInformacoesRegraAntesDeAplicarRegra(Regra:TRegra;IndiceTabelaMestreSped:Variant;ObjetoListaXmlSpedFiscal:TRetornoTamanhoLista):boolean;
      class function AvaliaCondicaoRegra(ValorRetornado,ValorCondicao:Variant;IdentificadorCondicao:String):boolean;
      class procedure CruzaDadosNfeXml_x_NfeSpedFiscal(Regra:TRegra;OpenDialogXml:TOpenDialog);
      {$EndRegion}
  end;


implementation
{ TRegrasController }

{$Region 'Function e procedures Xml'}

class procedure TRegrasController.VerificaCarregamentoArquivosXml(ListaArquivos:TOpenDialog);
begin
  if ListaArquivos.Files.Count = 0 then
  begin
    Showmessage('Não foi carregado nenhum arquivo xml para ser auditado!');
    Abort;
  end;
end;

class procedure TRegrasController.PreencheCdsTagXml;
var I: Integer;
begin
  DataModuleRegras.CdsTagXml.CreateDataSet;
  for I := 1 to length(TagXmlNivel1) do
  begin
    DataModuleRegras.CdsTagXml.Append;
    DataModuleRegras.CdsTagXml.Fieldbyname('TAGXML').AsString:=TagXmlNivel1[I];
    DataModuleRegras.CdsTagXml.Post;
  end;

  for I := 1 to length(TagXmlListasNivel2) do
  begin
    DataModuleRegras.CdsTagXml.Append;
    DataModuleRegras.CdsTagXml.Fieldbyname('TAGXML').AsString:=TagXmlListasNivel2[I];
    DataModuleRegras.CdsTagXml.Post;
  end;

  for I := 1 to length(TagXmlListasNivel3) do
  begin
    DataModuleRegras.CdsTagXml.Append;
    DataModuleRegras.CdsTagXml.Fieldbyname('TAGXML').AsString:=TagXmlListasNivel3[I];
    DataModuleRegras.CdsTagXml.Post;
  end;
end;

class function TRegrasController.LoadArquivoXml(PathArquivoXml: String): boolean;
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

class function TRegrasController.GetValorPesquisaParaEncontrarIndice(Tabela: String): String;
begin
  // Percorre Arquivo sped para verificar se o arquivo xml se encontra no sped. Caso seja encontrado retorna em qual indice ele está
  Result:='';
  //if (Tabela = 'C100') or (Tabela = 'C170') or (Tabela = 'C100|0150') or (Tabela = 'C170|0200')   then
  for Tabela in TabelasSped do
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
    RegistraErrosAdvertencias(DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe,
    DataModuleRegras.ACBrSpedFiscal1,IndiceTabelaMestreSpedFiscal,'','','','','Quantidade de Itens diferentes entre xml e sped',true);
    Result.QuantidadeItensEntreListasIguais:=false;
  end
end;

class function TRegrasController.TagXmlVinculadaaUmaLista(TagXml:String):boolean;
begin
    //Verifica se a tag xml passada como parametro é uma lista ou um um item unico
  Result:=False;
  for TagXml in TagXmlListasNivel2 do
  Exit(true);
end;

class function TRegrasController.GetQuantidadeItensListaXml(TagXml:String):Integer;
begin
  // Esta função Retorna a quantidade de itens na lista que o sistema deve percorrer conforme a tag xml passada como parametro
  Result:=0;
  for TagXml in TagXmlListasNivel2 do
  Exit(DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det.Count);
end;

class function TRegrasController.GetValorFieldXml(pTag, pNomeField: String;IndiceFilho:Integer): Variant;
var
  Contexto: TRttiContext;
  TipoTag: TRttiType;
  PropriedadeTag: TRttiProperty;
  NomeTipo: String;
  Objeto:TObject;
  teste:variant;
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

      tkEnumeration:
      begin
        Result:=GetValorListaXml(pNomeField,PropriedadeTag.GetValue(Objeto).AsVariant);//TODO ESTA CONVERSAO ESTA COM PROBLEMA
        //Teste:=GetValorListaXml(pNomeField,PropriedadeTag.GetValue(Objeto).AsVariant);
      end;
      tkVariant:Result:=PropriedadeTag.GetValue(Objeto).AsVariant;
      end;
    end;
  finally
    Contexto.Free;
    //Objeto.Free;;
  end;
end;

class function TRegrasController.VerificaGrupoTagPertencente(TagXml:String):String;
var str:String;
begin
 for Str in  TagXmlListasNivel2 do
  begin
    if str = TagXml then
    begin
      Result:='TagXmlListasNivel2';
      Exit;
    end;
  end;

  for Str in  TagXmlNivel1 do
  begin
    if str = TagXml then
    begin
      Result:='TagXmlNivel1';
      Exit;
    end;
  end;

  for Str in  TagXmlListasNivel3 do
  begin
    if str = TagXml then
    begin
      Result:='TagXmlListasNivel3';
      Exit;
    end;
  end;
  Result:='';
end;

class function TRegrasController.GetObjetoXml(TagXml:String;IndiceFilho:Integer):TObject;
var GrupoTag:String;
begin
  GrupoTag:=VerificaGrupoTagPertencente(TagXml);
  if GrupoTag= 'TagXmlNivel1' then
  begin
    //case AnsiIndexStr(TagXml,['Ide','Emit','ICMSTot','prod','ICMSSN101','ICMS60']) of
    case AnsiIndexStr(TagXml,TagXmlNivel1) of
      0:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Ide;
      1:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Emit;
      2:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Emit.EnderEmit;
      3:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Avulsa;
      4:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Dest;
      5:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Dest.EnderDest;

      6:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Retirada;
      7:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Entrega;
      8:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Total.ICMSTot;
      9:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Total.ISSQNtot;
      10:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Total.retTrib;
      11:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Transp;
      12:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Transp.Transporta;
      13:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Transp.retTransp;
      14:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Transp.veicTransp;

      15:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Cobr.Fat;
      16:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.InfAdic;
      //17:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.InfAdic.obsCont.;
      //18:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.InfAdic.obsFisco
      //19:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.procRef;
      20:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.exporta;
      21:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.compra;
      22:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.cana;
    end;
    Exit;
  end;

  if GrupoTag= 'TagXmlListasNivel2' then
  begin
    case AnsiIndexStr(TagXml,TagXmlListasNivel2) of
      0:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det.Items[IndiceFilho].Prod;
      1:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det.Items[IndiceFilho].Prod.DI;
      2:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det.Items[IndiceFilho].Prod.veicProd;
      3:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det.Items[IndiceFilho].Prod.med.Items[0];
      4:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det.Items[IndiceFilho].Prod.arma.Items[0];
      5:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det.Items[IndiceFilho].Prod.comb;
      6:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det.Items[IndiceFilho].Prod.comb.CIDE;

      7:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det.Items[IndiceFilho].Imposto.ICMS;

      8:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det.Items[IndiceFilho].Imposto.ICMSUFDest;

      9:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det.Items[IndiceFilho].Imposto.IPI;
      10:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det.Items[IndiceFilho].Imposto.II;

      11:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det.Items[IndiceFilho].Imposto.PIS;
      12:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det.Items[IndiceFilho].Imposto.PISST;

      13:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det.Items[IndiceFilho].Imposto.COFINS;
      14:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det.Items[IndiceFilho].Imposto.COFINSST;

      15:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det.Items[IndiceFilho].Imposto.ISSQN;
      16:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Ide.NFref.Items[IndiceFilho];
      17:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Transp.Reboque.Items[IndiceFilho];
      18:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Transp.Vol.Items[IndiceFilho];
      19:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Cobr.Dup.Items[IndiceFilho];
      20:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.cana.fordia.Items[IndiceFilho];
      21:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.cana.deduc.Items[IndiceFilho];
    end;
    Exit;
  end;

  if GrupoTag= 'TagXmlListasNivel3' then
  begin
    case AnsiIndexStr(TagXml,TagXmlListasNivel3) of
      0:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det.Items[IndiceFilho].Prod.DI.Items[0];//todo: passar parametros no lugara de zero no final
      1:Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Transp.Vol.Items[IndiceFilho].Lacres.Items[0];//todo: passar parametros no lugara de zero no final
    end;
    Exit;
  end;
  //Result:='';
end;

class function  TRegrasController.GetValorListaXml(pNomeField:String;ValorCampo:Variant):Variant;
//var teste:variant;
begin
  case AnsiIndexStr(pNomeField,['CST','orig','CSOSN']) of //TODO: Colocar o restante das conversões abaixo
  0:Result:=pcnconversao.CSTICMSToStr(ValorCampo);
  1:Result:=pcnconversao.OrigToStr(ValorCampo);
  2:Result:=pcnconversao.CSOSNIcmsToStr(ValorCampo)
  else
  Result:='';
  end;
  //teste:= pcnconversao.CSTICMSToStr(DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det[0].Imposto.ICMS.CST);
  //teste:= pcnconversao.CSTICMSToStr(DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Det[0].Imposto.ICMS.CST);
end;

{$EndRegion}

{$Region 'Function e procedures Sped'}

class procedure TRegrasController.PreencheCdsTabelasSped;
var I: Integer;
begin
  DataModuleRegras.CdsTabelaSped.CreateDataSet;
  for I := 1 to length(TabelasSped) do
  begin
    DataModuleRegras.CdsTabelaSped.Append;
    DataModuleRegras.CdsTabelaSped.Fieldbyname('TABELA_SPED').AsString:=TabelasSped[I];
    DataModuleRegras.CdsTabelaSped.Post;
  end;
end;

class function TRegrasController.LoadSpedFiscal(Path:String): boolean;
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

class function TRegrasController.GetIndiceTabelaSped(Tabela,Pesquisa: String): Variant;
var i:Integer;
begin
  Result:=false;
  //if (Tabela = 'C100') or (Tabela = 'C170') or (Tabela = 'C100|0150') or (Tabela = 'C170|0200')  then
  for Tabela in TabelasSped do
  begin
    for i := 0 to DataModuleRegras.AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Count-1 do
    if DataModuleRegras.AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[I].CHV_NFE = Pesquisa then
    Exit(i);
  end;
end;

class function TRegrasController.TabelaSpedVinculadaaUmaLista(TabelaSped:String):boolean;
begin
  //Verifica se a tabela sped passada como parametro é uma lista ou um um item unico
  Result:=False;
  for TabelaSped in TabelasSped do
  Exit(true);
end;

class function TRegrasController.GetQuantidadeItensListaSped(TabelaSped:String;IndiceTabelaMestreSpedFiscal:Integer):Integer;
begin
  // Esta função Retorna a quantidade de itens na lista que o sistema deve percorrer conforme a Tabela sped passada como parametro
  Result:=0;
  for TabelaSped in TabelasSped do
  Exit(DataModuleRegras.AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[IndiceTabelaMestreSpedFiscal].RegistroC170.Count);
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
  //case AnsiIndexStr(TabelaSped,['C100','C170','C100|0150','C170|0200']) of
  case AnsiIndexStr(TabelaSped,TabelasSped) of
  0:Result:= DataModuleRegras.AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[IndicePai];
  1:Result:= DataModuleRegras.AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[IndicePai].RegistroC170.Items[IndiceFilho];
  2:Result:= GetParticipanteSpedVinculadoRegistroC100(DataModuleRegras.AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[IndicePai].COD_PART);
  3:Result:= GetItemSpedVinculadoRegistroC170(DataModuleRegras.AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[IndicePai].RegistroC170.Items[IndiceFilho].COD_ITEM);
  end;
end;

class function TRegrasController.GetItemSpedVinculadoRegistroC170(CodigoItem:String):TObject;
var I:Integer;
begin
  for I := 0 to DataModuleRegras.AcbrSpedFiscal1.Bloco_0.Registro0001.Registro0200.Count-1 do
  begin
    if DataModuleRegras.AcbrSpedFiscal1.Bloco_0.Registro0001.Registro0200.Items[i].COD_ITEM = CodigoItem then
    begin
      Result:= DataModuleRegras.AcbrSpedFiscal1.Bloco_0.Registro0001.Registro0200.Items[i];
      Exit;
    end;
  end;
end;

class function TRegrasController.GetParticipanteSpedVinculadoRegistroC100(CodigoParticipante:String):TObject;
var I:Integer;
begin
  for I := 0 to DataModuleRegras.AcbrSpedFiscal1.Bloco_0.Registro0001.Registro0150.Count-1 do
  begin
    if DataModuleRegras.AcbrSpedFiscal1.Bloco_0.Registro0001.Registro0150.Items[i].COD_PART = CodigoParticipante then
    begin
      Result:= DataModuleRegras.AcbrSpedFiscal1.Bloco_0.Registro0001.Registro0150.Items[i];
      Exit;
    end;
  end;
end;

class function TRegrasController.VerificaExistenciaNfeNoSpedFiscal(IndiceTabelaMestreSped:Variant):boolean;
begin
  //Registra advertências caso nota fiscal não seja encontrada
  if IndiceTabelaMestreSped = false then
  begin
    TRegrasController.RegistraErrosAdvertencias(DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe,
    DataModuleRegras.ACBrSpedFiscal1,IndiceTabelaMestreSped,'','','','','Nota Fiscal não encontrada em arquivo Sped Fiscal',true);
    Exit(False);
  end
  else
  Exit(true);
end;

{$EndRegion}

{$Region 'Function e procedures Infra'}

class function TRegrasController.SetIndicadorOperacao(IndOper:TACBrIndOper):String;
begin
  case IndexStr(IndOperToStr(IndOper),['0','1']) of
  0:Result:='Entrada';
  1:Result:='Saída';
  else
  Result:=''
  end;
end;

class function TRegrasController.VerificaTipoEmpresaAplicadaARegra(Regra:TRegra):boolean;
begin
   if (Regra.Crt = '0') or (Regra.Crt =  CRTToStr(DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Emit.CRT) ) then
   Exit(True)
   else
   Exit(False);
end;


{$EndRegion}

{$Region 'Function e procedures Relatorio'}

class procedure TRegrasController.RegistraErrosAdvertenciasRegra(Nfe:TNfe;SpedFiscal:TAcbrSpedFiscal;IndiceNotaFiscal:Integer;
IndiceItem,ResultadoXml,ResultadoSped: String;AdvertenciaPadrao:boolean;Regra:TRegra);
begin
  DataModuleRegras.CdsRelErrosAdvertencias.Append;
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('TIPO_ENTRADA_SAIDA').AsString:=SetIndicadorOperacao(DataModuleRegras.AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[IndiceNotaFiscal].IND_OPER);
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('NUMERO_DOCUMENTO').AsString:=Nfe.Ide.nNF.ToString;
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('CHAVE_ACESSO').AsString:=Nfe.procNFe.chNFe;
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('HISTORICO').AsString:=Regra.Historico;
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('RESULTADO_XML').AsString:=ResultadoXml;
  if Regra.IdentificadorCondicaoSped = 'Sem Condição' then
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('RESULTADO_ESPERADO_SPED').AsString:=ResultadoXml
  else
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('RESULTADO_ESPERADO_SPED').AsString:=Regra.IdentificadorCondicaoSped+' '+ Regra.ValorSperadoSped;

  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('RESULTADO_SPED').AsString:=ResultadoSped;

  if DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('TIPO_ENTRADA_SAIDA').AsString = 'Entrada' then
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('FORNECEDOR_CLIENTE').AsString:=Nfe.Emit.xNome
  else
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('FORNECEDOR_CLIENTE').AsString:=Nfe.Dest.xNome;

  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('DATA_EMISSAO').AsDateTime:=Nfe.Ide.dEmi;

  if AdvertenciaPadrao = false  then
  begin
    DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('DATA_ENTRADA').AsDateTime:=SpedFiscal.Bloco_C.RegistroC001.RegistroC100.Items[IndiceNotaFiscal].DT_E_S;
    DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('ITEM').AsString:=IndiceItem;
    //RegistroC001.RegistroC100.Items[IndiceNotaFiscal]
  end;

  DataModuleRegras.CdsRelErrosAdvertencias.Post;
end;




class procedure TRegrasController.RegistraErrosAdvertencias(Nfe:TNfe;SpedFiscal:TAcbrSpedFiscal;IndiceNotaFiscal:Integer;
IndiceItem,ResultadoXml,ResultadoEsperadoSped,ResultadoSped,Historico: String;AdvertenciaPadrao:boolean);
begin
  DataModuleRegras.CdsRelErrosAdvertencias.Append;
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('TIPO_ENTRADA_SAIDA').AsString:=SetIndicadorOperacao(DataModuleRegras.AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[IndiceNotaFiscal].IND_OPER);
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('NUMERO_DOCUMENTO').AsString:=Nfe.Ide.nNF.ToString;
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('CHAVE_ACESSO').AsString:=Nfe.procNFe.chNFe;
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('HISTORICO').AsString:=Historico;
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('RESULTADO_XML').AsString:=ResultadoXml;
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('RESULTADO_ESPERADO_SPED').AsString:=ResultadoEsperadoSped;
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('RESULTADO_SPED').AsString:=ResultadoSped;

  if DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('TIPO_ENTRADA_SAIDA').AsString = 'Entrada' then
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('FORNECEDOR_CLIENTE').AsString:=Nfe.Emit.xNome
  else
  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('FORNECEDOR_CLIENTE').AsString:=Nfe.Dest.xNome;

  DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('DATA_EMISSAO').AsDateTime:=Nfe.Ide.dEmi;

  if AdvertenciaPadrao = false  then
  begin
    DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('DATA_ENTRADA').AsDateTime:=SpedFiscal.Bloco_C.RegistroC001.RegistroC100.Items[IndiceNotaFiscal].DT_E_S;
    DataModuleRegras.CdsRelErrosAdvertencias.FieldByName('ITEM').AsString:=IndiceItem;

    //RegistroC001.RegistroC100.Items[IndiceNotaFiscal]
  end;


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

{$EndRegion}

{$Region 'Function e procedures de Cruzamento de Dados'}

class function TRegrasController.AvaliaCondicaoRegra(ValorRetornado,ValorCondicao:Variant;IdentificadorCondicao:String):boolean;
begin
  Result:=False;
  case AnsiIndexStr(IdentificadorCondicao,['Igual a','Diferente de','Menor que','Maior que','Maior ou Igual a','Menor ou igual a']) of
  0:if ValorRetornado = ValorCondicao then Result:=True;
  1:if ValorRetornado <> ValorCondicao then Result:=True;
  2:if ValorRetornado < ValorCondicao then Result:=True;
  3:if ValorRetornado > ValorCondicao then Result:=True;
  4:if ValorRetornado >= ValorCondicao then Result:=True;
  5:if ValorRetornado <= ValorCondicao then Result:=True;
  end;
  //todo:fazer uma função que identifique se o valor retornado é numerico
end;

class procedure TRegrasController.AplicaRegraSemCondicao(Regra:TRegra;IndiceMestreSped,IndiceDetalheDetalheSped_Xml:Integer;ValorCampoXmlRetornado:Variant);
var ValorCampoSpedRetornado:Variant;
begin
  ValorCampoSpedRetornado:=GetValorFieldSped(Regra.TabelaSped,Regra.CampoSped,IndiceMestreSped,IndiceDetalheDetalheSped_Xml);
  if ValorCampoXmlRetornado <> ValorCampoSpedRetornado then

  TRegrasController.RegistraErrosAdvertenciasRegra(DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe,
  DataModuleRegras.ACBrSpedFiscal1,IndiceMestreSped,(IndiceDetalheDetalheSped_Xml+1).ToString,VarToStr(ValorCampoXmlRetornado),
  VarToStr(ValorCampoSpedRetornado),false,Regra);
end;

class function TRegrasController.ValidaInformacoesRegraAntesDeAplicarRegra(Regra:TRegra;IndiceTabelaMestreSped:Variant;ObjetoListaXmlSpedFiscal:TRetornoTamanhoLista):boolean;
begin
  if not VerificaExistenciaNfeNoSpedFiscal(IndiceTabelaMestreSped) then
  Exit(False);
  if not VerificaQuantidadeItensNfeXml_x_NfeSpedFiscal(ObjetoListaXmlSpedFiscal) then
  Exit(False);
  if not (VerificaTipoEmpresaAplicadaARegra(Regra)) then
  Exit(False);
  Exit(True);
end;

class function TRegrasController.VerificaQuantidadeItensNfeXml_x_NfeSpedFiscal(ObjetoListaXmlSpedFiscal:TRetornoTamanhoLista):boolean;
begin
   // Verifica se a quantidade de itens lançados no xml é igual do sped
   if ObjetoListaXmlSpedFiscal.QuantidadeItensEntreListasIguais then
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
    TRegrasController.LoadArquivoXml(OpenDialogXml.Files[IndiceArqXml]);

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
  if (Regra.IdentificadorCondicaoXml = 'Sem Condição') or (Regra.IdentificadorCondicaoXml = '') then
  AplicaRegraSemCondicao(Regra,IndiceMestreSped,IndiceDetalheDetalheSped_Xml,ValorCampoXmlRetornado)
  else
  AplicaRegraComCondicao(Regra,IndiceMestreSped,IndiceDetalheDetalheSped_Xml,ValorCampoXmlRetornado);
end;

class procedure TRegrasController.AplicaRegraComCondicao(Regra:TRegra;IndiceMestreSped,IndiceDetalheDetalheSped_Xml:Integer;ValorCampoXmlRetornado:Variant);
var ValorCampoSpedRetornado:Variant;
begin
  //if VarToStr(ValorCampoXmlRetornado) = Regra.CondicaoCampoXml then
  if AvaliaCondicaoRegra(ValorCampoXmlRetornado,Regra.CondicaoCampoXml,Regra.IdentificadorCondicaoXml) then
  begin
    ValorCampoSpedRetornado:=GetValorFieldSped(Regra.TabelaSped,Regra.CampoSped,IndiceMestreSped,IndiceDetalheDetalheSped_Xml);
    if AvaliaCondicaoRegra(ValorCampoSpedRetornado,Regra.ValorSperadoSped,Regra.IdentificadorCondicaoSped) = false then
    //if Regra.ValorSperadoSped <> VarToStr(ValorCampoSpedRetornado) then
    RegistraErrosAdvertenciasRegra(DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe,
    DataModuleRegras.ACBrSpedFiscal1,IndiceMestreSped,(IndiceDetalheDetalheSped_Xml+1).ToString,VarToStr(ValorCampoXmlRetornado),
    VarToStr(ValorCampoSpedRetornado),false,Regra);
  end;
end;

{$EndRegion}

end.
