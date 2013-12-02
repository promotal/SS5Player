package ss5player.utils {

	public class SS5Interpolation {
		public function SS5Interpolation() {
		}

		public static function interpolate(ipType:String, timeStart:Number, timeEnd:Number, timeNow:Number, valueStart:*, valueEnd:*):* {
			var a:Number = (timeNow - timeStart) / (timeEnd - timeStart);
			var b:Number = 1 - a;
			switch (ipType) {
				case "linear":
					return valueStart * b + valueEnd * a;
					break;
			}
			return valueStart;
		}
	}
}
