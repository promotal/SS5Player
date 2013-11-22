package jp.promotal.ssplayer.data {

	public class SSKeyFrame extends SSFrame {

		private var _xml:XML;

		public function SSKeyFrame() {
			super();
		}

		public static function fromXML(xml:XML):SSKeyFrame {
			var result:SSKeyFrame = new SSKeyFrame();
			if (SSProject.DEBUG) {
				result._xml = xml;
			}
			result.time = xml.@time;
			result.ipType = xml.@ipType;

			var value:XML = xml.value[0];
			// treat as SSCellName if valid
			result.value = SSCellName.fromXML(value);
			// fall back for Number
			result.value ||= parseFloat(String(value.text()).replace(/\s/g, ""));

			return result;
		}
	}
}
