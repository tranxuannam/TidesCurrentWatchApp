using Toybox.WatchUi;
using Toybox.System;

class ComfirmationLoadNextTidesCurrent extends WatchUi.ConfirmationDelegate {
    
    function initialize() {
        ConfirmationDelegate.initialize();
    }

    function onResponse(response) {
        if (response != 0) {
            System.println("Confirm");            	
			WatchUi.pushView(new ProgressBarView(), new ProgressBarDelegate(), WatchUi.SLIDE_UP);
        }
    }   
}
