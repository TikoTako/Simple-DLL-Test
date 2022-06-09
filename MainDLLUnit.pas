unit MainDLLUnit;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.IOUtils, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TDLLForm = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BotKeyEdit: TEdit;
    ChatIDEdit: TEdit;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DLLForm: TDLLForm;
  BotDataFile: string;

implementation

{$R *.dfm}

procedure TDLLForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ModalResult = mrOk then
    try
      StrToInt64(DLLForm.ChatIDEdit.Text); // failing this will cause the exception and skip the saving
      if FileExists(BotDataFile) then
        TFile.Delete(BotDataFile);
      TFile.WriteAllText(BotDataFile, DLLForm.BotKeyEdit.Text + #13#10 + DLLForm.ChatIDEdit.Text);
    except
      ModalResult := mrClose;
    end;
end;

end.
