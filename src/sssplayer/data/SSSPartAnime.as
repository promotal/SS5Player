package sssplayer.data {

	public class SSSPartAnime {

		private var xml:XML;

		private var _partName:String;
		public function get partName():String {
			return this._partName ||= xml.partName;
		}

		private var _attributes:Object;
		public function get attributes():Object {
			if (this._attributes) {
				return this._attributes;
			}
			this._attributes = {};
			for each (var attribute:XML in this.xml.attributes.attribute) {
				this._attributes[attribute.@tag] = SSSAttribute.fromXML(attribute);
			}
			return this._attributes;
		}

		public function attribute(tag:String):SSSAttribute {
			return this.attributes[tag] ||= SSSAttribute.empty();
		}

		public function SSSPartAnime() {
			super();
		}

		public static function fromXML(xml:XML):SSSPartAnime {
			var result:SSSPartAnime = new SSSPartAnime();
			result.xml = xml;
			return result;
		}
	}
}
