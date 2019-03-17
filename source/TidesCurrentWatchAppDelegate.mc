using Toybox.WatchUi;
using Toybox.Communications;
using Toybox.Application;
using Toybox.System;

class TidesCurrentWatchAppDelegate extends WatchUi.BehaviorDelegate {

	const URL = "http://localhost/TidesCurrent/public/test/0/2018/01/10/11";
	var ppTimer;
	
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
        return true;
    } 
    
    function onPreviousPage() {   		
    	ppTimer.start( method(:onPrePage), 1000, false );
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