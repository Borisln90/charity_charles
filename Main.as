/**
* Charity Charles
*
* Main class for the Charity Charles game.
* @author Boris Lykke Nielsen
*/

package  {
	import net.eriksjodin.arduino.events.ArduinoEvent;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;

	import flash.ui.Keyboard;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.media.SoundChannel;


	public class Main extends MovieClip {
		// Instance
		private static var _instance:Main;
		private var _leaderboard:Leaderboard;
		private var _arduino:ArduinoWrapper;
		// Hero
		var heroOne:HeroGreenArduino;
		var heroTwo:HeroRedArduino;
		// Level
		private var _lvl:Array = new Array();
		private var _blockHolder = new Sprite();
		private var _leftBank:Bank;
		private var _rightBank;
		// Coins
		private var _coins:Array = new Array();
		private var _coinsOnStage:Array = new Array();
		private var _coinTimer:Timer;
		// Timer
		var countTimer:CountTimer;
		var buttonTimer:Timer;
		var delayTimer:Timer;
		var restartTimer:Timer;
		// Music
		var bgMusic:BackgroundMusic;
		var bgmSoundChannel:SoundChannel;
		// Session data
		private var _session:Object = {};
		private var _lastSession:int;
		// Buttons
		var redButtonDown:Boolean = false;
		var redLeftButtonDown:Boolean = false;
		var redRightButtonDown:Boolean = false;

		var greenButtonDown:Boolean = false;
		var greenLeftButtonDown:Boolean = false;
		var greenRightButtonDown:Boolean = false;

		public function Main() {
			// instance
			_instance = this;
			_leaderboard = new Leaderboard();
			_arduino = new ArduinoWrapper();
			_arduino.resetBoard();
			// go to start frame
			this.gotoAndStop(1);
			// init variables
			prepareGame();
			// Music
			bgMusic = new BackgroundMusic();
			bgmSoundChannel = bgMusic.play();
			bgmSoundChannel.addEventListener(Event.SOUND_COMPLETE, bgMusicHandler);

			buttonTimer = new Timer(2000, 1);
			buttonTimer.addEventListener(TimerEvent.TIMER_COMPLETE, buttonTimerStart);
			buttonTimer.start();
			//startBtn.addEventListener(MouseEvent.CLICK, startGame);
			// init leaderboard
			//_leaderboard.initDB();


		} // end Main


		private function buttonTimerStart(e:TimerEvent):void {
			// Timer
			buttonTimer = new Timer(50);
			buttonTimer.addEventListener(TimerEvent.TIMER, arduinoHandler);
			buttonTimer.start();
		}

		/**
		 * Update loop for main class.
		 * Updates counters on stage.
		 * @param  e Event
		 * @return   void
		 */
		private function update(e:Event):void {
			scoreCounterGreen.text = String(heroOne.score);
			scoreCounterRed.text = String(heroTwo.score);
			RedCoinCounter.text = String(heroTwo.coins.length);
			GreenCoinCounter.text = String(heroOne.coins.length);
		} // end update


		private function keyDownHandler(e:KeyboardEvent):void {
			heroOne.keyDownHandler(e);
			heroTwo.keyDownHandler(e);
		}

		private function keyUpHandler(e:KeyboardEvent):void {
			heroOne.keyUpHandler(e);
			heroTwo.keyUpHandler(e);
		}

		private function coinTimerHandler(e:TimerEvent):void {
			var coin = _coins.pop();
			_coinsOnStage.push(coin);
			stage.addChild(coin);
			coin.begin();
		}

		private function bgMusicHandler(e:Event):void {
			bgmSoundChannel = bgMusic.play();
			bgmSoundChannel.addEventListener(Event.SOUND_COMPLETE, bgMusicHandler);
		}

		private function gameTimerHandler(e:TimerEvent):void {
			// stop the game
			this.endGame();
			// delay the button timer
			delayTimer = new Timer(5000, 1);
			delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, delayHandler);
			delayTimer.start();
			// finish the game
			this.finishGame();
		}

		private function arduinoHandler(e:TimerEvent):void {
			this.redButtonDown = _arduino.getDigitalData(3) == false;
			this.redLeftButtonDown = _arduino.getDigitalData(4);
			this.redRightButtonDown = _arduino.getDigitalData(6);

			this.greenButtonDown = _arduino.getDigitalData(2) == false;
			this.greenLeftButtonDown = _arduino.getDigitalData(7);
			this.greenRightButtonDown = _arduino.getDigitalData(5);

			if (this.redButtonDown || this.greenButtonDown) {
				this.gotoNextFrame(this.currentFrame + 1);
				buttonTimer.stop();
				delayTimer = new Timer(3000, 1);
				delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, delayHandler);
				delayTimer.start();
			}
		}

		private function delayHandler(e:TimerEvent):void {
			buttonTimer.start();
		}

		private function gotoNextFrame(current:int):void {
			var frame:int = current;
			switch (frame) {
				case 1:
					this.gotoAndStop(1);
					prepareGame();
					break;
				case 2:
					this.gotoAndStop(2);
					break;
				case 3:
					startGame();
					break;
				case 5:
					restartGame();
					break;
			}
		}

		/**
		 * Creates the level layout and bank buildings.
		 * @return void
		 */
		private function createLevel():void {
			// Define the layout
			var X:String = "heroOne";
			_lvl[0] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			_lvl[1] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			_lvl[2] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			_lvl[3] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			_lvl[4] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			_lvl[5] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			_lvl[6] = [0,0,0,0,0,0,0,2,3,0,0,0,0,0,0,0,0,0,0,0,0,0];
			_lvl[7] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			_lvl[8] = [0,0,0,0,0,0,0,0,0,0,0,0,0,2,1,3,0,0,0,0,0,0];
			_lvl[9] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			_lvl[10] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			_lvl[11] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			_lvl[12] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			_lvl[13] = [0,0,0,0,0,0,0,0,0,2,1,3,0,0,0,0,0,0,0,0,0,0];
			_lvl[14] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			_lvl[15] = [0,0,0,0,0,0,2,3,0,0,0,0,0,2,3,0,0,0,0,0,0,0];
			_lvl[16] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			_lvl[17] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			_lvl[18] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			_lvl[19] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			_lvl[20] = [0,0,0,0,0,0,0,0,0,X,0,0,0,0,0,0,0,0,0,0,0,0];

			for (var row:int = 0; row < _lvl.length; row++) {
				for (var column:int = 0; column < _lvl[row].length; column++) {
					if (_lvl[row][column] == 1 || _lvl[row][column] == 2 || _lvl[row][column] == 3) {
						var newBlock:Platform = new Platform(_lvl[row][column]);
						newBlock.x = column*newBlock.width;
						newBlock.y = row*newBlock.height;

						_blockHolder.addChild(newBlock);
					}
					if (_lvl[row][column] == X) {
						heroOne.x = column * 37-18;
						heroOne.y = row * 29-18;
						heroOne.startingPoint = new Point(heroOne.x, heroOne.y);
					}
				}
			}
			_leftBank = new Bank(heroTwo);
			_leftBank.x = 0;
			_leftBank.y = stage.stageHeight - _leftBank.height;
			_leftBank.gotoAndStop(2);

			_rightBank = new Bank(heroOne);
			_rightBank.x = stage.stageWidth - _rightBank.width;
			_rightBank.y = stage.stageHeight - _rightBank.height;
			_rightBank.gotoAndStop(1);
		}

		/**
		 * Creates 100 new coins to use in game.
		 * @return void
		 */
		private function createCoins():void {
			for (var i:int = 0; i<100; i++) {
				var coin = new Coin();
				coin.y = -10;
				coin.x = Math.random() * stage.stageWidth;
				_coins.push(coin);
			}
		}

		/**
		 * Removes a coin from the game.
		 * @param  c The coin to remove
		 * @return   void
		 */
		public function removeCoin(c:Coin):void {
			// Stop the coins loop
			c.end();
			// Remove coin from stage
			stage.removeChild(c);
			_coinsOnStage.splice(_coinsOnStage.indexOf(c), 1);
		}

		/**
		 * used to find the opponent object
		 * @param  h The Hero lokking for his opponent.
		 * @return   The opponent of H otherwise null
		 */
		public function getOpponent(h:Hero):Hero {
			var heroes:Array = this.heroes;
			for (var i:int=0; i < heroes.length; i++) {
				if (heroes[i] != h) {
					return heroes[i];
				}
			}
			return null;
		}

		/**
		 * Finds if anyone has won the game.
		 * @param  heroes An array of participants
		 * @return        The Hero object of the winner otherwise null
		 */
		public function getWinner(heroes:Array):Hero {
			for each (var hero:Hero in heroes) {
				if (hero.hasWon()) {
					return hero;
				}
			}
			return null;
		}

		private function startGame():void {
			// go to the proper frame
			this.gotoAndStop(3);
			// stop button timer. The players has their own.
			buttonTimer.stop();
			// add elements to stage
			stage.addChild(heroOne);
			stage.addChild(heroTwo);
			stage.addChild(_blockHolder);
			stage.addChildAt(_leftBank, 1);
			stage.addChildAt(_rightBank, 1);
			// start element loops
			heroOne.jug = JugRed;
			heroTwo.jug = JugGreen;
			heroOne.begin();
			heroTwo.begin();
			_coinTimer.start();
			countTimer.textField = TimerTxt;
			countTimer.start();
			// Add game loop
			stage.addEventListener(Event.ENTER_FRAME, update);
			_coinTimer.addEventListener(TimerEvent.TIMER, coinTimerHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			countTimer.addEventListener(TimerEvent.TIMER_COMPLETE, gameTimerHandler);
			// make sure the stage is in fucus for keyboard events.
			stage.focus = this;

		}

		private function prepareGame():void {
			// reset arrays
			_lvl.length = 0;
			_coins.length = 0;
			_coinsOnStage.length = 0;
			_blockHolder = new Sprite();
			// init heroes
			heroOne = new HeroGreenArduino(this.arduino);
			heroTwo = new HeroRedArduino(this.arduino);
			// init level
			createLevel();
			// init coins
			createCoins();
			_coinTimer = new Timer(2500);
			// init game timer
			countTimer = new CountTimer(2, 0, "down");
		}

		private function endGame():void {
			// remove game loop
			stage.removeEventListener(Event.ENTER_FRAME, update);
			_coinTimer.removeEventListener(TimerEvent.TIMER, coinTimerHandler);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			countTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, gameTimerHandler);
			// stop element loops
			_coinTimer.stop();
			countTimer.stop();
			heroOne.end();
			heroTwo.end();
			// remove game elements from stage
			stage.removeChild(_leftBank);
			stage.removeChild(_rightBank);
			stage.removeChild(_blockHolder);
			stage.removeChild(heroOne);
			stage.removeChild(heroTwo);
			// remove all coins from stage
			for each (var c:Coin in _coinsOnStage) {
				c.end();
				stage.removeChild(c);
			}
			_coinsOnStage.length = 0;

		}

		private function finishGame():void {
			// Go to finish frame
			this.gotoAndStop(4);
			// Find the winner
			var winner:Hero = this.getWinner(this.heroes);
			// Announce the winner
			var str:String;
			if (winner != null) {
				var opponent:Hero = this.getOpponent(winner);
				str = "congratulations " + winner.nme + " you won the game with " + String(winner.score) + " points!\n" + opponent.nme + " got " + String(opponent.score) + " points.";
			} else {
				str = "Sadly nobody won this game :( \n" + heroOne.nme + " got " + String(heroOne.score) + " points and " + heroTwo.nme + " got " + String(heroTwo.score) + " points.";
			}
			FinishFrameText.text = str.toUpperCase();
			// Add listener for restart button
			restartTimer = new Timer(10000,1);
			restartTimer.addEventListener(TimerEvent.TIMER_COMPLETE, gotoStart);
			restartTimer.start();
		}

		private function gotoStart(e:TimerEvent):void {
			restartTimer.stop();
			gotoNextFrame(1);
		}

		private function restartGame():void {
			restartTimer.stop();
			// no more changes can be made in this game. Create the session data and put in storage.
			var session:Session = new Session(this.heroes);
			this._lastSession = _leaderboard.addScore(session);
			// restart the game
			this.prepareGame();
			this.startGame();
		}

		/**
		 * Getters
		 */
		public static function get instance():Main { return _instance; }
		public function get blocks():Sprite { return _blockHolder; }
		public function get heroes():Array { return [heroOne, heroTwo]; }
		public function get arduino():ArduinoWrapper {return this._arduino; }

	} // end class

} // end package
