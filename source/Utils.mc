using Toybox.System;
using Toybox.Communications;
using Toybox.Application;
using Toybox.Lang;
using Toybox.WatchUi;
using Toybox.Time;
using Toybox.Time.Gregorian;

class Utils extends Application.AppBase {
    
    static var INFO_LOCATION_ENDPOINT = "http://localhost/TidesCurrentWebsite/api/tides/get_info_location/?code=";
    static var URL = "http://localhost/TidesCurrentWebsite/api/tides/get_tide_current_by_date/?code=$1$&date=$2$";
    static var TIME_REQUEST_API = 2000;
    	
    function initialize() {    	
        AppBase.initialize();        
    }   
    
    static function getUrl(location, date)
    {
    	return Lang.format(URL, [location, date]);
    } 
    
    static function getUrls(location, date)
    {
    	var url = getUrl(location, date);
    	return {1=>url + "&begin=0&end=5", 2=>url + "&begin=5&end=5", 3=>url + "&begin=10&end=5"};
    } 
   
    static function getCurrentFullDate()
    {    	    	
    	var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT); 
    	var fMedium = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM); 
		//return Lang.format( "$1$-$2$-$3$", [ today.year, month, day ] );
		return {"year" => today.year, "month" => today.month.format("%02d"), "month_medium" => fMedium.month, "day" => today.day.format("%02d"), "day_of_week" => fMedium.day_of_week};		
    }
    
    static function getCurrentDate()
    {    	    	
    	var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT); 
		return Lang.format( "$1$-$2$-$3$", [ today.year, today.month.format("%02d"), today.day.format("%02d") ] );
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
    
    static function getDisplayDate(dateString, addedNumDay, isNext)
    {	
    	var dateDic = convertDateToDictionary(dateString);
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
        if(isNext == true)
        {
        	gMoment = gMoment.add(addedNumDay);
        }
        else
        {
        	gMoment = gMoment.subtract(addedNumDay);
        }
        var info = Gregorian.info(gMoment, Gregorian.FORMAT_SHORT);
        System.println(Lang.format("$1$-$2$-$3$T$4$:$5$:$6$", [
            info.year.format("%4d"),
            info.month.format("%02d"),
            info.day.format("%02d"),
            info.hour.format("%02d"),
            info.min.format("%02d"),
            info.sec.format("%02d")
        ]));
        //var fMedium = Gregorian.info(gMoment, Gregorian.FORMAT_MEDIUM);
        //return {"year" => info.year.format("%4d"), "month" => info.month.format("%02d"), "day" => info.day.format("%02d"), "day_of_week" => fMedium.day_of_week};
    	return Lang.format("$1$-$2$-$3$", [info.year.format("%4d"), info.month.format("%02d"), info.day.format("%02d")]);
    }
     
    static function addOneDay()
    {
    	return new Time.Duration(Gregorian.SECONDS_PER_DAY);
    }
    
    static function convertDateToFullDate(dateString)
    {	
    	var dateDic = convertDateToDictionary(dateString);
    	var year = dateDic["year"].toNumber();
    	var month = dateDic["month"].toNumber();
    	var day = dateDic["day"].toNumber();
		var gMoment = Gregorian.moment({
            :year => year,
            :month => month,
            :day => day           
        });     
        var info = Gregorian.info(gMoment, Gregorian.FORMAT_MEDIUM);  
        return {"year" => info.year.format("%4d"), "month" => info.month, "day" => info.day.format("%02d"), "day_of_week" => info.day_of_week};
    }
    
    static function convertDateToDictionary(date)
    {
    	return {"year" => date.substring(0, 4), "month" => date.substring(5, 7).toString(), "day" => date.substring(8, 10).toString()};
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
	    	//System.println(strSplit);
	    	
	    	date = strSplit.substring(0, strSplit.find("=>{"));
	    	strSplit = strSplit.substring(strSplit.find("=>{") + 3, strSplit.length());  
	    	//System.println(date);
	    	
	    	//System.println("strSplit = " + strSplit); 	
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
	    		//System.println(str);
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
    
    function setTidesData(data)
	{
		var app = Application.getApp();      
   		var keys = data.keys();
   		for(var i = 0; i < keys.size(); i++)
   		{
   			app.setProperty(keys[i], {keys[i] => data[keys[i]]}.toString()); 
   		}
   		System.println("TideDate = " + data); 		
	}
	
	function saveTidesDataToDictionary(data, tmpDic)
	{
   		var keys = data.keys();
   		for(var i = 0; i< keys.size(); i++)
   		{
   			tmpDic.put(keys[i], data[keys[i]].toString());
   		}
	}
	
	function saveLocationInfo(data)
	{
		var app = Application.getApp(); 
		app.setProperty("locationInfo", data.toString());     
   		System.println("locationInfo = " + data); 		
	}		
	
	static function convertTextToMultiline(dc, text, font){
		var extraRoom = 1; //0.8 735xt
		var oneCharWidth = dc.getTextWidthInPixels("EtaoiNshrd", font)/10;
		var charPerLine = extraRoom * dc.getWidth()/oneCharWidth;
		return convertTextToMultilineHelper(text, charPerLine);
	}
	
	static function convertTextToMultilineHelper(text, charPerLine) {		
	    if (text.length() <= charPerLine) {
	        return text;
	    } else {
	        var i = charPerLine + 1;
	        for (; i >= 0; i--) {
	            if (text.substring(i, i + 1).equals("\n")) {
	                break;
	            }
	        }
	        if (i >= 0) {
	            var line = text.substring(0, i);
	            var textLeft = text.substring(i + 1, text.length());
	            var otherLines = convertTextToMultilineHelper(textLeft, charPerLine);
	            return line + "\n" + otherLines;
	        } else {
	            var lastChar = charPerLine + 1;
	            while (!(text.substring(lastChar, lastChar + 1).equals(" ") || text.substring(lastChar, lastChar + 1).equals("\n"))&& lastChar >= charPerLine/2) {
	                lastChar--;
	            }
	            if (lastChar >= charPerLine/2) {
	                var line = text.substring(0, lastChar + 1);
	                var textLeft = text.substring(lastChar + 1, text.length());
	                var otherLines = convertTextToMultilineHelper(textLeft, charPerLine);
	                return line + "\n" + otherLines;
	            } else {
	                var line = text.substring(0, charPerLine) + "-";
	                var textLeft = text.substring(charPerLine, text.length());
	                var otherLines = convertTextToMultilineHelper(textLeft, charPerLine);
	                return line + "\n" + otherLines;
	            }
	        }
	    }
	}
	
	function countChars(text, pattern)
	{
		var arrChars = text.toCharArray();
		var count = 0;
		
		for(var i = 0; i < arrChars.size(); i++)
		{
			if (text.substring(i, i + 1).equals(pattern))
			{
				count++;
			}
		}		
		return count;
	}	
    
}