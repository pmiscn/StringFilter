program MSF;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  System.Console,
  Mu.Console.Params,
  EasyConsole.Input,
  EasyConsole.Output,
  EasyConsole.Types,
  uMSF in 'uMSF.pas';

var
  Cmd: TMCmd;
  s  : String;

procedure showhelp;
begin
  Console.WriteLine('过滤文本程序');
  Console.WriteLine('主命令:filter');
  Console.WriteLine('参数写法是 参数名字=参数值');
  Console.WriteLine('参数列表');
  Console.WriteLine('from       源文件路径');
  Console.WriteLine('to         输出文件路径，如果输出文件参数没有或者为空，则在屏幕打印结果。');
  Console.WriteLine('conf       配置文件路径');
  Console.WriteLine('print      屏幕输出结果');

end;

procedure doCmd(Cmd: TMCmd);
var
  s: String;
begin
  if Cmd.Cmd = '?' then
  begin
    showhelp();
  end;

  if (Cmd.Cmd.ToLower = 'filter') or (Cmd.Cmd = '') then
  begin
    s := Filter(Cmd);
  end
  else
    s := '无法识别的命令';

end;

begin
  try

    Cmd := GetParams;
    if (Cmd.Cmd <> '') or (length(Cmd.Params) > 0) then
    begin
      doCmd(Cmd);
      // Console.WriteLine(Cmd.Cmd);

    end else begin
      while true do
      begin
        Cmd.clear();
        s := Input.ReadString('input command:');
        Cmd.parse(s);
        doCmd(Cmd);

      end;
    end;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
