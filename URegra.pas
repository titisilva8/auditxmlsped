unit URegra;

interface

uses pcnConversao;

  type TRegra = class
  private
    FTAG_XML:String;
    FCAMPO_XML:String;
    FCONDICAO_CAMPO_XML:String;
    FIDENTIFICADOR_CONDICAO_XML:String;

    FTABELA_SPED:String;
    FCAMPO_SPED:String;
    FVALOR_ESPERADO_SPED:String;
    FIDENTIFICADOR_CONDICAO_SPED:String;
    FCRT: String;
    FHISTORICO:String;


  protected

  public
    property TagXml:String read FTAG_XML write FTAG_XML;
    property CampoXml:String read FCAMPO_XML write FCAMPO_XML;
    property IdentificadorCondicaoXml:String read FIDENTIFICADOR_CONDICAO_XML write FIDENTIFICADOR_CONDICAO_XML;
    property CondicaoCampoXml:String read FCONDICAO_CAMPO_XML write FCONDICAO_CAMPO_XML;

    property TabelaSped:String read FTABELA_SPED write FTABELA_SPED;
    property CampoSped:String read FCAMPO_SPED write FCAMPO_SPED;
    property IdentificadorCondicaoSped:String read FIDENTIFICADOR_CONDICAO_SPED write FIDENTIFICADOR_CONDICAO_SPED;
    property ValorSperadoSped:String read FVALOR_ESPERADO_SPED write FVALOR_ESPERADO_SPED;
    property Crt: String read FCRT write FCRT;
    property Historico:String read FHISTORICO write FHISTORICO;

end;

implementation



{ TRegra }


end.
