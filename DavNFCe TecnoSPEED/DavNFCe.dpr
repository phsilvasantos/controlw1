program DavNFCe;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  untNFCe in '..\untNFCe.pas',
  classes1 in '..\classes1.pas',
  func in 'func.pas',
  funcoesDAV in '..\funcoesDAV.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
