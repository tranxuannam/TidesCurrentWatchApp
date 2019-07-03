using Toybox.WatchUi;
using Toybox.Communications;
using Toybox.Application;
using Toybox.System;
using Toybox.Timer;

class MainDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        var device = WatchUi.loadResource(Rez.Strings.Device);
        if (Utils.FIX_PREVIOUS_PAGE_PER_DEVICE.toString().find(device) != null)
        {
           onPreviousPage();
        }
        
        return true;
    }
    
    function onSelect()
    {
    	System.println("onSelect");
    	var app = Application.getApp();
		var location = app.getProperty("location");
		WatchUi.pushView(new LocationInfoView(), new LocationInfoDelegate(), WatchUi.SLIDE_UP); 
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
        	var message = WatchUi.loadResource( Rez.Strings.LoadNextData );
			var dialog = new ConfirmDialogView();
			WatchUi.pushView(
			    dialog,
			    new ConfirmDialogDelegate(),
			    WatchUi.SLIDE_IMMEDIATE
			);
			System.println("Comfirmation called");
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