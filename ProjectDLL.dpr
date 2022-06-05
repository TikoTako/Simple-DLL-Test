library ProjectDLL;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  MainDLLUnit in 'MainDLLUnit.pas' {DLLForm};

{$R *.res}

type

  TVersion = packed record
    Name: PChar;
    Major: integer;
    Minor: integer;
  end;

function GetVersion(): TVersion; stdcall;
begin
  result.Name := 'Potato';
  result.Major := 69;
  result.Minor := 420;
end;

function OpenWindow(Modal: boolean): integer; stdcall;
begin
  result := 0;
  if Modal then
    result := DLLForm.ShowModal
  else
    DLLForm.Show;
end;

exports
  GetVersion,
  OpenWindow;

begin
  DLLForm := TDLLForm.Create(nil);

end.
