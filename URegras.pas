unit URegras;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, LabeledCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Data.DB, Vcl.WinXCtrls, Vcl.Grids, Vcl.DBGrids,
  JvExDBGrids, JvDBGrid, JvDBUltimGrid,Vcl.FileCtrl, ACBrSpedFiscal, ACBrBase,
  ACBrDFe, ACBrNFe, ACBrEFDImportar,System.StrUtils,System.Rtti,pcnProcNFe,pcnNFe,
  UDataModule,Datasnap.DBClient,URegrasController,URegra,pcnConversao,
  JvExStdCtrls, JvCombobox, JvDBSearchComboBox, Vcl.Buttons;

type
  TFAuditoriaXmlSpedFiscal = class(TForm)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label1: TLabel;
    EditPathSpedFiscal: TSearchBox;
    EditPathArquivosXml: TSearchBox;
    GroupBox2: TGroupBox;
    ComboboxRegimeTributario: TLabeledComboBox;
    EditHistorico: TLabeledEdit;
    GroupBox3: TGroupBox;
    BotaoCruzaDados: TButton;
    GridAdvertencias: TDBGrid;
    GroupBox4: TGroupBox;
    EditTagXml: TJvDBSearchComboBox;
    Label3: TLabel;
    EditCampoXml: TLabeledEdit;
    Label6: TLabel;
    ComboboxIdentificadorCondicaoXml: TLabeledComboBox;
    EditValorXml: TLabeledEdit;
    GroupBox5: TGroupBox;
    EditTabelaSped: TJvDBSearchComboBox;
    Label5: TLabel;
    EditCampoSped: TLabeledEdit;
    ComboboxIdentificadorCondicaoSped: TLabeledComboBox;
    EditValorEsperadoSped: TLabeledEdit;
    Label4: TLabel;
    procedure EditPathArquivosXmlInvokeSearch(Sender: TObject);
    procedure EditPathSpedFiscalInvokeSearch(Sender: TObject);
    procedure BotaoCruzaDadosClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GridAdvertenciasTitleClick(Column: TColumn);
    procedure GridAdvertenciasDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure GridAdvertenciasCellClick(Column: TColumn);
    procedure ComboboxIdentificadorCondicaoXmlChange(Sender: TObject);
    procedure ComboboxIdentificadorCondicaoSpedChange(Sender: TObject);
  private
    { Private declarations }
    function OrdenarGrid_PintaTitulo(xGrid: TDBGrid; Column: TColumn; Cds: TClientDataSet): boolean;
    procedure DesenhaCheckBoxGridPadrao(Cds:TClientDataSet;Field,CheckTrue:String;Grid:TDBGrid;Column: TColumn;const Rect: TRect);

    procedure AjustaDadosIniciais;
    procedure AjustaVisibilidadeCamposCondicaoXml;
    procedure AjustaVisibilidadeCamposCondicaoSpedFiscal;
    procedure CruzarInformacoes;
    procedure LoadArquivosXMl;
    procedure LoadSpedFiscal;
    procedure SetRegraValidacao;

  public
    { Public declarations }
    var OpenDialogArquivosXml:TOpenDialog;
    var NomeClasseController: String;
    var RegraValidacao:TRegra;


  end;

var
  FAuditoriaXmlSpedFiscal: TFAuditoriaXmlSpedFiscal;

implementation


Const
SELDIRHELP = 1000;

{$R *.dfm}

{$Region 'Infra'}

procedure TFAuditoriaXmlSpedFiscal.DesenhaCheckBoxGridPadrao(Cds:TClientDataSet;Field,CheckTrue:String;Grid:TDBGrid;Column: TColumn;const Rect: TRect);
var
  iCheck: Integer;
  rRect: TRect;
begin
  //Desenha um checkbox no dbgrid
  if Column.FieldName = Field then
  begin
    Grid.Canvas.FillRect(Rect);
    iCheck := 0;
    if CDS.FieldByName(Field).AsString = CheckTrue then
      iCheck := DFCS_CHECKED
    else
      iCheck := 0;
    rRect := Rect;
    InflateRect(rRect,-2,-2);
    DrawFrameControl(Grid.Canvas.Handle,rRect,DFC_BUTTON, DFCS_BUTTONCHECK or iCheck);
  end;
end;

function TFAuditoriaXmlSpedFiscal.OrdenarGrid_PintaTitulo(xGrid: TDBGrid; Column: TColumn; Cds: TClientDataSet): boolean;
const
idxdefault='DEFAULT_ORDER';
var
  strColumn: string;
  bolUsed: Boolean;
  idOptions: TIndexOptions;
  I: Integer;
  VDescendField: string;
begin
  Result := false;
  if not CDS.Active then exit;
  strColumn := idxDefault;
  // Se for campo calculado não deve fazer nada
  if (Column.Field.FieldKind = fkCalculated) then exit;
  // O índice já está em uso
  bolUsed := (Column.Field.FieldName = cds.IndexName);
  // Verifica a existência do índice e propriedades
  CDS.IndexDefs.Update;
  idOptions := [];
  for I := 0 to CDS.IndexDefs.Count - 1 do
  begin
    if cds.IndexDefs.Items[I].Name = Column.Field.FieldName then
    begin
      strColumn := Column.Field.FieldName;
      // Determina como deve ser criado o índice, inverte a condição ixDescending
      case (ixDescending in cds.IndexDefs.Items[I].Options) of
      True: begin
              idOptions := [];
              VDescendField := '';
            end;
      False:begin
              idOptions := [ixDescending];
              vDescendField := strColumn;
            end;
      end;
    end;
  end;
  // Se não encontrou o índice, ou o índice já esta em uso...
  if (strColumn = idxDefault) or bolUsed then
  begin
    if bolUsed then
      CDS.DeleteIndex(Column.Field.FieldName);
    try
      CDS.AddIndex(Column.Field.FieldName, Column.Field.FieldName, idOptions, VDescendField, '', 0);
      strColumn := Column.Field.FieldName;
    except
        // O índice esta indeterminado, passo para o padrão
      if bolUsed then strColumn := idxDefault;
    end;
  end;
  for I := 0 to xGRID.Columns.Count - 1 do begin
    if Pos(StrColumn, xGrid.Columns[I].Field.FieldName) <> 0 then
      xGrid.Columns[I].Title.Font.Color := clBlue
    else
      xGrid.Columns[I].Title.Font.Color := clWindowText;
  end;
  try
    CDS.IndexName := strColumn;
  except
    CDS.IndexName := idxDefault;
  end;
  result := true;
end;

procedure TFAuditoriaXmlSpedFiscal.AjustaVisibilidadeCamposCondicaoXml;
begin
  if (ComboboxIdentificadorCondicaoXml.Text = 'Sem Condição') or (ComboboxIdentificadorCondicaoXml.Text = '') then
  begin
    EditValorXml.Visible:=false;
    ComboboxIdentificadorCondicaoXml.Width:=345;
  end
  else
  begin
    EditValorXml.Visible:=true;
    ComboboxIdentificadorCondicaoXml.Width:=188;
  end;
end;

procedure TFAuditoriaXmlSpedFiscal.AjustaVisibilidadeCamposCondicaoSpedFiscal;
begin
  if (ComboboxIdentificadorCondicaoSped.Text = 'Sem Condição') or  (ComboboxIdentificadorCondicaoSped.Text = '') then
  begin
    EditValorEsperadoSped.Visible:=false;
    ComboboxIdentificadorCondicaoSped.Width:=345;
  end
  else
  begin
    EditValorEsperadoSped.Visible:=true;
    ComboboxIdentificadorCondicaoSped.Width:=188;
  end;
end;

procedure TFAuditoriaXmlSpedFiscal.FormCreate(Sender: TObject);
begin
  TRegrasController.PreencheCdsTabelasSped;
  TRegrasController.PreencheCdsTagXml;
  AjustaDadosIniciais;
end;

procedure TFAuditoriaXmlSpedFiscal.GridAdvertenciasCellClick(Column: TColumn);
begin
  if Column.Index = 11 then
  begin
    DataModuleRegras.CDSRelErrosAdvertencias.Edit;
    if DataModuleRegras.CDSRelErrosAdvertencias.FieldByName('IDENTIFICADOR_ERRO_ADVERTENCIA').AsString = '' then
    DataModuleRegras.CDSRelErrosAdvertencias.FieldByName('IDENTIFICADOR_ERRO_ADVERTENCIA').AsString := 'S'
    else
    DataModuleRegras.CDSRelErrosAdvertencias.FieldByName('IDENTIFICADOR_ERRO_ADVERTENCIA').AsString := '';
    DataModuleRegras.CDSRelErrosAdvertencias.Post;
  end;
end;

procedure TFAuditoriaXmlSpedFiscal.GridAdvertenciasDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  DesenhaCheckBoxGridPadrao(DataModuleRegras.CdsRelErrosAdvertencias,'IDENTIFICADOR_ERRO_ADVERTENCIA','S',GridAdvertencias,Column,Rect);
end;

procedure TFAuditoriaXmlSpedFiscal.GridAdvertenciasTitleClick(Column: TColumn);
begin
  OrdenarGrid_PintaTitulo(GridAdvertencias, Column,DataModuleRegras.CdsRelErrosAdvertencias);
end;

{$EndRegion}

{$Region 'Botões'}

procedure TFAuditoriaXmlSpedFiscal.BotaoCruzaDadosClick(Sender: TObject);
begin
  CruzarInformacoes;
end;

procedure TFAuditoriaXmlSpedFiscal.ComboboxIdentificadorCondicaoSpedChange(Sender: TObject);
begin
  AjustaVisibilidadeCamposCondicaoSpedFiscal;
end;

procedure TFAuditoriaXmlSpedFiscal.ComboboxIdentificadorCondicaoXmlChange(Sender: TObject);
begin
  AjustaVisibilidadeCamposCondicaoXml;
end;

procedure TFAuditoriaXmlSpedFiscal.EditPathArquivosXmlInvokeSearch(Sender: TObject);
begin
  LoadArquivosXml;
end;

procedure TFAuditoriaXmlSpedFiscal.EditPathSpedFiscalInvokeSearch(Sender: TObject);
begin
  LoadSpedFiscal;
end;

{$EndRegion}

{$Region 'Functions e Procedures'}

procedure TFAuditoriaXmlSpedFiscal.LoadSpedFiscal;
begin
  if DataModuleRegras.OpenDialogSped.Execute() then
  EditPathSpedFiscal.Text:=DataModuleRegras.OpenDialogSped.FileName;
end;

procedure TFAuditoriaXmlSpedFiscal.SetRegraValidacao;
begin
  try
    RegraValidacao:=TRegra.Create;
    RegraValidacao.TagXml:=EditTagXml.Text;
    RegraValidacao.CampoXml:=EditCampoXml.Text;
    RegraValidacao.IdentificadorCondicaoXml:=ComboboxIdentificadorCondicaoXml.Text;
    RegraValidacao.CondicaoCampoXml:=EditValorXml.Text;
    RegraValidacao.TabelaSped:=EditTabelaSped.Text;
    RegraValidacao.CampoSped:=EditCampoSped.Text;
    RegraValidacao.IdentificadorCondicaoSped:=ComboboxIdentificadorCondicaoSped.Text;
    RegraValidacao.ValorSperadoSped:=EditValorEsperadoSped.Text;
    RegraValidacao.Crt:= Copy(ComboboxRegimeTributario.Text,1,1);
    RegraValidacao.Historico:=EditHistorico.Text;
  Except on E:Exception do
    begin
      Showmessage('Erro ao instanciar regra de validação! '+E.Message);
      Abort;
    end;
  end;
end;

procedure TFAuditoriaXmlSpedFiscal.CruzarInformacoes;
begin
  try
    try
      SetRegraValidacao;
      TRegrasController.LimpaCdsAdvertencias;
      TRegrasController.LoadSpedFiscal(EditPathSpedFiscal.Text);
      TRegrasController.VerificaCarregamentoArquivosXml(OpenDialogArquivosXml);
      TRegrasController.CruzaDadosNfeXml_x_NfeSpedFiscal(RegraValidacao,OpenDialogArquivosXml);
      Except on E:Exception do
      Showmessage('Parâmetros da regra não puderam ser auditados');
    end;
  finally
    Freeandnil(RegraValidacao);
  end;
end;

procedure TFAuditoriaXmlSpedFiscal.LoadArquivosXMl;
var I:Integer;
begin
  OpenDialogArquivosXml:=TOpenDialog.Create(nil);
  OpenDialogArquivosXml.Options:=[ofHideReadOnly,ofAllowMultiSelect,ofEnableSizing];
  OpenDialogArquivosXml.Filter:='Arquivos Xml (*.xml)|*.xml|';
  OpenDialogArquivosXml.Execute;
  EditPathArquivosXml.Text:=OpenDialogArquivosXml.Files[0];
end;

procedure TFAuditoriaXmlSpedFiscal.AjustaDadosIniciais;
begin
  EditPathSpedFiscal.Clear;
  EditPathArquivosXml.Clear;
  EditPathSpedFiscal.Clear;
  EditPathSpedFiscal.Text:='D:\Arquivos Black Slate\Sped Fiscal\SpedEFD-09026278000102-0010417880006-Remessa de arquivo original-dez2021 - Reti.txt';
  EditPathArquivosXml.Text:='D:\Arquivos Black Slate\Arquivos Xml 12-2021\31211223469125000160550010000771871009906148.xml';
  EditHistorico.Text:='';
  EditTagXml.Text:='prod';
  EditTabelaSped.Text:='C170|0200';

  EditCampoXml.Text:='NCM';
  EditCampoSped.Text:='COD_NCM';
  EditHistorico.Text:='Ncm do item no arquivo xml está diferente do ncm do mesmo item lançado no Sped Fiscal';

  ComboboxRegimeTributario.ItemIndex:=0;
  ComboboxIdentificadorCondicaoXml.ItemIndex:=0;
  ComboboxIdentificadorCondicaoSped.ItemIndex:=0;
  EditValorXml.Visible:=False;
  EditValorEsperadoSped.Visible:=false;


  GridAdvertencias.Columns[1].Font.Color:=clmaroon;
  GridAdvertencias.Columns[1].Font.style:=[fsbold];
  GridAdvertencias.Columns[3].Font.style:=[fsbold];


  GridAdvertencias.Columns[4].Font.Color:=clblue;
  GridAdvertencias.Columns[5].Font.Color:=clgreen;
  GridAdvertencias.Columns[6].Font.Color:=clred;

  GridAdvertencias.Columns[7].Font.style:=[fsbold];

  ComboboxIdentificadorCondicaoXml.Width:=345;
  ComboboxIdentificadorCondicaoSped.Width:=345;


end;

{$EndRegion}

end.
