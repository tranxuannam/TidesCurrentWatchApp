using Toybox.WatchUi;
using Toybox.Communications;
using Toybox.Application;
using Toybox.System;
using Toybox.Timer;

class TidesCurrentWatchAppDelegate extends WatchUi.BehaviorDelegate {

	var stopLoadingData = true;
	
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
	        var nextDate = Utils.getDisplayDate(displayedDate, Utils.addOneDay());	
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
				    new ConfirmDialogDelegate(true),
				    WatchUi.SLIDE_IMMEDIATE
				);
	        }
        }
        return true;
    } 
    
    function onNextPage() {    	
        var displayedDate = Utils.getProperty("displayedDate");        
        if(displayedDate != null)
        {
	        var nextDate = Utils.getDisplayDate(displayedDate, Utils.subtractOneDay());	
	        displayedDate = Utils.getProperty(nextDate);
	        
	        if(displayedDate != null)
	        {
		        Utils.setProperty("displayedDate", nextDate);
		        var limitDate = Utils.getDisplayDate(Utils.getCurrentDate(), Utils.subtractByDays(Utils.NUMBER_RECORD_GREATER_64K * 2)); // 4 weeks limited
		        
		        if(limitDate.equals(nextDate))
		        {
		        	stopLoadingData = false;
		        }
		        WatchUi.requestUpdate();
	        }
	        else
	        {
				if(stopLoadingData)
	        	{
	        		var dialog = new ConfirmDialogView(WatchUi.loadResource( Rez.Strings.LoadPreviousData ), 0);
					WatchUi.switchToView(
					    dialog,
					    new ConfirmDialogDelegate(false),
					    WatchUi.SLIDE_IMMEDIATE
					);				
				}
	        }
        }
        return false;
    }      
}