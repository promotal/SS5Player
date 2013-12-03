package ss5player.net {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import ss5player.data.SS5Project;

	import starling.textures.Texture;

	/**
	 * Loader of SpriteStudio project file (.sspj).
	 * @author PROMOTAL Inc.
	 */
	public class SS5ProjectLoader {

		/** Loaded SpriteStudio project, or <code>null</code> if not loading is not completed. */
		public var project:SS5Project;

		private var tasks:SS5LoaderTask;
		private var directoryURL:String;

		/** Enables verbose logging when set to <code>true</code>. */
		public static var DEBUG:Boolean = false;

		private function toURLRequest(fileName:String):URLRequest {
			return new URLRequest(this.directoryURL + "/" + fileName);
		}

		/**
		 * Constructor.
		 */
		public function SS5ProjectLoader() {
			super();
		}

		/**
		 * Initiates loading a SpriteStudio project file asynchronously.
		 * <p>
		 *     <code>onProgress()</code> will be repeatedly called with <code>ratio</code> where <code>0 &lt;= ratio &lt;= 1</code>.
		 * </p>
		 * <p>
		 *     When loading is complete, <code>onProgress()</code> is called with <code>ratio = 1</code>
		 *     and <code>project</code> is ready to use.
		 * </p>
		 * @param request path to the SpriteStudio project file (.sspj) to load.
		 * @param onProgress function(ratio:Number):void;
		 */
		public function load(request:URLRequest, onProgress:Function):void {
			if (this.project) {
				return;
			}
			this.project = new SS5Project();
			this.directoryURL = request.url.slice(0, request.url.lastIndexOf("/"));
			this.tasks = new SS5LoaderTask();
			this.loadProject(request);
			this.tasks.start(onProgress);
		}

		private function loadProject(request:URLRequest):void {
			debugTrace("SSSProjectLoader.loadProject()");
			var _this:SS5ProjectLoader = this;
			var task:SS5LoaderTask = this.tasks.spawn();
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, task.spawnEventListener(onLoadProjectComplete));
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, listenAndDie("Error! Project load failed: "));
			urlLoader.load(request);
			function onLoadProjectComplete(event:Event):void {
				debugTrace("SSSProjectLoader.onLoadProjectComplete()");
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
			debugTrace("SSSProjectLoader.loadAnimepack()");
			var _this:SS5ProjectLoader = this;
			var task:SS5LoaderTask = this.tasks.spawn();
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, task.spawnEventListener(onLoadAnimepackComplete));
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, listenAndDie("Error! Animepack load failed: " + name));
			urlLoader.load(this.toURLRequest(name));
			function onLoadAnimepackComplete(event:Event):void {
				debugTrace("SSSProjectLoader.onLoadAnimepackComplete()");
				var xml:XML = XML(urlLoader.data);
				_this.project.addAnimePackXML(xml, name)
			}
		}

		private function loadCellMap(name:String):void {
			debugTrace("SSSProjectLoader.loadCellMap()");
			var _this:SS5ProjectLoader = this;
			var task:SS5LoaderTask = this.tasks.spawn();
			var urlLoader:URLLoader = new URLLoader();
			var loader:Loader = new Loader();
			var xml:XML;
			urlLoader.addEventListener(Event.COMPLETE, task.spawnEventListener(onLoadCellMapComplete));
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, listenAndDie("Error! Cellmap load failed: " + name));
			urlLoader.load(this.toURLRequest(name));
			function onLoadCellMapComplete(event:Event):void {
				debugTrace("SSSProjectLoader.onLoadCellMapComplete()");
				XML.ignoreWhitespace = false; // XXX dirty hack
				xml = XML(urlLoader.data);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, task.spawnEventListener(onLoadCellMapTextureComplete));
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, listenAndDie("Error! Texture load failed: " + xml.imagePath));
				loader.load(_this.toURLRequest(xml.imagePath));
			}
			function onLoadCellMapTextureComplete(event:Event):void {
				debugTrace("SSSProjectLoader.onLoadCellMapTextureComplete()");
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

		private function debugTrace(text:String):void {
			if (DEBUG) {
				trace("[SSProjectLoader]", text);
			}
		}

		private function listenAndDie(text:String):Function {
			return function(event:Event):void {
				trace("[SSProjectLoader]", text);
			}
		}
	}
}

