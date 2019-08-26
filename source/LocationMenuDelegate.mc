using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Math as Math;

class LocationMenuDelegate extends Ui.MenuInputDelegate {

	var	view, count;
	var data;
	
	// view is only needed if you need to access the menu array directly or replace it.  Otherwise
	// the item passed to onMenu can be modified 'in place'.
    function initialize (_view, _data)
	{
		view = _view;
		data = _data;
        MenuInputDelegate.initialize ();
		count = 0;
    }

    function onMenuItem (item) 
	{
 		//WatchUi.switchToView(new TidesCurrentWatchAppView(), new TidesCurrentWatchAppDelegate(), WatchUi.SLIDE_IMMEDIATE);
    }
}
