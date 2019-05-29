using Toybox.WatchUi;
using Toybox.AntPlus;
using Toybox.System;
using Toybox.Application;
using Toybox.Time;
using Toybox.Time.Gregorian;

class TidesCurrentWatchAppView2 extends WatchUi.View {

	const URL = "http://localhost/TidesCurrent/public/test/0/2018/01/0/15";
	hidden var dateDic;

    function initialize() {
    	System.println("Init view 2");   
        View.initialize();
        
        //read last values from the Object Store
        var temp=Application.getApp().getProperty(OSCOUNTER);
        if(temp!=null && temp instanceof Number) {counter=temp;}
        
        temp=Application.getApp().getProperty(OSDATA);
        if(temp!=null && temp instanceof String) {bgdata=temp;}
        
        var now=System.getClockTime();
    	var ts=now.hour+":"+now.min.format("%02d");
        System.println("From OS: data="+bgdata+" "+counter+" at "+ts);  
    }

    // Load your resources here
    function onLayout(dc) {     
        //setLayout(Rez.Layouts.MainLayout(dc));
        setLayout(Rez.Layouts.MainLayout(dc));       
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }
    
    function onClock123()
    {    	
		var myTime = System.getClockTime(); // ClockTime object	
		View.findDrawableById("id_hours").setText(Lang.format( "$1$:$2$", [myTime.hour.format("%02d"), myTime.min.format("%02d")]));
		WatchUi.requestUpdate();
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout   
        
        // Get and show the current time
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        View.findDrawableById("id_hours").setText(timeString);     
        
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
    
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	var now=System.getClockTime();
    	var ts=now.hour+":"+now.min.format("%02d");        
        System.println("onHide counter="+counter+" "+ts);    
    	Application.getApp().setProperty(OSCOUNTER, counter);    
    }  

}
