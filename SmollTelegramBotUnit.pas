unit SmollTelegramBotUnit;

interface

uses
  Vcl.Dialogs,
  Winapi.WinInet,
  System.JSON, System.SysUtils, System.NetEncoding;

type
  TSmollTelegramBot = class
  private
    fUrl: string;
    fHIO: HINTERNET;
    fHazKey: boolean;
  public
    constructor Create;
    procedure SetKeyAndChat(BotKey: string; ChatID: UInt64);
    function SendMessage(msg: string): string;
    destructor Destroy; override;
  end;

implementation

const
  cUserAgent = 'TSmollTelegramBot/1.0';
  cUrl = 'https://api.telegram.org/bot%s/sendMessage?chat_id=%d&text=';

  { !!! THIS IS A BLOCKING VERSION BECAUSE THE REPLY SIZE IS VERY SMALL !!! }

procedure ShowError(msg: string);
begin
  MessageDlg(msg, mtError, [mbOk], 0);
end;

constructor TSmollTelegramBot.Create;
begin
  fHazKey := false;
  inherited Create;
  fHIO := InternetOpen(cUserAgent, INTERNET_OPEN_TYPE_DIRECT, nil, nil, 0);
  if not Assigned(fHIO) then
    ShowError(Format('InternetOpen > FAIL [%d]', [GetLastError]));
end;

procedure TSmollTelegramBot.SetKeyAndChat(BotKey: string; ChatID: UInt64);
begin
  fHazKey := true;
  fUrl := Format(cUrl, [BotKey, ChatID]);
end;

function TSmollTelegramBot.SendMessage(msg: string): string;
var
  vUrl: PChar;
  vHIOU: HINTERNET;
  vJSONstring: string;
  vBytesRead: cardinal;
  JSonValue: TJSonValue;
  vBuffer: array [0 .. 10240] of byte;
begin
  if not fHazKey then
    Exit(string.Empty);

  vUrl := PChar(fUrl + TURLEncoding.URL.EncodeQuery(UTF8Encode(msg), [byte('&')]));

  vHIOU := InternetOpenUrl(fHIO, PChar(vUrl), nil, 0, 0, INTERNET_FLAG_RELOAD);
  if Assigned(vHIOU) then
    try
      // there should be a loop here but the reply is the json of the message sent so max size should be a bit more than 4kb
      // maxmessagelength(4096) + other stuff like ids, name, date, etc...
      if not InternetReadFile(vHIOU, @vBuffer, SizeOf(vBuffer), vBytesRead) then
        ShowError(Format('InternetReadFile(vHIOU) > FAIL [%d]', [GetLastError]))
      else
        vJSONstring := TEncoding.ANSI.GetString(vBuffer).Trim;
    finally
      if not InternetCloseHandle(vHIOU) then
        ShowError(Format('InternetCloseHandle(vHIOU) > FAIL [%d]', [GetLastError]));
    end
  else
    ShowError(Format('InternetOpenUrl > FAIL [%d]', [GetLastError]));

  writeln(vUrl + #1310 + vJSONstring + #1310);

  // to only check if sent or not theres no need for json stuff just check if the reply start with {"ok":false or {"ok":true
  if not string.IsNullOrEmpty(vJSONstring) then
    try
      JSonValue := TJSonObject.ParseJSONValue(vJSONstring);
      if JSonValue.GetValue<string>('ok').Equals('false') then
        result := (Format('Error code [%d] <%s>', [JSonValue.GetValue<integer>('error_code'), JSonValue.GetValue<string>('description')]))
      else
        result := Format('Message sent from <%s> to <%s> @ ', [JSonValue.GetValue<string>('result.from.username'), JSonValue.GetValue<string>('result.chat.username'), FormatDateTime('dd/MM/yyyy HH:NN:ss', (JSonValue.GetValue<integer>('result.date') / SecsPerDay) + UnixDateDelta)]);
    finally
      JSonValue.Free;
    end;
end;

destructor TSmollTelegramBot.Destroy;
begin
  writeln('TSmollTelegramBot Q_Q/');
  if Assigned(fHIO) then
    if not InternetCloseHandle(fHIO) then
      ShowError(Format('InternetCloseHandle(fHIO) > FAIL [%d]', [GetLastError]));
  inherited Destroy;
end;

end.
