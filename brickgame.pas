unit brickgame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DB, ADODB, hsframeA, InputName, winForm, dialog,
  WinSkinData, Buttons;

type

  // �����˶�״̬
  BoardMoveStatus = (up, down, stop);
  // ��Ϸ״̬
  GameStatus = (init, inGame, pause, dead, load, win, dbError, allOver,
    unkonwn);

  // ש�����
  GameButton = class(TSpeedButton)
  public
    // x�ٶȺ�y�ٶ�
    speedx, speedy: integer;
    // �����ײ
    procedure checkContact(var X: integer; var Y: integer);
    // �߿���ײ
    procedure checkPenalContact(var tempLeft: integer; var tempTop: integer);
    // ������ײ����
    procedure BorderContact(var tempLeft: integer; var tempTop: integer);
   // procedure contacted;
    procedure move;
  end;

  // ש��
  BrickButton = class(GameButton)
  public
    heart, reward: integer; // Ѫ������Ʒ
    backGround: TImage;
    procedure contacted;
    procedure setColor;
    constructor create(AOwner: Tcomponent); override;
    destructor destroy; override;
    // ������Ʒ
    procedure createReward(rwdType: integer);
  end;

  // ��Ʒ
  RewardButton = class(GameButton)
  public
    rewardtype: integer;
    procedure BorderContact(var tempLeft: integer; var tempTop: integer);
    constructor create(AOwner: Tcomponent); override;
    destructor destroy; override;
  end;

  // ����
  BoardButton = class(GameButton)
  public
    boardSpeed: integer;
    canControl: boolean;
    bms: BoardMoveStatus;
    procedure moveBoard;
    constructor create(AOwner: Tcomponent); override;
    destructor destroy; override;
  end;

  // ��
  ballButton = class(GameButton)
  public

    constructor create(AOwner: Tcomponent); override;
    // �����ײ
    procedure checkContact(var X: integer; var Y: integer);
    destructor destroy; override;
    procedure BorderContact(var tempLeft: integer; var tempTop: integer);
  end;

  TMainForm = class(TForm)
    // ��Ϸ���
    gamePanel: TPanel;
    // ��֡����ʱ��
    frameControl: TTimer;
    // ״̬
    statusText: TLabel;
    // ado����
    cnnSqlite: TADOConnection;
    // �߷ְ�ť
    highScoreButton: TButton;
    // ado��ѯ
    sQry: TADOQuery;
    // ��������
    scoreLabel: TLabel;
    // �ؿ�����
    Stage: TLabel;
    // ʣ��ש������
    brickleftlabel: TLabel;
    Button1: TButton;
    SkinData1: TSkinData;
    // ����¼�����Ϸ������ƶ������Ƶ����ƶ�״̬��
    procedure gamePanelMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    // ��ʼ��
    procedure initGame;
    // �����ƶ�
    procedure ballsmove;
    // ����
    procedure gamedead;
    // ���عؿ�
    function loadStage(stageName: string): boolean;
    // ��Ϸ״̬������
    procedure load(stageName: string);
    // �ͷ���Ϸ����
    procedure freeStageRes;
    // �����Ƿ��ཻ���ж��Ƿ���ײ��
    function isRecInteracted(rectX, rectY, rectWidth, rectHeight, objX, objY,
      objWidth, objHeight: integer): boolean;
    // �ػ����
    procedure drawScore;
    // ����ש��
    procedure createBrick(X, Y, w, h, ht, rwd: integer);
    // ״̬�л�
    procedure switchStatus(curStatus, nextStatus: GameStatus);
    // ��֡
    procedure frameControlTimer(Sender: TObject);
    // ��������Ϸ��壨��������״̬��
    procedure gamePanelEnter(Sender: TObject);
    // ����뿪��Ϸ��壨�رտ���״̬��
    procedure gamePanelExit(Sender: TObject);
    procedure statusTextClick(Sender: TObject);
    procedure highScoreButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    // �Ƿ�����
    function checkDead: boolean;
    // �Ƿ�Ӯ��
    function checkWin: boolean;
    procedure Button1Click(Sender: TObject);
    procedure rePaintBricks;
    procedure updateBoardMoveStatus;
    procedure updateRewards;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  // ��ǰ��Ϸ״̬
  gs: GameStatus = GameStatus.init;
  // ��һ����Ϸ״̬
  lastStatus: GameStatus = GameStatus.unkonwn;
  // �����Կ���flag
  canControl: boolean = false;
  // ����
  board: BoardButton;
  // ��
  ball: ballButton;
  // ����
  score: integer = 0;
  // ��ͣ
  timerpause: boolean = false;
  // ��Ϸ��״̬
  subStatus: integer = 0;
  // ��Ϸ�ؿ�
  stageCount: integer = 1;
  // �ؿ����ƣ�Ϊ��Ӧ�Զ���ؿ���
  stageName: string;
  // ʣ��ש����
  brickLeft: integer;
  // ������
  ballCount: integer;
  // ��Ʒ����
  rewardCount: integer;
  // ����ڵ�ǰgamepenal��λ��
  curMousePos: TPoint;

implementation

{$R *.dfm}

procedure TMainForm.updateRewards;
var
  rwd: RewardButton;
  i: integer;
begin
  for i := 0 to ComponentCount - 1 do
    if components[i] is RewardButton then
    begin
      rwd := RewardButton(components[i]);
      rwd.move;
    end;
end;

procedure TMainForm.updateBoardMoveStatus;
begin
  if board = nil then
    exit;
  if curMousePos.Y > board.Top + board.height then
    board.bms := BoardMoveStatus.down
  else if curMousePos.Y < board.Top then
    board.bms := BoardMoveStatus.up
  else
    board.bms := BoardMoveStatus.stop
end;

procedure GameButton.checkPenalContact(var tempLeft: integer;
  var tempTop: integer);
begin
  if tempLeft < board.Left + board.width then
    if board.Top < tempTop + height then
      if board.Top > tempTop - board.height then
      begin
        BorderContact(tempLeft, tempTop);
      end;
  if tempTop < 0 then
  begin
    tempTop := 0;
    speedy := -speedy;
  end;
  if parent <> nil then
    if tempTop + height > parent.height then
    begin
      tempTop := parent.height - height;
      speedy := -speedy;
    end;
  if parent <> nil then
    if tempLeft + width > parent.width then
    begin
      tempLeft := parent.width - width;
      speedx := -speedx;
    end;
  Top := tempTop;
  Left := tempLeft;
  if tempLeft + width < 0 then
  begin
    free;
  end;
end;

procedure GameButton.move;
var
  tempTop, tempLeft: integer;
begin
  tempTop := Top + speedy;
  tempLeft := Left + speedx;
  checkContact(tempLeft, tempTop);
  checkPenalContact(tempLeft, tempTop);

end;

procedure GameButton.BorderContact(var tempLeft, tempTop: integer);
begin ;
end;

procedure GameButton.checkContact(var X: integer; var Y: integer);
var
  i, xOff, yOff, xNow, yNow: integer;
  af: double;
  br: BrickButton;
  isContact: boolean;
begin
  if X <> Left then
    af := (Y - Top) / (X - Left);
  if Left < X then
  begin
    for xNow := Left to X do
    begin
      yNow := Y + round((xNow - X) * af);
      for i := brickgame.MainForm.ComponentCount - 1 downto 0 do
      begin
        br := nil;
        if (brickgame.MainForm.components[i] is BrickButton) then
        begin
          isContact := false;
          br := BrickButton(brickgame.MainForm.components[i]);
          isContact := brickgame.MainForm.isRecInteracted(xNow, yNow, width,
            height, br.Left, br.Top, br.width, br.height);
          if isContact then
          begin
            X := xNow;
            Y := yNow;
            if speedx < 0 then
              xOff := br.Left + br.width - X
            else
              xOff := X - br.Left;
            if br <> nil then
            begin
              if speedy < 0 then
                yOff := br.Top + br.height - Y
              else
                yOff := Y - br.Top;
              if speedy = 0 then
              begin
                speedx := -speedx;
                X := br.Left - br.width;
                Y := yNow + round((X - xNow) * af);
              end
              else if xOff / abs(speedx) > yOff / abs(speedy) then
              begin
                speedy := -speedy;
              end
              else
              begin
                speedx := -speedx;
                X := br.Left - br.width;
                Y := yNow + round((X - xNow) * af);
              end;
              br.contacted;
              exit;
            end;
          end;
        end;
      end;
    end;
  end
  else if Left > X then
  begin
    for xNow := Left downto X do
    begin
      yNow := Y + round((xNow - X) * af);
      for i := brickgame.MainForm.ComponentCount - 1 downto 0 do
      begin
        br := nil;
        if (brickgame.MainForm.components[i] is BrickButton) then
        begin
          isContact := false;
          br := BrickButton(brickgame.MainForm.components[i]);
          isContact := brickgame.MainForm.isRecInteracted(xNow, yNow, width,
            height, br.Left, br.Top, br.width, br.height);
          if isContact then
          begin
            X := xNow;
            Y := yNow;
            if speedx < 0 then
              xOff := br.Left + br.width - X
            else
              xOff := X - br.Left;
            if speedy < 0 then
              yOff := br.Top + br.height - Y
            else
              yOff := Y - br.Top;
            if br <> nil then
            begin
              if speedy = 0 then
              begin
                speedx := -speedx;
                X := br.Left + br.width;
                Y := yNow + round((X - xNow) * af);
              end
              else if xOff / abs(speedx) > yOff / abs(speedy) then
              begin
                speedy := -speedy;
              end
              else
              begin
                speedx := -speedx;
                X := br.Left + br.width;
                Y := yNow + round((X - xNow) * af);
              end;
              br.contacted;
              exit;
            end;
          end;
        end;
      end;
    end;
  end;
end;


procedure BrickButton.contacted;
begin
  heart := heart - 1;
  score := score + 1;
  setColor;
  if heart = 0 then
  begin
    createReward(reward);
    free;
  end;
end;

// ������Ʒ
procedure BrickButton.createReward(rwdType: integer);
var
  reward: RewardButton;
begin
  reward := RewardButton.create(self.parent.parent);
  reward.parent := self.parent;
  reward.rewardtype := rwdType;
  reward.speedx := -Random(3);
  reward.speedy := Random(10);
  reward.width := 10;
  reward.height := 10;
  reward.Top := Top + height div 2 - reward.height div 2;
  reward.Left := Left - reward.width;
end;

procedure TMainForm.rePaintBricks;
var
  i: integer;
  br: BrickButton;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if components[i] is BrickButton then
    begin
      br := BrickButton(components[i]);
      br.setColor;
    end;
  end;
end;

procedure TMainForm.createBrick(X, Y, w, h, ht, rwd: integer);
var
  brick: BrickButton;
begin
  brick := BrickButton.create(self);
  brick.parent := gamePanel;
  brick.Left := X;
  brick.Top := Y;
  brick.width := w;
  brick.height := h;
  brick.heart := ht;
  brick.reward := rwd;
end;

procedure BrickButton.setColor;
var
  pic: TRect;
begin
  pic.Left := 1;
  pic.right := width - 1;
  pic.Top := 1;
  pic.Bottom := height - 1;
  case heart of
    1:
      begin
        canvas.Brush.color := clred;
        canvas.FillRect(pic);
      end;
    2:
      begin
        canvas.Brush.color := clblue;
        canvas.FillRect(pic);
      end;
    3:
      begin
        canvas.Brush.color := clyellow;
        canvas.FillRect(pic);
      end;
    4:
      begin
        canvas.Brush.color := clAqua;
        canvas.FillRect(pic);
      end;
  end;
end;

constructor BrickButton.create(AOwner: Tcomponent);
begin
  inherited create(AOwner);
  self.Transparent := true;
  brickgame.brickLeft := brickgame.brickLeft + 1;
end;

destructor BrickButton.destroy;
begin
  brickgame.brickLeft := brickgame.brickLeft - 1;
  inherited destroy;
end;


constructor BoardButton.create(AOwner: Tcomponent);
begin
  inherited create(AOwner);
  self.width := 10;
  self.height := 60;
  self.Caption := '';
end;

destructor BoardButton.destroy;
begin
  inherited destroy;
end;

procedure RewardButton.BorderContact(var tempLeft, tempTop: integer);
begin ;
end;

constructor RewardButton.create(AOwner: Tcomponent);
begin
  inherited create(AOwner);
  self.Transparent := true;
  brickgame.rewardCount := brickgame.rewardCount + 1;
end;

destructor RewardButton.destroy;
begin
  brickgame.rewardCount := brickgame.rewardCount - 1;
  inherited destroy;
end;

constructor ballButton.create(AOwner: Tcomponent);
begin
  inherited create(AOwner);
  self.width := 10;
  self.height := 10;
  brickgame.ballCount := brickgame.ballCount + 1;
end;

destructor ballButton.destroy;
begin
  brickgame.ballCount := brickgame.ballCount - 1;
  inherited destroy;
end;

procedure ballButton.BorderContact(var tempLeft: integer; var tempTop: integer);
begin
  tempLeft := board.Left + board.width;
  speedx := -speedx;
  case board.bms of
    BoardMoveStatus.up:
      speedy := speedy - 1;
    BoardMoveStatus.down:
      speedy := speedy + 1;
  end;
end;

procedure ballButton.checkContact(var X: integer; var Y: integer);
var
  i, xOff, yOff, xNow, yNow: integer;
  af: double;
  br: BrickButton;
  isContact: boolean;
begin
  if X <> Left then
    af := (Y - Top) / (X - Left);
  if Left < X then
  begin
    for xNow := Left to X do
    begin
      yNow := Y + round((xNow - X) * af);
      for i := brickgame.MainForm.ComponentCount - 1 downto 0 do
      begin
        br := nil;
        if (brickgame.MainForm.components[i] is BrickButton) then
        begin
          isContact := false;
          br := BrickButton(brickgame.MainForm.components[i]);
          isContact := brickgame.MainForm.isRecInteracted(xNow, yNow, width,
            height, br.Left, br.Top, br.width, br.height);
          if isContact then
          begin
            X := xNow;
            Y := yNow;
            if speedx < 0 then
              xOff := br.Left + br.width - X
            else
              xOff := X - br.Left;
            if br <> nil then
            begin
              if speedy < 0 then
                yOff := br.Top + br.height - Y
              else
                yOff := Y - br.Top;
              if speedy = 0 then
              begin
                speedx := -speedx;
                X := br.Left - br.width;
                Y := yNow + round((X - xNow) * af);
              end
              else if xOff / abs(speedx) > yOff / abs(speedy) then
              begin
                speedy := -speedy;
              end
              else
              begin
                speedx := -speedx;
                X := br.Left - br.width;
                Y := yNow + round((X - xNow) * af);
              end;
              br.contacted;
              exit;
            end;
          end;
        end;
      end;
    end;
  end
  else if Left > X then
  begin
    for xNow := Left downto X do
    begin
      yNow := Y + round((xNow - X) * af);
      for i := brickgame.MainForm.ComponentCount - 1 downto 0 do
      begin
        br := nil;
        if (brickgame.MainForm.components[i] is BrickButton) then
        begin
          isContact := false;
          br := BrickButton(brickgame.MainForm.components[i]);
          isContact := brickgame.MainForm.isRecInteracted(xNow, yNow, width,
            height, br.Left, br.Top, br.width, br.height);
          if isContact then
          begin
            X := xNow;
            Y := yNow;
            if speedx < 0 then
              xOff := br.Left + br.width - X
            else
              xOff := X - br.Left;
            if speedy < 0 then
              yOff := br.Top + br.height - Y
            else
              yOff := Y - br.Top;
            if br <> nil then
            begin
              if speedy = 0 then
              begin
                speedx := -speedx;
                X := br.Left + br.width;
                Y := yNow + round((X - xNow) * af);
              end
              else if xOff / abs(speedx) > yOff / abs(speedy) then
              begin
                speedy := -speedy;
              end
              else
              begin
                speedx := -speedx;
                X := br.Left + br.width;
                Y := yNow + round((X - xNow) * af);
              end;
              br.contacted;
              exit;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
var
  newBall: ballButton;
begin
  newBall := ballButton.create(self);
  newBall.parent := gamePanel;
  newBall.Top := 50;
  newBall.Left := 300;
  newBall.speedx := 5;
  newBall.speedy := 1;
end;

procedure TMainForm.ballsmove;
var
  i: integer;
  ball: ballButton;
begin
  for i := ComponentCount - 1 downto 0 do
  begin
    if components[i] is ballButton then
    begin
      ball := ballButton(components[i]);
      ball.move;
    end;
  end;
end;

function TMainForm.checkDead: boolean;
begin
  if ballCount = 0 then
    switchStatus(gs, GameStatus.dead)
end;

function TMainForm.checkWin: boolean;
begin
  if brickLeft = 0 then
    switchStatus(gs, GameStatus.win);
end;

function TMainForm.isRecInteracted(rectX, rectY, rectWidth, rectHeight, objX,
  objY, objWidth, objHeight: integer): boolean;
begin
  if ((rectX + rectWidth > objX) and (rectX < objX + objWidth) and
      (rectY + rectHeight > objY) and (rectY < objY + objHeight)) then

    result := true
  else
    result := false;
end;

procedure TMainForm.freeStageRes;
var
  i: integer;
begin
  case subStatus of
    0:
      begin
        for i := ComponentCount - 1 downto 0 do
          if (components[i] is BrickButton) or (components[i] is ballButton)
            then
          begin
            components[i].free;
          end;
        subStatus := subStatus + 1;
      end;
  end;
end;

procedure TMainForm.load(stageName: string);
var
  isLoadSucceed: boolean;
begin
  try
    isLoadSucceed := loadStage(stageName) except on e: exception
    do
    begin
      switchStatus(gs, dbError);
      exit;
    end;
  end;
  if isLoadSucceed then
    switchStatus(gs, inGame)
  else
    switchStatus(gs, allOver);
end;

function TMainForm.loadStage(stageName: string): boolean;
var
  icount, i: integer;
begin
  try
    if cnnSqlite.Connected = false then
      cnnSqlite.open;
    if sQry.Active then
      sQry.Close;
    sQry.sql.clear;
    sQry.sql.text := 'select * from stage where stageName =' + stageName;
    sQry.open;
    icount := sQry.RecordCount;
    for i := 0 to icount - 1 do
    begin
      createBrick(sQry.FieldByName('xpos').AsInteger,
        sQry.FieldByName('ypos').AsInteger,
        sQry.FieldByName('width').AsInteger,
        sQry.FieldByName('height').AsInteger,
        sQry.FieldByName('heart').AsInteger,
        sQry.FieldByName('reward').AsInteger);
      sQry.Next;
    end;
  finally
    cnnSqlite.Close;
  end;
  if icount = 0 then
    result := false
  else
    result := true;
end;

procedure TMainForm.switchStatus(curStatus, nextStatus: GameStatus);
begin
  subStatus := 0;
  if nextStatus = GameStatus.dbError then
  begin
    if dialogForm = nil then
      dialogForm := TdialogForm.create(self);
    dialogForm.DialogText.Caption := '���ݶ�ȡ���������ļ�ȱʧ';
    gs := GameStatus.dbError;
    dialogForm.show;
  end;
  if curStatus = GameStatus.win then
  begin
    if nextStatus = GameStatus.init then
    begin
      winforma.Close;
      stageCount := stageCount + 1;
      gs := GameStatus.init;
    end;
  end;
  if curStatus = GameStatus.inGame then
  begin
    if nextStatus = GameStatus.dead then
    begin
      statusText.Caption := '��Ϸ����';
      if inputNameDialog = nil then
        inputNameDialog := TInputNameDialog.create(self);
      inputNameDialog.show;
      gs := GameStatus.dead;
    end
    else if nextStatus = GameStatus.win then
    begin
      statusText.Caption := 'ʤ��';
      if winforma = nil then
        winforma := TwinFormA.create(self);
      gs := GameStatus.win;
      winforma.show;
    end;
  end;

  if curStatus = GameStatus.init then
  begin
    if nextStatus = GameStatus.inGame then
    begin
      statusText.Caption := '��Ϸ��';
      gs := GameStatus.inGame;
    end
    else if nextStatus = GameStatus.load then
    begin
      statusText.Caption := '������';
      gs := GameStatus.load;
    end;
  end;

  if curStatus = GameStatus.load then
  begin
    if nextStatus = GameStatus.inGame then
    begin
      statusText.Caption := '��Ϸ��';
      gs := GameStatus.inGame;
    end
    else if nextStatus = allOver then
    begin
      statusText.Caption := '����������йؿ���';
      if winforma = nil then
      begin
        winforma := TwinFormA.create(self);
      end;
      gs := GameStatus.allOver;
      winforma.show;
    end;

  end;

  if curStatus = GameStatus.dead then
    if nextStatus = GameStatus.init then
    begin
      statusText.Caption := '��Ϸ��';
      gs := GameStatus.init;
    end;
  if curStatus = GameStatus.inGame then
    if nextStatus = GameStatus.pause then
    begin
      statusText.Caption := '��ͣ';
      gs := GameStatus.pause;
    end;
  if curStatus = GameStatus.pause then
    if nextStatus = GameStatus.inGame then
    begin
      statusText.Caption := '��Ϸ��';
      gs := GameStatus.inGame;
    end;
  if curStatus = GameStatus.allOver then
    if nextStatus = GameStatus.init then
    begin
      stageCount := 1;
      statusText.Caption := '��ʼ��';
      gs := GameStatus.init;
    end;
  lastStatus := curStatus;
end;

procedure TMainForm.gamedead;
begin ;
  stageCount := 1;
  stageName := intToStr(stageCount);
end;

procedure TMainForm.initGame;
var
  i: integer;
begin
  statusText.Caption := '��ʼ��';
  // �ӹ��ع����Ļ�Ҫ�̳з���
  if lastStatus <> GameStatus.win then
    score := 0;

  stageName := intToStr(stageCount);
  for i := ComponentCount - 1 downto 0 do
  begin
    if (components[i] is BrickButton) or (components[i] is ballButton) or
      (components[i] is BoardButton) then
      components[i].free;
  end;
  board := BoardButton.create(self);
  ball := ballButton.create(self);
  ball.parent := gamePanel;
  ball.Top := 50;
  ball.Left := 300;
  ball.speedx := 5;
  ball.speedy := 1;
  board.parent := gamePanel;
  board.Left := 1;
  board.boardSpeed := 5;
  board.canControl := true;
  board.bms := BoardMoveStatus.stop;
  board.Top := gamePanel.height div 2 - board.height div 2;
  switchStatus(gs, GameStatus.load);
end;

procedure BoardButton.moveBoard;
begin

  if board = nil then
    exit;
  if not canControl then
    exit;
  case bms of
    BoardMoveStatus.up:
      if Top > 0 then
        Top := Top - boardSpeed;
    BoardMoveStatus.down:
      if Top + height < parent.height then
        Top := Top + boardSpeed;
    BoardMoveStatus.stop:
      ;
  end;
end;

procedure TMainForm.highScoreButtonClick(Sender: TObject);
begin
  if highScoreForm = nil then
    highScoreForm := ThighScoreForm.create(self);
  highScoreForm.show;
  highScoreForm.qeuryHighScore;
  switchStatus(gs, GameStatus.pause);
end;

procedure TMainForm.drawScore;
begin
  scoreLabel.Caption := 'score:' + intToStr(score);
  brickleftlabel.Caption := 'ʣ��ש�飺' + intToStr(brickLeft);
  Stage.Caption := '��' + stageName + '��';
end;

procedure TMainForm.statusTextClick(Sender: TObject);
begin
  if gs = GameStatus.dead then
    gs := init;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin ;
end;

procedure TMainForm.frameControlTimer(Sender: TObject);
begin
  if timerpause then
    exit;
  case gs of
    GameStatus.init:
      begin
        drawScore;
        initGame;
      end;
    GameStatus.win:
      begin
        freeStageRes;
      end;
    GameStatus.inGame:
      begin
        rePaintBricks;
        updateBoardMoveStatus;
        board.moveBoard;
        ballsmove;
        updateRewards;
        drawScore;
        checkWin;
        checkDead;
      end;
    GameStatus.dead:
      begin
        gamedead;
        freeStageRes;
      end;
    GameStatus.pause:
      ;
    GameStatus.load:
      load(stageName);
  end;

end;

procedure TMainForm.gamePanelEnter(Sender: TObject);
begin
  canControl := true;
end;

procedure TMainForm.gamePanelExit(Sender: TObject);
begin
  canControl := false;
end;

procedure TMainForm.gamePanelMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  curMousePos.X := X;
  curMousePos.Y := Y;
end;

end.
