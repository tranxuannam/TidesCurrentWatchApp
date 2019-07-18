using Toybox.WatchUi;
using Toybox.Application;

class LocationInfoView extends WatchUi.View {

	hidden var smallCustomFont;
	hidden var largeCustomFont;
	
    function initialize() {
        View.initialize();  
        smallCustomFont = WatchUi.loadResource(Rez.Fonts.small_font);
        largeCustomFont = WatchUi.loadResource(Rez.Fonts.large_font);     
    }

    // Load your resources here
    function onLayout(dc) {     
        setLayout(Rez.Layouts.LocationInfoLayout(dc));       
    }
  
    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout 
               
       var app = Application.getApp();
       var location = WatchUi.loadResource( Rez.Strings.Location );
       var lat = WatchUi.loadResource( Rez.Strings.Lati );
       var long = WatchUi.loadResource( Rez.Strings.Longi );
       var code = WatchUi.loadResource( Rez.Strings.Code );    
       var xPos = WatchUi.loadResource( Rez.Strings.Xpos ).toNumber();
       var YPos = WatchUi.loadResource( Rez.Strings.Ypos ).toNumber();
       var xPosLocationInfo = WatchUi.loadResource( Rez.Strings.XposLocationInfo ).toNumber();
       var yPosLocationInfo = WatchUi.loadResource( Rez.Strings.YposLocationInfo ).toNumber();
       var distance2Line = 17; 
       
       // Location info
       var viewLocationInfo = View.findDrawableById("id_location_info");
       viewLocationInfo.setFont(largeCustomFont);
       viewLocationInfo.setLocation(xPosLocationInfo, yPosLocationInfo);     
       
       // Display location
       var viewLocation = View.findDrawableById("id_name");
       viewLocation.setFont(smallCustomFont);      
       var name = app.getProperty("location");        
       var newText = Utils.displayMultilineOnScreen(dc, location + ": " + name, smallCustomFont, WatchUi.loadResource( Rez.Strings.ExtraRoom ).toFloat());
       viewLocation.setText(newText);   
       viewLocation.setLocation(xPos, YPos);   
       
       // Calculate lines
       var countLine = Utils.countChars(newText, "\n") + 1;
       var nextLine = YPos + distance2Line*countLine;
       
       // Display latitude
       var viewLat = View.findDrawableById("id_lat");
       viewLat.setLocation(xPos, nextLine);
       viewLat.setFont(smallCustomFont);
       viewLat.setText(lat + ": " + app.getProperty("latitude"));
       viewLat.setColor(Graphics.COLOR_DK_GREEN);
       
       // Display longitude
       var viewLong = View.findDrawableById("id_long");
       viewLong.setLocation(xPos, nextLine + distance2Line);
       viewLong.setFont(smallCustomFont);
       viewLong.setText(long + ": " + app.getProperty("longitude"));
       viewLong.setColor(Graphics.COLOR_DK_GREEN);
       
       //Display code
       var viewCode = View.findDrawableById("id_code");
       viewCode.setLocation(xPos, nextLine + distance2Line*2);
       viewCode.setFont(smallCustomFont);
       viewCode.setText(code + ": " + app.getProperty("code"));
       viewCode.setColor(Graphics.COLOR_DK_GREEN);
       
       View.onUpdate(dc);    
    }
  
}
