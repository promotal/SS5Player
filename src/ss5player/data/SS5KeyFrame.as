package ss5player.data {

	public class SS5KeyFrame extends SS5Frame {

		private var _xml:XML;

		public function SS5KeyFrame() {
			super();
		}

		public static function fromXML(xml:XML):SS5KeyFrame {
			var result:SS5KeyFrame = new SS5KeyFrame();
			if (SS5Project.DEBUG) {
				result._xml = xml;
			}
			result.time = xml.@time;
			result.ipType = xml.@ipType;

			var value:XML = xml.value[0];
			// treat as SSCellName if valid
			result.value = SS5CellName.fromXML(value);
			// fall back for Number
			result.value ||= parseFloat(String(value.text()).replace(/\s/g, ""));

			return result;
		}
	}
}
