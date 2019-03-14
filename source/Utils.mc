using Toybox.System;
using Toybox.Communications;
using Toybox.Application;
using Toybox.Lang;
using Toybox.WatchUi;
using Toybox.Time;
using Toybox.Time.Gregorian;

class Utils extends Application.AppBase {
    
    static var URL = "http://localhost/TidesCurrent/public/test/$1$/$2$/$3$/";
    	
    function initialize() {    	
        AppBase.initialize();        
    }   
    
    static function getUrl(location, year, month)
    {
    	return Lang.format(URL, [location, year, month]);
    } 
    
    static function getUrls(location, year, month)
    {
    	var url = getUrl(location, year, month);
    	return {1=>url + "0/5", 2=>url + "5/5", 3=>url + "10/5", 4=>url + "15/5", 5=>url + "20/5", 6=>url + "25/6"};
    } 
   
    static function getCurrentDate()
    {    	    	
    	var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT); 
    	var fMedium = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM); 
		//return Lang.format( "$1$-$2$-$3$", [ today.year, month, day ] );
		return {"year" => today.year, "month" => today.month.format("%02d"), "month_medium" => fMedium.month, "day" => today.day.format("%02d"), "day_of_week" => fMedium.day_of_week};		
    }
    
    static function getCurrentMonth()
    {
    	var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    	return today.month.format("%02d"); 	
    }
    
    static function getCurrentDay()
    {
    	var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT); 
    	return today.day.format("%02d");  	
    }
    
    static function getCurrentYear()
    {
    	var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT); 
    	return today.year.format("%4d");  
    }
    
    static function getDateByAddedDay(dateDic, addedNumDay)
    {	
    	var year = dateDic["year"].toNumber();
    	var month = dateDic["month"].toNumber();
    	var day = dateDic["day"].toNumber();
    	//https://forums.garmin.com/forum/developers/connect-iq/122767-
		var gMoment = Gregorian.moment({
            :year => year,
            :month => month,
            :day => day,
            :hour => 0,
            :minute => 0,
            :second => 0
        });
        gMoment = gMoment.add(addedNumDay);
        var info = Gregorian.info(gMoment, Gregorian.FORMAT_SHORT);
        System.println(Lang.format("$1$-$2$-$3$T$4$:$5$:$6$", [
            info.year.format("%4d"),
            info.month.format("%02d"),
            info.day.format("%02d"),
            info.hour.format("%02d"),
            info.min.format("%02d"),
            info.sec.format("%02d")
        ]));
        var fMedium = Gregorian.info(gMoment, Gregorian.FORMAT_MEDIUM);
        return {"year" => info.year.format("%4d"), "month" => info.month.format("%02d"), "day" => info.day.format("%02d"), "day_of_week" => fMedium.day_of_week};
    }
    
    static function addOneDay()
    {
    	return new Time.Duration(Gregorian.SECONDS_PER_DAY);
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
    
    static function upperFirstLetterCase(str)
    {
    	return str.substring(0, 1).toUpper() + str.substring(1, str.length());
    }
    
}