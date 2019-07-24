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
    static var TIME_REQUEST_API = 1000;
    static var ANGLE = 360;
    static var NUMBER_RECORD_GREATER_64K = 14;
    static var NUMBER_RECORD_LESS_64K = 7;
    static var FIX_PREVIOUS_PAGE_PER_DEVICE = ["fr235", "semi-round"];
    static var REQUEST_NUMBER_PER_DEVICE = ["fr235", "fenix3", "vivoactive", "vivoactive-hr", "d2-face"]; //64kb mem
    static var SPECIAL_FONT_ON_DEIVICE = ["fr920xt", "vivoactive_hr"];
    static var LAT = "latitude";
    static var LONG = "longitude";
    static var LOCATION = "location";
    static var CODE = "code";
    static var DISPLAYED_DATE = "displayedDate";
    static var OLD_CODE = "oldCode";
    static var NAME = "name";
    static var STATUS_TIDE_1 = ["slack1", "flood1", "slack2", "ebb1", "slack3", "flood2", "slack4", "ebb2", "slack5", "flood3", "slack6", "moon", "sunrise", "sunset", "moonrise", "moonset"];       					
    static var STATUS_TIDE_2 = ["high1" , "low1" , "high2", "low2", "high3", "low3", "high4", "low4", "moon", "sunrise", "sunset", "moonrise", "moonset"];  
    	
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
    	var device = WatchUi.loadResource(Rez.Strings.Device);
    	if (REQUEST_NUMBER_PER_DEVICE.toString().find(device) != null) 
    	{    	
    		//return {1=>url + "&begin=0&end=2", 2=>url + "&begin=2&end=2", 3=>url + "&begin=4&end=2", 4=>url + "&begin=6&end=1"};
    		//return { "number" => NUMBER_RECORD_LESS_64K, "url" => {1=>url + "&begin=0&end=3", 2=>url + "&begin=3&end=2", 3=>url + "&begin=5&end=2"} };
    		return { "number" => NUMBER_RECORD_GREATER_64K, "url" => {1=>url + "&begin=0&end=5", 2=>url + "&begin=5&end=5", 3=>url + "&begin=10&end=4"} };
    	}
    	else
    	{
    		return { "number" => NUMBER_RECORD_GREATER_64K, "url" => {1=>url + "&begin=0&end=5", 2=>url + "&begin=5&end=5", 3=>url + "&begin=10&end=4"} };
    	}
    } 
   
    static function getCurrentFullDate()
    {    	    	
    	var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT); 
    	var fMedium = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM); 
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
    	return Lang.format("$1$-$2$-$3$", [info.year.format("%4d"), info.month.format("%02d"), info.day.format("%02d")]);
    }
     
    static function addOneDay()
    {
    	return new Time.Duration(Gregorian.SECONDS_PER_DAY);
    }
    
    static function subtractOneDay()
    {
    	return new Time.Duration(-Gregorian.SECONDS_PER_DAY);
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
    	System.println("current date = " + str);
    	
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
	    	
	    	date = strSplit.substring(0, strSplit.find("=>{"));
	    	strSplit = strSplit.substring(strSplit.find("=>{") + 3, strSplit.length());  
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
	    		dic[key.substring(1, key.length() - 1)] = value.substring(1, value.length() - 1);
	    		isStop = false;
    		}
    		else
    		{
	   			var item = str.substring(0, str.find(","));
	   			var key = item.substring(0, item.find(":"));  
	    		var value = item.substring(item.find(":") + 1, item.length());  
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
   	   				
   	   			case 9:
   	   				return View.findDrawableById("id_label9");
   	   				
   	   			case 10:
   	   				return View.findDrawableById("id_label10");
   	   				
   	   			case 11:
   	   				return View.findDrawableById("id_label11");
   	   				
   	   			case 12:
   	   				return View.findDrawableById("id_label12");
   	   				
   	   			case 13:
   	   				return View.findDrawableById("id_label13");
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
	
	static function displayMultilineOnScreen(dc, text, font, extraRoom){
		var oneCharWidth = dc.getTextWidthInPixels("EtaoiNshrd", font)/10;
		var charPerLine = extraRoom * dc.getWidth()/oneCharWidth;
		return convertTextToMultiline(text, charPerLine);
	}
	
	static function convertTextToMultiline(text, charPerLine) {		
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
	            var otherLines = convertTextToMultiline(textLeft, charPerLine);
	            return line + "\n" + otherLines;
	        } else {
	            var lastChar = charPerLine + 1;
	            while (!(text.substring(lastChar, lastChar + 1).equals(" ") || text.substring(lastChar, lastChar + 1).equals("\n"))&& lastChar >= charPerLine/2) {
	                lastChar--;
	            }
	            if (lastChar >= charPerLine/2) {
	                var line = text.substring(0, lastChar + 1);
	                var textLeft = text.substring(lastChar + 1, text.length());
	                var otherLines = convertTextToMultiline(textLeft, charPerLine);
	                return line + "\n" + otherLines;
	            } else {
	                var line = text.substring(0, charPerLine) + "-";
	                var textLeft = text.substring(charPerLine, text.length());
	                var otherLines = convertTextToMultiline(textLeft, charPerLine);
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
	
	function displayFirstLine(text)
    {
    	var specialCharNum = text.find("\n");
    	if(specialCharNum != null)
    	{
    		return text.substring(0, specialCharNum);
    	}
    	else
    	{
    		return text;
    	}
    }
    
    static function convertTimeFormatBySettings(text)
    {
    	if(WatchUi.loadResource( Rez.Strings.IsTime24Format ).toNumber() == 1)
    	{
	    	var am = text.find("AM");    	
	    	
	    	if(am != null)
	    	{
	    		return splitLocalTime(text.substring(0, am - 1) + text.substring(am + 2, text.length()), true);
	    	}
	    	else
	    	{
	    		var pm = text.find("PM");
	    		if(pm != null)
	    		{
	    			var time = text.substring(0, pm - 1);
	    			var hour = time.find(":");
	    			if(hour != null)
	    			{
	    				var h = time.substring(0, hour).toNumber() + 12;
	    				time = h.toString() + ":" + time.substring(hour + 1, time.length());
	    			}
	    			return splitLocalTime(time + text.substring(pm + 2, text.length()), true);
	    		}
	    		else
	    		{
	    			return splitLocalTime(text, false);
	    		}
	    	}
    	} else {
    		return splitLocalTime(text, false);
    	}
    }
    
    static function splitLocalTime(text, isFormat24H)
    {
    	if(WatchUi.loadResource( Rez.Strings.SplitLocalTime ).toNumber() == 1)
    	{
	    	if(isFormat24H)
	    	{
	    		var space = text.find(" ");
	    		var time = text.substring(0, space);
	    		var leftTime = text.substring(space + 1, text.length());
	    		space = leftTime.find(" ");	
	    		var localTime = "";    		
	    			
	    		if(space != null)
	    		{
	    			localTime = leftTime.substring(0, space);
		    		var leftPart = leftTime.substring(space + 1, leftTime.length());
		    		return { 0 => localTime, 1 => time + " " + leftPart };
	    		}
	    		else
	    		{
	    			return { 0 => leftTime, 1 => time };
	    		}
	    	}
	    	else
	    	{
	    		var am = text.find("AM");
	    		var pm = text.find("PM");
	    		var pos;
	    		
	    		if(am != null)
	    		{
	    			pos = am;
	    		}
	    		else
	    		{
	    			pos = pm;
	    		}
	    		
	    		if(pos != null)
	    		{
		    		var time = text.substring(0, pos + 1);
		    		var leftTime = text.substring(pos + 2, text.length());
		    		var space = leftTime.find(" ");
		    		var localTime = leftTime.substring(0, space);
		    		var leftPart = leftTime.substring(space + 1, leftTime.length());
		    		return { 0 => localTime, 1 => time + " " + leftPart }; 
	    		}
	    		else
	    		{
	    			return { 0 => "", 1 => text };
	    		}
	    	}
    	}
    	else
    	{
    		return { 0 => "", 1 => text };
    	}
    }
	
	function checkPhoneConnected()
	{
		return System.getDeviceSettings().phoneConnected;
	}
	
	function setProperty(propName, propValue)
	{
		return Application.getApp().setProperty(propName, propValue);
	}
	
	function getProperty(propName)
	{
		return Application.getApp().getProperty(propName);
	}
	
	function clearProperties()
	{
		Application.getApp().clearProperties();
	}
	
	function getLabelStatusTide(key)
	{
		if (key.find("slack") != null)
		{
			return WatchUi.loadResource( Rez.Strings.Slack );
		}
		else
		if (key.find("flood") != null)
		{
			return WatchUi.loadResource( Rez.Strings.Flood );
		}
		else
		if (key.find("ebb") != null)
		{
			return WatchUi.loadResource( Rez.Strings.Ebb );
		}
		else
		if (key.find("high") != null)
		{
			return WatchUi.loadResource( Rez.Strings.High );
		}
		else
		if (key.find("low") != null)
		{
			return WatchUi.loadResource( Rez.Strings.Low );
		}
		else
		if (key.equals("moon"))
		{
			return WatchUi.loadResource( Rez.Strings.Moon );
		}
		else
		if (key.equals("sunrise"))
		{
			return WatchUi.loadResource( Rez.Strings.Sunrise );
		}
		else
		if (key.equals("sunset"))
		{
			return WatchUi.loadResource( Rez.Strings.Sunset );
		}
		else
		if (key.equals("moonrise"))
		{
			return WatchUi.loadResource( Rez.Strings.Moonrise );
		}
		else
		if (key.equals("moonset"))
		{
			return WatchUi.loadResource( Rez.Strings.Moonset );
		}
		return "";
	}
	
	static function loadMainFont()
	{
		var device = WatchUi.loadResource(Rez.Strings.Device);
    	if (SPECIAL_FONT_ON_DEIVICE.toString().find(device) != null) 
    	{
    		return WatchUi.loadResource(Rez.Fonts.font_12);
    	}
    	else
    	{
    		return WatchUi.loadResource(Rez.Fonts.small_font);
    	}
	}
    
}