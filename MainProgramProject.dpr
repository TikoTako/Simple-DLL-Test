program MainProgramProject;

uses
  Vcl.Forms,
  MainProgramUnit in 'MainProgramUnit.pas' {MainProgramForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainProgramForm, MainProgramForm);
  Application.Run;
end.
