package jp.promotal.sssplayer.data {

	public class SSSFrame {

		public function get time():int {
			return 0;
		}

		public function get ipType():String {
			return "";
		}

		private var _value:String;
		public function get value():String {
			return this._value;
		}
		public function set value(value:String):void {
			this._value = value;
		}

		public function SSSFrame() {
			super();
		}
	}
}
