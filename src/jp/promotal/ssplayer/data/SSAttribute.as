package jp.promotal.ssplayer.data {

	import jp.promotal.ssplayer.utils.SSInterpolation;

	public class SSAttribute {

		private var _xml:XML;

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
				return nextKeyFrame ? nextKeyFrame.value : "";
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

		public static function empty():SSAttribute {
			return SSAttribute.fromXML(<root />);
		}

		public static function fromXML(xml:XML):SSAttribute {
			var result:SSAttribute = new SSAttribute();
			if (SSProject.DEBUG) {
				result._xml = xml;
			}
			for each (var key:XML in xml.key) {
				var keyFrame:SSKeyFrame = SSKeyFrame.fromXML(key);
				result._keyFrames.push(keyFrame);
			}
			return result;
		}
	}
}
