using Toybox.WatchUi;
using Toybox.Application;

class LocationInfoView extends WatchUi.View {

	hidden var font;
	
    function initialize() {
        View.initialize();         
        font = Utils.loadSmallFont();             
    }

    // Load your resources here
    function onLayout(dc) {     
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
       var distance2Line = 17; 
       
       // Location info      
       dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
	   dc.clear();		
	   dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);  	   
  	   dc.drawText(dc.getWidth() / 2, WatchUi.loadResource( Rez.Strings.YLocationInfo ).toNumber(), font, WatchUi.loadResource( Rez.Strings.LocationInfo ), Graphics.TEXT_JUSTIFY_CENTER);
       
       // Display location
       var name = app.getProperty("location");        
       var newText = Utils.displayMultilineOnScreen(dc, location + ": " + name, font, WatchUi.loadResource( Rez.Strings.ExtraRoom ).toFloat());
  	   dc.drawText(xPos, YPos, font, newText, Graphics.TEXT_JUSTIFY_LEFT);
       
       // Calculate lines
       var countLine = Utils.countChars(newText, "\n") + 1;
       var nextLine = YPos + distance2Line*countLine;
       
       // Display latitude       
       dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_TRANSPARENT);  	   
  	   dc.drawText(xPos, nextLine, font, lat + ": " + app.getProperty("latitude"), Graphics.TEXT_JUSTIFY_LEFT);
       
       // Display longitude       
       dc.drawText(xPos, nextLine + distance2Line, font, lat + ": " + app.getProperty("longitude"), Graphics.TEXT_JUSTIFY_LEFT);
       
       //Display code
       dc.drawText(xPos, nextLine + distance2Line * 2, font, code + ": " + app.getProperty("oldCode"), Graphics.TEXT_JUSTIFY_LEFT);
    }
  
}
