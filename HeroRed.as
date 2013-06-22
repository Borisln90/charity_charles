package  {

    import flash.display.MovieClip;
    import flash.events.KeyboardEvent;
    import flash.events.Event;
    import flash.ui.Keyboard;


    public class HeroRed extends Hero {

        var leftKeyDown:Boolean = false;
        var rightKeyDown:Boolean = false;
        var upKeyDown:Boolean = false;
        var downKeyDown:Boolean = false;


        public function HeroRed() {
            // constructor code
            this.addEventListener(Event.ENTER_FRAME, update);
            this.nme = "red";
        }


        private function update(e:Event):void {
            this.move(leftKeyDown, rightKeyDown);
            if (upKeyDown && !this.isJumping) {
                this.jump();
            }
        }


        public function keyDownHandler(e:KeyboardEvent):void {
            var target = e.keyCode;
            switch (target) {
                case Keyboard.UP:
                    upKeyDown = true;
                    break;
                case Keyboard.LEFT:
                    leftKeyDown = true;
                    break;
                case Keyboard.DOWN:
                    downKeyDown = true;
                    break;
                case Keyboard.RIGHT:
                    rightKeyDown = true;
                    break;
            }
        } // end keyDownHandler


        public function keyUpHandler(e:KeyboardEvent):void {
            var target = e.keyCode;
            switch (target) {
                case Keyboard.UP:
                    upKeyDown = false;
                    break;
                case Keyboard.LEFT:
                    leftKeyDown = false;
                    break;
                case Keyboard.DOWN:
                    downKeyDown = false;
                    break;
                case Keyboard.RIGHT:
                    rightKeyDown = false;
                    break;
            }
        } // end keyUpHandler
    }

}
