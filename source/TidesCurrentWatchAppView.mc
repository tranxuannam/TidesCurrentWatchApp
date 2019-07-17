using Toybox.WatchUi;
using Toybox.AntPlus;
using Toybox.System;
using Toybox.Application;
using Toybox.Time;
using Toybox.Time.Gregorian;

class TidesCurrentWatchAppView extends WatchUi.View {

	hidden var extraRoom = 0.8;
	
    function initialize() {
        View.initialize();
    }
    
    // Load your resources here
    function onLayout(dc) {     
        setLayout(Rez.Layouts.MainLayout(dc));       
    }
   
    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout      
         
        if(Utils.getProperty(Utils.DISPLAYED_DATE) != null)
        {
        	System.println("onUpdate in TidesCurrentWatchAppView");
			onDisplayMainView(dc, Utils.getProperty(Utils.DISPLAYED_DATE)); 
        } 
        else
        {
	        onDisplayMessageInitApp(dc);
       	}
    } 
    
    function onDisplayMessageInitApp(dc)
    {
    	var customFont = WatchUi.loadResource(Rez.Fonts.large_font);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
		dc.clear();		
		var cx = dc.getWidth() / 2;
		var cy = dc.getHeight() / 3;		
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		var text = Utils.displayMultilineOnScreen(dc, WatchUi.loadResource( Rez.Strings.AppSettingRequired ), customFont, extraRoom);
       	dc.drawText(cx, cy, customFont, text, Graphics.TEXT_JUSTIFY_CENTER);
    }  
    
    function onDisplayMainView(dc, displayedDate) {    
       var smallCustomFont = WatchUi.loadResource(Rez.Fonts.small_font);
       var largeCustomFont = WatchUi.loadResource(Rez.Fonts.large_font);
       var font12 = WatchUi.loadResource(Rez.Fonts.font_12);
       
       var dateDic = Utils.convertDateToFullDate(displayedDate);
       var tidesData = Utils.getProperty(displayedDate);       
       
       					
       var displayDate = Lang.format( "$1$ $2$ $3$ $4$", [ dateDic["day_of_week"], dateDic["month"], dateDic["day"], dateDic["year"] ] );
	   var tidesDataDic = Utils.convertStringToDictionary(tidesData)[displayedDate];
 
 		/*
 	   var appNameView = View.findDrawableById("id_app_name");
 	   appNameView.setFont(largeCustomFont);
 	   */
  	   //var dateView = View.findDrawableById("id_date");	
  	   //dateView.setFont(font12);
  	   //dateView.setText(displayDate);
  	   
  	   var dateView = View.findDrawableById("id_date");	
  	   dateView.setFont(font12);
  	   dateView.setText(Utils.displayMultilineOnScreen(dc, displayDate, font12, 0.1));
  	   dateView.setColor(Graphics.COLOR_LT_GRAY);
  	 
  	   var currDateString = WatchUi.loadResource( Rez.Strings.CurrDate ); 	
  	   var currDate = Utils.convertDateToFullDate(Utils.getCurrentDate());
  	   var currDateFormat = Lang.format( "$1$, $2$ $3$ $4$", [ currDate["day_of_week"], currDate["month"], currDate["day"], currDate["year"] ] );
  	   var currDateView = View.findDrawableById("id_currDate");	
  	   currDateView.setFont(font12);
  	   currDateView.setText(currDateFormat);
  	   currDateView.setColor(Graphics.COLOR_LT_GRAY);  
  	   
       var localTime = onSwitchTypeTideCurrent(tidesDataDic, smallCustomFont);
            
       View.onUpdate(dc);
       
       if(WatchUi.loadResource( Rez.Strings.IsTime24Format ).toNumber() == 1)
       {
       		onDisPlayTime24HFormat(dc, font12, WatchUi.loadResource( Rez.Strings.XTimeFormat ).toNumber(), WatchUi.loadResource( Rez.Strings.YTimeFormat ).toNumber());
       }
       
       if(WatchUi.loadResource( Rez.Strings.SplitLocalTime ).toNumber() == 1)
       {
       		//System.println("data[0] = " + data[0]);
       		onLocalTime(dc, font12, WatchUi.loadResource( Rez.Strings.XTimeFormat ).toNumber(), WatchUi.loadResource( Rez.Strings.YTimeFormat ).toNumber(), localTime);
       }       
    }  
    
    function onSwitchTypeTideCurrent(tidesDataDic, smallCustomFont)
    {
    	var statusTide1 = ["slack1", "flood1", "slack2", "ebb1", "slack3", "flood2", "slack4", "ebb2", "slack5", "flood3", "slack6", "moon", "sunrise", "sunset", "moonrise", "moonset"];       					
        var statusTide2 = ["high1" , "low1" , "high2", "low2", "high3", "low3", "high4", "low4", "moon", "sunrise", "sunset", "moonrise", "moonset"];
    	var keys = tidesDataDic.keys();
    	
    	for (var i = 0; i < keys.size(); i++)
    	{
    		if(keys[i].find("high") != null || keys[i].find("low") != null)
    		{
    			return onShowTidesData(13, statusTide2, tidesDataDic, smallCustomFont);
    		}
    		else
    		{
    			return onShowTidesData(13, statusTide1, tidesDataDic, smallCustomFont);
    		}
    	}
    }
    
    function onShowTidesData(row, statusTide, tidesDataDic, font)
    {
       var view;
       var i = 1;
       var data = {};
       
       for (var j = 0; j < statusTide.size(); j++)
   	   {
   	   		if(i == row + 1 || tidesDataDic.keys().size() + 1 == i)
   	   		{
   	   			break;
   	   		}
   	   		
   	   		var key = statusTide[j];
   	   		if(tidesDataDic.hasKey(key))
   	   		{
	   	   		view = Utils.GetViewLabelOnLayout(i);	   	   		
	   	   		view.setFont(font);
	   	   		data = Utils.convertTimeFormatBySettings(Utils.displayFirstLine(tidesDataDic[key]));
	   	   		view.setText(Utils.upperFirstLetterCase(key.substring(0, key.length() - 1)) + ": " + data[1]);
	   	   		i++;  
   	   		}
   	   		/*
   	   		for (var l = i; l <= row; l++)
   	   		{
   	   			view = Utils.GetViewLabelOnLayout(l);
   	   			view.setText("");
   	   		}*/
       }
       return data[0];
    }
    
    function onDisPlayTime24HFormat(dc, font, x, y)
    {    	
    	dc.setPenWidth(1);
    	dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
    	dc.drawText(x, y, font, WatchUi.loadResource( Rez.Strings.TimeFormat ), Graphics.Graphics.TEXT_JUSTIFY_LEFT);
		dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
		dc.drawArc(x + 5, y + 7, 9, Graphics.ARC_COUNTER_CLOCKWISE, 0, 360);
    }  
    
    function onLocalTime(dc, font, x, y, message)
    {    	
    	dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
    	dc.drawText(x + 20, y, font, message, Graphics.Graphics.TEXT_JUSTIFY_LEFT);
    } 
    
}