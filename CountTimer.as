/**
 * CountTimer
 * Package for general purpose timer with textfield support.
 * Shows minutes and seconds.
 * @author Boris Lykke Nielsen
 */
package  {

    // Needed for timer
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    // Update textfield with time
    import flash.text.TextField;


    /**
     * CountTimer class extends Timer
     */
    public class CountTimer extends Timer {

        private var targetText:TextField;
        private var direction:String;
        private var minutes:int;
        private var seconds:int;
        private var totalSeconds:int;
        private var timeTotal;
        private var timeLoaded = 0;
        private var test:Boolean = false;


        /**
         * Constructor
         * @param min             minutes as int
         * @param sec             seconds as int
         * @param dir             The direction of the timer. "down" for a countdown.
         * @param targetTextField TextField to update with time values.
         */
        public function CountTimer(min:int, sec:int, dir:String, targetTextField:TextField=null) {
            this.minutes = int(min * 60);
            this.seconds = int(sec);
            this.timeTotal = this.minutes + this.seconds;
            super(1000, this.timeTotal);
            if (dir == "down") {
                this.totalSeconds = this.minutes + this.seconds;
            }
            else {
                this.totalSeconds = 0;
            }
            if (targetTextField != null) {
                this.targetText = targetTextField;
            }
            this.direction = dir;
        }


        /**
         * Start the timer
         * @return void
         */
        override public function start():void {
            super.start();
            addEventListener(TimerEvent.TIMER, timerHandler);
        }



        /**
         * Update loop for timer. Updates time and textfield.
         * @param  e TimerEvent
         * @return   void
         */
        private function timerHandler(e:TimerEvent):void {
            // update time loaded variable
            this.timeLoaded += 1;
            if (direction == "up") {
                // totalseconds is = 0, to start with. We add 1 to it.
                this.totalSeconds++;
            }
            else {
                // totalSeconds = theNumber of seconds by adding min and sec; We subtract 1 from it.
                this.totalSeconds--;
            }

            // How many seconds there are left.
            this.seconds = totalSeconds % 60;
            // How many minutes are left.
            this.minutes = Math.floor(totalSeconds / 60);
            // The minutes and seconds to display in the textField.
            var minutesDisplay:String = (minutes < 10) ? "0" + minutes.toString() : minutes.toString();
            var secondsDisplay:String = (seconds < 10) ? "0" + seconds.toString() : seconds.toString();
            if (this.targetText != null) {
                targetText.text = minutesDisplay + ":" + secondsDisplay;
            }
            if (test == true) {
                trace(minutesDisplay + ":" + secondsDisplay);
            }
        }


        /**
         * Method to return total time.
         * @return Timer target in seconds
         */
        public function getTimeTotal():int {
            return this.timeTotal;
        }


        /**
         * Method to return update count.
         * @return Number of updates.
         */
        public function getTimeLoaded():int {
            return this.timeLoaded;
        }


        /**
         * Returns progress in percent
         * @return progress
         */
        public function getProg():int {
            return Math.floor(timeLoaded/timeTotal*100);
        }


        /** setters */
        public function set testMode(val:Boolean):void {
            this.test = val;
        }
        public function set textField(val:TextField) {
            this.targetText = val;
        }

    } // end class

} // end package
