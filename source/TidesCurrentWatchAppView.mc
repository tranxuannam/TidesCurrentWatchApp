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
        
       var customFont = WatchUi.loadResource(Rez.Fonts.font_id);
       var app = Application.getApp();
       var tidesData1 = app.getProperty("tidesData1");	     
       var tidesData2 = app.getProperty("tidesData2");
       var tidesData3 = app.getProperty("tidesData3");
       var tidesData4 = app.getProperty("tidesData4");
       var tidesData5 = app.getProperty("tidesData5");
       var tidesData6 = app.getProperty("tidesData6");
       var statusTide = ["slack1", "flood1", "slack2", "ebb1", "slack3", "flood2", "slack4", "ebb2", "slack5", "flood3", "slack6"];
              
       if(tidesData6 != null)
       {       
		   var tidesDataDic = Utils.convertStringToDictionary(tidesData3)[dateString];
	       System.println( "tidesDataDic in TidesCurrentWatchAppView = " + tidesDataDic);
	  
	       var keys = tidesDataDic.keys();
	       var view;
	       var i = 1;
	       for (var j=0; j<statusTide.size(); j++)
	   	   {
	   	   		System.println("statusTide[j] = " + statusTide[j]);
	   	   		if(tidesDataDic.hasKey(statusTide[j]))
	   	   		{
		   	   		view = GetViewLabelOnLayout(i);
		   	   		view.setFont(customFont);
		   	   		view.setText(statusTide[j].substring(0, statusTide[j].length() - 1) + ": " + tidesDataDic[statusTide[j]]);  
		   	   		i++;  	   		
	   	   		}
	       }
	       if(i < 9)
	       {
		       for (var k=1; k<9-i; k++)
		       {
			       view = GetViewLabelOnLayout(i+k);
			       view.setText(keys[i+k] + ": " + tidesDataDic[keys[i+k]]);
		       }
	       }
	       View.onUpdate(dc);	      
       }    
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
    
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }  

}
