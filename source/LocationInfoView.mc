using Toybox.WatchUi;
using Toybox.AntPlus;
using Toybox.System;
using Toybox.Application;
using Toybox.Time;
using Toybox.Time.Gregorian;

class LocationInfoView extends WatchUi.View {

	hidden var dateDic;

    function initialize() {
    	System.println("LocationInfoView");   
        View.initialize();       
    }

    // Load your resources here
    function onLayout(dc) {     
        setLayout(Rez.Layouts.LocationInfoLayout(dc));       
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }    
   
    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout   
    
       var customFont = WatchUi.loadResource(Rez.Fonts.font_id);
       // 
       var location = WatchUi.loadResource( Rez.Strings.Location );
       var lat = WatchUi.loadResource( Rez.Strings.Lati );
       var long = WatchUi.loadResource( Rez.Strings.Longi );
       var code = WatchUi.loadResource( Rez.Strings.Code );
       
       var view = View.findDrawableById("id_name");
       view.setFont(customFont);
       
       var app = Application.getApp();
       var name = app.getProperty("location");         
       
       var newText = Utils.convertTextToMultiline(dc, name, Graphics.FONT_SMALL);
       view.setText(newText);
       System.println("newText = " + newText);
       System.println("count chars = " + Utils.countChars(newText, "\n"));
       
       //
       
       var viewLat = View.findDrawableById("id_lat");
       viewLat.setLocation(25, 100);
       viewLat.setFont(customFont);
       viewLat.setText(lat + ": " + app.getProperty("latitude"));
       
       //
       
       var viewLong = View.findDrawableById("id_long");
       viewLong.setLocation(25, 120);
       viewLong.setFont(customFont);
       viewLong.setText(long + ": " + app.getProperty("longitude"));
       
       var viewCode = View.findDrawableById("id_code");
       viewCode.setLocation(25, 140);
       viewCode.setFont(customFont);
       viewCode.setText(code + ": " + app.getProperty("code"));
       
       View.onUpdate(dc);    
    }
  
}
