unit URegras;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, LabeledCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Data.DB, Vcl.WinXCtrls, Vcl.Grids, Vcl.DBGrids,
  JvExDBGrids, JvDBGrid, JvDBUltimGrid,Vcl.FileCtrl, ACBrSpedFiscal, ACBrBase,
  ACBrDFe, ACBrNFe, ACBrEFDImportar,System.StrUtils,System.Rtti,pcnProcNFe,pcnNFe,
  UDataModule,Datasnap.DBClient;

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
    EditTagXml: TLabeledEdit;
    EditValorTagXml: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabeledComboBox3: TLabeledComboBox;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    EditCampoXml: TLabeledEdit;
    LabeledEdit8: TLabeledEdit;
    EdtiTabelaSped: TTabSheet;
    OpenDialog1: TOpenDialog;
    SearchBox1: TSearchBox;
    Label1: TLabel;
    Label2: TLabel;
    SearchBox2: TSearchBox;
    OpenDialog2: TOpenDialog;
    ACBrNFe: TACBrNFe;
    Button1: TButton;
    ACBrSpedFiscal: TACBrSpedFiscalImportar;
    ACBrSPEDFiscal1: TACBrSPEDFiscal;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
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
    procedure SearchBox1InvokeSearch(Sender: TObject);
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
    function GetValorTagXml(TagXml,CamposTagXml:String;I:Integer):String;
    function GetValorCampoSped(TabelaSped,CampoSped:String;I:Integer):String;
    procedure VerificaTagIde(TagXml,CamposTagXml:String);
    procedure ExecutarMetodo(pNomeClasseController, pNomeMetodo: String; pParametros:array of TValue; pMetodoRest: String; pTipoRetorno: String);
    function GetValorField(pTag, pNomeField: String;IndiceFilho:Integer):Variant;
    function GetValorFieldSped(pTabela, pCampo: String;IndicePai,IndiceFilho:Integer): Variant;
    procedure RegistraErrosAdvertencias(NumeroNf,ChaveAcesso,ResultadoXml,ResultadoEsperadoSped,
 ResultadoSped,Historico: String;Cds:TClientDataSet);

  end;

var
  Form1: TForm1;

implementation


Const
SELDIRHELP = 1000;

{$R *.dfm}

{function TForm1.GetValorField(pTag, pNomeField: String;pParametros: array of TValue): String;
var
  Contexto: TRttiContext;
  RttiInstanceType: TRttiInstanceType;
  i: Integer;
begin
  try
    FormatSettings.DecimalSeparator := '.';
    try
    //NomeClasseController := pNomeClasseController;
    RttiInstanceType := Contexto.FindType('AcbrNfe.TAcbrNfe') as TRttiInstanceType;
    RttiInstanceType.GetMethod('NotasFiscais.Imprimir').Invoke(RttiInstanceType.MetaclassType,[TAcbrNfe(AcbrNfe)]);
    //Result:= RttiInstanceType.GetField('NotasFiscais.Items[0].NFe.procNFe.chNFe').ToString;
    //Result:= RttiInstanceType.Get('NotasFiscais.Items[0].NFe.procNFe.chNFe').Name;
    except
      on E: Exception do
        Application.MessageBox(PChar('Ocorreu um erro durante a execução do método. Informe a mensagem ao Administrador do sistema.' + #13 + #13 + E.Message), 'Erro do sistema', MB_OK + MB_ICONERROR);
    end;
  finally
    FormatSettings.DecimalSeparator := ',';
    Contexto.Free;
  end;

end;}


 procedure TForm1.RegistraErrosAdvertencias(NumeroNf,ChaveAcesso,ResultadoXml,ResultadoEsperadoSped,
 ResultadoSped,Historico: String;Cds:TClientDataSet);
begin
  Cds.Append;
  Cds.FieldByName('NUMERO_DOCUMENTO').AsString:=NumeroNf;
  Cds.FieldByName('CHAVE_ACESSO').AsString:=ChaveAcesso;
  Cds.FieldByName('HISTORICO').AsString:=Historico;
  Cds.FieldByName('RESULTADO_XML').AsString:=ResultadoXml;
  Cds.FieldByName('RESULTADO_ESPERADO_SPED').AsString:=ResultadoEsperadoSped;
  Cds.FieldByName('RESULTADO_SPED').AsString:=ResultadoSped;
  Cds.Post;
end;




function TForm1.GetValorFieldSped(pTabela, pCampo: String;IndicePai,IndiceFilho:Integer): Variant;
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
    Objeto:= AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[IndicePai];

    if pTabela = 'C170' then
    Objeto:= AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[IndicePai].RegistroC170.Items[IndiceFilho];

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



function TForm1.GetValorField(pTag, pNomeField: String;IndiceFilho:Integer): Variant;
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
    Objeto:= AcbrNfe.NotasFiscais.Items[0].NFe.Ide;

    if pTag = 'Emit' then
    Objeto:= AcbrNfe.NotasFiscais.Items[0].NFe.Emit;

    if pTag = 'ICMSTot' then
    Objeto:= AcbrNfe.NotasFiscais.Items[0].NFe.Total.ICMSTot;

    if pTag = 'prod' then
    Objeto:= AcbrNfe.NotasFiscais.Items[0].NFe.Det.Items[IndiceFilho].Prod;

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


procedure TForm1.Button2Click(Sender: TObject);
var I:Integer;
quantidadeitensnf:integer;
teste:String;
begin
  AcbrNfe.NotasFiscais.Clear;
  AcbrNfe.NotasFiscais.LoadFromFile(SearchBox2.Text);

  AcbrSpedFiscal.Arquivo:=SearchBox1.Text;
  AcbrSpedFiscal.Importar;

  Teste:=GetValorFieldSped(EditTabelaSped.Text,EditCampoSped.Text,0,0);

  Showmessage(Teste);






end;


procedure TForm1.Button3Click(Sender: TObject);
var CampoXml,CampoSped:Variant;
  I,I2,I3,TamanhoListaXml,TamanhoListaSped: Integer;
  IndiceNfe:Integer;
begin
  DataModuleRegras.CdsRelErrosAdvertencias.EmptyDataSet;

  AcbrSpedFiscal.Arquivo:=SearchBox1.Text;
  AcbrSpedFiscal.Importar;

  for I := 0 to OpenDialog.Files.Count-1 do
  begin
    AcbrNfe.NotasFiscais.Clear;
    AcbrNfe.NotasFiscais.LoadFromFile(OpenDialog.Files[I]);

    for I2 := 0 to AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Count-1 do
    begin
     if  AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[I2].CHV_NFE =
     AcbrNfe.NotasFiscais.Items[0].NFe.procNFe.chNFe then
     begin
       IndiceNfe:=I2;
     end;
    end;




    if LabeledEdit3.Text = 'prod' then
    TamanhoListaXml:= AcbrNfe.NotasFiscais.Items[0].NFe.Det.Count
    else
    TamanhoListaXml:=1;

    if EditTabelaSped.Text = 'C170' then
    TamanhoListaSped:= AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[IndiceNfe].RegistroC170.Count
    else
    TamanhoListaSped:=1;


    if TamanhoListaXml <> TamanhoListaSped then
    begin
      RegistraErrosAdvertencias(AcbrNfe.NotasFiscais.Items[0].NFe.Ide.nNF.ToString,
      AcbrNfe.NotasFiscais.Items[0].NFe.procNFe.chNFe,
      '',
      '',
      '',
      'Quantidade de Itens diferentes entre xml e sped',DataModuleRegras.CdsRelErrosAdvertencias);
    end


    else
    begin
      for I3 := 0 to TamanhoListaXml-1 do
      begin

        CampoXml:=GetValorField(LabeledEdit3.Text,LabeledEdit2.Text,I3);

        if EditValorXml.Text<>'' then
        if VarToStr(CampoXml) = EditValorXml.Text then
        begin
          CampoSped:=GetValorFieldSped(EditTabelaSped.Text,EditCampoSped.Text,IndiceNfe,I3);
          if EditValorEsperadoSped.Text <> VarToStr(CampoSped) then
          RegistraErrosAdvertencias(AcbrNfe.NotasFiscais.Items[0].NFe.Ide.nNF.ToString,
          AcbrNfe.NotasFiscais.Items[0].NFe.procNFe.chNFe,
          VarToStr(CampoXml),
          VarToStr(EditValorEsperadoSped.Text),
          VarToStr(CampoSped),
          EditHistorico.Text,DataModuleRegras.CdsRelErrosAdvertencias);
        end;

        if EditValorXml.Text='' then
        begin
          CampoSped:=GetValorFieldSped(EditTabelaSped.Text,EditCampoSped.Text,IndiceNfe,I3);
          if CampoXml <> CampoSped then
          RegistraErrosAdvertencias(AcbrNfe.NotasFiscais.Items[0].NFe.Ide.nNF.ToString,
          AcbrNfe.NotasFiscais.Items[0].NFe.procNFe.chNFe,
          VarToStr(CampoXml),
          VarToStr(CampoXml),
          VarToStr(CampoSped),
          EditHistorico.Text,DataModuleRegras.CdsRelErrosAdvertencias);
        end;
      end;


    end;

    //showmessage(VarToStr(CampoXml)+'  '+VarToStr(CampoSped)+ 'nf '+AcbrNfe.NotasFiscais.Items[0].NFe.procNFe.chNFe);


  end;




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

procedure TForm1.SearchBox1InvokeSearch(Sender: TObject);
begin
  if OpenDialog1.Execute() then
  SearchBox1.Text:=OpenDialog1.FileName;
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
  AcbrNfe.NotasFiscais.Clear;
  AcbrNfe.NotasFiscais.LoadFromFile(SearchBox2.Text);

  AcbrSpedFiscal.Arquivo:=SearchBox1.Text;
  AcbrSpedFiscal.Importar;

 // VerificaTagIde;

  Teste:=GetValorField(LabeledEdit3.Text,LabeledEdit2.Text,0);




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


procedure TForm1.VerificaTagIde(TagXml,CamposTagXml:String);
var ValorCampo,ValorCampoSped:String;
begin
  if TagXml = 'Ide' then
  begin
    if EditValorTagXml.Text = GetValorTagXml(TagXml,CamposTagXml,0) then
    ValorCampo:= GetValorTagXml(TagXml,CamposTagXml,0);


 //   GetValorCampoSped(TabelaSped, CampoSped: String;I: Integer): String;


  end;
end;

function TForm1.GetValorCampoSped(TabelaSped, CampoSped: String;I: Integer): String;
begin
  if TabelaSped = 'C100' then
  begin
    case AnsiIndexStr(CampoSped,['SER','DT_DOC'])  of
    0:Result:=AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[I].SER;
    1:Result:=DateTimeToStr(AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[I].DT_DOC);
    end;
  end;


  if TabelaSped = 'C170' then
  begin
    case AnsiIndexStr(CampoSped,['CFOP'])  of
    0:Result:=AcbrSpedFiscal1.Bloco_C.RegistroC001.RegistroC100.Items[I].RegistroC170.Items[I].CFOP;
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



function TForm1.GetValorTagXml(TagXml, CamposTagXml: String;I:Integer): String;
var teste:string;
begin

  if TagXml = 'Ide' then
  begin
    case AnsiIndexStr(CamposTagXml,['serie','dEmi'])  of
    0:Result:=IntToStr(AcbrNfe.NotasFiscais.Items[0].Nfe.Ide.serie);
    1:Result:=DateTimeToStr(AcbrNfe.NotasFiscais.Items[0].Nfe.Ide.dEmi);
    end;
  end;


  if TagXml = 'Prod' then
  begin
    case AnsiIndexStr(CamposTagXml,['Ncm','Cfop'])  of
    0:Result:=AcbrNfe.NotasFiscais.Items[0].Nfe.Det.Items[i].Prod.Ncm;
    1:Result:=AcbrNfe.NotasFiscais.Items[0].Nfe.Det.Items[i].Prod.Cfop;
    end;
  end;


   if TagXml = 'Total' then
  begin
    case AnsiIndexStr(CamposTagXml,['vICMS'])  of
    0:Result:=FloattoStr(AcbrNfe.NotasFiscais.Items[0].Nfe.Total.ICMSTot.vICMS);
    end;
  end;

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
