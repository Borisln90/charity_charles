package  {

    import flash.display.MovieClip;
    import flash.events.KeyboardEvent;
    import flash.events.Event;
    import flash.ui.Keyboard;


    public class HeroGreen extends Hero {

        var leftKeyDown:Boolean = false;
        var rightKeyDown:Boolean = false;
        var upKeyDown:Boolean = false;
        var downKeyDown:Boolean = false;


        public function HeroGreen() {
            // constructor code
            this.addEventListener(Event.ENTER_FRAME, update);
            this.nme = "green";
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
                case Keyboard.W:
                    upKeyDown = true;
                    break;
                case Keyboard.A:
                    leftKeyDown = true;
                    break;
                case Keyboard.S:
                    downKeyDown = true;
                    break;
                case Keyboard.D:
                    rightKeyDown = true;
                    break;
            }
        } // end keyDownHandler


        public function keyUpHandler(e:KeyboardEvent):void {
            var target = e.keyCode;
            switch (target) {
                case Keyboard.W:
                    upKeyDown = false;
                    break;
                case Keyboard.A:
                    leftKeyDown = false;
                    break;
                case Keyboard.S:
                    downKeyDown = false;
                    break;
                case Keyboard.D:
                    rightKeyDown = false;
                    break;
            }
        } // end keyUpHandler
    }

}
