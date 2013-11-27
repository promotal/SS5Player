package jp.promotal.ssplayer.data {

	import jp.promotal.ssplayer.utils.SSInterpolation;

	public class SSAttribute {

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
			for each (var keyFrame:SSKeyFrame in this.keyFrames) {
				this._frames[keyFrame.time] = keyFrame;
			}
			for (var i:int = 0; i < this._frames.length; i++) {
				var startFrame:SSFrame = this._frames[i];
				if (startFrame) {
					var endFrame:SSFrame = null;
					for (var j:int = i + 1; j < this._frames.length; j++) {
						if (this._frames[j]) {
							endFrame = this._frames[j];
							break;
						}
					}
					if (endFrame) {
						for (var k:int = i + 1; k < j; k++) {
							var frame:SSFrame = new SSFrame();
							frame.value = SSInterpolation.interpolate(startFrame.ipType, i, j, k, startFrame.value, endFrame.value);
							this._frames[k] = frame;
						}
						i = j - 1;
					}
				}
			}
			return this._frames;
		}

		public function valueAt(time:Number):* {
			var prevKeyFrame:SSKeyFrame = null;
			var nextKeyFrame:SSKeyFrame = null;
			for each (var keyFrame:SSKeyFrame in this.keyFrames) {
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
			return SSInterpolation.interpolate(prevKeyFrame.ipType, prevKeyFrame.time, nextKeyFrame.time, time, prevKeyFrame.value, nextKeyFrame.value);
		}

		public function SSAttribute() {
			super();
			this._keyFrames = [];
		}

		public static function empty(tag:String):SSAttribute {
			var result:SSAttribute = new SSAttribute();
			result.tag = tag;
			return result;
		}

		public static function fromXML(xml:XML):SSAttribute {
			var result:SSAttribute = new SSAttribute();
			if (SSProject.DEBUG) {
				result._xml = xml;
			}
			result.tag = xml.@tag;
			for each (var key:XML in xml.key) {
				var keyFrame:SSKeyFrame = SSKeyFrame.fromXML(key);
				result._keyFrames.push(keyFrame);
			}
			return result;
		}
	}
}
