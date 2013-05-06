unit InputName;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TInputNameDialog = class(TForm)
    NameLabel: TLabel;
    NameInputText: TEdit;
    inputNameConfirm: TButton;
    inputNameCacel: TButton;
    inputNameLabel: TLabel;
    procedure inputNameConfirmClick(Sender: TObject);
    procedure inputNameCacelClick(Sender: TObject);
    procedure insertHighScore;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InputNameDialog: TInputNameDialog;

implementation

uses
  brickgame;
{$R *.dfm}

procedure TInputNameDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with brickgame.mainform do
  begin
    case substatus of
      0:
        begin
          switchStatus(gs, GameStatus.init);
        end;
      1:
        brickgame.mainform.Close;
    end;
  end;
end;

procedure TInputNameDialog.inputNameCacelClick(Sender: TObject);
begin
  Close;
end;

procedure TInputNameDialog.inputNameConfirmClick(Sender: TObject);
begin
  with brickgame.mainform do
  begin
    case substatus of
      0:
        begin
          insertHighScore;
          statusText.Caption := '保存成功，再来一局？';
          inputNameLabel.Caption := '保存成功，再来一局？';
          substatus := substatus + 1;
          exit;
        end;
      1:
        begin
          switchStatus(gs, GameStatus.init);
          inputNameLabel.Caption := '游戏结束，输入你的大名';
          InputNameDialog.Close;
        end;
    end;
  end;
end;

procedure TInputNameDialog.insertHighScore;
begin
  if NameInputText.text = '' then
    NameInputText.text := '匿名';
  with brickgame.mainform do
    try
      if cnnSqlite.Connected = false then
        cnnSqlite.open;
      if sQry.Active then
        sQry.Close;
      sQry.sql.clear;
      sQry.sql.text := 'select * from highscore';
      sQry.open;
      sQry.Append;
      sQry.FieldByName('playerName').AsString := NameInputText.text;
      sQry.FieldByName('score').AsInteger := score;
      sQry.Post;
    finally
      cnnSqlite.Close;
    end;
end;

end.
