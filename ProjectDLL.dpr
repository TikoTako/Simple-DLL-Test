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
  Vcl.Controls,
  Winapi.Windows,
  System.SysUtils,
  System.IOUtils,
  MainDLLUnit in 'MainDLLUnit.pas' {DLLForm} ,
  ThreadUnit in 'ThreadUnit.pas',
  CommonUnit in 'CommonUnit.pas',
  SmollTelegramBotUnit in 'SmollTelegramBotUnit.pas';

{$R *.res}

var
  gCallBackProcedure: TOnCallBack;
  SmollTelegramBot: TSmollTelegramBot;

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
  result.Name := 'ProjectDLL';
  result.Major := 1;
  result.Minor := 0;
end;

function OpenWindow(Modal: boolean): integer; stdcall;
begin
  result := 0;
  if Modal then
  begin
    result := DLLForm.ShowModal;
    if result = mrOk then
      SmollTelegramBot.SetKeyAndChat(DLLForm.BotKeyEdit.Text, StrToInt64(DLLForm.ChatIDEdit.Text));
  end
  else
    DLLForm.Show;
end;

function StartThread(SomeString: PChar; SomeInt: integer): boolean; stdcall;
begin
  // check start
end;

function SendMessage(Msg: PChar): PChar; stdcall;
begin
  result := PChar(SmollTelegramBot.SendMessage(Msg));
end;

exports
  SetCallBack,
  GetVersion,
  OpenWindow,
  StartThread,
  SendMessage;

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
        AllocConsole(); // Warning, closing the console also close the main program process
        WriteLn('DLL_PROCESS_ATTACH');
      end;
    DLL_PROCESS_DETACH:
      begin
        SmollTelegramBot.Free;
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

  // Since theres DLL_PROCESS_ATTACH this stuff can be moved there but whatever
  DLLForm := TDLLForm.Create(nil);
  SmollTelegramBot := TSmollTelegramBot.Create;

  SetLength(BotDataFile, MAX_PATH + 1);
  GetModuleFileName(hInstance, PChar(BotDataFile), MAX_PATH);
  BotDataFile := TPath.Combine(ExtractFilePath(Trim(BotDataFile)), 'BotData.txt');
  if FileExists(BotDataFile) then
  begin
    var
    vLines := TFile.ReadAllLines(BotDataFile);
    if Length(vLines) = 2 then
      try
        DLLForm.BotKeyEdit.Text := vLines[0];
        DLLForm.ChatIDEdit.Text := vLines[1];
        SmollTelegramBot.SetKeyAndChat(vLines[0], StrToInt64(vLines[1]));
      except
        on ex: Exception do
          WriteLn('TFile.ReadAllLines(BotDataFile) >> ' + ex.Message);
      end;
  end
  else if OpenWindow(true) = mrOk then
    SmollTelegramBot.SetKeyAndChat(DLLForm.BotKeyEdit.Text, StrToInt64(DLLForm.ChatIDEdit.Text));

  // starta thread qui che waita some event
end.
