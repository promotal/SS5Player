package jp.promotal.ssplayer.utils {

	public class SSInterpolation {
		public function SSInterpolation() {
		}

		public static function interpolate(ipType:String, timeStart:Number, timeEnd:Number, timeNow:Number, valueStart:String, valueEnd:String):String {
			var a:Number = (timeNow - timeStart) / (timeEnd - timeStart);
			var b:Number = 1 - a;
			switch (ipType) {
				case "linear":
					return String(Number(valueStart) * b + Number(valueEnd) * a);
					break;
			}
			return valueStart;
		}
	}
}
