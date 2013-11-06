package sssplayer.utils {

	public class SSSColor {

		private var _alpha:Number;
		public function get alpha():Number {
			return _alpha;
		}
		public function set alpha(value:Number):void {
			if (value < 0) {
				value = 0;
			} else if (value > 1) {
				value = 1;
			}
			_alpha = value;
		}

		private var _red:Number;
		public function get red():Number {
			return _red;
		}
		public function set red(value:Number):void {
			if (value < 0) {
				value = 0;
			} else if (value > 1) {
				value = 1;
			}
			_red = value;
		}

		private var _green:Number;
		public function get green():Number {
			return _green;
		}
		public function set green(value:Number):void {
			if (value < 0) {
				value = 0;
			} else if (value > 1) {
				value = 1;
			}
			_green = value;
		}

		private var _blue:Number;
		public function get blue():Number {
			return _blue;
		}
		public function set blue(value:Number):void {
			if (value < 0) {
				value = 0;
			} else if (value > 1) {
				value = 1;
			}
			_blue = value;
		}

		public function get value():uint {
			var value:int = 0;
			value += int(this._alpha * 255) << 24;
			value += int(this._red   * 255) << 16;
			value += int(this._green * 255) << 8;
			value += int(this._blue  * 255);
			return uint(value);
		}

		public function set value(value:uint):void {
			this._alpha = ((value >> 24) & 0xff) / 255;
			this._red   = ((value >> 16) & 0xff) / 255;
			this._green = ((value >>  8) & 0xff) / 255;
			this._blue  = ((value >>  0) & 0xff) / 255;
		}

		public function SSSColor(value:uint) {
			this.value = value;
		}

		public function clone():SSSColor {
			return new SSSColor(this.value);
		}

	}
}
