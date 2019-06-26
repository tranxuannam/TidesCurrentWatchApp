using Toybox.WatchUi;
using Toybox.AntPlus;
using Toybox.System;
using Toybox.Application;
using Toybox.Time;
using Toybox.Time.Gregorian;

class TidesCurrentWatchAppView2 extends WatchUi.View {

	hidden var dateDic;

    function initialize() {
    	System.println("Init view 2");   
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
       var displayedDate = app.getProperty("displayedDate");       
       System.println("displayedDate = " + displayedDate);
       
       if(displayedDate != null)
       {       
       	   dateDic = Utils.convertDateToFullDate(displayedDate);
       	   System.println("dateDic = " + dateDic);
	       var tidesData = app.getProperty(displayedDate);       
	       var statusTide = ["slack1", "flood1", "slack2", "ebb1", "slack3", "flood2", "slack4", "ebb2", "slack5", "flood3", "slack6"];
	       var displayDate = Lang.format( "$1$, $2$ $3$ $4$", [ dateDic["day_of_week"], dateDic["month"], dateDic["day"], dateDic["year"] ] );
           System.println("tidesData in update = " + tidesData);   
		   var tidesDataDic = Utils.convertStringToDictionary(tidesData)[displayedDate];
	       System.println( "tidesDataDic in TidesCurrentWatchAppView = " + tidesDataDic);	  	   
	  	   //System.println("AddOneday = " + Utils.getDisplayDate(dateDic, Utils.addOneDay(), true));	  	   
	 
	  	   View.findDrawableById("id_date").setText(displayDate);	 
	  	   var currDateString = WatchUi.loadResource( Rez.Strings.CurrDate ); 	
	  	   var currDate = Utils.convertDateToFullDate(Utils.getCurrentDate());
	  	   var currDateFormat = Lang.format( "$1$ $2$ $3$", [ currDate["month"], currDate["day"], currDate["year"] ] );
	  	   View.findDrawableById("id_currDate").setText(currDateString + ": " + currDateFormat);	     
	  	   
	       var keys = tidesDataDic.keys();
	       var view;
	       var i = 1;
	       for (var j=0; j<statusTide.size(); j++)
	   	   {
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
	       //View.onUpdate(dc);	      
       }
       View.onUpdate(dc);    
    }
  
}
