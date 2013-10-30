package sssplayer.data {

	public class SSSPart {

		private var xml:XML;

		private var _name:String;
		public function get name():String {
			return this._name ||= xml.name;
		}

		private var _type:String;
		public function get type():String {
			return this._type ||= xml.type;
		}

		private var _parentIndex:int;
		public function get parentIndex():int {
			return this._parentIndex ||= xml.parentIndex;
		}

		private var _show:int;
		public function get show():int {
			return this._show ||= xml.show;
		}

		public function SSSPart() {
			super();
		}

		public static function fromXML(xml:XML):SSSPart {
			var result:SSSPart = new SSSPart();
			result.xml = xml;
			return result;
		}
	}
}
