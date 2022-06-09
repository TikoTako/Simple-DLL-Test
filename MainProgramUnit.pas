unit MainProgramUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  CommonUnit, Vcl.ComCtrls,
  System.JSON;

type
  TSetCallBack = procedure(CallBackProcedure: TOnCallBack); stdcall;
  TGetVersion = function(): TVersion; stdcall;
  TOpenWindow = function(Modal: boolean): integer; stdcall;
  TStartThread = function(SomeString: PChar; SomeInt: integer): boolean; stdcall;
  TSendMessage = function(Msg: PChar): PChar; stdcall;

  TMainProgramForm = class(TForm)
    LogBox: TListBox;
    LoadUnloadButton: TButton;
    GetVersionButton: TButton;
    ShowWindowButton: TButton;
    StartThreadButton: TButton;
    ProgressBar1: TProgressBar;
    SendMessageButton: TButton;
    // procedure OnCallBack(CallBackData: TCallBackData);
    procedure log(s: string);
    procedure LoadUnloadButtonClick(Sender: TObject);
    procedure GetVersionButtonClick(Sender: TObject);
    procedure ShowWindowButtonClick(Sender: TObject);
    procedure SendMessageButtonClick(Sender: TObject);
  private
    { Private declarations }
    fDLLHandle: THandle;
    fGetDllVersion: TGetVersion;
    fShowWindow: TOpenWindow;
    fSetCallBack: TSetCallBack;
    fStartThread: TStartThread;
    fSendMessage: TSendMessage;
  public
    { Public declarations }
  end;

var
  MainProgramForm: TMainProgramForm;

const
  cDllFile = 'ProjectDLL.dll';

implementation

{$R *.dfm}

procedure // TMainProgramForm.
  OnCallBack(CallBackData: TCallBackData);
begin
  MainProgramForm.log('procedure TMainProgramForm.OnCallBack(CallBackData: TCallBackData);');
end;

procedure TMainProgramForm.log(s: string);
begin
  LogBox.Items.Add(s);
  LogBox.ItemIndex := LogBox.Count - 1;
end;

procedure TMainProgramForm.SendMessageButtonClick(Sender: TObject);
var
  vMsg, vResp: string;
begin
  if InputQuery('Test program', 'Please type your name', vMsg) then
  begin
    vResp := fSendMessage(PChar(vMsg));
    if not vResp.IsEmpty then
      log(vResp)
    else
      log('Reply null, setup key and chat id by pressing [Show Window].');
  end;
end;

procedure TMainProgramForm.ShowWindowButtonClick(Sender: TObject);
begin
  case fShowWindow(true) of
    mrOk:
      log('Ok');
    mrCancel:
      log('Cancel');
    mrClose:
      log('Close');
  else
    log('else');
  end;

end;

procedure TMainProgramForm.GetVersionButtonClick(Sender: TObject);
var
  vVersion: TVersion;
begin
  vVersion := fGetDllVersion;
  log(Format('%s - version %d.%d', [vVersion.Name, vVersion.Major, vVersion.Minor]));
end;

function LoadDllStuff(var meth: pointer; Name: string; DllHandle: THandle; Butan: TButton): string;
begin
  meth := GetProcAddress(DllHandle, PChar(Name));
  if Assigned(meth) then
  begin
    result := Format('%s @%p', [name, meth]);
    if Butan <> nil then
      Butan.Enabled := true;
  end
  else
    result := 'Failed to load "GetVersion".';
end;

procedure TMainProgramForm.LoadUnloadButtonClick(Sender: TObject);
var
  vFail: pointer;
begin
  if not FileExists(cDllFile) then
  begin
    log('Yare Yare Daze');
    log('DLL file not found.');
    Exit;
  end;

  if ('Load DLL'.Equals(LoadUnloadButton.Caption)) then
  begin
    fDLLHandle := Loadlibrary(cDllFile);
    if fDLLHandle > 0 then
    begin
      log('Library loaded.');

      log(LoadDllStuff(@fGetDllVersion, 'GetVersion', fDLLHandle, GetVersionButton));
      log(LoadDllStuff(@fShowWindow, 'OpenWindow', fDLLHandle, ShowWindowButton));
      log(LoadDllStuff(@fSetCallBack, 'SetCallBack', fDLLHandle, nil));
      log(LoadDllStuff(@fStartThread, 'StartThread', fDLLHandle, StartThreadButton));
      log(LoadDllStuff(@fSendMessage, 'SendMessage', fDLLHandle, SendMessageButton));

      if Assigned(fSetCallBack) then
        fSetCallBack(@OnCallBack)
      else
        log('Task failed successfully.');

      vFail := GetProcAddress(fDLLHandle, 'ILIKETURTLES');
      if Assigned(vFail) then
        log('impossibiru')
      else
        log('Task failed successfully.');

      LoadUnloadButton.Caption := 'Unload DLL';
    end
    else
      log('Failed to load the library.');
  end
  else
  begin
    // disabilita butans
    GetVersionButton.Enabled := false;
    ShowWindowButton.Enabled := false;
    // unload
    FreeLibrary(fDLLHandle);
    fGetDllVersion := nil;
    fShowWindow := nil;
    fDLLHandle := 0;
    LoadUnloadButton.Caption := 'Load DLL';
  end
end;

end.
