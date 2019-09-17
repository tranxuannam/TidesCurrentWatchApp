using Toybox.WatchUi;
using Toybox.AntPlus;
using Toybox.System;
using Toybox.Application;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Position;
using Toybox.Graphics;

class TidesCurrentWatchAppView extends WatchUi.View {
	
	hidden var font;
	hidden var locations;
	hidden var posnInfo = null;
       
    function initialize() {
        View.initialize();
        font = Utils.loadSmallFont();
    }
    
    // Load your resources here
    function onLayout(dc) {     
    }
   
    // Update the view
    function onUpdate(dc) {         
        if(Utils.getProperty("displayedDate") != null)
        {
			onDisplayMainView(dc, Utils.getProperty("displayedDate")); 
        } 
        else
        {
	        onDisplayMessageInitApp(dc);
       	}
    } 
    
    function getSuggestLocation(lat, long)
    {
    	var delegate = new WebResponseDelegate(null);
    	delegate.makeWebRequest(Utils.getUrlNearLocation(lat, long), self.method(:onReceiveLocations));	
    }
    
    function setPosition(info) {
    	System.println("setPosition");
        posnInfo = info;
        //getSuggestLocation(posnInfo.position.toDegrees()[0].toNumber(), posnInfo.position.toDegrees()[1].toNumber());
        getSuggestLocation(47.2858, -122.5445);
        posnInfo = null;
    }
    
    function onReceiveLocations(responseCode, data, code) { 
		if (responseCode == 200) {
			var fonts;
			
			var device = WatchUi.loadResource(Rez.Strings.Device);
			if (device.find("edge") != null || device.find("rectangle") != null)
			{
				fonts = { :small => Graphics.FONT_XTINY, :large => Graphics.FONT_TINY };
			}
			else
			{
				fonts = { :small => font, :large => Graphics.FONT_TINY };
			}
						
			var dMenu = [];
			
			for(var i = 0; i < data.size(); i++)
			{
				dMenu.add(new DMenuItem ("dmenu_" + i, data[i].get("name"), null, null, fonts));
			}
			 
	        var view = new DMenu (dMenu, WatchUi.loadResource( Rez.Strings.SelectedLocations ), fonts[:small]);
			WatchUi.switchToView(view, new DMenuDelegate (view, new LocationMenuDelegate (view, data)), WatchUi.SLIDE_IMMEDIATE);
		}
		else {
			System.println("Response: " + responseCode);					
		}
	}
	
	function onPosition(info) {
	    locations = info.position.toDegrees();
	}
    
    function onDisplayMessageInitApp(dc)
    {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
		dc.clear();		
		var cx = dc.getWidth() / 2;
		var cy = dc.getHeight() / 2;		
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		var text = Utils.displayMultilineOnScreen(dc, WatchUi.loadResource( Rez.Strings.FindLocations ), font, WatchUi.loadResource( Rez.Strings.ExtraRoom ).toFloat());
       	var centerY = 0;
       	
		if(text.length() >= Utils.CHARS_PER_LINE)
		{
			centerY = cy - (Utils.countChars(text, "\n") + 1) * 10;
		}
		else
		{		
       		centerY = cy / 2;
       	} 
       	
       	dc.drawText(cx, centerY, font, text, Graphics.TEXT_JUSTIFY_CENTER);
    }  
    
    function onDisplayMainView(dc, displayedDate) 
    {    
       var dateDic = Utils.convertDateToFullDate(displayedDate);
       var tidesData = Utils.getProperty(displayedDate);      
       var displayDate = Lang.format( "$1$ $2$ $3$ $4$", [ dateDic["day_of_week"], dateDic["month"], dateDic["day"], dateDic["year"] ] );
	   var tidesDataDic = Utils.convertStringToDictionary(tidesData)[displayedDate];      
  	   
  	   //Tide date
  	   dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
	   dc.clear();		
	   dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);  	   
  	   dc.drawText(WatchUi.loadResource( Rez.Strings.XDate ).toNumber(), WatchUi.loadResource( Rez.Strings.YDate ).toNumber(), font, Utils.displayMultilineOnScreen(dc, displayDate, font, WatchUi.loadResource( Rez.Strings.ExtraRoomDateTime ).toFloat()), Graphics.TEXT_JUSTIFY_CENTER);
  	   
  	   //Write a line
  	   Utils.drawCustomLine(dc);
  	   
  	   //Current date
  	   var currDate = Utils.convertDateToFullDate(Utils.getCurrentDate());
  	   var currDateFormat = Lang.format( "$1$ $2$ $3$", [ currDate["month"], currDate["day"], currDate["year"] ] );
  	   dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
  	   
  	   var device = WatchUi.loadResource(Rez.Strings.Device);
  	   if (device.find("vivoactive-hr") != null)
  	   {
  	   		dc.drawText(WatchUi.loadResource( Rez.Strings.XCurrDate ).toNumber(), WatchUi.loadResource( Rez.Strings.YCurrDate ).toNumber(), font, currDateFormat, Graphics.TEXT_JUSTIFY_LEFT);
  	   } 
  	   else
  	   {
  	   		dc.drawText(dc.getWidth() / 2, WatchUi.loadResource( Rez.Strings.YCurrDate ).toNumber(), font, currDateFormat, Graphics.TEXT_JUSTIFY_CENTER);
  	   }	
  	      
       var localTime = onSwitchTypeTideCurrent(dc, tidesDataDic, font);            
       
       if(WatchUi.loadResource( Rez.Strings.IsTime24Format ).toNumber() == 1)
       {
       		onDisPlayTime24HFormat(dc, font, WatchUi.loadResource( Rez.Strings.XTimeFormat ).toNumber(), WatchUi.loadResource( Rez.Strings.YTimeFormat ).toNumber());
       }
       
       if(WatchUi.loadResource( Rez.Strings.SplitLocalTime ).toNumber() == 1)
       {
       		onLocalTime(dc, font, WatchUi.loadResource( Rez.Strings.XLocalTime ).toNumber(), WatchUi.loadResource( Rez.Strings.YLocalTime ).toNumber(), localTime);
       }       
    }  
    
    function onSwitchTypeTideCurrent(dc, tidesDataDic, font)
    {
    	var keys = tidesDataDic.keys();  
    	var data;
    	if(tidesDataDic.toString().find("high") != null || tidesDataDic.toString().find("low") != null)
		{
			data = Utils.STATUS_TIDE_2;
		}
		else
		{
			data = Utils.STATUS_TIDE_1;
		}
    	return onShowTidesData(dc, Utils.NUMBER_LINE_ON_SCREEN, data, tidesDataDic, font);
    }
    
    function onShowTidesData(dc, row, statusTide, tidesDataDic, font)
    {
       var view;
       var i = 1;
       var data = {};       
       var step = 0;
       
       dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
       
       for (var j = 0; j < statusTide.size(); j++)
   	   {
   	   		if(i == row + 1 || tidesDataDic.keys().size() + 1 == i)
   	   		{
   	   			break;
   	   		}
   	   		
   	   		var key = statusTide[j];
   	   		if(tidesDataDic.hasKey(key))
   	   		{
	   	   		data = Utils.convertTimeFormatBySettings(Utils.displayFirstLine(tidesDataDic[key]));
	   	   		dc.drawText(WatchUi.loadResource( Rez.Strings.XData ).toNumber(), WatchUi.loadResource( Rez.Strings.YData ).toNumber() + step, font, Utils.getLabelStatusTide(key) + ": " + data[1], Graphics.TEXT_JUSTIFY_LEFT);
	   	   		step += WatchUi.loadResource( Rez.Strings.Distance2Line ).toNumber();
	   	   		i++;  
   	   		}  	   		
       }      
       return data[0];
    }
    
    function onDisPlayTime24HFormat(dc, font, x, y)
    {    	
    	dc.setPenWidth(1);
    	dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
    	dc.drawText(x - 2, y, font, WatchUi.loadResource( Rez.Strings.TimeFormat ), Graphics.TEXT_JUSTIFY_LEFT);
		dc.drawArc(x + 4, y + 7, 10, Graphics.ARC_COUNTER_CLOCKWISE, 0, 360);
    }  
    
    function onLocalTime(dc, font, x, y, message)
    {    	
    	dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
    	dc.drawText(x, y, font, message, Graphics.TEXT_JUSTIFY_LEFT);
    } 
    
}