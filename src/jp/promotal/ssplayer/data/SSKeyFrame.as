package jp.promotal.ssplayer.data {

	public class SSKeyFrame extends SSFrame {

		private var _xml:XML;

		private var _time:int = 0;
		override public function get time():int {
			return this._time;
		}

		private var _ipType:String = null;
		override public function get ipType():String {
			return this._ipType;
		}

		public function SSKeyFrame() {
			super();
		}

		public static function fromXML(xml:XML):SSKeyFrame {
			var result:SSKeyFrame = new SSKeyFrame();
			if (SSProject.DEBUG) {
				result._xml = xml;
			}
			result._time = xml.@time;
			result._ipType = xml.@ipType;

			var value:String;
			value = String(xml.value.text()).replace(/\s/g, "");
			value ||= SSCell.globalCellName(xml.value.mapId.text(), xml.value.name.text());
			result.value = value;

			return result;
		}
	}
}
