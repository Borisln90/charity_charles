package  {
	
	import Main;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.Event;
	
	
	public class Hero extends MovieClip {
		
		private var _instance:Main;
		private var _points:int = 0;
		private var _coins:Array = new Array();
		private var _opponent:Hero;
		private var _isJumping:Boolean = false;
		private var _startingPoint:Point;
		
		var _name:String;
		
		var xVelocity:Number = 0;
		var yVelocity:Number = 0;
		var gravity:Number = 0.96;
		var friction:Number = 0.96;
		
		var jumpSpeed:Number = 20;
		var moveSpeed:Number = 1.25;
		
		var leftBump:Boolean = false;
		var rightBump:Boolean = false;
		var upBump:Boolean = false;
		var downBump:Boolean = false;
		
		var leftBumpPoint:Point = new Point(-25, 0);
		var rightBumpPoint:Point = new Point(25, 0);
		var upBumpPoint:Point = new Point(0, -30.5);
		var downBumpPoint:Point = new Point(0, 30.5);
		
		private var _jug:MovieClip;
		
		var jumps:int = 0;
		var attacks:int = 0;
		var coinStacks:Array = [];
		
		public function Hero() {
			_instance = Main.instance;
		} // end Hero
		
		public function begin():void {
			_opponent = _instance.getOpponent(this);
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		public function end():void {
			this.removeEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:Event):void {
			var blocks:Sprite = _instance.blocks;
			
			this.x += xVelocity;
			this.y += yVelocity;
			
			if (this.x > stage.stageWidth - this.width/2) {
				this.x = stage.stageWidth - this.width/2;
				xVelocity = 0;
			}
			if (this.x < this.width/2) {
				this.x = this.width/2;
				xVelocity = 0;
			}
			if (this.y > stage.stageHeight - this.height/2) {
				this.y = stage.stageHeight - this.height/2;
				yVelocity = 0;
				_isJumping = false;
			}
			if (this.y < this.height/2) {
				this.y = this.height/2;
				yVelocity = -yVelocity;
			}
			
			xVelocity *= friction;
			yVelocity *= friction;
			
			yVelocity += gravity;
			
			for (var i:int=0; i<blocks.numChildren; i++) {
				var block:DisplayObject = blocks.getChildAt(i);
				detectEdge(block);
				if (downBump && this.y < block.y) {
					this.y = block.y - this.height/2;
					yVelocity = 0;
					_isJumping = false;
					break;
				}
				if (upBump && this.y > block.y) {
					this.y = block.y + block.height + this.height/2;
					yVelocity *= -1;
					break;
				}
				if (leftBump && this.x > block.x) {
					this.x = block.x + block.width + this.width/2;
					xVelocity = 0;
					break;
				}
				if (rightBump && this.x < block.x) {
					this.x = block.x - this.width/2;
					xVelocity = 0;
					break;
				}
			}
			
			if (xVelocity < 0) {
				this.gotoAndStop(3);
			} 
			if (xVelocity > 0) {
				this.gotoAndStop(2);
			}
			if (xVelocity > -.25 && xVelocity < .25) {
				this.gotoAndStop(1);
			}
			
			// check for attack on other player
			if (yVelocity > 0 && this.isJumping) {
				if (_opponent.hitTestPoint(this.x + downBumpPoint.x, this.y + downBumpPoint.y, true)) {
					if (_opponent.hasCoins()) {
						var coins:Array = _opponent.coins;
						this.score += coins.length;
						_opponent.emptyCoins();
						this._jug.gotoAndPlay(2);
						// log the attack
						this.attacks++;
					}
				}
			}
		}
		
		
		public function move(left:Boolean=false, right:Boolean=false):void {
			var factor:Number = Math.max(moveSpeed - this.coins.length / 6, 0.25);
			if (left) {
				xVelocity -= factor;
			}
			if (right) {
				xVelocity += factor;
			}
		}
		
		
		public function jump():void {
			yVelocity = -jumpSpeed;
			_isJumping = true;
			// log the jump
			this.jumps++;
		} // end jump
		
		
		public function coinCollected(c:Coin):void {
			_coins.push(c);
		}
		
		public function hasCoins():Boolean {
			return _coins.length > 0;
		}
		
		public function getCoinsValue():int {
			return Math.pow(_coins.length, 2);
		}
		
		public function emptyCoins():void {
			// first log the size of the stack
			this.coinStacks.push(this.coins.length);
			// empty the stack
			_coins.length = 0;
		}
		
		public function hasWon():Boolean {
			return this.score > _opponent.score;
		}
		
		// getter setter
		public function get isJumping():Boolean { return _isJumping; }
		public function set isJumping(val:Boolean):void { _isJumping = val; }
		public function get startingPoint():Point { return _startingPoint; }
		public function set startingPoint(val:Point):void { _startingPoint = val; }
		public function get score():int { return _points; }
		public function set score(val:int):void { _points = val; }
		public function get coins():Array { return _coins; }
		public function get nme():String { return _name; }
		public function set nme(val:String):void { _name = val; }
		public function set jug(val:MovieClip) { this._jug = val; }
		
		
		public function detectEdge(block:DisplayObject):void {
			if (block.hitTestPoint(this.x + leftBumpPoint.x, this.y + leftBumpPoint.y, true)) {
				leftBump = true;
			} else {
				leftBump = false;
			}
			if (block.hitTestPoint(this.x + rightBumpPoint.x, this.y + rightBumpPoint.y, true)) {
				rightBump = true;
			} else {
				rightBump = false;
			}
			if (block.hitTestPoint(this.x + upBumpPoint.x, this.y + upBumpPoint.y, true)) {
				upBump = true;
			} else {
				upBump = false;
			}
			if (block.hitTestPoint(this.x + downBumpPoint.x, this.y + downBumpPoint.y, true)) {
				downBump = true;
			} else {
				downBump = false;
			}
		}
	} // end class
	
} // end package
