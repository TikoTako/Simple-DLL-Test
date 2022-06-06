unit ThreadUnit;

interface

uses
  System.Classes,
  CommonUnit;

type
  TSomeThread = class(TThread)
  public
    procedure Execute(); override;
  end;

var
  gCallBack: procedure(CallBackData: TCallBackData);

implementation

procedure CallBack(CallBackData: TCallBackData);
begin
  if Assigned(gCallBack) then
    TThread.Synchronize(nil,
      procedure()
      begin
        CallBackData.SomeCardinal2 := TThread.CurrentThread.ThreadID;
        gCallBack(CallBackData);
      end);
end;

procedure TSomeThread.Execute();
var
  vCBD: TCallBackData;
begin
  vCBD.SomeCardinal := ThreadID;
  CallBack(vCBD);
end;

end.
