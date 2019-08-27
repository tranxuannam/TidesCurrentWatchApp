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
		var index = item.id.substring(6, item.id.length());		
		Utils.setProperty(Utils.CODE, data[index.toNumber()].get(Utils.CODE));
		data = null;
 		WatchUi.switchToView(new MiddleProcessView(WatchUi.loadResource( Rez.Strings.Processing )), new MiddleProcessDelegate(true), WatchUi.SLIDE_IMMEDIATE);
    }
}
