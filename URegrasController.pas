unit URegrasController;

interface

uses  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls,
  Vcl.Clipbrd, Vcl.StdCtrls,PDFium.Frame, Vcl.ComCtrls,Vcl.FileCtrl,
  ACBrDFeReport, ACBrDFeDANFeReport,ACBrNFeDANFEClass, ACBrNFeDANFeRLClass,
  ACBrBase, ACBrDFe, ACBrNFe, Data.DB,Vcl.Grids, Vcl.DBGrids, JvExDBGrids,
  JvDBGrid, JvDBUltimGrid,Datasnap.DBClient, Vcl.Buttons,pcnConversao,UDataModule;

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

class function TRegrasController.GetValorPesquisaParaEncontrarIndice(Tabela: String): String;
begin
  Result:='';
  if (Tabela = 'C100') or (Tabela = 'C170')  then
  begin
    Result:= DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.procNFe.chNFe;
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

end.
