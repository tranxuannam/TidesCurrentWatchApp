using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Communications;
using Toybox.Timer;

class TidesCurrentWatchAppApp extends Application.AppBase {

	hidden var count = 1;
	hidden var timer;
	hidden var urlDic;
	hidden var requestNum;
	
    function initialize() {
    	AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    	if(Utils.getProperty("displayedDate") != null)
        {
			WatchUi.switchToView(new MainView(), new MainDelegate(), WatchUi.SLIDE_UP); 
        }    
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
    		Utils.setProperty("displayedDate", Utils.getCurrentDate());
    		timer.stop();
    		count = 0;
    		WatchUi.switchToView(new MainView(), new MainDelegate(), WatchUi.SLIDE_UP);
    	}    
    	count++;	
    }
    
    function getInfoLocation(code)
    {
    	var delegate = new WebResponseDelegate(1);
    	delegate.makeWebRequest(Utils.INFO_LOCATION_ENDPOINT + code, self.method(:onReceiveLocationInfo));	
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {    	
        return [ new TidesCurrentWatchAppView(), new TidesCurrentWatchAppDelegate() ];
    }
    
    function onSettingsChanged() {	
    	System.println("onSettingsChanged");
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
			Utils.setTidesData(data);       		
		}
		else {
			System.println("Response123: " + responseCode);
			if(timer != null)
			{
				timer.stop();				
			}
			setUpInvalidCode();
		}
	}	
	
	// set up the response onReceiveLocationInfo function
    function onReceiveLocationInfo(responseCode, data, param) {   
		if (responseCode == 200) {
			Utils.setProperty("location", data["name"]);   
			Utils.setProperty("latitude", data["latitude"]);
			Utils.setProperty("longitude", data["longitude"]);	
		}
		else {
			System.println("Response456: " + responseCode);
			if(timer != null)
			{
				timer.stop();
			}
			
			if (responseCode == 404)
			{
				WatchUi.pushView(
				    new DialogMessageView(WatchUi.loadResource( Rez.Strings.InvalidCode )),
				    new DialogMessageDelegate(),
				    WatchUi.SLIDE_UP
				);
			}
			else 
			{
				setUpMessageFailed();
			}
		}
	}	
	
}
