using Toybox.WatchUi;
using Toybox.AntPlus;
using Toybox.System;

class TidesCurrentWatchAppView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {        
      	var mySettings = System.getDeviceSettings();      	
      /*
      	switch (mySettings.screenShape)
      	{
      		case 1: // round shape
      		{
      			setLayout(Rez.Layouts.RoundLayout(dc));
      			break;
      		}
      		
      		case 2: // semi-round shape
      		{
      			setLayout(Rez.Layouts.MainLayout(dc));
      			break;
      		}
      		
      		default:
      			setLayout(Rez.Layouts.MainLayout(dc));
      			break;
      	}
      	
        System.println( "AntPlus.Device = " + mySettings.screenShape);*/
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        //var app = Application.getApp();
       //var jsonData = app.getProperty("jsonData");	
       //System.println( "jsonData = " + jsonData);
       
       //dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
       //dc.clear();
       //dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_SMALL, "Json Data: ", Graphics.TEXT_JUSTIFY_LEFT);
       //dc.drawLine(30, 56, 80, 100);
       
       var customFont = WatchUi.loadResource(Rez.Fonts.font_id);
       //dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
       //dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, customFont, "TEXT", Graphics.TEXT_JUSTIFY_CENTER);
       //dc.drawText(dc.getWidth() / 2, dc.getHeight() / 3, Graphics.FONT_SMALL, "TEXT 1", Graphics.TEXT_JUSTIFY_CENTER);
       View.findDrawableById("id_label1").setFont(customFont);
       View.findDrawableById("id_label2").setFont(customFont);
       View.findDrawableById("id_label3").setFont(customFont);
       View.findDrawableById("id_label4").setFont(customFont);
       View.findDrawableById("id_label5").setFont(customFont);
       View.findDrawableById("id_label6").setFont(customFont);
       View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
