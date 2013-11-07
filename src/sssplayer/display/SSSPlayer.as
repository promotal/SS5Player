package sssplayer.display {

	import flash.geom.Point;

	import sssplayer.data.SSSModel;
	import sssplayer.data.SSSPartAnime;
	import sssplayer.data.SSSProject;
	import sssplayer.data.SSSAnime;
	import sssplayer.data.SSSPart;

	import starling.display.DisplayObject;

	import starling.display.Sprite;
	import starling.events.Event;

	public class SSSPlayer extends Sprite {

		private var project:SSSProject;

		private var model:SSSModel;
		private var _anime:SSSAnime;
		public function get anime():SSSAnime {
			return this._anime;
		}

		private var _currentFrame:Number;
		public function get currentFrame():Number {
			return this._currentFrame;
		}
		public function set currentFrame(value:Number):void {
			this._currentFrame = value;
			this.updateParts();
		}

		private var _partPlayers:Vector.<SSSPartPlayer>;
		public function get partPlayers():Vector.<SSSPartPlayer> {
			return this._partPlayers.concat();
		}

		private var _isPlaying:Boolean = false;
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
		public function get loop():Boolean {
			return this._loop;
		}
		public function set loop(value:Boolean):void {
			this._loop = value;
		}

		private var _withFlatten:Boolean = false;
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

		public function set color(value:uint):void {
			for each (var partPlayer:SSSPartPlayer in this._partPlayers) {
				partPlayer.color = value;
			}
		}

		public function SSSPlayer(project:SSSProject) {
			super();
			this.project = project;
		}

		public function setAnime(name:String):SSSPlayer {
			this.model = this.project.modelForAnime(name);
			this._anime = this.project.anime(name);
			this.prepareChildren();
			this._currentFrame = 0;
			this.updateParts();
			return this;
		}

		public function startAnime(name:String):SSSPlayer {
			this.setAnime(name);
			this.isPlaying = true;
			return this;
		}

		public function play():void {
			this.isPlaying = true;
		}

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
		}

		private function prepareChildren():void {
			this.removeChildren();
			this._partPlayers = new Vector.<SSSPartPlayer>();
			for each (var part:SSSPart in this.model.parts) {
				var partAnime:SSSPartAnime = this._anime.partAnimes[part.name];
				var parentPartPlayer:SSSPartPlayer = null;
				if (part.parentIndex > -1) {
					parentPartPlayer = this._partPlayers[part.parentIndex];
				}
				var partPlayer:SSSPartPlayer = new SSSPartPlayer(this.project, this.model, part, partAnime, parentPartPlayer);
				this.addChild(partPlayer);
				this._partPlayers.push(partPlayer);
			}
		}

		private function updateParts():void {
			for each (var partPlayer:SSSPartPlayer in this._partPlayers) {
				partPlayer.currentFrame = this._currentFrame;
			}
			if (this._withFlatten) {
				this.flatten();
			}
		}

		public function partPlayerAt(x:Number, y:Number, forTouch:Boolean = false):SSSPartPlayer {
			var touchable:Boolean = this.touchable;
			this.touchable = true;
			var hitObject:DisplayObject = this.hitTest(new Point(x, y), forTouch);
			this.touchable = touchable;
			if (!hitObject) {
				return null;
			}
			for each (var partPlayer:SSSPartPlayer in this._partPlayers) {
				if (hitObject.parent == partPlayer) {
					return partPlayer;
				}
			}
			return null;
		}

		public function partNameAt(x:Number, y:Number, forTouch:Boolean = false):String {
			var partPlayer:SSSPartPlayer = this.partPlayerAt(x, y, forTouch);
			return partPlayer ? partPlayer.name : null;
		}

	}
}
