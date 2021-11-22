unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Mu.StringFilter,
  SynHighlighterJScript,
  SynEditHighlighter, SynHighlighterHtml, SynEdit, SynMemo, Vcl.StdCtrls,
  Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Button1: TButton;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    E_Src: TSynMemo;
    SynHTMLSyn1: TSynHTMLSyn;
    SynJScriptSyn1: TSynJScriptSyn;
    E_Conf: TSynMemo;
    E_Result: TSynMemo;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function getexepath(): String;
begin
  result := extractfilepath(application.ExeName);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  sf: TMuStringFilter;
begin
  sf := TMuStringFilter.Create();
  try
    sf.loadConfigFromString(E_Conf.Text);
    sf.Input := E_Src.Text;
    sf.Filter();
    E_Result.Text := sf.Output;
  finally
    sf.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  fn: String;
begin
  fn := getexepath + 'src.txt';
  self.E_Src.Lines.SaveToFile(fn);
  
  fn := getexepath + 'conf.js';
  self.E_Conf.Lines.SaveToFile(fn);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  fn: String;
begin
  fn := getexepath + 'src.txt';
  if fileexists(fn) then
    self.E_Src.Lines.LoadFromFile(fn);
  fn := getexepath + 'conf.js';
  if fileexists(fn) then
    self.E_Conf.Lines.LoadFromFile(fn);
end;

end.
