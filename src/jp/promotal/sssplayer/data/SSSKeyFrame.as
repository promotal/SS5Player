package jp.promotal.sssplayer.data {

	public class SSSKeyFrame extends SSSFrame {

		private var _xml:XML;

		private var _time:int = 0;
		override public function get time():int {
			return this._time;
		}

		private var _ipType:String = null;
		override public function get ipType():String {
			return this._ipType;
		}

		public function SSSKeyFrame() {
			super();
		}

		public static function fromXML(xml:XML):SSSKeyFrame {
			var result:SSSKeyFrame = new SSSKeyFrame();
			if (SSSProject.DEBUG) {
				result._xml = xml;
			}
			result._time = xml.@time;
			result._ipType = xml.@ipType;

			var value:String;
			value = String(xml.value.text()).replace(/\s/g, "");
			value ||= SSSCell.globalCellName(xml.value.mapId.text(), xml.value.name.text());
			result.value = value;

			return result;
		}
	}
}
