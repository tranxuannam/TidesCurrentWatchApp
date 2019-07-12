using Toybox.WatchUi;
using Toybox.Communications;
using Toybox.Application;
using Toybox.System;
using Toybox.Timer;

class TidesCurrentWatchAppDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }
  
    function onMenu() {
    	if(Utils.getProperty("displayedDate") != null)
    	{
	        var device = WatchUi.loadResource(Rez.Strings.Device);
	        if (Utils.FIX_PREVIOUS_PAGE_PER_DEVICE.toString().find(device) != null)
	        {
	           onPreviousPage();
	        }
	        else
	        {
	        	onSelect();
	        }
        }
        return true;
    }
    
    function onBack() {
    	return false;    
    }    
  
    function onSelect()
    {
    	if(Utils.getProperty("displayedDate") != null)
    	{
			var location = Utils.getProperty("location");
			WatchUi.switchToView(new LocationInfoView(), new LocationInfoDelegate(), WatchUi.SLIDE_UP);
    	}
    	return true;
    }
    
   	function onPreviousPage() {  
        var displayedDate = Utils.getProperty("displayedDate");
        if(displayedDate != null)
        {
	        System.println("displayedDate = " + displayedDate);
	        var nextDate = Utils.getDisplayDate(displayedDate, Utils.addOneDay(), true);	
	        System.println("newDate = " + nextDate);
	        displayedDate = Utils.getProperty(nextDate);
	        
	        if(displayedDate != null)
	        {
		        Utils.setProperty("displayedDate", nextDate);
		        WatchUi.requestUpdate();
	        }
	        else
	        {
				var dialog = new ConfirmDialogView(WatchUi.loadResource( Rez.Strings.LoadNextData ), 0);
				WatchUi.switchToView(
				    dialog,
				    new ConfirmDialogDelegate(),
				    WatchUi.SLIDE_IMMEDIATE
				);
				System.println("Comfirmation called");
	        }
        }
        return true;
    } 
    
    function onNextPage() {    	
        var displayedDate = Utils.getProperty("displayedDate");
        if(displayedDate != null)
        {
	        System.println("displayedDate = " + displayedDate);
	        var nextDate = Utils.getDisplayDate(displayedDate, Utils.addOneDay(), false);	
	        System.println("newDate = " + nextDate);
	        displayedDate = Utils.getProperty(nextDate);
	        
	        if(displayedDate != null)
	        {
		        Utils.setProperty("displayedDate", nextDate);
		        WatchUi.requestUpdate();
	        }
        }
        return false;
    }      
}