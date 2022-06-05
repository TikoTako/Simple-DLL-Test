unit MainProgramUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TVersion = packed record
    Name: PChar;
    Major: integer;
    Minor: integer;
  end;

  TGetVersion = function(): TVersion; stdcall;
  TOpenWindow = function(Modal: boolean): integer; stdcall;

  TMainProgramForm = class(TForm)
    LogBox: TListBox;
    LoadUnloadButton: TButton;
    GetVersionButton: TButton;
    ShowWindowButton: TButton;
    procedure log(s: string);
    procedure LoadUnloadButtonClick(Sender: TObject);
    procedure GetVersionButtonClick(Sender: TObject);
    procedure ShowWindowButtonClick(Sender: TObject);
  private
    { Private declarations }
    fGetDllVersion: TGetVersion;
    fShowWindow: TOpenWindow;
    fDLLHandle: THandle;
  public
    { Public declarations }
  end;

var
  MainProgramForm: TMainProgramForm;

const
  cDllFile = 'ProjectDLL.dll';

implementation

{$R *.dfm}

procedure TMainProgramForm.log(s: string);
begin
  LogBox.Items.Add(s);
end;

procedure TMainProgramForm.ShowWindowButtonClick(Sender: TObject);
begin
  case fShowWindow(true) of
    mrOk:
      log('OK');
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

      { @fGetDllVersion := GetProcAddress(fDLLHandle, 'GetVersion');
        if Assigned(fGetDllVersion) then
        begin
        log(Format('GetVersion @%p', [@fGetDllVersion]));
        GetVersionButton.Enabled := true;
        end
        else
        log('Failed to load "GetVersion".');

        @fShowWindow := GetProcAddress(fDLLHandle, 'OpenWindow');
        if Assigned(fShowWindow) then
        begin
        log(Format('OpenWindow @%p', [@fShowWindow]));
        ShowWindowButton.Enabled := true;
        end
        else
        log('Failed to load "OpenWindow".'); }

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
