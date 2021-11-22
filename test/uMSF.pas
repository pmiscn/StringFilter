unit uMSF;

interface

uses Winapi.windows, System.SysUtils, System.classes,
  System.Console, Mu.Console.Params, Mu.StringFilter;

function Filter(Cmd: TMCmd): String;
function Filter2File(aConfigfile, aFrom, aTo: String; awrite: string = ''; encode: string = ''): string;

implementation

uses qstring, QJSON;

procedure writetoscreen(s: String);
var
  st: Tstringlist;
  i : integer;
begin
  st := Tstringlist.Create;
  try
    st.Text := s;
    for i   := 0 to st.Count - 1 do
      writeln(st[i]);
  finally
    st.Free;
  end;
end;

function getNowFileName(): string;
var
  szModuleName: array [0 .. 255] of char;
begin
  begin
    GetModuleFileName(hInstance, szModuleName, sizeof(szModuleName));
  end;
  result := (szModuleName);
end;

function getexepath(): String;
begin
  result := extractfilepath(getNowFileName);
end;

function Filter(Cmd: TMCmd): String;
var
  cf, ff, tf, wr, encode: String;
begin
  encode := Cmd.GetParam('encode');
  cf     := Cmd.GetParam('config');
  if cf = '' then
    cf := Cmd.GetParam('conf');

  ff := Cmd.GetParam('from');
  if ff = '' then
    ff := Cmd.GetParam('src');

  tf := Cmd.GetParam('to');
  if tf = '' then
    tf := Cmd.GetParam('result');

  if (cf <> '') and (ff <> '') then
  begin
    wr := Cmd.GetParam('print');
    if wr = '' then
    begin
      if Cmd.HasParam('print') then
        wr := 'true';
    end else if wr.ToLower <> 'false' then
      wr := 'true';

    result := Filter2File(cf, ff, tf, wr, encode);

  end
  else
    writeln('ERROR,´íÎóµÄ²ÎÊý');
end;

function Filter2File(aConfigfile, aFrom, aTo: String; awrite: string = ''; encode: string = ''): string;
var
  sf        : TMuStringFilter;
  qjs       : TQjson;
  st, ssf, s: String;
begin
  result := '';
  if not fileexists(aFrom) then
    aFrom := getexepath + aFrom;
  if not fileexists(aConfigfile) then
    aConfigfile := getexepath + aConfigfile;

  if not fileexists(aFrom) then
  begin
    exit(aFrom + ' not exists');
  end;
  if not fileexists(aConfigfile) then
  begin
    exit(aConfigfile + ' not exists');
  end;

  if aTo = '' then
  begin
    // aTo := Changefileext(aFrom, '') + '_s' + extractfileext(aFrom);

  end;
  ssf := qstring.LoadTexTw(aFrom);
  sf  := TMuStringFilter.Create();
  qjs := QJSON.AcquireJson;
  try
    try
      qjs.LoadFromFile(aConfigfile);
      sf.loadConfigFromJson(qjs);
      sf.Input := ssf;
      sf.Filter();
      st     := sf.Output;
      result := st;
      if (aTo <> '') then
      begin
        if (encode = 'ansi') or (encode = 'a') then
        begin
          qstring.SaveTextA(aTo, st)
        end else if (encode = 'utf8') or (encode = 'u') then
        begin
          qstring.SaveTextU(aTo, st)
        end else begin
          qstring.SaveTextW(aTo, st);
        end;
        if awrite = 'true' then
        begin
          writetoscreen(st);
        end;
      end else begin
        if awrite <> 'false' then
          writetoscreen(st);
      end;
    except

      on e: Exception do
        result := e.Message;
    end;
    result := st;
  finally
    sf.Free;
    QJSON.ReleaseJson(qjs);
  end;

end;

end.
