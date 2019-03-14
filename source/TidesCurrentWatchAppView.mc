using Toybox.WatchUi;
using Toybox.AntPlus;
using Toybox.System;
using Toybox.Application;
using Toybox.Time;
using Toybox.Time.Gregorian;

class TidesCurrentWatchAppView extends WatchUi.View {

	const URL = "http://localhost/TidesCurrent/public/test/0/2018/01/0/15";
	hidden var dateString;
	hidden var dateDic;

    function initialize() {
    	System.println("Init view");    
		dateDic = Utils.getCurrentDate();
		dateString = Lang.format( "$1$-$2$-$3$", [ dateDic["year"], dateDic["month"], dateDic["day"] ] );
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
    
    function onClock()
    {    	
		var myTime = System.getClockTime(); // ClockTime object	
		View.findDrawableById("id_hours").setText(Lang.format( "$1$:$2$", [myTime.hour.format("%02d"), myTime.min.format("%02d")]));
		WatchUi.requestUpdate();
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout        
        
       var customFont = WatchUi.loadResource(Rez.Fonts.font_id);
       var app = Application.getApp();
       var tidesData1 = app.getProperty("tidesData1");	     
       var tidesData2 = app.getProperty("tidesData2");
       var tidesData3 = app.getProperty("tidesData3");
       var tidesData4 = app.getProperty("tidesData4");
       var tidesData5 = app.getProperty("tidesData5");
       var tidesData6 = app.getProperty("tidesData6");
       var statusTide = ["slack1", "flood1", "slack2", "ebb1", "slack3", "flood2", "slack4", "ebb2", "slack5", "flood3", "slack6"];
       var displayDate = Lang.format( "$1$, $2$ $3$ $4$", [ dateDic["day_of_week"], dateDic["month_medium"], dateDic["day"], dateDic["year"] ] );
              
       if(tidesData6 != null)
       {       
		   var tidesDataDic = Utils.convertStringToDictionary(tidesData3)[dateString];
	       System.println( "tidesDataDic in TidesCurrentWatchAppView = " + tidesDataDic);	  	   
	  	   System.println("AddOneday = " + Utils.getDateByAddedDay(dateDic, Utils.addOneDay()));	  	   
	 
	  	   View.findDrawableById("id_date").setText(displayDate);	  	   
	  	   
	       var keys = tidesDataDic.keys();
	       var view;
	       var i = 1;
	       for (var j=0; j<statusTide.size(); j++)
	   	   {
	   	   		System.println("statusTide[j] = " + statusTide[j]);
	   	   		if(tidesDataDic.hasKey(statusTide[j]))
	   	   		{
		   	   		view = Utils.GetViewLabelOnLayout(i);
		   	   		view.setFont(customFont);
		   	   		view.setText(Utils.upperFirstLetterCase(statusTide[j].substring(0, statusTide[j].length() - 1)) + ": " + tidesDataDic[statusTide[j]]);  
		   	   		i++;  	   		
	   	   		}
	       }
	       if(i < 9)
	       {
	       	   System.println("i = " + i);
		       for (var k=0; k<9-i; k++)
		       {
			       view = Utils.GetViewLabelOnLayout(i+k);
			       view.setFont(customFont);
			       view.setText(Utils.upperFirstLetterCase(keys[i+k]) + ": " + tidesDataDic[keys[i+k]]);
		       }
	       }
	       View.onUpdate(dc);	      
       }    
    }
    
    
    
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }  

}
