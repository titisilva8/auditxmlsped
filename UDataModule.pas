unit UDataModule;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient, ACBrDFe, ACBrNFe,
  ACBrEFDImportar, ACBrBase, ACBrSpedFiscal, Vcl.Dialogs;

type
  TDataModuleRegras = class(TDataModule)
    DSRelErrosAdvertencias: TDataSource;
    CdsRelErrosAdvertencias: TClientDataSet;
    CdsRelErrosAdvertenciasNUMERO_DOCUMENTO: TStringField;
    CdsRelErrosAdvertenciasCHAVE_ACESSO: TStringField;
    CdsRelErrosAdvertenciasHISTORICO: TStringField;
    CdsRelErrosAdvertenciasIDENTIFICADOR_ERRO_ADVERTENCIA: TStringField;
    CdsRelErrosAdvertenciasRESULTADO_XML: TStringField;
    CdsRelErrosAdvertenciasRESULTADO_ESPERADO_SPED: TStringField;
    CdsRelErrosAdvertenciasRESULTADO_SPED: TStringField;
    ACBrSPEDFiscal1: TACBrSPEDFiscal;
    ACBrSpedFiscal: TACBrSpedFiscalImportar;
    ACBrNFe: TACBrNFe;
    CdsTabelaSped: TClientDataSet;
    DsTabelaSped: TDataSource;
    CdsTabelaSpedTABELA_SPED: TStringField;
    CdsTabelaSpedNIVEL: TIntegerField;
    CdsTagXml: TClientDataSet;
    DsTagXml: TDataSource;
    CdsTagXmlTAGXML: TStringField;
    CdsTagXmlNIVEL: TIntegerField;
    CdsRelErrosAdvertenciasITEM: TStringField;
    CdsRelErrosAdvertenciasDATA_EMISSAO: TDateField;
    CdsRelErrosAdvertenciasDATA_ENTRADA: TDateField;
    CdsRelErrosAdvertenciasTIPO_ENTRADA_SAIDA: TStringField;
    CdsRelErrosAdvertenciasFORNECEDOR_CLIENTE: TStringField;
    OpenDialogSped: TOpenDialog;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModuleRegras: TDataModuleRegras;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
