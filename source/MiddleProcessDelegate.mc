using Toybox.WatchUi;
using Toybox.Communications;
using Toybox.Application;
using Toybox.System;
using Toybox.Timer;

class MiddleProcessDelegate extends WatchUi.BehaviorDelegate {
	
	hidden var count = 1;	
	hidden var urlDic;
	//hidden var timer;
	hidden var requestNum;
	hidden var tmpDic = {};
	
    function initialize(action) {
        BehaviorDelegate.initialize();
        
        if(timer != null)
        {
        	timer.stop();
        }
        
        if(action)
        {
        	onProcessingData();
        }
    }

    function onMenu() {   
    }     	
 
    function onBack() {        
    	if(timer != null)
		{
			timer.stop();				
		}	
        WatchUi.switchToView(new TidesCurrentWatchAppView(), new TidesCurrentWatchAppDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
    
    function loadTidesCurrentData()
    {
    	urlDic = Utils.getUrls(Utils.getProperty("code"), Utils.getCurrentDate());
    	requestNum = urlDic.size();    	
        timer = new Timer.Timer();
		timer.start(method(:tidesCurrentCallBack), Utils.TIME_REQUEST_API, true);
    }       
    
    function tidesCurrentCallBack()
    {
    	System.println("count=" + count);
    	if(count <= requestNum)
    	{
    		var delegate = new WebResponseDelegate(1);
    		delegate.makeWebRequest(urlDic[count], self.method(:onReceive));
    		setUpProgressBar(count);
    	}
    	else
    	{
    		timer.stop();
    		count = 0;    		
    		var name = Utils.getProperty("location"); 
       		var code = Utils.getProperty("code"); 
       		var latitude = Utils.getProperty("latitude"); 
       		var longitude = Utils.getProperty("longitude");       
            Utils.clearProperties();
            Utils.setTidesData(tmpDic);
            Utils.setProperty("displayedDate", Utils.getCurrentDate());
            Utils.setProperty("location", name); 
            Utils.setProperty("code", code); 
            Utils.setProperty("latitude", latitude); 
            Utils.setProperty("longitude", longitude);            
    		WatchUi.switchToView(new TidesCurrentWatchAppView(), new TidesCurrentWatchAppDelegate(), WatchUi.SLIDE_UP);
    	}    
    	count++;	
    }
    
    function getInfoLocation(code)
    {
    	var delegate = new WebResponseDelegate(1);
    	delegate.makeWebRequest(Utils.INFO_LOCATION_ENDPOINT + code, self.method(:onReceiveLocationInfo));	
    }

    function onProcessingData() {	
    	if(Utils.checkPhoneConnected())
    	{
			setUpProcessing(); 
			getInfoLocation(Utils.getProperty("code"));
			loadTidesCurrentData();
		}
		else
		{
			setUpMessagePhoneConnected();
		}
	}	
	
	// set up the response callback function
    function onReceive(responseCode, data, param) {   
		if (responseCode == 200) {
			Utils.saveTidesDataToDictionary(data, tmpDic);   		
		}
		else {
			System.println("Response: " + responseCode);
			if(timer != null)
			{
				timer.stop();				
			}
			
			if (responseCode == 404)
			{
				setUpInvalidCode();
			}
			else
			{
				setUpMessageFailed();
			}
		}
	}	
	
	// set up the response onReceiveLocationInfo function
    function onReceiveLocationInfo(responseCode, data, param) {   
		if (responseCode == 200) {
			Utils.setProperty("location", data["name"]);   
			Utils.setProperty("latitude", data["latitude"]);
			Utils.setProperty("longitude", data["longitude"]);	
			Utils.setProperty("oldCode", Utils.getProperty("code"));
		}
		else {
			System.println("Response: " + responseCode);
			if(timer != null)
			{
				timer.stop();
			}
			
			if (responseCode == 404)
			{
				Utils.setProperty("code", Utils.getProperty("oldCode"));				
				setUpInvalidCode();
			}
			else 
			{
				setUpMessageFailed();
			}
		}
	}	
}