unit URegras;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, LabeledCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Data.DB, Vcl.WinXCtrls, Vcl.Grids, Vcl.DBGrids,
  JvExDBGrids, JvDBGrid, JvDBUltimGrid,Vcl.FileCtrl, ACBrSpedFiscal, ACBrBase,
  ACBrDFe, ACBrNFe, ACBrEFDImportar,System.StrUtils,System.Rtti,pcnProcNFe,pcnNFe,
  UDataModule,Datasnap.DBClient,URegrasController,URegra;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    produtosmercadorias: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    LabeledEdit1: TLabeledEdit;
    LabeledMemo1: TLabeledMemo;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    LabeledComboBox1: TLabeledComboBox;
    JvDBUltimGrid1: TJvDBUltimGrid;
    JvDBUltimGrid2: TJvDBUltimGrid;
    JvDBUltimGrid3: TJvDBUltimGrid;
    JvDBUltimGrid4: TJvDBUltimGrid;
    JvDBUltimGrid5: TJvDBUltimGrid;
    LabeledComboBox2: TLabeledComboBox;
    EditTagXml1: TLabeledEdit;
    EditValorTagXml: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabeledComboBox3: TLabeledComboBox;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    EditCampoXml1: TLabeledEdit;
    LabeledEdit8: TLabeledEdit;
    EdtiTabelaSped: TTabSheet;
    OpenDialog1: TOpenDialog;
    EditPathSpedFiscal: TSearchBox;
    Label1: TLabel;
    Label2: TLabel;
    SearchBox2: TSearchBox;
    OpenDialog2: TOpenDialog;
    Button1: TButton;
    EditCampoXml: TLabeledEdit;
    EditTagXml: TLabeledEdit;
    EditTabelaSped: TLabeledEdit;
    EditCampoSped: TLabeledEdit;
    Button2: TButton;
    EditHistorico: TLabeledEdit;
    LabeledComboBox4: TLabeledComboBox;
    EditValorEsperadoSped: TLabeledEdit;
    EditValorXml: TLabeledEdit;
    LabeledComboBox5: TLabeledComboBox;
    Button3: TButton;
    DBGrid1: TDBGrid;
    procedure SearchBox2InvokeSearch(Sender: TObject);
    procedure EditPathSpedFiscalInvokeSearch(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    var OpenDialog:TOpenDialog;
    var NomeClasseController: String;
    procedure PathClick(Sender: TObject);
    procedure ExecutarMetodo(pNomeClasseController, pNomeMetodo: String; pParametros:array of TValue; pMetodoRest: String; pTipoRetorno: String);
    var RegraValidacao:TRegra;
    procedure SetRegraValidacao;
  end;

var
  Form1: TForm1;

implementation


Const
SELDIRHELP = 1000;

{$R *.dfm}

procedure TForm1.SetRegraValidacao;
begin
  RegraValidacao:=TRegra.Create;
  RegraValidacao.TagXml:=EditTagXml.Text;
  RegraValidacao.CampoXml:=EditCampoXml.Text;
  RegraValidacao.CondicaoCampoXml:=EditValorXml.Text;
  RegraValidacao.TabelaSped:=EditTabelaSped.Text;
  RegraValidacao.CampoSped:=EditCampoSped.Text;
  RegraValidacao.ValorSperadoSped:=EditValorEsperadoSped.Text;
  RegraValidacao.Historico:=EditHistorico.Text;
end;


procedure TForm1.Button2Click(Sender: TObject);
var I:Integer;
quantidadeitensnf:integer;
teste:String;
begin
  DataModuleRegras.AcbrNfe.NotasFiscais.Clear;
  DataModuleRegras.AcbrNfe.NotasFiscais.LoadFromFile(SearchBox2.Text);

  DataModuleRegras.AcbrSpedFiscal.Arquivo:=EditPathSpedFiscal.Text;
  DataModuleRegras.AcbrSpedFiscal.Importar;

  Teste:=TRegrasController.GetValorFieldSped(EditTabelaSped.Text,EditCampoSped.Text,0,0);
  Showmessage(Teste);
end;


procedure TForm1.Button3Click(Sender: TObject);
var
  IndiceArqXml,IndiceQuantItens: Integer;
  IndiceTabelaMestreSped:Variant;
  ObjetoListaXmlSpedFiscal:TRetornoTamanhoLista;
begin
  TRegrasController.LimpaCdsAdvertencias;
  TRegrasController.ImportaSpedFiscal(EditPathSpedFiscal.Text);
  SetRegraValidacao;

  for IndiceArqXml := 0 to OpenDialog.Files.Count-1 do
  begin
    TRegrasController.CarregaArquivoXml(OpenDialog.Files[IndiceArqXml]);

    IndiceTabelaMestreSped:=TRegrasController.GetIndiceTabelaSped(EditTabelaSped.Text,
    TRegrasController.GetValorPesquisaParaEncontrarIndice(EditTabelaSped.Text));

    if IndiceTabelaMestreSped = false then
    TRegrasController.RegistraErrosAdvertencias(DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.Ide.nNF.ToString,
    DataModuleRegras.AcbrNfe.NotasFiscais.Items[0].NFe.procNFe.chNFe,'','','','Nota Fiscal não encontrada em arquivo Sped Fiscal')

    else
    begin
      ObjetoListaXmlSpedFiscal:=TRegrasController.VerificaQuantidadeItensXmltoSped(EditTagXml.Text,EditTabelaSped.Text,IndiceTabelaMestreSped);
      if ObjetoListaXmlSpedFiscal.QuantidadeItensEntreListasIguais then
      begin
        for IndiceQuantItens := 0 to ObjetoListaXmlSpedFiscal.QuatidadeListaXml-1 do
        TRegrasController.VerificaDivergencias_Xml_X_Sped(RegraValidacao,IndiceTabelaMestreSped,IndiceQuantItens);
      end;
    end;

  end;
  FreeAndNil(RegraValidacao);
end;

procedure TForm1.ExecutarMetodo(pNomeClasseController, pNomeMetodo: String; pParametros:
array of TValue; pMetodoRest: String; pTipoRetorno: String);
var
  Contexto: TRttiContext;
  RttiInstanceType: TRttiInstanceType;
  i: Integer;
begin
  try
    FormatSettings.DecimalSeparator := '.';
    try
    NomeClasseController := pNomeClasseController;
    RttiInstanceType := Contexto.FindType(pNomeClasseController) as TRttiInstanceType;
    RttiInstanceType.GetMethod(pNomeMetodo).Invoke(RttiInstanceType.MetaclassType, pParametros);
    except
      on E: Exception do
        Application.MessageBox(PChar('Ocorreu um erro durante a execução do método. Informe a mensagem ao Administrador do sistema.' + #13 + #13 + E.Message), 'Erro do sistema', MB_OK + MB_ICONERROR);
    end;
  finally
    FormatSettings.DecimalSeparator := ',';
    Contexto.Free;
  end;
end;



procedure TForm1.FormCreate(Sender: TObject);
begin
  DataModuleRegras.CdsRelErrosAdvertencias.CreateDataSet;
end;

procedure TForm1.EditPathSpedFiscalInvokeSearch(Sender: TObject);
begin
  if OpenDialog1.Execute() then
  EditPathSpedFiscal.Text:=OpenDialog1.FileName;
end;

procedure TForm1.SearchBox2InvokeSearch(Sender: TObject);
var I:Integer;
begin
  //PathClick(Sender);
  OpenDialog:=TOpenDialog.Create(nil);
  OpenDialog.Options:=[ofHideReadOnly,ofAllowMultiSelect,ofEnableSizing];
  Opendialog.Filter:='Arquivos Xml (*.xml)|*.xml|';
  OpenDialog.Execute;
  SearchBox2.Text:=OpenDialog.Files[0];
end;


procedure TForm1.Button1Click(Sender: TObject);
var I:Integer;
quantidadeitensnf:integer;
teste:String;
begin
  DataModuleRegras.AcbrNfe.NotasFiscais.Clear;
  DataModuleRegras.AcbrNfe.NotasFiscais.LoadFromFile(SearchBox2.Text);

  DataModuleRegras.AcbrSpedFiscal.Arquivo:=EditPathSpedFiscal.Text;
  DataModuleRegras.AcbrSpedFiscal.Importar;
  //VerificaTagIde;

  Teste:=TRegrasController.GetValorField(EditTagXml.Text,EditCampoXml.Text,0);

  //LowerCase()
  Showmessage(Teste);

  { for I := 0 to AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Count -1 do
  begin
    if AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[I].CHV_NFE = AcbrNfe.NotasFiscais.Items[0].NFe.procNFe.chNFe  then

    begin
      AcbrNfe.NotasFiscais.Imprimir;
      quantidadeItensNf:= AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[I].RegistroC170.Count;
      Showmessage('Nota Fiscal Encontrada');
    end;

  end;}


end;

procedure TForm1.PathClick(Sender: TObject);
var
  Dir: string;
begin
  if Length(TSearchBox(Sender).Text) <= 0 then
     Dir := ExtractFileDir(application.ExeName)
  else
     Dir := TSearchBox(Sender).Text;

  if SelectDirectory(Dir, [sdAllowCreate, sdPerformCreate, sdPrompt],SELDIRHELP) then
    TSearchBox(Sender).Text := Dir+'\';
end;



end.
