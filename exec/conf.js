
//�������Ǽ��ݵ�json��ʽ�����ݳ�����json��ʽ��

{
	FullToHalf:false,			//ȫ��ת���
	HtmlUnescape:false,			//HTML����
	MultiValueSpliter:"\r\n",	//���ֵ֮��ķָ�����˴��ǻس��ͻ��У�ͬ�������� , ; �ȡ�
	
	
	//Filters�ǰ���˳��ִ�еĹ��˷��������� ftCopy,ftReplace,ftMatch,ftDelete ���ֲ���
	/*
		ÿ�����������ã������漸���ֶ� {
			�ֶ�				��ѡ		����	˵��
			-------------------------------------------
			FilterType			����		�ַ���	��������
			RegException 		��ѡ		����	�Ƿ���ʽ��Ĭ��false��ֻ֧�� false��true2��ֵ
			Exception1 			����		�ַ���	���ʽ1
			Exception2 			��ѡ		�ַ���	���ʽ2��ftCopy��ftReplace��ftMatchʱ���Ǳ�ѡ��
			FilterOptions		��ѡ		�ַ���	����ѡ�������foIgnoreCase, foAll, foRegMultiLine, foRegSingleLine ���������  ���磺FilterOptions:"[foIgnoreCase, foAll]"},//, foRegMultiLine
													foIgnoreCase		���Դ�Сд				Ĭ��false		
													foAll				ȫ��ƥ��				Ĭ��false
													foRegMultiLine		������ʽ�Ķ���ģʽ	Ĭ��false
													foRegSingleLine		������ʽ�ĵ���ģʽ	Ĭ��true
			Parallel			��ѡ		����	�Ƿ�׷�ӵ����棬
													true	ƥ����Ľ����׷�ӵ�Դ�ı�������Ϊ���������
													false	ƥ����Ľ���Ǳ������Ľ��							
			MultiValueSpliter	��ѡ		�ַ���	�ָ�����Ĭ���Ǹ��ڵ��MultiValueSpliter�������ǰ���������˴�ֵ���Դ�Ϊ׼��						
			BeforeStr			��ѡ		�ַ���	���������ǰ��׷�ӵ��ַ�����Ĭ�Ͽ�
			AfterStr			��ѡ		�ַ���	�������������׷�ӵ��ַ�����Ĭ�Ͽ�
 
		���������ֲ�����˵��	
		ftCopy 		���ı��и������ݳ������ӿ�Exception1��ʼ��λ�õ�Exception2������λ�� �������ݣ�����ж��ƥ����Ŀ����FilterOptions ����foAll��ʱ�򣬻������ƥ�������÷ָ����ֿ�
		ftReplace	�滻����Exception1�����ݣ��滻ΪException2�����ݣ���Exception1��������ʽʱ��Exception2������$0 $1 ��ƥ����Ŀ
		ftMatch		���ʽ����ȡ����ftCopy��ͬ��ֻ֧�ֱ��ʽ����Ҫ��Exception2��ƥ����������ݣ�һЩ����£�������ftReplaceͨ�á�
		fgDelete	ɾ��ƥ�����Exception2=""ʱ�򣬵�ͬ��ftReplace����Exception1 Exception2 ����Ϊ��ʱ��ɾ��2��֮���ƥ���
		
		
		ע�⣺
			1�����е��ַ�������ʹ��js��ת����ţ�����\\
			2��FiltersΪ�յ�ʱ�򣬷��ص���Դ�ļ������ĳһ���ڵ���󣬷���Ϊ�ջ�˽ڵ����֮ǰ�Ľ����
	*/
	
	Filters:[
		{FilterType:"ftCopy",RegException:false,Exception1:"<div class=\"huisefengexian\"></div>",Exception2:"<!-- ������ -->",FilterOptions:"[foAll]" },
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
		{FilterType:"ftReplace",RegException:true,Exception1:"^��",Exception2:" ",FilterOptions:"[foIgnoreCase, foAll, foRegMultiLine]" }   ,

		{FilterType:"ftReplace",RegException:true,Exception1:"<img src=\"([^>]*?)\"[^>]*>",Exception2:"",FilterOptions:"[foIgnoreCase,foAll]" },
		//   	{FilterType:"ftReplace",RegException:true,Exception1:"\\s*$",Exception2:"",FilterOptions:"[foIgnoreCase, foAll, foRegMultiLine]" }   ,
		// {FilterType:"ftReplace",RegException:true,Exception1:"\"\\s+",Exception2:"\"",FilterOptions:"[foIgnoreCase, foAll, foRegMultiLine]" }   ,
		{FilterType:"ftReplace",RegException:true,Exception1:"([^,])[\\r\\n]+",Exception2:"$1",FilterOptions:"[foIgnoreCase, foAll, foRegMultiLine]" }   ,
		{FilterType:"ftMatch",RegException:true,Exception1:"(.+)",Exception2:"{$1}",FilterOptions:"[foIgnoreCase, foAll]" }   ,
		 
		// {FilterType:"ftReplace",RegException:true,Exception1:"\\s+",Exception2:"",FilterOptions:"[foIgnoreCase, foAll]" }
					
	]
}