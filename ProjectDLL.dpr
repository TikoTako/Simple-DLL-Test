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
  System.IOUtils,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  MainDLLUnit in 'MainDLLUnit.pas' {DLLForm} ,
  ThreadUnit in 'ThreadUnit.pas',
  CommonUnit in 'CommonUnit.pas';

{$R *.res}

var
  gBotKey: string = 'YOUR TELEGRAM BOT KEY HERE';
  gCallBackProcedure: TOnCallBack;

procedure SetCallBack(CallBackProcedure: TOnCallBack); stdcall;
var
  vCBD: TCallBackData;
begin
  gCallBackProcedure := CallBackProcedure;
  vCBD.SomeString := 'Y HALO THAR';
  gCallBackProcedure(vCBD);
  gCallBack := @CallBackProcedure;
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
  SetCallBack,
  GetVersion,
  OpenWindow;

procedure CallBack(CBD: TCallBackData);
begin
  if Assigned(gCallBackProcedure) then
    gCallBackProcedure(CBD);
end;

procedure DLLHandler(wut: integer);
var
  s: string;
begin
  case wut of
    DLL_PROCESS_ATTACH:
      begin
        AllocConsole(); // Closing the console also close the program
        WriteLn('DLL_PROCESS_ATTACH');
      end;
    DLL_PROCESS_DETACH:
      begin
        WriteLn('DLL_PROCESS_DETACH');
        WriteLn('Press enter to exit.');
        ReadLN(s); // This block main program too cuz the console is allocated there
        FreeConsole();
      end;
    DLL_THREAD_ATTACH:
      WriteLn('DLL_THREAD_ATTACH');
    DLL_THREAD_DETACH:
      WriteLn('DLL_THREAD_DETACH');
  end;
end;

begin
  DLLProc := DLLHandler;
  DLLProc(DLL_PROCESS_ATTACH);

  if FileExists('c:\bot.key') then
    gBotKey := TFile.ReadAllText('c:\bot.key');

  DLLForm := TDLLForm.Create(nil);
  DLLForm.Edit1.Text := gBotKey;

  // starta thread qui che waita some event

end.
