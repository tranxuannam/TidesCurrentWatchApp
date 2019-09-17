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
	hidden var isStoped = true;
	hidden var status;
	
    function initialize(_status) {
        BehaviorDelegate.initialize();
        status = _status;
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
        	setMessageFailed(WatchUi.loadResource( Rez.Strings.PhoneConnected ));
        }  
        else
        {
        	if( pressedSelectButton )
        	{
	    		setProgressBarConfirmDialog(0);
	    		loadNextTidesCurrent(status);
	    		pressedSelectButton = false;
	    	}  
    	}    	
    }  
    
    function onBack() {
    	isStoped = false;    
	    onStopTimer();
	    setProgressBarToDefault();
	    WatchUi.switchToView(new TidesCurrentWatchAppView(), new TidesCurrentWatchAppDelegate(), WatchUi.SLIDE_IMMEDIATE);
	    return true;
    }	
    
    function loadNextTidesCurrent(status)
    {
        if( timer == null )
        {
            timer = new Timer.Timer();
        }
    	displayedDate = Utils.getProperty("displayedDate");	
    	location = Utils.getProperty("oldCode");
    	
    	var nextDate;
    	if(status)
    	{
    		nextDate = Utils.addOneDay();
    	}
    	else
    	{
    		nextDate = Utils.subtractOneDay();
    	}
    	displayedDate = Utils.getDisplayDate(displayedDate, nextDate);
        urlDic = Utils.getUrls(status, location, displayedDate);
        timer.start( method(:tideCurrentCallback), Utils.TIME_REQUEST_API, true );
    }

    function tideCurrentCallback()
    {
    	//System.println("count=" + count);
        if( count <= urlDic["url"].size() )
        {
        	var delegate = new WebResponseDelegate(1);
    		delegate.makeWebRequest(urlDic["url"][count], self.method(:onReceive));
    		if( timer != null )
    		{
    			timer.stop();
    		}    		            
        }     
        else
        {            
            if(tmpDic.isEmpty())
			{
				setMessageFailed(WatchUi.loadResource( Rez.Strings.ServerError ));
				onStopTimer();				
			}
			else
			{
				if(tmpDic.size() == urlDic["number"])
				{
					onStopTimer();
					if(tmpDic.hasKey(displayedDate))
					{
			            var name = Utils.getProperty("location"); 
				   		var oldCode = Utils.getProperty("oldCode");
				   		var latitude = Utils.getProperty("latitude"); 
				   		var longitude = Utils.getProperty("longitude");       
				        Utils.clearProperties();
				        Utils.setTidesData(tmpDic);
				        Utils.setProperty("displayedDate", displayedDate);
				        Utils.setProperty("location", name); 
				        Utils.setProperty("oldCode", oldCode); 
				        Utils.setProperty("latitude", latitude); 
				        Utils.setProperty("longitude", longitude);        
			            tmpDic = null;
			            WatchUi.switchToView(new TidesCurrentWatchAppView(), new TidesCurrentWatchAppDelegate(), WatchUi.SLIDE_UP);
		            }
		            else
		            {
		            	setMessageFailed(WatchUi.loadResource( Rez.Strings.NotSupported ));
		            }
	            }
	        }
        }        
    }   
   
    function onReceive(responseCode, data, param) 
    {   
		if (responseCode == 200) {	
			if(data.size() == 0)
			{
				onStopTimer();
				setMessageFailed(WatchUi.loadResource( Rez.Strings.ServerError ));
			}
			else
			{
				Utils.saveTidesDataToDictionary(data, tmpDic);
				
				if(isStoped)
				{
					setProgressBarConfirmDialog(count);
    				count++;
    				timer.start( method(:tideCurrentCallback), Utils.TIME_REQUEST_API, true );
    			}
			} 		
		}
		else {
			//System.println("Response: " + responseCode);
			setMessageFailed(WatchUi.loadResource( Rez.Strings.RequestFailed ));
			onStopTimer();
		}
	}
	
	function onStopTimer()
	{
		if( timer != null )
	    {    	
	    	timer.stop();
	    	timer = null;
	    	count = 1;
	    }
	}
}