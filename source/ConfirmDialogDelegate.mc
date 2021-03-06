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
        	setMessageFailed(WatchUi.loadResource( Rez.Strings.PhoneConnected ));
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
    	isStoped = false;    
	    onStopTimer();
	    setProgressBarToDefault();
	    WatchUi.switchToView(new TidesCurrentWatchAppView(), new TidesCurrentWatchAppDelegate(), WatchUi.SLIDE_IMMEDIATE);
	    return true;
    }	
    
    function loadNextTidesCurrent()
    {
        if( timer == null )
        {
            timer = new Timer.Timer();
        }
    	displayedDate = Utils.getProperty(Utils.DISPLAYED_DATE);	
    	location = Utils.getProperty(Utils.OLD_CODE);
    	displayedDate = Utils.getDisplayDate(displayedDate, Utils.addOneDay());
        urlDic = Utils.getUrls(location, displayedDate);
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
			            var name = Utils.getProperty(Utils.LOCATION); 
			       		var oldCode = Utils.getProperty(Utils.OLD_CODE);
			       		var latitude = Utils.getProperty(Utils.LAT); 
			       		var longitude = Utils.getProperty(Utils.LONG);       
			            Utils.clearProperties();
			            Utils.setTidesData(tmpDic);
			            Utils.setProperty(Utils.DISPLAYED_DATE, displayedDate);
			            Utils.setProperty(Utils.LOCATION, name); 
			            Utils.setProperty(Utils.OLD_CODE, oldCode); 
			            Utils.setProperty(Utils.LAT, latitude); 
			            Utils.setProperty(Utils.LONG, longitude); 
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