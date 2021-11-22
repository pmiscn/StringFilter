{
	FullToHalf:false,
	HtmlUnescape:false,
	MultiValueSpliter:"\r\n",
	Filters:[
        {  FilterType:"ftReplace", RegException:true,Exception1:"(\\w+)(\\d+)",
           Exception2:"$1-$2",FilterOptions:"[foIgnoreCase, foAll]" 
        },
   
 				
	]
}