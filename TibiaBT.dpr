program TibiaBT;

uses
  Vcl.Forms,
  unitPrincipal in 'unitPrincipal.pas' {TibiaBTClient},
  unitThread in 'unitThread.pas',
  unitThreadExec in 'unitThreadExec.pas',
  bib.vars in 'bib.vars.pas',
  bib.reader.mem in 'bib.reader.mem.pas',
  Inputer in 'Inputer.pas',
  Memory in 'Memory.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TTibiaBTClient, TibiaBTClient);
  Application.Run;
end.
