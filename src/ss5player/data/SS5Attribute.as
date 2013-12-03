package ss5player.data {

	import ss5player.utils.SS5Interpolation;

	/**
	 * A structure which represents a SpriteStudio attribute.
	 * Is internal and API may break on library version update.
	 * @author PROMOTAL Inc.
	 */
	public class SS5Attribute {

		private var _xml:XML;

		private var _tag:String;
		public function get tag():String {
			return this._tag;
		}
		public function set tag(value:String):void {
			this._tag = value;
			if (defaultValue(value) === undefined) {
				trace("[SSProject] SSAttribute.tag(): Attribute not supported:", value);
			}
		}

		public static function defaultValue(tag:String):* {
			switch (tag) {
				case "CELL":
					return null;
				case "HIDE":
					return 0;
				case "POSX":
					return 0;
				case "POSY":
					return 0;
				case "ROTZ":
					return 0;
				case "SCLX":
					return 1;
				case "SCLY":
					return 1;
				case "ALPH":
					return 1;
				default:
					return undefined;
			}
		}

		private var _keyFrames:Array;
		public function get keyFrames():Array {
			return this._keyFrames;
		}

		private var _frames:Array;
		public function get frames():Array {
			if (this._frames) {
				return this._frames;
			}
			this._frames = [];
			for each (var keyFrame:SS5KeyFrame in this.keyFrames) {
				this._frames[keyFrame.time] = keyFrame;
			}
			for (var i:int = 0; i < this._frames.length; i++) {
				var startFrame:SS5Frame = this._frames[i];
				if (startFrame) {
					var endFrame:SS5Frame = null;
					for (var j:int = i + 1; j < this._frames.length; j++) {
						if (this._frames[j]) {
							endFrame = this._frames[j];
							break;
						}
					}
					if (endFrame) {
						for (var k:int = i + 1; k < j; k++) {
							var frame:SS5Frame = new SS5Frame();
							frame.value = SS5Interpolation.interpolate(startFrame.ipType, i, j, k, startFrame.value, endFrame.value);
							this._frames[k] = frame;
						}
						i = j - 1;
					}
				}
			}
			return this._frames;
		}

		public function valueAt(time:Number):* {
			var prevKeyFrame:SS5KeyFrame = null;
			var nextKeyFrame:SS5KeyFrame = null;
			for each (var keyFrame:SS5KeyFrame in this.keyFrames) {
				if (keyFrame.time <= time) {
					if (!prevKeyFrame || keyFrame.time > prevKeyFrame.time) {
						prevKeyFrame = keyFrame;
					}
				} else {
					if (!nextKeyFrame || keyFrame.time < nextKeyFrame.time) {
						nextKeyFrame = keyFrame;
					}
				}
			}
			if (!prevKeyFrame) {
				return nextKeyFrame ? nextKeyFrame.value : defaultValue(this.tag);
			}
			if (!nextKeyFrame) {
				return prevKeyFrame.value;
			}
			return SS5Interpolation.interpolate(prevKeyFrame.ipType, prevKeyFrame.time, nextKeyFrame.time, time, prevKeyFrame.value, nextKeyFrame.value);
		}

		public function SS5Attribute() {
			super();
			this._keyFrames = [];
		}

		public static function empty(tag:String):SS5Attribute {
			var result:SS5Attribute = new SS5Attribute();
			result.tag = tag;
			return result;
		}

		public static function fromXML(xml:XML):SS5Attribute {
			var result:SS5Attribute = new SS5Attribute();
			if (SS5Project.DEBUG) {
				result._xml = xml;
			}
			result.tag = xml.@tag;
			for each (var key:XML in xml.key) {
				var keyFrame:SS5KeyFrame = SS5KeyFrame.fromXML(key);
				result._keyFrames.push(keyFrame);
			}
			return result;
		}
	}
}
