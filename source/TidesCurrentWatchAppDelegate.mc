import Toybox.WatchUi;
import Toybox.Communications;
import Toybox.Application;
import Toybox.System;
import Toybox.Timer;
import Toybox.Lang;

class TidesCurrentWatchAppDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }
  
    function onMenu() {
    	if(Utils.getProperty(Utils.DISPLAYED_DATE) != null)
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
		System.println("onSelect");  
        sendrequest();

    	if(Utils.getProperty(Utils.DISPLAYED_DATE) != null)
    	{
			var location = Utils.getProperty(Utils.LOCATION);
			WatchUi.switchToView(new LocationInfoView(), new LocationInfoDelegate(), WatchUi.SLIDE_UP);
    	}
    	return true;
    }

	function data_response(code as Number, data as Dictionary or String or Null) as Void {
        System.println("Should be exiting = " + code);  
		System.println("Should be exiting data 123 = " + data);         
    }

	function sendrequest() {
        System.println("GET");
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };
        Communications.makeWebRequest("https://tidescurrents.com/api/tides/get_info_location?code=P0SU4WQB", null, options, method(:data_response));   	
    }
    
   	function onPreviousPage() {  
        var displayedDate = Utils.getProperty(Utils.DISPLAYED_DATE);
        if(displayedDate != null)
        {
	        var nextDate = Utils.getDisplayDate(displayedDate, Utils.addOneDay());	
	        displayedDate = Utils.getProperty(nextDate);
	        
	        if(displayedDate != null)
	        {
		        Utils.setProperty(Utils.DISPLAYED_DATE, nextDate);
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
	        }
        }
        return true;
    } 
    
    function onNextPage() {    	
        var displayedDate = Utils.getProperty(Utils.DISPLAYED_DATE);
        if(displayedDate != null)
        {
	        var nextDate = Utils.getDisplayDate(displayedDate, Utils.subtractOneDay());	
	        displayedDate = Utils.getProperty(nextDate);
	        
	        if(displayedDate != null)
	        {
		        Utils.setProperty(Utils.DISPLAYED_DATE, nextDate);
		        WatchUi.requestUpdate();
	        }
        }
        return false;
    }      
}