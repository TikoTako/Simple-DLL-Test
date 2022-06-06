unit CommonUnit;

interface

type
  TVersion = packed record
    Name: PChar;
    Major: integer;
    Minor: integer;
  end;

  TCallBackData = packed record
    SomeString: PChar;
    SomeInt: integer;
    SomeFloat: single;
    SomeCardinal: Cardinal;
    SomeCardinal2: Cardinal;
  end;

  TOnCallBack = procedure(CallBackData: TCallBackData); stdcall;

implementation

end.
