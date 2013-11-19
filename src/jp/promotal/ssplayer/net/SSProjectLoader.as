package jp.promotal.ssplayer.net {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import jp.promotal.ssplayer.data.SSProject;

	import starling.textures.Texture;

	public class SSProjectLoader {

		public var project:SSProject;
		private var tasks:SSLoaderTask;
		private var directoryURL:String;

		private function toURLRequest(fileName:String):URLRequest {
			return new URLRequest(this.directoryURL + "/" + fileName);
		}

		public function SSProjectLoader() {
			super();
		}

		/* onProgress is function(ratio:Number) where 0 <= ratio <= 1 */
		public function load(request:URLRequest, onProgress:Function):void {
			if (this.project) {
				return;
			}
			this.project = new SSProject();
			this.directoryURL = request.url.slice(0, request.url.lastIndexOf("/"));
			this.tasks = new SSLoaderTask();
			this.loadProject(request);
			this.tasks.start(onProgress);
		}

		private function loadProject(request:URLRequest):void {
			trace("SSSProjectLoader.loadProject()");
			var _this:SSProjectLoader = this;
			var task:SSLoaderTask = this.tasks.spawn();
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, task.spawnEventListener(onLoadProjectComplete));
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, listenAndDie("error! project読み込み失敗"));
			urlLoader.load(request);
			function onLoadProjectComplete(event:Event):void {
				trace("SSSProjectLoader.onLoadProjectComplete()");
				var xml:XML = XML(URLLoader(event.target).data);
				for each (var anime:XML in xml.animepackNames.value) {
					_this.loadAnimepack(anime.text());
				}
				for each (var cell:XML in xml.cellmapNames.value) {
					_this.loadCellMap(cell.text());
				}
			}
		}

		private function loadAnimepack(name:String):void {
			trace("SSSProjectLoader.loadAnimepack()");
			var _this:SSProjectLoader = this;
			var task:SSLoaderTask = this.tasks.spawn();
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, task.spawnEventListener(onLoadAnimepackComplete));
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, listenAndDie("error! アニメーション読み込み失敗" + name));
			urlLoader.load(this.toURLRequest(name));
			function onLoadAnimepackComplete(event:Event):void {
				trace("SSSProjectLoader.onLoadAnimepackComplete()");
				var xml:XML = XML(urlLoader.data);
				_this.project.addAnimePackXML(xml, name)
			}
		}

		private function loadCellMap(name:String):void {
			trace("SSSProjectLoader.loadCellMap()");
			var _this:SSProjectLoader = this;
			var task:SSLoaderTask = this.tasks.spawn();
			var urlLoader:URLLoader = new URLLoader();
			var loader:Loader = new Loader();
			var xml:XML;
			urlLoader.addEventListener(Event.COMPLETE, task.spawnEventListener(onLoadCellMapComplete));
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, listenAndDie("error! セルマップ読み込み失敗" + name));
			urlLoader.load(this.toURLRequest(name));
			function onLoadCellMapComplete(event:Event):void {
				trace("SSSProjectLoader.onLoadCellMapComplete()");
				XML.ignoreWhitespace = false; // XXX dirty hack
				xml = XML(urlLoader.data);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, task.spawnEventListener(onLoadCellMapTextureComplete));
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, listenAndDie("error! テクスチャ読み込み失敗" + xml.imagePath));
				loader.load(_this.toURLRequest(xml.imagePath));
			}
			function onLoadCellMapTextureComplete(event:Event):void {
				trace("SSSProjectLoader.onLoadCellMapTextureComplete()");
				var texture:Texture;
				var bitmap:Bitmap = Bitmap(loader.content);
				if (bitmap.width > 2048 || bitmap.height > 2048) {
					var factor:Number = 1 / 2;
					var bitmapData:BitmapData = new BitmapData(Math.ceil(bitmap.width * factor), Math.ceil(bitmap.height * factor), true, 0);
					bitmapData.draw(bitmap, new Matrix(factor, 0, 0, factor, 0, 0));
					bitmap.bitmapData.dispose();
					texture = Texture.fromBitmapData(bitmapData, true, false, factor);
				} else {
					texture = Texture.fromBitmap(bitmap);
				}
				_this.project.addCellMapXML(texture, xml, name);
			}
		}

		private function listenAndDie(text:String):Function {
			return function(event:Event):void {
				trace(text);
			}
		}
	}
}

