using Toybox.WatchUi;
using Toybox.AntPlus;
using Toybox.System;
using Toybox.Application;
using Toybox.Time;
using Toybox.Time.Gregorian;

class TidesCurrentWatchAppView extends WatchUi.View {

	const URL = "http://localhost/TidesCurrent/public/test/0/2018/01/0/15";
	hidden var dateString;

    function initialize() {
    	System.println("Init view");    
		dateString = Utils.GetCurrentDate();
		System.println("dateString = " + dateString);
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {     
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
       var app = Application.getApp();
       var tidesData1 = app.getProperty("tidesData1");	     
       var tidesData2 = app.getProperty("tidesData2");
       var tidesData3 = app.getProperty("tidesData3");
       var tidesData4 = app.getProperty("tidesData4");
       var tidesData5 = app.getProperty("tidesData5");
       var tidesData6 = app.getProperty("tidesData6");
              
       if(tidesData6 != null)
       {       
		   var tidesDataDic = Utils.convertStringToDictionary(tidesData3)[dateString];
	       System.println( "tidesData6 in TidesCurrentWatchAppView = " + tidesData6);
	  
	       var customFont = WatchUi.loadResource(Rez.Fonts.font_id);	      
	       
	       var keys = tidesDataDic.keys();
	       for (var j=0; j<keys.size(); j++)
	   	   {
	   	   		if((j + 1) == 1)
	   	   		{
		   	   		View.findDrawableById("id_label1").setFont(customFont);
		   			View.findDrawableById("id_label1").setText(keys[j] + ": " + tidesDataDic[keys[j]]);
	   			}
	       }       
	       
       }
       View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }  

}
