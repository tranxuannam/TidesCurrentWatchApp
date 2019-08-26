using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

// Inherit from this if you want to store additional information in the menu entry and/or change how 
// the menu is drawn - for example adding in a status icon.
// Any overridden drawing should be constrained within the items boundaries, i.e. y .. y + height / 3.
    
class DMenuItem
{
	//const LABEL_FONT = Gfx.FONT_SMALL;
	//const SELECTED_LABEL_FONT = Gfx.FONT_LARGE;
	//const VALUE_FONT = Gfx.FONT_MEDIUM;
	
	var LABEL_FONT;
	var SELECTED_LABEL_FONT;
	var VALUE_FONT = Gfx.FONT_MEDIUM;	
	
	const PAD = 0;

	var	id, label, value, userData;
	var index;		// filled in with its index, if selected
	
	// _id 		  is typically a symbol but can be anything and is just used in menu delegate to identify 
	//            which item has been selected.
	// _label	  the text to show as the item name.  Can be any object responding to toString ().
	// _value     the text to show when the item is in the selectable position.  Use null for no text
	//			  otherwise any object responding to toString () can be used.
	// _userData  optional.
	function initialize (_id, _label, _value, _userData, _fonts)
	{
		id = _id;
		label = _label;
		value = _value;
		userData = _userData;
		LABEL_FONT = _fonts[:small];
		SELECTED_LABEL_FONT = _fonts[:large];
	}

	function draw (dc, y, highlight)
	{

		if (highlight)
		{
			setHighlightColor (dc);
			drawHighlightedLabel (dc, y);
		}
		else
		{
			setColor (dc);
			drawLabel (dc, y);
		}
	}
	
	function setHighlightColor (dc)
	{
		dc.setColor (Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
	}
	
	function setColor (dc)
	{
		dc.setColor (Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
	}
	
	function drawLabel (dc, y)
	{
		var width = dc.getWidth ();
		var h3 = dc.getHeight () / 3;
		var lab = Utils.displayMultilineOnScreen(dc, label.toString(), LABEL_FONT, WatchUi.loadResource( Rez.Strings.ExtraRoom ).toFloat());
		var labDims = dc.getTextDimensions (lab, LABEL_FONT);
		var yL = y + (h3 - labDims[1]) / 2;

		dc.drawText (width / 2, yL, LABEL_FONT, lab, Gfx.TEXT_JUSTIFY_CENTER);
	}

	function drawHighlightedLabel (dc, y)
	{
		var width = dc.getWidth ();
		var h3 = dc.getHeight () / 3;
		var lab = label.toString();
		
		lab = Utils.displayMultilineOnScreen(dc, Utils.substringByWord(lab, Utils.CHARS_PER_LINE * 3), SELECTED_LABEL_FONT, WatchUi.loadResource( Rez.Strings.ExtraRoomSelectedMenu ).toFloat());
			
		var labDims = dc.getTextDimensions (lab, SELECTED_LABEL_FONT);
		var yL, yV, h;

		if (value != null)
		{
			// Show label and value.
			var val = value.toString ();
			var valDims = dc.getTextDimensions (val, VALUE_FONT);

			h = labDims[1] + valDims[1] + PAD;
			yL = y + (h3 - h) / 2;
			yV = yL + labDims[1] + PAD;
			dc.drawText (width / 2, yV, VALUE_FONT, val, Gfx.TEXT_JUSTIFY_CENTER);
		}
		else
		{
			yL = y + (h3 - labDims[1]) / 2;
		}
		dc.drawText (width / 2, yL, SELECTED_LABEL_FONT, lab, Gfx.TEXT_JUSTIFY_CENTER);
	}
}

class DMenu extends Ui.View
{
	var menuArray;
	var title;
	var index;
	var nextIndex;
	var font;
	hidden var drawMenu;
	
	var menuHeight = null;
	
	function initialize (_menuArray, _menuTitle, _font)
	{
		menuArray = _menuArray;
		title = _menuTitle;
		index = 0;
		nextIndex = 0;
		font = _font;
		View.initialize ();
	}
	
	function onShow ()
	{
		drawMenu = new DrawMenu ();
	}
	
	function onHide ()
	{
		drawMenu = null;
	}

	// Return the menuItem with the matching id.  The menu item has its index field updated
	// with the index it was found at.  Returns null if not found.
	function itemWithId (id)
	{
		for (var idx = 0; idx < menuArray.size (); idx++)
		{
			if (menuArray[idx].id == id)
			{
				menuArray[idx].index = idx;
				return menuArray[idx];
			}
		}
		return null;
	}
	
	function animateComplete()
	{
		drawMenu.t = 0;
		WatchUi.requestUpdate();
	}
	
	//const ANIM_TIME = 0.3;
	const ANIM_TIME = 0; //disable animation
	function updateIndex (offset)
	{
		if (menuArray.size () <= 1)
		{
			return;
		}
		
		if (offset == 1)
		{
			// Scroll down. Use 1000 as end value as cannot use 1. Scale as necessary in draw call.
			if (ANIM_TIME > 0)
			{
				Ui.animate (drawMenu, :t, Ui.ANIM_TYPE_LINEAR, 1000, 0, ANIM_TIME, method(:animateComplete));
			}
		}
		else
		{
			// Scroll up.
			if (ANIM_TIME > 0)
			{
				Ui.animate (drawMenu, :t, Ui.ANIM_TYPE_LINEAR, -1000, 0, ANIM_TIME, method(:animateComplete));
			}
		}
		
		nextIndex = index + offset;
		
		// Cope with a 'feature' in modulo operator not handling -ve numbers as desired.
		nextIndex = nextIndex < 0 ? menuArray.size () + nextIndex : nextIndex;
		
		nextIndex = nextIndex % menuArray.size ();
		
		Ui.requestUpdate();
		index = nextIndex;
	}
	
	function selectedItem ()
	{
		menuArray[index].index = index;
		return menuArray[index];
	}
	
	function onUpdate (dc)
	{
		var width = dc.getWidth ();
		var height = dc.getHeight ();
		menuHeight = height;
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.fillRectangle(0, 0, width, height);

		// Draw the menu items.
		if (drawMenu == null)
		{
			return;
		}
		
		drawMenu.index = index;
		drawMenu.nextIndex = nextIndex;
		drawMenu.menu = self;
		
		drawMenu.draw (dc, font);
		
		// Draw the decorations.
		var h3 = height / 3;
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
		dc.setPenWidth (2);
		dc.drawLine (0, h3, width, h3);
		dc.drawLine (0, h3 * 2, width, h3 * 2);
		
		drawArrows (dc);
	}
	
	const GAP = 5;
	const TS = 5;
	
	// The arrows are drawn with lines as polygons don't give different sized triangles depending
	// on their orientation.
	function drawArrows (dc)
	{
		var x = dc.getWidth () / 2;
		var y;

		dc.setPenWidth (1);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
		
		if (nextIndex != 0)
		{
			y = GAP;
			
			for (var i = 0; i < TS; i++)
			{
				dc.drawLine (x - i, y + i, x + i + 1, y + i);
			}
		}	

		if (nextIndex != menuArray.size () - 1)
		{
			y = dc.getHeight () - TS - GAP;
			
			var d;
			for (var i = 0; i < TS; i++)
			{
				d = TS - 1 - i;
				dc.drawLine (x - d, y + i, x + d + 1, y + i);
			}
		}	
	}	
}

// Done as a class so it can be animated.
class DrawMenu extends Ui.Drawable
{
	const titleFont = Gfx.FONT_SMALL;
	//var titleFont = Utils.loadMainFont();

	var t = 0;				// 'time' in the animation cycle 0...1000 or -1000...0.
	var index, nextIndex, menu;
			
	function initialize ()
	{
		Drawable.initialize ({});
	}
	
	function draw (dc, font)
	{
		var width = dc.getWidth ();
		var height = dc.getHeight ();
		var h3 = height / 3;
		var items = menu.menuArray.size ();
		
		nextIndex = menu.nextIndex;

		// y for the middle of the three items.  
		var y = h3 + (t / 1000.0) * h3;
		
		// Depending on where we are in the menu and in the animation some of 
		// these will be unnecessary but it is easier to draw everything and
		// rely on clipping to avoid unnecessary drawing calls.
		drawTitle (dc, y - nextIndex * h3 - h3, font);
		for (var i = -2; i < 3; i++)
		{
			drawItem (dc, nextIndex + i, y + h3 * i, i == 0);
		}
	}
	
	function drawTitle (dc, y, font)
	{		
		var width = dc.getWidth ();
		var h3 = dc.getHeight () / 3;

		// Check if any of the title is visible., 
		if (y < -h3)
		{
			return;
		}

        dc.setColor (Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        dc.fillRectangle (0, y, width, h3);

		if (menu.title != null)
		{
			var dims = dc.getTextDimensions (menu.title, font);
			var h = (h3 - dims[1]) / 2;
			dc.setColor (Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
			var title = Utils.displayMultilineOnScreen(dc, menu.title, font, WatchUi.loadResource( Rez.Strings.ExtraRoomTitleMenu ).toFloat());
			dc.drawText (width / 2, y + h, font, title, Gfx.TEXT_JUSTIFY_CENTER);
		}
	}
	
	// highlight is the selected menu item that can optionally show a value.
	function drawItem (dc, idx, y, highlight)
	{
		var h3 = dc.getHeight () / 3;

		// Cannot see item if it doesn't exist or will not be visible.
		if (idx < 0 || idx >= menu.menuArray.size () || 
			menu.menuArray[idx] == null || y > dc.getHeight () || y < -h3)
		{
			return;
		}
		
		menu.menuArray[idx].draw (dc, y, highlight);
	}
}

class DMenuDelegate extends Ui.BehaviorDelegate 
{
	hidden var menu;
	hidden var userMenuDelegate;
	
	function initialize (_menu, _userMenuInputDelegate)
	{
		menu = _menu;
		userMenuDelegate = _userMenuInputDelegate;
		BehaviorDelegate.initialize ();
	}
	
	function onSwipe(swipeEvent)
	{
		var d = swipeEvent.getDirection();
		if (d == WatchUi.SWIPE_UP)
		{
			return onNextPage();
		} 
		if (d == WatchUi.SWIPE_DOWN)
		{
			return onPreviousPage();
		} 
		
		return false;
		
	}
	
	function onTap(clickEvent)
	{
		var c = clickEvent.getCoordinates();
		var t = clickEvent.getType();
		
		if (t == WatchUi.CLICK_TYPE_TAP)
		{
			if (menu.menuHeight != null)
			{
				var h3 = menu.menuHeight  / 3;
				if (c[1] > h3*2)
				{
					return onNextPage();
				} 
				else if (c[1] < h3)
				{
					return onPreviousPage();
				}
			}
			
			userMenuDelegate.onMenuItem (menu.selectedItem ());
			Ui.requestUpdate();
			return true;
		} 
		return false;
		
	}
	
	
	function onNextPage()
	{
		menu.updateIndex (1);
		return true;
	}
	
	function onPreviousPage ()
	{
		menu.updateIndex (-1);
		return true;		
	}
	
	function onSelect ()
	{
		return false;
	}
	
	function onKey(keyEvent) {
		var k = keyEvent.getKey();
		
		if (k == WatchUi.KEY_START || k == WatchUi.KEY_ENTER )
		{		
			userMenuDelegate.onMenuItem (menu.selectedItem ());
			Ui.requestUpdate();
			return true;
		}
		return false;
	}
	
    function onBack () 
	{
        Ui.popView (Ui.SLIDE_RIGHT);
		return true;
    }
}
