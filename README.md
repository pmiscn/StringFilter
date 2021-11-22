# StringFilter
A text filtering program developed by Delphi mainly uses the regular expression function of.  Can be used to process text.


本程序主要功能是实现文本文件过滤，能够从文本文件提取需要的数据，或者格式化文本文件，是从我爬虫程序里面提取的，通过配置，能够实现绝大部分的文本过滤处理。

配置文件是json格式，说明请看目录下conf.js的注释


msf.exe 是命令行程序
支持文本输入命令和参数输入，2者的格式一致。命令行参数为

filter conf=conf.js from=src.txt to=aa.txt print

filter 		是主命令，对文本进行过滤，可以省略。
conf=conf.js 	配置文件路径，
from=src.txt	源文件的路径，
to=aa.txt		输出结果文件路径
print		控制台打印输出结果，如果to参数是空，则默认打印，除非存在 print=false参数。
以上文件路径相对目录绝对目录都可以

TestStringFilter.exe
一个带界面的测试程序


配置说明如下：
//本配置是兼容的json格式，兼容常见的json格式。

{
	FullToHalf:false,			//全角转半角
	HtmlUnescape:false,			//HTML解码
	MultiValueSpliter:"\r\n",	//多个值之间的分割符，此处是回车和换行，同样可以是 , ; 等。
	
	
	//Filters是按照顺序执行的过滤方法。包括 ftCopy,ftReplace,ftMatch,ftDelete 四种操作
	/*
		每个操作的配置，有下面几个字段 {
			字段				可选		类型	说明
			-------------------------------------------
			FilterType			必须		字符串	操作类型
			RegException 		可选		布尔	是否表达式，默认false，只支持 false和true2个值
			Exception1 			必须		字符串	表达式1
			Exception2 			可选		字符串	表达式2，ftCopy，ftReplace，ftMatch时候，是必选项
			FilterOptions		可选		字符串	操作选项，内容是foIgnoreCase, foAll, foRegMultiLine, foRegSingleLine 的组合数组  例如：FilterOptions:"[foIgnoreCase, foAll]"},//, foRegMultiLine
													foIgnoreCase		忽略大小写				默认false		
													foAll				全部匹配				默认false
													foRegMultiLine		正则表达式的多行模式	默认false
													foRegSingleLine		正则表达式的单行模式	默认true
			Parallel			可选		布尔	是否追加到后面，
													true	匹配项的结果将追加到源文本后面作为本操作结果
													false	匹配项的结果是本操作的结果							
			MultiValueSpliter	可选		字符串	分隔符，默认是根节点的MultiValueSpliter，如果当前操作设置了此值，以此为准。						
			BeforeStr			可选		字符串	本操作结果前面追加的字符串，默认空
			AfterStr			可选		字符串	本操作结果后面追加的字符串，默认空
 
		下面是四种操作的说明	
		ftCopy 		从文本中复制内容出来，从开Exception1开始的位置到Exception2结束的位置 复制内容，如果有多个匹配项目，当FilterOptions 包含foAll的时候，会把所有匹配内容用分隔符分开
		ftReplace	替换，把Exception1的内容，替换为Exception2的内容，当Exception1是正则表达式时，Exception2可以用$0 $1 等匹配项目
		ftMatch		表达式的提取，和ftCopy不同，只支持表达式，主要靠Exception2的匹配项输出内容，一些情况下，可以与ftReplace通用。
		fgDelete	删除匹配项，当Exception2=""时候，等同于ftReplace，当Exception1 Exception2 都不为空时，删除2者之间的匹配项。
		
		
		注意：
			1、所有的字符串必须使用js的转义符号，比如\\
			2、Filters为空的时候，返回的是源文件。如果某一个节点错误，返回为空或此节点操作之前的结果。
	*/
	
	Filters:[
		{FilterType:"ftCopy",RegException:false,Exception1:"<div class=\"huisefengexian\"></div>",Exception2:"<!-- 左侧结束 -->",FilterOptions:"[foAll]" },
		{FilterType:"ftReplace",RegException:true,Exception1:"<script>s5f\\(\"([^\"]*?)\"\\);</script>",Exception2:" ($1)",FilterOptions:"[foIgnoreCase,foAll]" },
		{FilterType:"ftReplace",RegException:true,Exception1:"<span[^>]*?dicpy[^>]*>(.*?)((</span>)|(</p>))",Exception2:"<em>$1</em>",FilterOptions:"[foIgnoreCase, foAll]"},//, foRegMultiLine
																  

		{FilterType:"ftReplace",RegException:true,Exception1:"<script[^>]*>.*?</script>",Exception2:"",FilterOptions:"[foIgnoreCase,foAll]" },
		{FilterType:"ftReplace",RegException:true,Exception1:"<div id=\"ggwz__[^>]*>.*?</div>",Exception2:"",FilterOptions:"[foIgnoreCase,foAll]" },
		{FilterType:"ftReplace",RegException:true,Exception1:"<a[^>]*>.*?</a>",Exception2:"",FilterOptions:"[foIgnoreCase,foAll]" },
		{FilterType:"ftReplace",RegException:false,Exception1:"&amp;",Exception2:"&",FilterOptions:"[foIgnoreCase,foAll]" },

		// {FilterType:"ftReplace",RegException:true,Exception1:"<h2[^>]*>(.*?)</h2>",Exception2:"||$1||,",FilterOptions:"[foIgnoreCase, foAll]"},//, foRegMultiLine
		{FilterType:"ftReplace",RegException:true,Exception1:"<div class=\"huisefengexian\">(.*?)</div>",Exception2:"$1",FilterOptions:"[foIgnoreCase, foAll]"},//, foRegMultiLine
		{FilterType:"ftReplace",RegException:true,Exception1:"<div[^>]*?>\\s*</div>",Exception2:"",FilterOptions:"[foIgnoreCase, foAll]"},//, foRegMultiLine

		{FilterType:"ftReplace",RegException:true,Exception1:"<div class=\"zikuang\">(.*?)</div>",Exception2:"\"Char\":\"$1\",",FilterOptions:"[foIgnoreCase, foAll]"},//, foRegMultiLine

		{FilterType:"ftReplace",RegException:true,Exception1:"<p>(.*?)</p>",Exception2:"$1\\r\\n",FilterOptions:"[foIgnoreCase, foAll]"},//, foRegMultiLine
		{FilterType:"ftReplace",RegException:true,Exception1:"</p>",Exception2:"",FilterOptions:"[foIgnoreCase, foAll]"},//, foRegMultiLine

		{FilterType:"ftReplace",RegException:true,Exception1:"<span[^>]*?charu_yc_url[^>]*>(.*?)</span>",Exception2:"",FilterOptions:"[foIgnoreCase, foAll]"},//, foRegMultiLine

		{FilterType:"ftReplace",RegException:true,Exception1:"<span[^>]*>(.*?)</span>",Exception2:"$1",FilterOptions:"[foIgnoreCase, foAll]"},//, foRegMultiLine
		{FilterType:"ftReplace",RegException:true,Exception1:"<strong[^>]*>(.*?)</strong>",Exception2:"$1",FilterOptions:"[foIgnoreCase, foAll]"},//, foRegMultiLine
		{FilterType:"ftReplace",RegException:true,Exception1:"<!--.*?-->",Exception2:"",FilterOptions:"[foIgnoreCase, foAll]"},//, foRegMultiLine
		{FilterType:"ftReplace",RegException:true,Exception1:"<h2[^>]*>(.*?)</h2>",Exception2:"",FilterOptions:"[foIgnoreCase, foAll]"},//, foRegMultiLine
		{FilterType:"ftReplace",RegException:true,Exception1:"<div id=\"(\\w+)_div\">(.*?)</div>",Exception2:"\"$1\":\"$2\",",FilterOptions:"[foIgnoreCase, foAll]"},//, foRegMultiLine
		{FilterType:"ftReplace",RegException:true,Exception1:"<div class=\"(.*?)\">(.*?)</div>",Exception2:"\"$1\":\"$2\",",FilterOptions:"[foIgnoreCase, foAll]"},//, foRegMultiLine
		{FilterType:"ftReplace",RegException:false,Exception1:"'",Exception2:"''",FilterOptions:"[foIgnoreCase, foAll]"},//, foRegMultiLine
		{FilterType:"ftReplace",RegException:false,Exception1:"\\",Exception2:"\\\\",FilterOptions:"[foIgnoreCase, foAll]"},//, foRegMultiLine

		{FilterType:"ftReplace",RegException:true,Exception1:"<br[^>]*>",Exception2:" ",FilterOptions:"[foIgnoreCase,foAll]" },
		{FilterType:"ftReplace",RegException:true,Exception1:"</div>",Exception2:"",FilterOptions:"[foIgnoreCase,foAll]" },
		{FilterType:"ftReplace",RegException:true,Exception1:"\\n+",Exception2:"\n",FilterOptions:"[foIgnoreCase, foAll]" },

		//  {FilterType:"ftReplace",RegException:false,Exception1:"\"",Exception2:"\\\"",FilterOptions:"[foIgnoreCase,foAll]" },
		//  {FilterType:"ftReplace",RegException:false,Exception1:"||",Exception2:"\"",FilterOptions:"[foIgnoreCase,foAll]" },
		{Parallel:true, FilterType:"ftMatch",RegException:true,Exception1:"<img src=(\".*?\")[^>]*>",Exception2:"\"swjzimg\":$1 ",FilterOptions:"[foIgnoreCase,foAll]" },
		//    {FilterType:"ftReplace",RegException:true,Exception1:"<img src=\"([^>]*?)\"[^>]*>$",Exception2:"\"swjzimg\":\"$1\"",FilterOptions:"[foIgnoreCase,foAll, foRegMultiLine]" },
		//    {FilterType:"ftReplace",RegException:true,Exception1:".*?(\"swjzimg.*)$",Exception2:"$1",FilterOptions:"[foIgnoreCase,foAll, foRegMultiLine]" },
		{FilterType:"ftReplace",RegException:true,Exception1:"^　",Exception2:" ",FilterOptions:"[foIgnoreCase, foAll, foRegMultiLine]" }   ,

		{FilterType:"ftReplace",RegException:true,Exception1:"<img src=\"([^>]*?)\"[^>]*>",Exception2:"",FilterOptions:"[foIgnoreCase,foAll]" },
		//   	{FilterType:"ftReplace",RegException:true,Exception1:"\\s*$",Exception2:"",FilterOptions:"[foIgnoreCase, foAll, foRegMultiLine]" }   ,
		// {FilterType:"ftReplace",RegException:true,Exception1:"\"\\s+",Exception2:"\"",FilterOptions:"[foIgnoreCase, foAll, foRegMultiLine]" }   ,
		{FilterType:"ftReplace",RegException:true,Exception1:"([^,])[\\r\\n]+",Exception2:"$1",FilterOptions:"[foIgnoreCase, foAll, foRegMultiLine]" }   ,
		{FilterType:"ftMatch",RegException:true,Exception1:"(.+)",Exception2:"{$1}",FilterOptions:"[foIgnoreCase, foAll]" }   ,
		 
		// {FilterType:"ftReplace",RegException:true,Exception1:"\\s+",Exception2:"",FilterOptions:"[foIgnoreCase, foAll]" }
					
	]
}
