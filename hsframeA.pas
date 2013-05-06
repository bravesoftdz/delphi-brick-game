unit hsframeA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB;

type
  ThighScoreForm = class(TForm)
    highscoreText: TMemo;
    confirm: TButton;
    clear: TButton;
    procedure qeuryHighScore;
    procedure confirmClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  highScoreForm: ThighScoreForm;
  hsRecordset: Variant;

implementation

uses
  brickgame;
{$R *.dfm}

procedure ThighScoreForm.confirmClick(Sender: TObject);
begin
  close;
end;

procedure ThighScoreForm.qeuryHighScore;
var
  icount, i: integer;
begin
  with brickgame.MainForm do
    try
      if cnnSqlite.Connected = false then
        cnnSqlite.open;
      if sQry.Active then
        sQry.close;
      sQry.sql.clear;
      sQry.sql.text := 'select * from highscore order by score desc';
      sQry.open;
      icount := sQry.RecordCount;
      highscoreText.text := 'playerName' + chr(9) + 'score';
      for i := 0 to icount - 1 do
      begin
        highscoreText.text := highscoreText.text + chr(13) + chr(10) + chr(9)
          + sQry.FieldByName('playerName').AsString + chr(9) + sQry.FieldByName
          ('score').AsString;
        sQry.Next;
      end;
    finally
      cnnSqlite.close;
    end;
end;

procedure ThighScoreForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with brickgame.MainForm do
    switchStatus(gs, gamestatus.inGame);
end;

procedure ThighScoreForm.FormCreate(Sender: TObject);
begin
  try
    qeuryHighScore;
  except
    on e: Exception do
    begin
      with brickgame.MainForm do
        switchStatus(gs, dbError);
    end;
  end;
end;

end.
