using Toybox.System;
using Toybox.Communications;
using Toybox.Application;
using Toybox.Lang;
using Toybox.WatchUi;
using Toybox.Time;
using Toybox.Time.Gregorian;

class Utils extends Application.AppBase {
    
    function initialize() {    	
        AppBase.initialize();        
    }    
   
    static function GetCurrentDate()
    {    	    	
    	var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT); 
    	var month = today.month.toString();
		var day = today.day.toString();
    	
    	if(month.length() == 1)
    	{
    		month = "0" + today.month;
    	}    	
    	if(day.length() == 1)
    	{
    		day = "0" + today.day;
    	}    	
		return Lang.format( "$1$-$2$-$3$", [ today.year, month, day ] );		
    }
    
    static function getCurrentMonth()
    {
    	var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT); 
    	var month = today.month.toString();  	
    	if(month.length() == 1)
    	{
    		month = "0" + today.month;
    	}
    	return month;
    }
    
    static function getCurrentDay()
    {
    	var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT); 
    	var day = today.day.toString();  	
    	if(day.length() == 1)
    	{
    		day = "0" + today.day;
    	}
    	return day;
    }
    
    static function getCurrentYear()
    {
    	var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT); 
    	return today.year.toString();  
    }
    
    function addOneday()
    {
    	//var date = new Time.Moment(Time.today().value());
		var oneDay = new Time.Duration(Gregorian.SECONDS_PER_DAY);
		//return date.add(oneDay);
		
		var now = Gregorian.info(Time.now(), Gregorian.FORMAT_SHORT);
		var first_day_of_month = Gregorian.moment({
            :year => now.year,
            :month => now.month,
            :day => now.day,
            :hour => 0,
            :minute => 0,
            :second => 0
        });
        first_day_of_month = first_day_of_month.add(oneDay);
        var info = Gregorian.info(first_day_of_month, Gregorian.FORMAT_SHORT);
        System.println(Lang.format("$1$-$2$-$3$T$4$:$5$:$6$", [
            info.year.format("%4d"),
            info.month.format("%02d"),
            info.day.format("%02d"),
            info.hour.format("%02d"),
            info.min.format("%02d"),
            info.sec.format("%02d")
        ]));
    }
    
    static function convertStringToDictionary(str)
    {   
    	var dic = {}; 
    	var isStop = true;
    	var strSplit;
    	var date;
    	
    	str = str.substring(1, str.length()-2);
    	System.println(str);
    	
    	while( isStop )
    	{
    		if(str.find("}, ") == null && str.length() > 0)
    		{
	    		strSplit = str;		
	    		isStop = false;	    	
	    	}
	    	else
	    	{
	    		strSplit = str.substring(0, str.find("}, "));
	    		str = str.substring(str.find("}, ") + 3, str.length());
	    	}
	    	System.println(strSplit);
	    	
	    	date = strSplit.substring(0, strSplit.find("=>{"));
	    	strSplit = strSplit.substring(strSplit.find("=>{") + 3, strSplit.length());  
	    	System.println(date);
	    	
	    	System.println("strSplit = " + strSplit); 	
	    	dic[date] = elements(strSplit);   	
    	}    
    	return dic;
    }
    
    static function elements(str)
    {
    	var dic = {};
    	var isStop = true;
    	while( isStop )   
    	{
    		if(str.find(", ") == null && str.length() > 0)
    		{
    			var key = str.substring(0, str.find("=>"));  
	    		var value = str.substring(str.find("=>") + 2, str.length());  
	    		dic[key] = value;
	    		isStop = false;
    		}
    		else
    		{
	   			var item = str.substring(0, str.find(", "));
	   			var key = item.substring(0, item.find("=>"));  
	    		var value = item.substring(item.find("=>") + 2, item.length());  
	    		dic[key] = value;
	    		str = str.substring(str.find(", ") + 2, str.length());
	    		System.println(str);
    		}
   		}
   		return dic;		
    }    
    
    static function convertJsonStringToDictionary(str)
    {   
    	var dic = {}; 
    	var isStop = true;
    	var strSplit;
    	var date;
    	
    	str = str.substring(0, str.length()-2);
    	System.println(str);
    	
    	while( isStop )
    	{
    		if(str.find("},") == null && str.length() > 0)
    		{
	    		strSplit = str;		
	    		isStop = false;	    	
	    	}
	    	else
	    	{
	    		strSplit = str.substring(0, str.find("},"));
	    		str = str.substring(str.find("},") + 2, str.length());
	    	}
	    	System.println(strSplit);
	    	
	    	date = strSplit.substring(0, strSplit.find(":{"));
	    	strSplit = strSplit.substring(strSplit.find(":{") + 2, strSplit.length());  
	    	System.println(date);
	    	
	    	System.println("strSplit = " + strSplit); 	
	    	dic[date.substring(1, date.length() - 1)] = jsonElements(strSplit);   	
	    	//System.println("DIC = " + dic); 
    	}    
    	return dic;
    }
    
    static function jsonElements(str)
    {
    	var dic = {};
    	var isStop = true;
    	while( isStop )   
    	{
    		if(str.find(",") == null && str.length() > 0)
    		{
    			var key = str.substring(0, str.find(":"));  
	    		var value = str.substring(str.find(":") + 1, str.length()); 
	    		//System.println("key = " + key.substring(1, key.length() - 1));
	    		//System.println("value = " + value.substring(1, value.length() - 1)); 
	    		dic[key.substring(1, key.length() - 1)] = value.substring(1, value.length() - 1);
	    		isStop = false;
    		}
    		else
    		{
	   			var item = str.substring(0, str.find(","));
	   			var key = item.substring(0, item.find(":"));  
	    		var value = item.substring(item.find(":") + 1, item.length());  
	    		//System.println("key = " + key.substring(1, key.length() - 1));
	    		//System.println("value = " + value.substring(1, value.length() - 1)); 
	    		dic[key.substring(1, key.length() - 1)] = value.substring(1, value.length() - 1);
	    		str = str.substring(str.find(",") + 1, str.length());
	    		System.println(str);
    		}
   		}
   		return dic;		
    }    
 
 	function GetViewLabelOnLayout(index)
    {
    	switch (index)
   	   		{
   	   			case 1:
   	   				return View.findDrawableById("id_label1");	
   	   			break;
   	   			
   	   			case 2:
   	   				return View.findDrawableById("id_label2");
   	   			break;
   	   			
   	   			case 3:
   	   				return View.findDrawableById("id_label3");
   	   			break;
   	   			
   	   			case 4:
   	   				return View.findDrawableById("id_label4");
   	   			break;
   	   			
   	   			case 5:
   	   				return View.findDrawableById("id_label5");
   	   			break;
   	   			
   	   			case 6:
   	   				return View.findDrawableById("id_label6");
   	   			break;
   	   			
   	   			case 7:
   	   				return View.findDrawableById("id_label7");
   	   			break;
   	   			
   	   			case 8:
   	   				return View.findDrawableById("id_label8");
   	   			break;
   	   		}
    }
    
    function upperFirstLetterCase(str)
    {
    	return str.substring(0, 1).toUpper() + str.substring(1, str.length());
    }
    
}