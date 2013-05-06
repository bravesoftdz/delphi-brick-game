unit dialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TdialogForm = class(TForm)
    DialogText: TLabel;
    DialogOK: TButton;
    procedure DialogOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dialogForm: TdialogForm;

implementation

{$R *.dfm}

uses
  brickgame;

procedure TdialogForm.DialogOKClick(Sender: TObject);
begin
  with brickgame.MainForm do
    case gs of
      gamestatus.dbError:
        Free;
    end;
end;

end.
