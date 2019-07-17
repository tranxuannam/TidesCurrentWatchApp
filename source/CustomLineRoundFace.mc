using Toybox.WatchUi as Ui;

class CustomLineRoundFace extends Ui.Drawable {
	function initialize(params) {
		Drawable.initialize(params);
	}
	
    function draw(dc) {
        // Draw the move bar here
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
        dc.setPenWidth(2);      
        
        //dc.drawLine(43, 41, 43, 186);
        dc.drawLine(43, 20, 43, 220);
    }
}