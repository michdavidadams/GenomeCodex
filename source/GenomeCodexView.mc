import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

using Toybox.Time.Gregorian;

class GenomeCodexView extends WatchUi.WatchFace {
    var width, height;
    var myBitmap;
    function initialize() {
        WatchFace.initialize();
        myBitmap=WatchUi.loadResource(Rez.Drawables.genome);
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        width=dc.getWidth();
        height=dc.getHeight();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get and show the current time
        var clockTime = System.getClockTime();
        var timeString = getClockTime(clockTime);
        var clockDate = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateString = Lang.format("$1$,$2$$3$", [clockDate.day_of_week, clockDate.month, clockDate.day]);

        dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_BLACK);
		dc.clear();
		
		dc.drawBitmap(0, 0, myBitmap);
		
		dc.setColor(Graphics.COLOR_GREEN,Graphics.COLOR_TRANSPARENT);
		dc.drawText(90,80,Graphics.FONT_MEDIUM,timeString,Graphics.TEXT_JUSTIFY_RIGHT|Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(85,98,Graphics.FONT_XTINY,dateString,Graphics.TEXT_JUSTIFY_RIGHT|Graphics.TEXT_JUSTIFY_VCENTER);
        }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

    hidden function getClockTime(clockTime) {
        var hour, min, ampm, result;

hour = clockTime.hour;
min = clockTime.min.format("%02d");

ampm = (hour > 11) ? "PM" : "AM";
hour = hour % 12;
hour = (hour == 0) ? 12 : hour;
hour = hour.format("%02d");

result = Lang.format("$1$:$2$ $3$", [hour, min, ampm]);
return result; 
    }
}
