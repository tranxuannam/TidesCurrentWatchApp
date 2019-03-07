using Toybox.WatchUi;
using Toybox.AntPlus;
using Toybox.System;
using Toybox.Application;
using Toybox.Time;
using Toybox.Time.Gregorian;

class TidesCurrentWatchAppView extends WatchUi.View {

	const URL = "http://localhost/TidesCurrent/public/test/0/2018/01/0/15";
	hidden var _beginTidesData;
	hidden var _midleTidesData;
	hidden var _lastTidesData;
	hidden var dateString;
	var month;
	var day;

    function initialize(beginTidesData, midleTidesData, lastTidesData) {
    	System.println("Init view");
    	_beginTidesData = beginTidesData;
    	_midleTidesData = midleTidesData;
    	_lastTidesData = lastTidesData;
    	System.println("_beginTidesData = " + _beginTidesData);
    	System.println("_midleTidesData = " + _midleTidesData);
    	System.println("_lastTidesData = " + _lastTidesData);
    	
    	var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    	if(today.month.toString().length() == 1)
    	{
    		month = "0" + today.month;
    	}
    	if(today.day.toString().length() == 1)
    	{
    		day = "0" + today.day;
    	}
    	
		dateString = Lang.format(
						    "$1$-$2$-$3$",
						    [        
						        today.year,
						        month,
						        day
						    ]
						);		
		System.println("dateString = " + dateString);
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {        
      	var mySettings = System.getDeviceSettings();      	
      /*
      	switch (mySettings.screenShape)
      	{
      		case 1: // round shape
      		{
      			setLayout(Rez.Layouts.RoundLayout(dc));
      			break;
      		}
      		
      		case 2: // semi-round shape
      		{
      			setLayout(Rez.Layouts.MainLayout(dc));
      			break;
      		}
      		
      		default:
      			setLayout(Rez.Layouts.MainLayout(dc));
      			break;
      	}
      	
        System.println( "AntPlus.Device = " + mySettings.screenShape);*/
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout     	      
              
       if(_beginTidesData.size() != 0)
       {       
       System.println( "_beginTidesData in TidesCurrentWatchAppView = " + _beginTidesData);
       System.println( "_midleTidesData in TidesCurrentWatchAppView = " + _midleTidesData);
       System.println( "_lastTidesData in TidesCurrentWatchAppView = " + _lastTidesData);
       System.println( "Item in TidesCurrentWatchAppView = " + _beginTidesData["2018-01-08"].get("high2"));
       
       //dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
       //dc.clear();
       //dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_SMALL, "Json Data: ", Graphics.TEXT_JUSTIFY_LEFT);
       //dc.drawLine(30, 56, 80, 100);
       
       var customFont = WatchUi.loadResource(Rez.Fonts.font_id);
       //dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
       //dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, customFont, "TEXT", Graphics.TEXT_JUSTIFY_CENTER);
       //dc.drawText(dc.getWidth() / 2, dc.getHeight() / 3, Graphics.FONT_SMALL, "TEXT 1", Graphics.TEXT_JUSTIFY_CENTER);
       View.findDrawableById("id_label1").setFont(customFont);
       View.findDrawableById("id_label2").setFont(customFont);
       View.findDrawableById("id_label3").setFont(customFont);
       View.findDrawableById("id_label4").setFont(customFont);
       View.findDrawableById("id_label5").setFont(customFont);
       View.findDrawableById("id_label6").setFont(customFont);
       //View.findDrawableById("id_label7").setFont(customFont);
       //View.findDrawableById("id_label8").setFont(customFont);
       
       //View.findDrawableById("id_label1").setText(tidesData[i].get("high1"));
       //View.findDrawableById("id_label2").setText(tidesData[i].get("low1"));
       //View.findDrawableById("id_label3").setText(tidesData[2].get("high2"));
       //View.findDrawableById("id_label4").setText(tidesData[i].get("low2"));
       
       }
       View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }  

}
