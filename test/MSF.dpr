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
  Console.WriteLine('�����ı�����');
  Console.WriteLine('������:filter');
  Console.WriteLine('����д���� ��������=����ֵ');
  Console.WriteLine('�����б�');
  Console.WriteLine('from       Դ�ļ�·��');
  Console.WriteLine('to         ����ļ�·�����������ļ�����û�л���Ϊ�գ�������Ļ��ӡ�����');
  Console.WriteLine('conf       �����ļ�·��');
  Console.WriteLine('print      ��Ļ������');

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
    s := '�޷�ʶ�������';

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
