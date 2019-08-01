using Toybox.WatchUi;
using Toybox.Communications;
using Toybox.Application;
using Toybox.System;
using Toybox.Timer;

class MiddleProcessDelegate extends WatchUi.BehaviorDelegate {
	
	hidden var count = 1;	
	hidden var urlDic;
	hidden var tmpDic = {};	
	hidden var isStoped = true;
	
    function initialize(action) {
        BehaviorDelegate.initialize();
        onStopTimer();        
        if(action)
        {
        	onProcessingData();
        }
    }

    function onMenu() {   
    }     	
 
    function onBack() {  
    	isStoped = false;    
		onStopTimer();
		setUpProgressBar(0);
        WatchUi.switchToView(new TidesCurrentWatchAppView(), new TidesCurrentWatchAppDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
    
    function loadTidesCurrentData()
    {
    	urlDic = Utils.getUrls(Utils.getProperty(Utils.CODE), Utils.getCurrentDate());
    	if(timer == null)
    	{    	
	        timer = new Timer.Timer();
        }	
        timer.start(method(:tidesCurrentCallBack), Utils.TIME_REQUEST_API, true);	
    }       
    
    function tidesCurrentCallBack()
    {
    	//System.println("count=" + count);
    	if(count <= urlDic["url"].size())
    	{
    		var delegate = new WebResponseDelegate(1);
    		delegate.makeWebRequest(urlDic["url"][count], self.method(:onReceive));    		
    		timer.stop();  		
    	}
    	else
    	{
    		if(tmpDic.isEmpty())
			{
				setUpMessageFailed(WatchUi.loadResource( Rez.Strings.ServerError ));
				onStopTimer();				
			}
			else
			{
				if(tmpDic.size() == urlDic["number"])
				{
					onStopTimer();
		    		var name = Utils.getProperty(Utils.LOCATION); 
		       		var code = Utils.getProperty(Utils.CODE);
		       		var oldCode = Utils.getProperty(Utils.OLD_CODE); 
		       		var latitude = Utils.getProperty(Utils.LAT); 
		       		var longitude = Utils.getProperty(Utils.LONG);       
		            Utils.clearProperties();
		            Utils.setTidesData(tmpDic);
		            Utils.setProperty(Utils.DISPLAYED_DATE, Utils.getCurrentDate());
		            Utils.setProperty(Utils.LOCATION, name); 
		            Utils.setProperty(Utils.CODE, code);
		            Utils.setProperty(Utils.OLD_CODE, oldCode); 
		            Utils.setProperty(Utils.LAT, latitude); 
		            Utils.setProperty(Utils.LONG, longitude); 
		    		WatchUi.switchToView(new TidesCurrentWatchAppView(), new TidesCurrentWatchAppDelegate(), WatchUi.SLIDE_UP);
	    		}
    		}
    	}    
    }
    
    function getInfoLocation(code)
    {
    	var delegate = new WebResponseDelegate(code);
    	delegate.makeWebRequest(Utils.INFO_LOCATION_ENDPOINT + code, self.method(:onReceiveLocationInfo));	
    }

    function onProcessingData() {	
    	if(Utils.checkPhoneConnected())
    	{
			setUpProcessing(); 
			getInfoLocation(Utils.getProperty(Utils.CODE));
			loadTidesCurrentData();
		}
		else
		{
			setUpMessageFailed(WatchUi.loadResource( Rez.Strings.PhoneConnected ));
		}
	}	
	
	// set up the response callback function
    function onReceive(responseCode, data, param) {
		if (responseCode == 200) {			
			if(data.isEmpty())
			{
				onStopTimer();
				setUpMessageFailed(WatchUi.loadResource( Rez.Strings.ServerError ));				
			}
			else
			{
				Utils.saveTidesDataToDictionary(data, tmpDic);
				
				if(isStoped)
				{
					setUpProgressBar(count);
	    			count++;  
					timer.start(method(:tidesCurrentCallBack), Utils.TIME_REQUEST_API, true);
				}
			}
		}
		else {
			//System.println("Response: " + responseCode);
			onStopTimer();
			if (responseCode == 404)
			{
				setUpMessageFailed(WatchUi.loadResource( Rez.Strings.InvalidCode ));
			}
			else
			{
				setUpMessageFailed(WatchUi.loadResource( Rez.Strings.RequestFailed ));
			}
		}
	}	
	
	// set up the response onReceiveLocationInfo function
    function onReceiveLocationInfo(responseCode, data, code) {   
		if (responseCode == 200) {
			Utils.setProperty(Utils.LOCATION, data[Utils.NAME]);   
			Utils.setProperty(Utils.LAT, data[Utils.LAT]);
			Utils.setProperty(Utils.LONG, data[Utils.LONG]);	
			Utils.setProperty(Utils.OLD_CODE, code);
		}
		else {
			//System.println("Response: " + responseCode);
			onStopTimer();
			if (responseCode == 404)
			{
				Utils.setProperty(Utils.CODE, Utils.getProperty(Utils.OLD_CODE));				
				setUpMessageFailed(WatchUi.loadResource( Rez.Strings.InvalidCode ));
			}
			else 
			{
				setUpMessageFailed(WatchUi.loadResource( Rez.Strings.RequestFailed ));
			}			
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