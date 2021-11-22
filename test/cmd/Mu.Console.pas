unit Mu.Console;

interface

uses
  System.SysUtils, winapi.windows, winapi.messages,

  Mu.charshelper, strutils, Mu.LookPool,
  System.Console, Generics.Collections, TypInfo,
  System.Classes, System.UITypes, Mu.Console.params,
  EasyConsole.Input,
  EasyConsole.Output,
  EasyConsole.Types;

var
  pubColor: TConsoleColor = TConsoleColor.White;

type
  TMCKey = record
    Name: String;
    key: word;

  public
    class function create(aKey: word): TMCKey; overload; static;
    class function create(aKey: TConsoleKey): TMCKey; overload; static;
  end;

type

  TThread_help = class helper for TThread
  private
    function GetIsTerminated: Boolean;
  public
    property IsTerminated: Boolean read GetIsTerminated;
  end;

  TMPageType = (mptShow, mptMemu, mptInput);

  TMConsoleElec = record
    Left: smallint;
    Top: smallint;
    Color: TConsoleColor;
    bgColor: TConsoleColor;
    Text: string;
    IsLine: Boolean;
  end;

  TMConsolePool = TMuLockList<TMConsoleElec>;

  TMPage = class;
  TMPageShow = class;
  TMPageInput = class;
  TMPageClass = class of TMPage;
  TMPageShowClass = class of TMPageShow;
  TMPageInputClass = class of TMPageInput;

  TMPageList = Tlist<TMPage>;

  TMCControl = class
  private
    procedure SetColor(const Value: TConsoleColor);
  Protected
    FTop, FLeft: smallint;
    FVisible: Boolean;
    FColor: TConsoleColor;
  public
    constructor create(aLeft: smallint = -1; aTop: smallint = -1); virtual;
    procedure repaint; virtual; abstract;
    property Left: smallint read FLeft write FLeft;
    property Top: smallint read FTop write FTop;
    property Color: TConsoleColor read FColor write SetColor;
    property Visible: Boolean read FVisible write FVisible;
  end;

  TMCControls = Tlist<TMCControl>;

  TMPages = class(TMCControl)
  private
    function GetPageCount: integer;
    procedure SetActiveIndex(const Value: integer);
  Protected
    FPages: TMPageList;
    FActiveIndex: integer;
    FPageThread: TThread;
    FisWaitFree: Boolean;
    procedure ShowHeader;
    procedure HandleKey(aKey: TConsoleKey);
  public
    constructor create(aLeft: smallint = -1; aTop: smallint = -1); override;
    destructor Destroy; override;
    function ChangeToPage(i: integer): TMPage;
    function Add(const aCaption: String; const aHotKey: TConsoleKey = TConsoleKey.None;
      aPageType: TMPageType = TMPageType.mptShow): TMPage;

    procedure repaint; override;
    procedure Show(aActiveIndex: integer = -1);
    property PageCount: integer read GetPageCount;
    property Pages: TMPageList read FPages;
    property ActiveIndex: integer read FActiveIndex write SetActiveIndex;
    property PageThread: TThread read FPageThread;

    property isWaitFree: Boolean read FisWaitFree;
  end;

  TMPage = class(TMCControl)
  private
    procedure SetCaption(const Value: String);
    procedure setVisibled(const Value: Boolean); virtual;
  Protected
    FCaption: String;
    FHotKey: TConsoleKey;
    FPageType: TMPageType;
    FParent: TMPages;

    FVisibled: Boolean;
    FIndex: integer;
  public
    constructor create(aParent: TMPages; const aCaption: String; const aHotKey: TConsoleKey;
      aPageType: TMPageType); overload;

    destructor Destroy; override;
    procedure repaint; override;

    procedure Show(); virtual;
    procedure Hide(); virtual;

    property Caption: String read FCaption write SetCaption;
    property HotKey: TConsoleKey read FHotKey write FHotKey;
    property PageType: TMPageType read FPageType write FPageType;
    property Parent: TMPages read FParent;
    property visibled: Boolean read FVisibled write setVisibled;
    property ItemIndex: integer read FIndex write FIndex;
  end;

  TMPageShow = class(TMPage)
  Protected
    FControls: TMCControls;
    // procedure setVisibled(const Value: boolean); override;
    procedure AddControl(aControl: TMCControl);
  public
    constructor create(aParent: TMPages; const aCaption: String; const aHotKey: TConsoleKey); overload;
    procedure Show(); override;
    procedure Hide(); override;
    procedure repaint; override;
    destructor Destroy; override;

  end;

  TMCInputAction = reference to procedure(aCmdStr: String; aParams: TMCParams);
  TMCInputActions = TDictionary<String, TMCInputAction>;

  TMPageInput = class(TMPage)
  Protected
    FCmdThread: TThread;
    FActions: TMCInputActions;
    FPromp: String;
    procedure DoCmd(acmd: String);
    procedure WaitFor();
    procedure setVisibled(const Value: Boolean); override;
    procedure canclewaitfor();
  public
    constructor create(aParent: TMPages; const aCaption: String; const aHotKey: TConsoleKey); overload;
    destructor Destroy; override;
    procedure Show(); override;
    procedure Hide(); override;
    procedure repaint; override;
    procedure AddAction(acmd: String; aAct: TMCInputAction);
    property Promp: string read FPromp write FPromp;
  end;

  TMPageMemu = class(TMPage)
  public
    constructor create(aParent: TMPages; const aCaption: String; const aHotKey: TConsoleKey); overload;

  end;

  TMCLabel = class(TMCControl)
  private
    procedure SetCaption(const Value: String);
  Protected
    FParent: TMPageShow;
    FFormat: String;
    FCaption: String;
    FOldCaption: String;
  public
    constructor create(aParent: TMPageShow; aFormat: String; aLeft: smallint = -1; aTop: smallint = -1); overload;
    procedure repaint; override;
    property Caption: String read FCaption write SetCaption;
  end;

  TMProgressBar = class(TMCControl)
  private

    const
    SpinnerChars = '|/-\';
  private
    FEmptyChars: String;
    FActive: Boolean;
    FSpinnerCharIndex: integer;
    procedure drawSpinner;
    procedure SetPosition(const Value: integer);
    procedure start;
  Protected
    FThread: TThread;
    FTop, FLeft: smallint;
    FCaption: String;
    FColor: TConsoleColor;
    FWidth: integer;
    FPosition: integer;
    FShowPosition: Boolean;
    FShowSpinner: Boolean;
    FParent: TMPageShow;
  public
    constructor create(aParent: TMPageShow; aWidth: integer = 100; aShowSpinner: Boolean = true; aLeft: smallint = -1;
      aTop: smallint = -1); overload;
    destructor Destroy; override;
    procedure repaint; override;
    property Position: integer read FPosition write SetPosition;
    property ShowPosition: Boolean read FShowPosition write FShowPosition;
    property ShowSpinner: Boolean read FShowSpinner write FShowSpinner;

  end;

  TMConsoleShow = class
  private
    FConsolePool: TMConsolePool;
    FActive: Boolean;
    FThread: TThread;
    procedure start;

  public
    constructor create();
    destructor Destroy; override;
    procedure Stop;

    procedure Add(aText: String); overload;
    procedure Add(aColor: TConsoleColor; aText: String); overload;
    procedure Add(aColor, aBgColor: TConsoleColor; aText: String); overload;
    procedure Add(aColor: TConsoleColor; aText: String; aValue: array of const); overload;
    procedure Add(aColor, aBgColor: TConsoleColor; aText: String; aValue: array of const); overload;

    procedure Add(aLeft, aTop: smallint; aColor: TConsoleColor; aText: String); overload;
    procedure Add(aLeft, aTop: smallint; aColor: TConsoleColor; aText: String; aLine: Boolean); overload;
    procedure Add(aLeft, aTop: smallint; aColor: TConsoleColor; aBgColor: TConsoleColor; aText: String;
      aLine: Boolean); overload;

    procedure Add(aLeft, aTop: smallint; aColor: TConsoleColor; aText: String; aValue: array of const); overload;

    procedure AddLine(aText: String); overload;
    procedure AddLine(aColor: TConsoleColor; aText: String); overload;
    procedure AddLine(aColor, aBgColor: TConsoleColor; aText: String); overload;

    procedure AddLine(aColor: TConsoleColor; aText: String; aValue: array of const); overload;
    procedure AddLine(aColor, aBgColor: TConsoleColor; aText: String; aValue: array of const); overload;

    procedure AddLine(aLeft, aTop: smallint; aColor: TConsoleColor; aText: String); overload;
    procedure AddLine(aLeft, aTop: smallint; aColor: TConsoleColor; aText: String; aValue: array of const); overload;

    property ConsolePool: TMConsolePool read FConsolePool write FConsolePool;

  end;

var
  pubConsolePool: TMConsolePool;
  pubConsoleShow, mcs: TMConsoleShow;

implementation

const
  MCKeys: array [0 .. 144] of TMCKey = ((Name: 'Backspace'; key: vkBack), (Name: 'Tab'; key: vkTab), (Name: 'Clear';
    key: vkClear), (Name: 'Enter'; key: vkReturn), (Name: 'Pause'; key: vkPause), (Name: 'Escape'; key: vkEscape),
    (Name: 'Spacebar'; key: vkSpace), (Name: 'PageUp'; key: vkPrior), (Name: 'PageDown'; key: vkNext), (Name: '&End';
    key: vkEnd), (Name: 'Home'; key: vkHome), (Name: 'LeftArrow'; key: vkLeft), (Name: 'UpArrow'; key: vkUp),
    (Name: 'RightArrow'; key: vkRight), (Name: 'DownArrow'; key: vkDown), (Name: 'Select'; key: vkSelect),
    (Name: 'Print'; key: vkPrint), (Name: 'Execute'; key: vkExecute), (Name: 'PrintScreen'; key: vkSnapshot),
    (Name: 'Insert'; key: vkInsert), (Name: 'Delete'; key: vkDelete), (Name: 'Help'; key: vkHelp), (Name: 'D0';
    key: vk0), (Name: 'D1'; key: vk1), (Name: 'D2'; key: vk2), (Name: 'D3'; key: vk3), (Name: 'D4'; key: vk4),
    (Name: 'D5'; key: vk5), (Name: 'D6'; key: vk6), (Name: 'D7'; key: vk7), (Name: 'D8'; key: vk8), (Name: 'D9';
    key: vk9), (Name: 'A'; key: vkA), (Name: 'B'; key: vkB), (Name: 'C'; key: vkC), (Name: 'D'; key: vkD), (Name: 'E';
    key: vkE), (Name: 'F'; key: vkF), (Name: 'G'; key: vkG), (Name: 'H'; key: vkH), (Name: 'I'; key: vkI), (Name: 'J';
    key: vkJ), (Name: 'K'; key: vkK), (Name: 'L'; key: vkL), (Name: 'M'; key: vkM), (Name: 'N'; key: vkN), (Name: 'O';
    key: vkO), (Name: 'P'; key: vkP), (Name: 'Q'; key: vkQ), (Name: 'R'; key: vkR), (Name: 'S'; key: vkS), (Name: 'T';
    key: vkT), (Name: 'U'; key: vkU), (Name: 'V'; key: vkV), (Name: 'W'; key: vkW), (Name: 'X'; key: vkX), (Name: 'Y';
    key: vkY), (Name: 'Z'; key: vkZ), (Name: 'LeftWindows'; key: vkLWin), (Name: 'RightWindows'; key: vkRWin),
    (Name: 'Applications'; key: vkApps), (Name: 'Sleep'; key: vkSleep), (Name: 'NumPad0'; key: vkNumpad0),
    (Name: 'NumPad1'; key: vkNumpad1), (Name: 'NumPad2'; key: vkNumpad2), (Name: 'NumPad3'; key: vkNumpad3),
    (Name: 'NumPad4'; key: vkNumpad4), (Name: 'NumPad5'; key: vkNumpad5), (Name: 'NumPad6'; key: vkNumpad6),
    (Name: 'NumPad7'; key: vkNumpad7), (Name: 'NumPad8'; key: vkNumpad8), (Name: 'NumPad9'; key: vkNumpad9),
    (Name: 'Multiply'; key: vkMultiply), (Name: 'Add'; key: vkAdd), (Name: 'Separator'; key: vkSeparator),
    (Name: 'Subtract'; key: vkSubtract), (Name: 'Decimal'; key: vkDecimal), (Name: 'Divide'; key: vkDivide),
    (Name: 'F1'; key: vkF1), (Name: 'F2'; key: vkF2), (Name: 'F3'; key: vkF3), (Name: 'F4'; key: vkF4), (Name: 'F5';
    key: vkF5), (Name: 'F6'; key: vkF6), (Name: 'F7'; key: vkF7), (Name: 'F8'; key: vkF8), (Name: 'F9'; key: vkF9),
    (Name: 'F10'; key: vkF10), (Name: 'F11'; key: vkF11), (Name: 'F12'; key: vkF12), (Name: 'F13'; key: vkF13),
    (Name: 'F14'; key: vkF14), (Name: 'F15'; key: vkF15), (Name: 'F16'; key: vkF16), (Name: 'F17'; key: vkF17),
    (Name: 'F18'; key: vkF18), (Name: 'F19'; key: vkF19), (Name: 'F20'; key: vkF20), (Name: 'F21'; key: vkF21),
    (Name: 'F22'; key: vkF22), (Name: 'F23'; key: vkF23), (Name: 'F24'; key: vkF24), (Name: 'BrowserBack';
    key: vkBrowserBack), (Name: 'BrowserForward'; key: vkBrowserForward), (Name: 'BrowserRefresh';
    key: vkBrowserRefresh), (Name: 'BrowserStop'; key: vkBrowserStop), (Name: 'BrowserSearch'; key: vkBrowserSearch),
    (Name: 'BrowserFavorites'; key: vkBrowserFavorites), (Name: 'BrowserHome'; key: vkBrowserHome), (Name: 'VolumeMute';
    key: vkVolumeMute), (Name: 'VolumeDown'; key: vkVolumeDown), (Name: 'VolumeUp'; key: vkVolumeUp),
    (Name: 'MediaNext'; key: vkMediaNextTrack), (Name: 'MediaPrevious'; key: vkMediaPrevTrack), (Name: 'MediaStop';
    key: vkMediaStop), (Name: 'MediaPlay'; key: vkMediaPlayPause), (Name: 'LaunchMail'; key: vkLaunchMail),
    (Name: 'LaunchMediaSelect'; key: vkLaunchMediaSelect), (Name: 'LaunchApp1'; key: vkLaunchApp1), (Name: 'LaunchApp2';
    key: vkLaunchApp2), (Name: 'Oem1'; key: vkSemicolon), (Name: 'OemPlus'; key: vkEqual), (Name: 'OemComma';
    key: vkComma), (Name: 'OemMinus'; key: vkMinus), (Name: 'OemPeriod'; key: vkPeriod), (Name: 'Oem2'; key: vkSlash),
    (Name: 'Oem3'; key: vkTilde), (Name: 'Oem4'; key: vkLeftBracket), (Name: 'Oem5'; key: vkBackslash), (Name: 'Oem6';
    key: vkRightBracket), (Name: 'Oem7'; key: vkQuote), (Name: 'Oem8'; key: vkPara), (Name: 'Oem102'; key: vkOem102),
    (Name: 'Process'; key: vkProcessKey), (Name: 'Packet'; key: vkPacket), (Name: 'Attention'; key: vkAttn),
    (Name: 'CrSel'; key: vkCrsel), (Name: 'ExSel'; key: vkExsel), (Name: 'EraseEndOfFile'; key: vkErEof), (Name: 'Play';
    key: vkPlay), (Name: 'Zoom'; key: vkZoom), (Name: 'NoName'; key: vkNoname), (Name: 'Pa1'; key: vkPA1),
    (Name: 'OemClear'; key: vkOemClear), (Name: 'None'; key: vkNone));

  { TMPages }

function TMPages.Add(const aCaption: String; const aHotKey: TConsoleKey = TConsoleKey.None;
  aPageType: TMPageType = TMPageType.mptShow): TMPage;
begin
  case aPageType of
    TMPageType.mptShow:
      result := TMPageShow.create(self, aCaption, aHotKey);
    TMPageType.mptInput:
      result := TMPageInput.create(self, aCaption, aHotKey);
    TMPageType.mptMemu:
      result := TMPageMemu.create(self, aCaption, aHotKey);

  end;

  result.ItemIndex := self.FPages.Add(result);
end;

function TMPages.ChangeToPage(i: integer): TMPage;
begin
  Show(i);
  result := FPages[i];
end;

function VetoOnVKCode(const VKCode: word): Boolean;
const
  NumVetoKeys = 6;
  VetoKey: array [1 .. NumVetoKeys] of word = (VK_CONTROL, VK_SHIFT, VK_MENU, VK_CAPITAL, VK_NUMLOCK, VK_SCROLL);
var
  iKey: integer;
begin
  for iKey := 1 to NumVetoKeys do
    if VKCode = VetoKey[iKey] then
    begin
      result := true;
      Exit
    end;
  result := False
end;

function ReadKey: string;
var
  NumRead: Cardinal;
  HConsoleInput: thandle;
  InputRec: TInputRecord;
  c: ANSICHAR;
  pc: PansiChar;
  s: ansiString;
  VirtualKeyCode: word;
  VirtualScanCode: word;
begin

  s := '';
  result := '';
  HConsoleInput := GetStdHandle(STD_INPUT_HANDLE);

  repeat

    if ReadConsoleInput(HConsoleInput, InputRec, 1, NumRead) and (InputRec.Event.KeyEvent.bKeyDown) then
    begin
      with PKeyEventRecord(@InputRec.Event.KeyEvent)^ do
        if bKeyDown and not VetoOnVKCode(wVirtualKeyCode) then
        begin
          VirtualScanCode := wVirtualScanCode;
          VirtualKeyCode := wVirtualKeyCode;
          if VirtualScanCode = $0E then //
          begin
            if length(s) > 0 then
            begin
              s := copy(s, 1, length(s) - 1);
              writeln(s);
              // write(#$15);
            end;
            continue;
          end;

          // Exit;
        end;
    end
    else
      sleep(1);

  until False;
end;

constructor TMPages.create(aLeft, aTop: smallint);
begin
  inherited create(aLeft, aTop);
  FPages := TMPageList.create;
  // 有一个线程是监控 页面的
  FisWaitFree := False;
  FPageThread := TThread.CreateAnonymousThread(
    procedure
    var
      key: TConsoleKeyInfo;
    begin
      while not FisWaitFree do
      begin
        key := Console.ReadKey(False);

        HandleKey(key.key);
      end;
    end);
  FPageThread.start;
end;

destructor TMPages.Destroy;
var
  i: integer;
begin
  FisWaitFree := true;
  if assigned(self.FPageThread) then
    FPageThread.Terminate;

  for i := 0 to FPages.Count - 1 do
    FPages[i].Free;
  FPages.Free;
  inherited;
end;

function TMPages.GetPageCount: integer;
begin
  result := self.FPages.Count;
end;

procedure TMPages.HandleKey(aKey: TConsoleKey);
var
  i: integer;
begin
  for i := 0 to self.FPages.Count - 1 do
    if (aKey = FPages[i].HotKey) then
    begin
      self.ActiveIndex := i;
      Exit;
    end;

  case aKey of
    TConsoleKey.PageUp:
      begin
        i := self.ActiveIndex;
        dec(i);
        if i < 0 then
          i := self.PageCount - 1;
        self.ActiveIndex := i;
        Exit;
      end;
    TConsoleKey.PageDown:
      begin
        i := self.ActiveIndex;
        inc(i);
        if i >= PageCount then
          i := 0;
        self.ActiveIndex := i;
        Exit;
      end;
  end;
end;

procedure TMPages.repaint;
begin
  Console.Clear;
  Console.ClearEOL;
  ShowHeader;
  Pages[FActiveIndex].Show;
end;

procedure TMPages.SetActiveIndex(const Value: integer);
begin
  FActiveIndex := Value;
  self.Show(FActiveIndex);
end;

procedure TMPages.Show(aActiveIndex: integer);
var
  i: integer;
begin

  if aActiveIndex = -1 then
    aActiveIndex := 0;
  self.FActiveIndex := aActiveIndex;
  for i := 0 to self.Pages.Count - 1 do
  begin
    Pages[i].visibled := i = FActiveIndex;
  end;
  repaint;

  case Pages[FActiveIndex].PageType of
    mptShow:
      Console.CursorVisible := False;
    mptInput:
      Console.CursorVisible := true;
  end;

end;

function hotkeystr(ak: TConsoleKey): String;
var
  i: word;
begin
  result := TMCKey.create(ak).Name;
end;

procedure TMPages.ShowHeader;
var
  i: integer;
  l, t: integer;
  cap: String;
begin

  mcs.AddLine(Left, Top, Color, StringOfChar('-', 30) + '   ' + StringOfChar('-', 30));

  if (FPages.Count > 0) and (FActiveIndex < 0) then
    FActiveIndex := 0;

  for i := 0 to self.FPages.Count - 1 do
  begin
    if i = 0 then
      mcs.Add('|');
    FPages[i].Top := Top + 1;
    FPages[i].Left := Console.CursorLeft;
    if FPages[i].HotKey <> TConsoleKey.None then
      cap := format(' %s (%s) ', [FPages[i].Caption, hotkeystr(FPages[i].HotKey)])
    else
      cap := format(' %s ', [FPages[i].Caption]);
    if FActiveIndex = i then
    begin
      mcs.Add(TConsoleColor.DarkYellow, TConsoleColor.Black, cap);

    end else begin
      mcs.Add(cap);
    end;

    Console.ForegroundColor := FColor; Console.BackgroundColor := TConsoleColor.Black;
    mcs.Add('|');

  end;
  mcs.AddLine('');

end;

constructor TMCControl.create(aLeft, aTop: smallint);
begin
  FColor := pubColor; FLeft := aLeft; FTop := aTop;
  FVisible := False;
end;

procedure TMCControl.SetColor(const Value: TConsoleColor);
begin
  FColor := Value;
end;

{ TMPage }

constructor TMPage.create(aParent: TMPages; const aCaption: String; const aHotKey: TConsoleKey; aPageType: TMPageType);
begin
  self.Left := aParent.Left; self.Top := aParent.Top + 3; self.FCaption := aCaption;
  self.FHotKey := aHotKey;
  self.FPageType := aPageType;
  self.FParent := aParent;

end;

destructor TMPage.Destroy;
begin
end;

procedure TMPage.Hide;
var
  i: integer;
begin
  FVisibled := False;

end;

procedure TMPage.repaint;
begin
end;

procedure TMPage.SetCaption(const Value: String);
begin
  FCaption := Value; mcs.Add(FLeft, FTop, FColor, Value);
end;

procedure TMPage.setVisibled(const Value: Boolean);
var
  i: integer;
begin
  FVisibled := Value;
  if FVisibled then
    // self.Show
  else
    // self.Hide;
end;

procedure TMPage.Show;
var
  i: integer;
begin
  FVisibled := true;
end;

{ TMPageShow }

procedure TMPageShow.AddControl(aControl: TMCControl);
begin
  FControls.Add(aControl)
end;

constructor TMPageShow.create(aParent: TMPages; const aCaption: String; const aHotKey: TConsoleKey);
begin
  self.Left := aParent.Left; self.Top := aParent.Top + 3; self.FCaption := aCaption;
  self.FHotKey := aHotKey;
  self.FPageType := mptShow;
  self.FParent := aParent;
  FControls := TMCControls.create;

end;

destructor TMPageShow.Destroy;
var
  i: integer;
begin

  for i := 0 to FControls.Count - 1 do
    FControls[i].Free;
  FControls.Free; inherited;

  inherited;
end;

procedure TMPageShow.Hide;
var
  i: integer;
begin
  inherited;
  for i := 0 to self.FControls.Count - 1 do
    FControls[i].Visible := False;
end;

procedure TMPageShow.repaint;
var
  i: integer;
begin
  inherited;
  for i := 0 to self.FControls.Count - 1 do
    FControls[i].repaint;
end;

procedure TMPageShow.Show;
var
  i: integer;
begin
  inherited;
  for i := 0 to self.FControls.Count - 1 do
  begin
    FControls[i].Visible := true;
    FControls[i].repaint;
  end;
end;

{ TMPageInput }

procedure TMPageInput.AddAction(acmd: String; aAct: TMCInputAction);
begin
  FActions.Add(acmd, aAct);
end;

procedure TMPageInput.canclewaitfor;
var
  handle: thandle;
  ConsoleWindowHnd: thandle;
begin

  handle := GetStdHandle(STD_INPUT_HANDLE);
  CancelIoEx(handle, nil);

  // ConsoleWindowHnd := GetForegroundWindow();
  // PostMessage(ConsoleWindowHnd, WM_KEYDOWN, vk_Return, 0);

end;

constructor TMPageInput.create(aParent: TMPages; const aCaption: String; const aHotKey: TConsoleKey);
var
  i: integer;
begin
  self.Left := aParent.Left; self.Top := aParent.Top + 3; self.FCaption := aCaption;
  self.FHotKey := aHotKey;
  self.FParent := aParent;
  FPromp := 'Input Command:';
  self.FPageType := mptInput;
  i := 0;
  FActions := TMCInputActions.create;
  { FCmdThread := TThread.CreateAnonymousThread(
    procedure
    begin
    sleep(100);
    while not self.Parent.isWaitFree do
    begin
    if self.FVisibled then
    begin
    self.WaitFor;
    end
    else
    sleep(200);
    inc(i);
    Console.Title := i.ToString;
    end;
    end);
    FCmdThread.start;
  }
end;

destructor TMPageInput.Destroy;
begin
  if assigned(FCmdThread) then
  begin
    FCmdThread.Terminate;
    // FCmdThread.Free;
  end;
  FActions.Free;
  inherited;
end;

procedure TMPageInput.DoCmd(acmd: String);
var
  act: TMCInputAction;

  MCmd: TMCmd;
begin
  if not self.FVisibled then
    Exit;
  MCmd := TMCmd.create(acmd);
  if self.FActions.TryGetValue(MCmd.Cmd, act) then
  begin
    Console.ForegroundColor := TConsoleColor.White;
    act(MCmd.Cmd, MCmd.params);
  end else begin
    Console.ForegroundColor := TConsoleColor.Red;
    Console.WriteLine('Unkown command:' + MCmd.Cmd);
    Console.ForegroundColor := TConsoleColor.White;
  end;
end;

procedure TMPageInput.Hide;
begin
  inherited;
end;

procedure TMPageInput.repaint;
begin
  inherited;
end;

procedure TMPageInput.setVisibled(const Value: Boolean);
begin
  inherited;
  if self.FVisibled then
  begin
    FCmdThread := TThread.CreateAnonymousThread(
      procedure
      begin
        sleep(100);
        while (not FCmdThread.IsTerminated) and (not self.Parent.isWaitFree) do
        begin
          if self.FVisibled then
          begin
            self.WaitFor;
            sleep(100);
          end
          else
            sleep(200);
          // inc(i);
          // Console.Title := i.ToString;
        end;
      end);
    FCmdThread.start;
  end else begin
    canclewaitfor;
    if assigned(FCmdThread) then
    begin
      FCmdThread.Terminate;
      // freeandnil(FCmdThread);
    end;
  end;
end;

procedure TMPageInput.Show;
begin
  inherited;
  Console.SetCursorPosition(Left, Top);

end;

procedure TMPageInput.WaitFor;
var
  acmd: String;
begin
  try
    Console.ForegroundColor := TConsoleColor.Cyan;
    Console.Write(FPromp);
    acmd := Console.ReadLine;

    if acmd <> '' then
      DoCmd(acmd);
  except
    sleep(10);
  end;
end;
{ TMPageMemu }

constructor TMPageMemu.create(aParent: TMPages; const aCaption: String; const aHotKey: TConsoleKey);
begin
  self.Left := aParent.Left; self.Top := aParent.Top + 3; self.FCaption := aCaption;
  self.FHotKey := aHotKey;
  self.FParent := aParent;
  self.FPageType := mptMemu;
end;

{ TMCLabel }

constructor TMCLabel.create(aParent: TMPageShow; aFormat: String; aLeft, aTop: smallint);
begin
  FParent := aParent;
  FParent.AddControl(self);

  create(aLeft, aTop); FFormat := aFormat; FLeft := aLeft; FTop := aTop;
  if FLeft < 0 then
    FLeft := Console.CursorLeft;
  if FTop < 0 then
    FTop := Console.CursorTop;

  FLeft := aParent.Left + FLeft; FTop := aParent.Top + FTop;

  self.FColor := pubColor;
end;

procedure TMCLabel.repaint;
var
  s: String;
begin
  if not self.Visible then
    Exit;
  if FFormat = '' then
  begin
    if FOldCaption <> '' then
      mcs.Add(FLeft, FTop, FColor, '%-' + inttostr(length(FOldCaption)) + 's', [' ']);
    mcs.Add(FLeft, FTop, FColor, FCaption);
  end
  else
    mcs.Add(FLeft, FTop, FColor, FFormat, [FCaption]);

  Console.ForegroundColor := pubColor;

end;

procedure TMCLabel.SetCaption(const Value: String);
begin
  FOldCaption := FCaption; FCaption := Value;
  if not self.Visible then
    Exit;
  repaint;
end;

{ TMProgressBar }

constructor TMProgressBar.create(aParent: TMPageShow; aWidth: integer; aShowSpinner: Boolean; aLeft: smallint;
aTop: smallint);
var
  s: String;
begin
  FParent := aParent; FLeft := aLeft; FTop := aTop;
  FParent.AddControl(self);
  if FLeft < 0 then
    FLeft := Console.CursorLeft;
  if FTop < 0 then
    FTop := Console.CursorTop;

  self.FLeft := aParent.FLeft; self.FTop := aParent.FTop;

  FColor := pubColor; FSpinnerCharIndex := 1; self.FWidth := aWidth;

  FEmptyChars := StringOfChar('.', FWidth); FShowPosition := true; FShowSpinner := aShowSpinner; FActive := true;
  if FShowSpinner then
  begin
    start;
  end;
end;

destructor TMProgressBar.Destroy;
begin
  FActive := False;
  if assigned(FThread) then
    FThread.Terminate;

  inherited;
end;

procedure TMProgressBar.SetPosition(const Value: integer);
var
  s: String;
  l, t, ln, l2, t2: integer;
begin
  FPosition := Value;
  if not self.Visible then
    Exit;
  repaint;

end;

procedure TMProgressBar.drawSpinner;
var
  l, t: integer;
begin
  if not self.Visible then
    Exit;
  l := Console.CursorLeft;
  t := Console.CursorTop;
  // Console.SetCursorPosition(FLeft, FTop);
  if FShowSpinner then
  begin
    mcs.Add(FLeft, FTop, TConsoleColor.Gray, '[');
    mcs.Add(TConsoleColor.Green, SpinnerChars[FSpinnerCharIndex]); mcs.Add(TConsoleColor.Gray, ']');

    inc(FSpinnerCharIndex);
    if FSpinnerCharIndex > length(SpinnerChars) then
      FSpinnerCharIndex := 1;
  end;
  // Console.SetCursorPosition(l, t);
end;

procedure TMProgressBar.repaint;
var
  s: String;
  l, t, ln, l2, t2: integer;
begin
  if not self.Visible then
    Exit;
  l := Console.CursorLeft;
  t := Console.CursorTop;

  ln := FPosition * FWidth div 100;

  s := FEmptyChars;
  s := StuffString(s, 1, ln, StringOfChar('|', ln));
  // fillchar(s, ln '|');
  FPosition := FPosition;

  l2 := FLeft; t2 := FTop;
  if FShowSpinner then
    l2 := l2 + 3;
  mcs.Add(l2, t2, TConsoleColor.Gray, '['); mcs.Add(TConsoleColor.Green, '%d%%', [FPosition]);
  mcs.Add(TConsoleColor.Gray, ']');

  mcs.Add(TConsoleColor.Gray, '['); mcs.Add(FColor, s);

  mcs.Add(TConsoleColor.Gray, ']');

  // Console.SetCursorPosition(l, t);

end;

procedure TMProgressBar.start;
begin
  if FShowSpinner then
  begin
    FThread := TThread.CreateAnonymousThread(
      procedure
      begin
        while FActive do
        begin
          if not FVisible then
          begin
            sleep(1000);
            continue;
          end;

          drawSpinner;
          TThread.sleep(500);
        end;
      end); FThread.start;
  end;
end;

{ TMConsoleShow }

procedure TMConsoleShow.Add(aText: String);
begin
  Add(-1, -1, pubColor, aText, False);
end;

procedure TMConsoleShow.Add(aColor: TConsoleColor; aText: String);
begin
  Add(-1, -1, aColor, aText, False);
end;

procedure TMConsoleShow.Add(aLeft, aTop: smallint; aColor: TConsoleColor; aText: String; aLine: Boolean);

begin
  Add(aLeft, aTop, aColor, TConsoleColor.Black, aText, aLine);
end;

procedure TMConsoleShow.Add(aLeft, aTop: smallint; aColor: TConsoleColor; aText: String; aValue: array of const);
begin
  Add(aLeft, aTop, aColor, format(aText, aValue), False);
end;

procedure TMConsoleShow.AddLine(aColor, aBgColor: TConsoleColor; aText: String; aValue: array of const);
begin
  Add(-1, -1, aColor, aBgColor, format(aText, aValue), true);
end;

procedure TMConsoleShow.Add(aColor, aBgColor: TConsoleColor; aText: String; aValue: array of const);
begin
  Add(-1, -1, aColor, aBgColor, format(aText, aValue), False);
end;

procedure TMConsoleShow.Add(aColor, aBgColor: TConsoleColor; aText: String);
begin
  Add(-1, -1, aColor, aBgColor, aText, False);
end;

procedure TMConsoleShow.Add(aLeft, aTop: smallint; aColor, aBgColor: TConsoleColor; aText: String; aLine: Boolean);
var
  ce: TMConsoleElec;
begin
  ce.Left := aLeft; ce.Top := aTop; ce.Color := aColor; ce.Text := aText;
  ce.bgColor := aBgColor;
  ce.IsLine := aLine; self.FConsolePool.Add(ce);

end;

procedure TMConsoleShow.AddLine(aColor: TConsoleColor; aText: String; aValue: array of const);
begin
  AddLine(aColor, format(aText, aValue));
end;

procedure TMConsoleShow.Add(aColor: TConsoleColor; aText: String; aValue: array of const);
begin
  Add(aColor, format(aText, aValue));
end;

procedure TMConsoleShow.Add(aLeft, aTop: smallint; aColor: TConsoleColor; aText: String);
begin
  Add(aLeft, aTop, aColor, aText, False);
end;

procedure TMConsoleShow.AddLine(aText: String);
begin
  Add(-1, -1, pubColor, aText, true);
end;

procedure TMConsoleShow.AddLine(aColor: TConsoleColor; aText: String);
begin
  Add(-1, -1, aColor, aText, true);
end;

procedure TMConsoleShow.AddLine(aLeft, aTop: smallint; aColor: TConsoleColor; aText: String; aValue: array of const);
begin
  Add(aLeft, aTop, aColor, format(aText, aValue), true);
end;

procedure TMConsoleShow.AddLine(aColor, aBgColor: TConsoleColor; aText: String);
begin
  Add(-1, -1, aColor, aBgColor, aText, true);
end;

procedure TMConsoleShow.AddLine(aLeft, aTop: smallint; aColor: TConsoleColor; aText: String);
begin
  Add(aLeft, aTop, aColor, aText, true);
end;

constructor TMConsoleShow.create;
begin
  FActive := true; FThread := TThread.CreateAnonymousThread(
    procedure
    begin
      start;
    end); FThread.start;
end;

destructor TMConsoleShow.Destroy;
begin
  self.FActive := False; FThread.Terminate; freeandnil(FThread); inherited;
end;

procedure TMConsoleShow.start;
var
  ce: TMConsoleElec;
  ol, ot, l, t: smallint;
begin
  while FActive do
  begin
    if assigned(pubConsolePool) then
    begin
      if pubConsolePool.GetOne(ce) then
      begin
        l := ce.Left; t := ce.Top;

        ol := Console.CursorLeft; ot := Console.CursorTop;
        if l < 0 then
          l := ol;
        if t < 0 then
          t := ot;
        Console.BackgroundColor := ce.bgColor;
        Console.SetCursorPosition(l, t); Console.ForegroundColor := ce.Color;

        if ce.IsLine then
          Console.WriteLine(ce.Text)
        else
          Console.Write(ce.Text);
        // Console.SetCursorPosition(ol, ot);
      end
      else
        sleep(10);
    end
    else
      sleep(1000);
  end;
end;

procedure TMConsoleShow.Stop;
begin
  FActive := False;
end;

{ TMCKey }

class function TMCKey.create(aKey: word): TMCKey;
var
  i: integer;
begin
  for i := Low(MCKeys) to High(MCKeys) do
  begin
    if MCKeys[i].key = aKey then
      Exit(MCKeys[i])
  end;
end;

class function TMCKey.create(aKey: TConsoleKey): TMCKey;
var
  i: integer;
begin
  for i := Low(MCKeys) to High(MCKeys) do
  begin
    if MCKeys[i].key = ord(aKey) then
      Exit(MCKeys[i])
  end;

end;

{ TThread_help }

function TThread_help.GetIsTerminated: Boolean;
begin
  result := self.Terminated
end;

initialization

pubConsolePool := TMConsolePool.create;
pubConsoleShow := TMConsoleShow.create;
pubConsoleShow.ConsolePool := pubConsolePool;
mcs := pubConsoleShow;

finalization

pubConsoleShow.Stop; pubConsoleShow.Free;

pubConsolePool.Free;

end.
