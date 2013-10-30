package sssplayer.data {

	import sssplayer.utils.SSSInterpolation;

	public class SSSAttribute {

		private var xml:XML;

		private var _keyFrames:Array;
		public function get keyFrames():Array {
			if (this._keyFrames) {
				return this._keyFrames;
			}
			this._keyFrames = [];
			for each (var key:XML in this.xml.key) {
				var keyFrame:SSSKeyFrame = SSSKeyFrame.fromXML(key);
				this._keyFrames.push(keyFrame);
			}
			return this._keyFrames;
		}

		private var _frames:Array;
		public function get frames():Array {
			if (this._frames) {
				return this._frames;
			}
			this._frames = [];
			for each (var keyFrame:SSSKeyFrame in this.keyFrames) {
				this._frames[keyFrame.time] = keyFrame;
			}
			for (var i:int = 0; i < this._frames.length; i++) {
				var startFrame:SSSFrame = this._frames[i];
				if (startFrame) {
					var endFrame:SSSFrame = null;
					for (var j:int = i + 1; j < this._frames.length; j++) {
						if (this._frames[j]) {
							endFrame = this._frames[j];
							break;
						}
					}
					if (endFrame) {
						for (var k:int = i + 1; k < j; k++) {
							var frame:SSSFrame = new SSSFrame();
							frame.value = SSSInterpolation.interpolate(startFrame.ipType, i, j, k, startFrame.value, endFrame.value);
							this._frames[k] = frame;
						}
						i = j - 1;
					}
				}
			}
			return this._frames;
		}

		public function valueAt(time:Number):String {
			if (false && this._frames) {
				var frame:SSSFrame = this._frames[time] || this._frames[this._frames.length - 1];
				return frame ? frame.value : "";
			}
			var prevKeyFrame:SSSKeyFrame = null;
			var nextKeyFrame:SSSKeyFrame = null;
			for each (var keyFrame:SSSKeyFrame in this.keyFrames) {
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
			return SSSInterpolation.interpolate(prevKeyFrame.ipType, prevKeyFrame.time, nextKeyFrame.time, time, prevKeyFrame.value, nextKeyFrame.value);
		}

		public function SSSAttribute() {
			super();
		}

		public static function empty():SSSAttribute {
			return SSSAttribute.fromXML(<root />);
		}

		public static function fromXML(xml:XML):SSSAttribute {
			var result:SSSAttribute = new SSSAttribute();
			result.xml = xml;
			return result;
		}
	}
}
