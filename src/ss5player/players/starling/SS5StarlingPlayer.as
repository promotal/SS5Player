package ss5player.players.starling {

	import flash.geom.Point;

	import ss5player.data.SS5Model;
	import ss5player.data.SS5PartAnime;
	import ss5player.data.SS5Project;
	import ss5player.data.SS5Anime;
	import ss5player.data.SS5Part;

	import starling.display.DisplayObject;

	import starling.display.Sprite;
	import starling.events.Event;

	/**
	 * A Starling DisplayObject for SpriteStudio animation playbacks.
	 * @author PROMOTAL Inc.
	 */
	public class SS5StarlingPlayer extends Sprite {

		private var project:SS5Project;

		private var model:SS5Model;
		private var _anime:SS5Anime;
		/** Current anime. */
		public function get anime():SS5Anime {
			return this._anime;
		}

		private var _currentFrame:Number;
		/** Current frame number (can be fractional). */
		public function get currentFrame():Number {
			return this._currentFrame;
		}
		public function set currentFrame(value:Number):void {
			this._currentFrame = value;
			this.updateParts();
		}

		private var _partPlayers:Vector.<SS5StarlingPartPlayer>;
		/** @private */
		public function get partPlayers():Vector.<SS5StarlingPartPlayer> {
			return this._partPlayers.concat();
		}

		private var _isPlaying:Boolean = false;
		/** <code>true</code> if the animation is playing. */
		public function get isPlaying():Boolean {
			return this._isPlaying;
		}
		public function set isPlaying(value:Boolean):void {
			if (value == this._isPlaying) {
				return;
			}
			if (value) {
				this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
			} else {
				this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
			}
			this._isPlaying = value;
		}

		private var _loop:Boolean = true;
		/** Set to <code>true</code> to enable loop of the animation playback. */
		public function get loop():Boolean {
			return this._loop;
		}
		public function set loop(value:Boolean):void {
			this._loop = value;
		}

		private var _withFlatten:Boolean = false;
		/** Set to <code>true</code> to call <code>Sprite.flatten()</code> on each display state update. */
		public function get withFlatten():Boolean {
			return this._withFlatten;
		}
		public function set withFlatten(value:Boolean):void {
			if (value == this._withFlatten) {
				return;
			}
			this._withFlatten = value;
			if (value) {
				this.flatten();
			} else {
				this.unflatten();
			}
		}

		/** @private */
		public function set color(value:uint):void {
			for each (var partPlayer:SS5StarlingPartPlayer in this._partPlayers) {
				partPlayer.color = value;
			}
		}

		/**
		 * Constructor.
		 * @param project SpriteStudio project to display.
		 */
		public function SS5StarlingPlayer(project:SS5Project) {
			super();
			this.project = project;
		}

		/**
		 * Selects animation to play by name.
		 * @param name The name of the animation.
 		 * @param modelName If not <code>null</code>, animation is searched from the given model or anime pack.
		 */
		public function setAnime(name:String, modelName:String = null):SS5StarlingPlayer {
			if (modelName) {
				this.model = this.project.model(modelName);
				this._anime = this.model.anime(name);
			} else {
				this.model = this.project.modelForAnime(name);
				this._anime = this.project.anime(name);
			}
			this.prepareChildren();
			this._currentFrame = 0;
			this.updateParts();
			return this;
		}

		/**
		 * Calls <code>setAnime()</code> and <code>play()</code> in order.
		 * @see SS5StarlingPlayer#play()
		 * @see SS5StarlingPlayer#setAnime()
		 * @param name The name of the animation.
		 * @param modelName If not <code>null</code>, animation is searched from the given model or anime pack.
		 */
		public function startAnime(name:String, modelName:String = null):SS5StarlingPlayer {
			this.setAnime(name, modelName);
			this.isPlaying = true;
			return this;
		}

		/**
		 * Start playback of the animation.
		 */
		public function play():void {
			this.isPlaying = true;
		}

		/**
		 * Stops playback of the animation.
		 */
		public function stop():void {
			this.isPlaying = false;
		}

		private function onEnterFrame(event:Event):void {
			if (++this._currentFrame >= this._anime.frameCount) {
				if (this._loop) {
					this._currentFrame = 0;
				} else {
					this._currentFrame--;
					this.stop();
				}
				this.dispatchEventWith(Event.COMPLETE);
			}
			this.updateParts();
		}

		private function prepareChildren():void {
			this.removeChildren();
			this._partPlayers = new Vector.<SS5StarlingPartPlayer>();
			for each (var part:SS5Part in this.model.parts) {
				var partAnime:SS5PartAnime = this._anime.partAnimes[part.name];
				var parentPartPlayer:SS5StarlingPartPlayer = null;
				if (part.parentIndex > -1) {
					parentPartPlayer = this._partPlayers[part.parentIndex];
				}
				var partPlayer:SS5StarlingPartPlayer = new SS5StarlingPartPlayer(this.project, this.model, part, partAnime, parentPartPlayer);
				this.addChild(partPlayer);
				this._partPlayers.push(partPlayer);
			}
		}

		private function updateParts():void {
			for each (var partPlayer:SS5StarlingPartPlayer in this._partPlayers) {
				partPlayer.currentFrame = this._currentFrame;
			}
			if (this._withFlatten) {
				this.flatten();
			}
		}

		/**
		 * Returns a <code>SS5StarlingPartPlayer</code> at the given location,
		 * or <code>null</code> if nothing is found at the given position.
		 * @param x The x coordinate.
		 * @param y The y coordinate.
		 * @param forTouch Passed to <code>hitTest()</code>.
		 */
		public function partPlayerAt(x:Number, y:Number, forTouch:Boolean = false):SS5StarlingPartPlayer {
			var touchable:Boolean = this.touchable;
			this.touchable = true;
			var hitObject:DisplayObject = this.hitTest(new Point(x, y), forTouch);
			this.touchable = touchable;
			if (!hitObject) {
				return null;
			}
			for each (var partPlayer:SS5StarlingPartPlayer in this._partPlayers) {
				if (hitObject.parent == partPlayer) {
					return partPlayer;
				}
			}
			return null;
		}

		/**
		 * Returns the name of the part at the given location,
		 * or <code>null</code> if nothing is found at the given position.
		 * @param x The x coordinate.
		 * @param y The y coordinate.
		 * @param forTouch Passed to <code>hitTest()</code>.
		 */
		public function partNameAt(x:Number, y:Number, forTouch:Boolean = false):String {
			var partPlayer:SS5StarlingPartPlayer = this.partPlayerAt(x, y, forTouch);
			return partPlayer ? partPlayer.name : null;
		}

	}
}
