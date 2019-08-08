using Toybox.WatchUi;
using Toybox.AntPlus;
using Toybox.System;
using Toybox.Application;
using Toybox.Time;
using Toybox.Time.Gregorian;

class TidesCurrentWatchAppView extends WatchUi.View {
	
	hidden var smallCustomFont;
    hidden var font12;
       
    function initialize() {
        View.initialize();
        smallCustomFont = Utils.loadMainFont();
        font12 = Utils.loadFontSize12();
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
			onDisplayMainView(dc, Utils.getProperty(Utils.DISPLAYED_DATE)); 
        } 
        else
        {
	        onDisplayMessageInitApp(dc);
       	}
    } 
    
    function onDisplayMessageInitApp(dc)
    {
    	var customFont = Utils.loadLargeFont();
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
		dc.clear();		
		var cx = dc.getWidth() / 2;
		var cy = dc.getHeight() / 2;		
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		var text = Utils.displayMultilineOnScreen(dc, WatchUi.loadResource( Rez.Strings.AppSettingRequired ), customFont, WatchUi.loadResource( Rez.Strings.ExtraRoom ).toFloat());
       	var centerY = 0;
       	
		if(text.length() >= Utils.CHARS_PER_LINE)
		{
			centerY = cy - (Utils.countChars(text, "\n") + 1) * 10;
		}
		else
		{		
       		centerY = cy / 2;
       	} 
       	
       	dc.drawText(cx, centerY, customFont, text, Graphics.TEXT_JUSTIFY_CENTER);
    }  
    
    function onDisplayMainView(dc, displayedDate) 
    {    
       var dateDic = Utils.convertDateToFullDate(displayedDate);
       var tidesData = Utils.getProperty(displayedDate);      
       var displayDate = Lang.format( "$1$ $2$ $3$ $4$", [ dateDic["day_of_week"], dateDic["month"], dateDic["day"], dateDic["year"] ] );
	   var tidesDataDic = Utils.convertStringToDictionary(tidesData)[displayedDate]; 
  	   
  	   var dateView = View.findDrawableById("id_date");	
  	   dateView.setFont(font12);
  	   dateView.setText(Utils.displayMultilineOnScreen(dc, displayDate, font12, WatchUi.loadResource( Rez.Strings.ExtraRoomDateTime ).toFloat()));
  	   dateView.setColor(Graphics.COLOR_LT_GRAY);
  	 
  	   var currDate = Utils.convertDateToFullDate(Utils.getCurrentDate());
  	   var currDateFormat = Lang.format( "$1$ $2$ $3$", [ currDate["month"], currDate["day"], currDate["year"] ] );
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
       		onLocalTime(dc, font12, WatchUi.loadResource( Rez.Strings.XLocalTime ).toNumber(), WatchUi.loadResource( Rez.Strings.YLocalTime ).toNumber(), localTime);
       }       
    }  
    
    function onSwitchTypeTideCurrent(tidesDataDic, font)
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
    	return onShowTidesData(Utils.NUMBER_LINE_ON_SCREEN, data, tidesDataDic, font);
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
	   	   		view.setText(Utils.getLabelStatusTide(key) + ": " + data[1]);
	   	   		i++;  
   	   		}  	   		
       }
       
       for (var l = i; l <= row; l++)
   	   {
   	   		view = Utils.GetViewLabelOnLayout(l);
   	   		view.setText("");
   	   }
   	   
       return data[0];
    }
    
    function onDisPlayTime24HFormat(dc, font, x, y)
    {    	
    	dc.setPenWidth(1);
    	dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
    	dc.drawText(x, y, font, WatchUi.loadResource( Rez.Strings.TimeFormat ), Graphics.TEXT_JUSTIFY_LEFT);
		dc.drawArc(x + 5, y + 7, 9, Graphics.ARC_COUNTER_CLOCKWISE, 0, 360);
    }  
    
    function onLocalTime(dc, font, x, y, message)
    {    	
    	dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
    	dc.drawText(x, y, font, message, Graphics.TEXT_JUSTIFY_LEFT);
    } 
    
}