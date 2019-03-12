using Toybox.WatchUi;
using Toybox.AntPlus;
using Toybox.System;
using Toybox.Application;
using Toybox.Time;
using Toybox.Time.Gregorian;

class TidesCurrentWatchAppView extends WatchUi.View {

	const URL = "http://localhost/TidesCurrent/public/test/0/2018/01/0/15";
	hidden var dateString;

    function initialize() {
    	System.println("Init view");    
		dateString = Utils.GetCurrentDate();
		System.println("dateString = " + dateString);
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {     
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
        
       var customFont = WatchUi.loadResource(Rez.Fonts.font_id);
       var app = Application.getApp();
       var tidesData1 = app.getProperty("tidesData1");	     
       var tidesData2 = app.getProperty("tidesData2");
       var tidesData3 = app.getProperty("tidesData3");
       var tidesData4 = app.getProperty("tidesData4");
       var tidesData5 = app.getProperty("tidesData5");
       var tidesData6 = app.getProperty("tidesData6");
              
       if(tidesData6 != null)
       {       
		   var tidesDataDic = Utils.convertStringToDictionary(tidesData3)[dateString];
	       System.println( "tidesDataDic in TidesCurrentWatchAppView = " + tidesDataDic);
	  
	       var keys = tidesDataDic.keys();
	       var view;
	       var img;
	       for (var j=0; j<keys.size()-4; j++)
	   	   {
	   	   		switch (j + 1)
	   	   		{
	   	   			case 1:
	   	   				view = View.findDrawableById("id_label1");	
	   	   				img = View.findDrawableById("id_img1");	   	   				
	   	   			break;
	   	   			
	   	   			case 2:
	   	   				view = View.findDrawableById("id_label2");
	   	   				img = View.findDrawableById("id_img2");	
	   	   			break;
	   	   			
	   	   			case 3:
	   	   				view = View.findDrawableById("id_label3");
	   	   				img = View.findDrawableById("id_img3");	
	   	   			break;
	   	   			
	   	   			case 4:
	   	   				view = View.findDrawableById("id_label4");
	   	   				img = View.findDrawableById("id_img4");	
	   	   			break;
	   	   			
	   	   			case 5:
	   	   				view = View.findDrawableById("id_label5");
	   	   				img = View.findDrawableById("id_img5");	
	   	   			break;
	   	   			
	   	   			case 6:
	   	   				view = View.findDrawableById("id_label6");
	   	   				img = View.findDrawableById("id_img6");	
	   	   			break;
	   	   			
	   	   			case 7:
	   	   				view = View.findDrawableById("id_label7");
	   	   				img = View.findDrawableById("id_img7");	
	   	   			break;
	   	   			
	   	   			case 8:
	   	   				view = View.findDrawableById("id_label8");
	   	   				img = View.findDrawableById("id_img8");	
	   	   			break;
	   	   		}
	   	   		view.setFont(customFont);
	   	   		view.setText(tidesDataDic[keys[j]]); 	   		
	       }
	       
	       View.onUpdate(dc);
	       
	       for (var j=0; j<keys.size()-4; j++)
	       {
	       		//System.println("Key = " + j + " = " + keys[j]);
	   	   		//System.println("Number = " + keys[j].find("flood"));
	   	   		if(keys[j].find("flood") != null)
	   	   		{
	   	   			var imageUp = WatchUi.loadResource( Rez.Drawables.Up );
	    			dc.drawBitmap( img.locX, img.locY, imageUp );
	   	   			System.println("X1=" + img.locX + " Y1=" + img.locY);
	   	   		}
	   	   		else
	   	   		{
	   	   			var imageDown = WatchUi.loadResource( Rez.Drawables.Down );
	    			dc.drawBitmap( img.locX, img.locY, imageDown );
	    			System.println("X2=" + img.locX + " Y2=" + img.locY);
	   	   		}   	   		
	       }
	       
       }
       /*
       var myBitmap = new WatchUi.Bitmap({
		            :rezId=>Rez.Drawables.Down,
		            :locX=>10,
		            :locY=>30
		        });       
	       myBitmap.draw(dc);*/
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }  

}
