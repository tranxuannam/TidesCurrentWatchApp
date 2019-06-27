using Toybox.WatchUi;
using Toybox.Application;

class LocationInfoView extends WatchUi.View {

    function initialize() {
        View.initialize();       
    }

    // Load your resources here
    function onLayout(dc) {     
        setLayout(Rez.Layouts.LocationInfoLayout(dc));       
    }
  
    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout  
    
       var customFont = WatchUi.loadResource(Rez.Fonts.small_font);
       var app = Application.getApp();
       var location = WatchUi.loadResource( Rez.Strings.Location );
       var lat = WatchUi.loadResource( Rez.Strings.Lati );
       var long = WatchUi.loadResource( Rez.Strings.Longi );
       var code = WatchUi.loadResource( Rez.Strings.Code );    
       var loactionYPos = 36;
       var xPos = 25;
       var distance2Line = 20;       
       
       // Display location
       var viewLocation = View.findDrawableById("id_name");
       viewLocation.setFont(customFont);      
       var name = app.getProperty("location");        
       var newText = Utils.convertTextToMultiline(dc, name, Graphics.FONT_SMALL);
       viewLocation.setText(newText);      
       
       // Calculate lines
       var countLine = Utils.countChars(newText, "\n") + 1;
       var nextLine = loactionYPos + distance2Line*countLine;
       
       // Display latitude
       var viewLat = View.findDrawableById("id_lat");
       viewLat.setLocation(xPos, nextLine);
       viewLat.setFont(customFont);
       viewLat.setText(lat + ": " + app.getProperty("latitude"));
       
       // Display longitude
       var viewLong = View.findDrawableById("id_long");
       viewLong.setLocation(xPos, nextLine + distance2Line);
       viewLong.setFont(customFont);
       viewLong.setText(long + ": " + app.getProperty("longitude"));
       
       //Display code
       var viewCode = View.findDrawableById("id_code");
       viewCode.setLocation(xPos, nextLine + distance2Line*2);
       viewCode.setFont(customFont);
       viewCode.setText(code + ": " + app.getProperty("code"));
       
       View.onUpdate(dc);    
    }
  
}
