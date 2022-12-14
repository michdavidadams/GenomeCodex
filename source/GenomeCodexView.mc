import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.ActivityMonitor;

using Toybox.Time.Gregorian;

class GenomeCodexView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }


    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        
    }

    // Update the view
    function onUpdate(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var activityMonitorInfo = System.ActivityMonitor.getInfo();
        var healthColor = getHealthColor(activityMonitorInfo.moveBarLevel);
        var systemStats = System.getSystemStats();
        System.println("getSystemsStats battery: " + systemStats.battery);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 0, width, height);
        
        // Heart rate line container
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 25, 280, 5);
        for(var i=0; i<280; i+=10) {
            dc.fillCircle(i, 20, 1);
            dc.fillCircle(i, 130, 1);
        }
        dc.fillRectangle(0, 120, 280, 5);

        // Heart rate line
        dc.setColor(healthColor, Graphics.COLOR_TRANSPARENT);
        // Left of time
        dc.drawLine(0, 70, 10, 70);
        dc.drawLine(10, 70, 15, 68);
        dc.drawLine(15, 68, 20, 70);
        dc.drawLine(20, 70, 25, 70);
        dc.drawLine(25, 70, 30, 40);
        dc.drawLine(30, 40, 35, 70);
        dc.drawLine(35, 70, 160, 70);
        // Right of time
        dc.drawLine(160, 70, 162, 72);
        dc.drawLine(162, 72, 164, 70);
        dc.drawLine(164, 70, 174, 70);
        dc.drawLine(174, 70, 179, 100);
        dc.drawLine(179, 100, 184, 70);
        dc.drawLine(184, 70, 280, 70);

        // Time and date
        var clockTime = System.getClockTime();
        var timeString = getClockTime(clockTime);
        var clockDate = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateString = Lang.format("$1$,$2$$3$", [clockDate.day_of_week, clockDate.month, clockDate.day]);
        dc.setColor(healthColor,Graphics.COLOR_BLACK);
		dc.drawText(width/2,60,Graphics.FONT_LARGE,timeString,Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/2,90,Graphics.FONT_XTINY,dateString,Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);

        // Move bar indicator (Health bar on bottom right)
        dc.setColor(healthColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(120, 170, 150, 5, 10);

        // Yellow (Orange) heart at bottom left
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(50, 170, 10);

        // White lines at bottom beside yellow heart
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        // Battery is 1st line
        var batteryPercentage = systemStats.battery;
        if(batteryPercentage == null) {
            batteryPercentage = 1.0;
            System.print("batteryPercentage is null");
        }
        dc.fillRoundedRectangle(65, 160, (0.3 * batteryPercentage), 3, 10);
        dc.fillRoundedRectangle(65, 165, 30, 3, 10);
        // Steps is 3rd line, with 4th line being the max value the bar can get so user can eyeball total
        var steps = activityMonitorInfo.steps;
        if(steps == null) {
            steps = 1;
            System.print("Steps is null");
        }
        var stepGoal = activityMonitorInfo.stepGoal;
        if(stepGoal == null) {
            stepGoal = 1;
            System.print("stepGoal is null");
        }
        System.print("steps: " + steps + ". stepGoal: " + stepGoal);
        dc.fillRoundedRectangle(65, 170, (30 * (steps/stepGoal)), 3, 10);
        dc.fillRoundedRectangle(65, 175, 30, 3, 10);
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

        result = Lang.format("$1$:$2$ $3$", [hour, min, ampm]);
        return result; 
    }

    // Sets health color (green, yellow, red)
    hidden function getHealthColor(moveBarLevel) {
        if(moveBarLevel == null) {
            moveBarLevel = 0;
            System.println("moveBarLevel in getHealthColor() is null");
        }
        var moveBarPercentage = moveBarLevel/5;
        System.println("moveBarPercentage in getHealthColor() is " + moveBarPercentage);
        if(moveBarPercentage >= 0.75) {
            return Graphics.COLOR_RED;
        } else if(moveBarPercentage >= 0.50) {
            return Graphics.COLOR_YELLOW;
        } else if(moveBarPercentage >= 0.0) {
            return Graphics.COLOR_GREEN;
        } else {
            return Graphics.COLOR_GREEN;
        }
    }

}
