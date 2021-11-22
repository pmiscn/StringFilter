unit Mu.Console.Params;

interface

uses System.SysUtils, windows, System.classes, qstring;

type
  TMCParam = record
    Name: String;
    Value: String;
    public
      procedure parse(str: String);
  end;

  TMCParams = TArray<TMCParam>;

  TMCmd = record
    Cmd: String;
    Params: TMCParams;
    public
      procedure parse(aStr: String);
      procedure AddParam(p: TMCParam); overload;
      procedure AddParam(ps: string); overload;

      function HasParam(aName: String): boolean;
      function TryGetParam(aName: String; var aValue: String): boolean; overload;
      function GetParam(aName: String; aDefault: String = ''): String; overload;
      procedure clear ;
      class function Create(aStr: String): TMCmd; static;
  end;

  TMCParams_help = record helper for TMCParams
    public
      function tostring: string;
      class function Create(aStr: String): TMCParams; overload; static;
      class function Create(aStr: String; var Cmd: String): TMCParams; overload; static;
  end;

function GetParams(): TMCmd;

implementation

function GetParams(): TMCmd;
var
  i : integer;
  ln: String;
  fn: String;
var
  Buffer: array [0 .. 260] of char;
begin
  SetString(fn, Buffer, GetModuleFileName(0, Buffer, Length(Buffer)));
  ln     := GetCommandLine;
  ln     := trim(ln.Replace('"' + fn + '"', ''));
  ln     := trim(ln.Replace(fn, ''));
  result := TMCmd.Create(ln);

end;
{ TMCparam }

procedure TMCParam.parse(str: String);
var
  n, v: String;
  i   : integer;
begin
  i := pos('=', str);
  if i > 0 then
  begin
    self.Name  := trim(copy(str, 1, i - 1));
    self.Value := trim(str.Substring(i));
  end else begin
    self.Name  := str;
    self.Value := '';
  end;

end;

{ TMCmd }

procedure TMCmd.AddParam(p: TMCParam);
var
  i: integer;
begin
  i := Length(Params);
  setlength(Params, i + 1);
  self.Params[i].Name  := p.Name;
  self.Params[i].Value := p.Value;
end;

procedure TMCmd.AddParam(ps: string);
var
  p: TMCParam;
begin
  if ps = '' then
    exit;
  p.parse(ps);
  AddParam(p);
end;

procedure TMCmd.clear;
begin
  self.Cmd := '';
  setlength(self.Params, 0);
end;

class function TMCmd.Create(aStr: String): TMCmd;
begin
  result.parse(aStr);
end;

function TMCmd.HasParam(aName: String): boolean;
var
  i: integer;
begin
  result := false;
  for i  := 0 to high(self.Params) do
    if Params[i].Name = aName then
      exit(true);
end;

procedure TMCmd.parse(aStr: String);
var
  i         : integer;
  p, p1     : PChar;
  Name, line: String;
begin

  p  := PChar(aStr);
  p1 := p;
  skipspacew(p);
  // 第一个是名字
  Name := DecodeTokenW(p, #32#9' ', #0, false);
  if pos('=', name) > 0 then
  begin
    Cmd := '';
    p   := PChar(aStr);
  end
  else
    self.Cmd := name;
  skipspacew(p);
  p1 := p;
  while p^ <> #0 do
  begin
    if p^ in ['"', ''''] then
    begin
      inc(p);
      line := DecodeTokenW(p, '"''', #0, true, true);

      self.AddParam(trim(line));
      // inc(p);
      skipspacew(p);
      p1 := p;
    end else if IsSpaceW(p) then
    begin
      line := copy(p1, 1, p - p1);
      self.AddParam(trim(line));
      skipspacew(p);
      p1 := p;
    end else begin
      inc(p);
    end
    // skipspacew(p);
  end;
  if p > p1 then
  begin
    line := copy(p1, 1, p - p1);
    self.AddParam(trim(line));
  end;
  { sa := aStr.Split([' ']);
    if (length(sa) = 1) then
    begin
    self.Cmd := aStr;
    end else begin
    self.Cmd := sa[0];
    // self.AddParam();
    end; }
end;

function TMCmd.GetParam(aName: String; aDefault: String): String;
var
  i: integer;
begin
  result := aDefault;
  for i  := 0 to high(self.Params) do
    if Params[i].Name = aName then
    begin
      result := Params[i].Value;
      exit;
    end;
end;

function TMCmd.TryGetParam(aName: String; var aValue: String): boolean;
var
  i: integer;
begin
  result := false;
  for i  := 0 to high(self.Params) do
    if Params[i].Name = aName then
    begin
      aValue := Params[i].Value;
      exit(true);
    end;
end;

{ TMCParams }

class function TMCParams_help.Create(aStr: String): TMCParams;
begin

end;

class function TMCParams_help.Create(aStr: String; var Cmd: String): TMCParams;
begin

end;

function TMCParams_help.tostring: string;
var
  i: integer;
begin
  result := '';
  for i  := Low(self) to High(self) do
  begin
    if i > 0 then
      result := result + ';';
    result   := result + format('%s=%s', [self[i].Name, self[i].Value]);
  end;
end;

end.
