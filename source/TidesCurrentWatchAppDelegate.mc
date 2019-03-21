using Toybox.WatchUi;
using Toybox.Communications;
using Toybox.Application;
using Toybox.System;
using Toybox.Timer;

class TidesCurrentWatchAppDelegate extends WatchUi.BehaviorDelegate {

	var ppTimer;
	var mPressedTime;
	var mTimer;
	
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
    //    WatchUi.pushView(new Rez.Menus.MainMenu(), new TidesCurrentWatchAppMenuDelegate(), WatchUi.SLIDE_UP);
        ppTimer.stop();	
        return true;
    }
    
   	function onNextPage() {  
        var app = Application.getApp();
        var displayedDate = app.getProperty("displayedDate");
        System.println("displayedDate = " + displayedDate);
        var nextDate = Utils.getDisplayDate(displayedDate, Utils.addOneDay(), true);	
        System.println("newDate = " + nextDate);
        displayedDate = app.getProperty(nextDate);
        
        if(displayedDate != null)
        {
	        app.setProperty("displayedDate", nextDate);
	        WatchUi.requestUpdate();
        }
        else
        {
        	var message = "Load next 2 weeks data?";
			var dialog = new WatchUi.Confirmation(message);
			WatchUi.pushView(
			    dialog,
			    new ComfirmationLoadNextTidesCurrent(),
			    WatchUi.SLIDE_IMMEDIATE
			);
			System.println("ComfirmationLoadNextTidesCurrent called");
        }
        return true;
    } 
    
    function onPreviousPage() {   	
    	ppTimer = new Timer.Timer();	
    	ppTimer.start( method(:onPrePage), 100, false );
        return false;
    }  
    
    function onPrePage() {   		
        var app = Application.getApp();
        var displayedDate = app.getProperty("displayedDate");
        System.println("displayedDate = " + displayedDate);
        var nextDate = Utils.getDisplayDate(displayedDate, Utils.addOneDay(), false);	
        System.println("newDate = " + nextDate);
        displayedDate = app.getProperty(nextDate);
        
        if(displayedDate != null)
        {
	        app.setProperty("displayedDate", nextDate);
	        WatchUi.requestUpdate();
        }
    }  
}