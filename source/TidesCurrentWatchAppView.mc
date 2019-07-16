using Toybox.WatchUi;
using Toybox.AntPlus;
using Toybox.System;
using Toybox.Application;
using Toybox.Time;
using Toybox.Time.Gregorian;

class TidesCurrentWatchAppView extends WatchUi.View {

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
		var text = Utils.displayMultilineOnScreen(dc, WatchUi.loadResource( Rez.Strings.AppSettingRequired ), customFont);
       	dc.drawText(cx, cy, customFont, text, Graphics.TEXT_JUSTIFY_CENTER);
    }  
    
    function onDisplayMainView(dc, displayedDate) {    
       var smallCustomFont = WatchUi.loadResource(Rez.Fonts.small_font);
       var largeCustomFont = WatchUi.loadResource(Rez.Fonts.large_font);
       var font12 = WatchUi.loadResource(Rez.Fonts.font_12);
       
       var dateDic = Utils.convertDateToFullDate(displayedDate);
       var tidesData = Utils.getProperty(displayedDate);       
       var statusTide = ["slack1", "flood1", "slack2", "ebb1", "slack3", "flood2", "slack4", "ebb2", "slack5", "flood3", "slack6"];
       var displayDate = Lang.format( "$1$, $2$ $3$ $4$", [ dateDic["day_of_week"], dateDic["month"], dateDic["day"], dateDic["year"] ] );
	   var tidesDataDic = Utils.convertStringToDictionary(tidesData)[displayedDate];
 
 	   var appNameView = View.findDrawableById("id_app_name");
 	   appNameView.setFont(largeCustomFont);
  	   var dateView = View.findDrawableById("id_date");	
  	   dateView.setFont(font12);
  	   dateView.setText(displayDate);
  	 
  	   var currDateString = WatchUi.loadResource( Rez.Strings.CurrDate ); 	
  	   var currDate = Utils.convertDateToFullDate(Utils.getCurrentDate());
  	   var currDateFormat = Lang.format( "$1$ $2$ $3$", [ currDate["month"], currDate["day"], currDate["year"] ] );
  	   var currDateView = View.findDrawableById("id_currDate");	
  	   currDateView.setFont(font12);
  	   currDateView.setText(currDateString + ": " + currDateFormat);  
  	   
       var keys = tidesDataDic.keys();
       var view;
       var i = 1;
       var data = {};
       for (var j=0; j<statusTide.size(); j++)
   	   {
   	   		if(tidesDataDic.hasKey(statusTide[j]))
   	   		{
	   	   		view = Utils.GetViewLabelOnLayout(i);
	   	   		view.setFont(smallCustomFont);
	   	   		//data = Utils.convertTimeFormatBySettings(Utils.displayFirstLine(tidesDataDic[statusTide[j]]));
	   	   		view.setText(Utils.upperFirstLetterCase(statusTide[j].substring(0, statusTide[j].length() - 1)) + ": " + Utils.displayFirstLine(tidesDataDic[statusTide[j]]));  
	   	   		i++;  	   		
   	   		}
       }
       if(i < 9)
       {
	       for (var k=0; k<9-i; k++)
	       {
		       view = Utils.GetViewLabelOnLayout(i+k);
		       view.setFont(smallCustomFont);
		       //data = Utils.convertTimeFormatBySettings(Utils.displayFirstLine(tidesDataDic[keys[i+k]]));
		       System.println("keys[i+k] = " + (i+k));
		       view.setText(Utils.upperFirstLetterCase(keys[i+k]) + ": " + Utils.displayFirstLine(tidesDataDic[keys[i+k]]));
	       }
       }      
       View.onUpdate(dc);
       
       if(WatchUi.loadResource( Rez.Strings.IsTime24Format ).toNumber() == 1)
       {
       		//onDisPlayTime24HFormat(dc, font12, WatchUi.loadResource( Rez.Strings.XTimeFormat ).toNumber(), WatchUi.loadResource( Rez.Strings.YTimeFormat ).toNumber());
       }
       
       if(WatchUi.loadResource( Rez.Strings.SplitLocalTime ).toNumber() == 1)
       {
       		//System.println("data[0] = " + data[0]);
       		//onLocalTime(dc, font12, WatchUi.loadResource( Rez.Strings.XTimeFormat ).toNumber(), WatchUi.loadResource( Rez.Strings.YTimeFormat ).toNumber(), data[0]);
       }
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