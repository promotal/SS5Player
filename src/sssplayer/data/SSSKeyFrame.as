package sssplayer.data {

	public class SSSKeyFrame extends SSSFrame {

		private var xml:XML;

		private var _time:int = 0;
		override public function get time():int {
			return this._time ||= xml.@time;
		}

		private var _ipType:String = null;
		override public function get ipType():String {
			return this._ipType ||= xml.@ipType;
		}

		override public function get value():String {
			var value:String = super.value;
			if (value) {
				return value;
			}
			value ||= String(xml.value.text()).replace(/\s/g, "");
			value ||= SSSCell.globalCellName(xml.value.mapId.text(), xml.value.name.text());
			super.value = value;
			return value;
		}

		public function SSSKeyFrame() {
			super();
		}

		public static function fromXML(xml:XML):SSSKeyFrame {
			var result:SSSKeyFrame = new SSSKeyFrame();
			result.xml = xml;
			return result;
		}
	}
}
