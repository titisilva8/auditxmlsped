program PrototipoRegras;

uses
  Vcl.Forms,
  URegras in 'URegras.pas' {Form1},
  UDataModule in 'UDataModule.pas' {DataModuleRegras: TDataModule},
  URegrasController in 'URegrasController.pas',
  URegra in 'URegra.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataModuleRegras, DataModuleRegras);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
