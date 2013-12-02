package ss5player.data {

	public class SS5Part {

		private var _xml:XML;

		private var _name:String;
		public function get name():String {
			return this._name;
		}

		private var _type:String;
		public function get type():String {
			return this._type;
		}

		private var _parentIndex:int;
		public function get parentIndex():int {
			return this._parentIndex;
		}

		private var _show:int;
		public function get show():int {
			return this._show;
		}

		public function SS5Part() {
			super();
		}

		public static function fromXML(xml:XML):SS5Part {
			var result:SS5Part = new SS5Part();
			if (SS5Project.DEBUG) {
				result._xml = xml;
			}
			result._name = xml.name;
			result._type = xml.type;
			result._parentIndex = xml.parentIndex;
			result._show = xml.show;
			return result;
		}
	}
}
