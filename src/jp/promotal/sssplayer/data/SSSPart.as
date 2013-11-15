package jp.promotal.sssplayer.data {

	public class SSSPart {

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

		public function SSSPart() {
			super();
		}

		public static function fromXML(xml:XML):SSSPart {
			var result:SSSPart = new SSSPart();
			if (SSSProject.DEBUG) {
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
