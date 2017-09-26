program TibiaBT;

uses
  Vcl.Forms,
  unitPrincipal in 'unitPrincipal.pas' {Form1},
  unitThread in 'unitThread.pas',
  unitThreadExec in 'unitThreadExec.pas',
  bib.vars in 'bib.vars.pas',
  bib.reader.mem in 'bib.reader.mem.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
