package ss5player.data {

	public class SS5Frame {

		private var _time:int = 0;
		public function get time():int {
			return this._time;
		}
		public function set time(value:int):void {
			this._time = value;
		}

		private var _ipType:String = null;
		public function get ipType():String {
			return this._ipType;
		}
		public function set ipType(value:String):void {
			this._ipType = value;
		}

		private var _value:*;
		public function get value():* {
			return this._value;
		}
		public function set value(value:*):void {
			this._value = value;
		}

		public function SS5Frame() {
			super();
		}
	}
}
