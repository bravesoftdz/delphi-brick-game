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
          winFormA.caption := '过关！';
          winFormA.nextStage.caption := '下一关';
          winFormA.Label1.caption := '恭喜你过关啦';
        end;
      allover:
        begin
          winFormA.caption := '恭喜你完成了所有关卡';
          winFormA.nextStage.caption := '确定';
          winFormA.Label1.caption := '恭喜你完成了所有关卡';
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
          statusText.caption := '游戏结束';
          if inputNameDialog = nil then
            inputNameDialog := TInputNameDialog.Create(brickgame.MainForm);
          inputNameDialog.show;
          winFormA.close;
        end;
    end;
  end;
end;

end.
