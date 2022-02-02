unit UDataModule;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient;

type
  TDataModuleRegras = class(TDataModule)
    DSRelErrosAdvertencias: TDataSource;
    CdsRelErrosAdvertencias: TClientDataSet;
    CdsRelErrosAdvertenciasID: TIntegerField;
    CdsRelErrosAdvertenciasNUMERO_DOCUMENTO: TStringField;
    CdsRelErrosAdvertenciasCHAVE_ACESSO: TStringField;
    CdsRelErrosAdvertenciasHISTORICO: TStringField;
    CdsRelErrosAdvertenciasIDENTIFICADOR_ERRO_ADVERTENCIA: TStringField;
    CdsRelErrosAdvertenciasRESULTADO_XML: TStringField;
    CdsRelErrosAdvertenciasRESULTADO_ESPERADO_SPED: TStringField;
    CdsRelErrosAdvertenciasRESULTADO_SPED: TStringField;
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
