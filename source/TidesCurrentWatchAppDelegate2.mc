using Toybox.WatchUi;
using Toybox.Communications;
using Toybox.Application;
using Toybox.System;
using Toybox.Timer;

class TidesCurrentWatchAppDelegate2 extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        //WatchUi.pushView(new Rez.Menus.MainMenu(), new TidesCurrentWatchAppMenuDelegate(), WatchUi.SLIDE_UP);        
        var device = WatchUi.loadResource(Rez.Strings.Device);

        if ("fr235".equals(device)) {
           System.println("fr235");
           onPreviousPage();
        }
        return true;
    }
    
   	function onPreviousPage() {  
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
    
    function onNextPage() {    	
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
        return false;
    }     
    
}