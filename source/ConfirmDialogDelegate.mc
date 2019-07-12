using Toybox.WatchUi;
using Toybox.Communications;
using Toybox.Application;
using Toybox.System;
using Toybox.Timer;

class ConfirmDialogDelegate extends WatchUi.BehaviorDelegate {

	hidden var location;
    hidden var count = 1;	
	hidden var urlDic;
	hidden var displayedDate;
	hidden var pressedSelectButton = true;
	hidden var tmpDic = {};
	
    function initialize() {
        BehaviorDelegate.initialize();        
    }

    function onMenu() {  
    	var device = WatchUi.loadResource(Rez.Strings.Device);
        if (Utils.FIX_PREVIOUS_PAGE_PER_DEVICE.toString().find(device) == null)
        {
    		onSelect();
    	}      
    }   
    
    function onSelect() {  
    	if(!Utils.checkPhoneConnected())
        {
        	setMessagePhoneConnected();
        }  
        else
        {
        	if( pressedSelectButton )
        	{
	    		setProgressBarConfirmDialog(0);
	    		loadNextTidesCurrent();
	    		pressedSelectButton = false;
	    	}  
    	}
    }  
    
    function onBack() {    
	    if( timer != null )
	    {	    	
	    	timer.stop();
	    }
	    setProgressBarToDefault();
	    WatchUi.switchToView(new TidesCurrentWatchAppView(), new TidesCurrentWatchAppDelegate(), WatchUi.SLIDE_UP);
	    return true;
    }	
    
    function loadNextTidesCurrent()
    {
        if( timer == null )
        {
            timer = new Timer.Timer();
        }
    	displayedDate = Utils.getProperty("displayedDate");	
    	location = Utils.getProperty("code");
    	displayedDate = Utils.getDisplayDate(displayedDate, Utils.addOneDay(), true);
        urlDic = Utils.getUrls(location, displayedDate);
        timer.start( method(:tideCurrentCallback), Utils.TIME_REQUEST_API, true );
    }

    function tideCurrentCallback()
    {
    	System.println("count=" + count);
        if( count > urlDic.size() )
        {
            timer.stop();
       		var name = Utils.getProperty("location"); 
       		var code = Utils.getProperty("code"); 
       		var latitude = Utils.getProperty("latitude"); 
       		var longitude = Utils.getProperty("longitude");       
            Utils.clearProperties();
            Utils.setTidesData(tmpDic);
            Utils.setProperty("displayedDate", displayedDate);
            Utils.setProperty("location", name); 
            Utils.setProperty("code", code); 
            Utils.setProperty("latitude", latitude); 
            Utils.setProperty("longitude", longitude); 
            setProgressBarConfirmDialog(count);            
            WatchUi.switchToView(new TidesCurrentWatchAppView(), new TidesCurrentWatchAppDelegate(), WatchUi.SLIDE_UP);
        }     
        else
        {
            var delegate = new WebResponseDelegate(1);
    		delegate.makeWebRequest(urlDic[count], self.method(:onReceive));
    		setProgressBarConfirmDialog(count);
        }
        count++;
    }   
   
    function onReceive(responseCode, data, param) 
    {   
		if (responseCode == 200) {			
			Utils.saveTidesDataToDictionary(data, tmpDic);       	
			System.println("TideDate in tmpDic = " + tmpDic); 		
		}
		else {
			System.println("Response: " + responseCode);
			setMessageFailed();
			count = 1;
			timer.stop();
		}
	}
}