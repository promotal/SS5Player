package sssplayer.data {

	import flash.geom.Rectangle;

	import starling.textures.Texture;

	public class SSSCell {

		public var texture:Texture;

		private var xml:XML;

		private var _name:String;
		public function get name():String {
			return this._name ||= xml.name;
		}

		private var _pictArea:Rectangle;
		public function get pictArea():Rectangle {
			if (this._pictArea) {
				return this._pictArea;
			}
			var pos:Array = String(this.xml.pos).split(" ");
			var size:Array = String(this.xml.size).split(" ");
			this._pictArea = new Rectangle(pos[0], pos[1], size[0], size[1]);
			return this._pictArea;
		}

		private var _pivot:Array;
		public function get pivot():Array {
			return this._pivot ||= String(this.xml.pivot).split(" ");
		}

		private var _pivotX:int;
		public function get pivotX():int {
			return this._pivotX ||= (Number(this.pivot[0]) + 0.5) * this.pictArea.width;
		}

		private var _pivotY:int;
		public function get pivotY():int {
			return this._pivotY ||= (-Number(this.pivot[1]) + 0.5) * this.pictArea.height;
		}

		public function SSSCell() {
			super();
		}

		public static function fromXML(xml:XML, texture:Texture):SSSCell {
			var result:SSSCell = new SSSCell();
			result.xml = xml;
			result.texture = Texture.fromTexture(texture, result.pictArea);
			return result;
		}

		public static function globalCellName(mapName:String, cellName:String):String {
			return mapName + "/" + cellName;
		}
	}
}
