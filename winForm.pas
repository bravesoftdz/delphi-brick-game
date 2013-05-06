unit winForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TwinFormA = class(TForm)
    nextStage: TButton;
    Label1: TLabel;
    procedure nextStageClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  winFormA: TwinFormA;

implementation

uses
  brickgame,InputName;
{$R *.dfm}

procedure TwinFormA.FormShow(Sender: TObject);
begin
  with brickgame.MainForm do
  begin
    case gs of
      win:
        begin
          winFormA.caption := '���أ�';
          winFormA.nextStage.caption := '��һ��';
          winFormA.Label1.caption := '��ϲ�������';
        end;
      allover:
        begin
          winFormA.caption := '��ϲ����������йؿ�';
          winFormA.nextStage.caption := 'ȷ��';
          winFormA.Label1.caption := '��ϲ����������йؿ�';
        end;
    end;

  end;
end;

procedure TwinFormA.nextStageClick(Sender: TObject);
begin
  with brickgame.MainForm do
  begin
    case gs of
      win:
        switchstatus(gs, gamestatus.init);
      allover:
        begin
          statusText.caption := '��Ϸ����';
          if inputNameDialog = nil then
            inputNameDialog := TInputNameDialog.Create(brickgame.MainForm);
          inputNameDialog.show;
          winFormA.close;
        end;
    end;
  end;
end;

end.
