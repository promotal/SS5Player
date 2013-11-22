# SSSPlayer: Starling SpriteStudio Player

## About SSSPlayer

SSSPlayer is an ActionScript 3 library which displays
[OPTPiX SpriteStudio](http://www.webtech.co.jp/spritestudio/) animation data with [Starling Framework](http://starling-framework.org/).


## Requirements

* Adobe Flash Player, latest
* Starling Framework, latest
* OPTPiX SpriteStudio, version 5


## Usage

Sorry, documentation and demo is in progress.

Try this in Starling Sprite:

	var loader:SSProjectLoader;
	const SSPJ:String = "path/to/your/SpriteStudioProject.sspj";

	this.loader = new SSProjectLoader();
	this.loader.load(new URLRequest(SSPJ), this.onProgress);

	private function onProgress(progress:Number):void {
		// progress is 1 when loading is complete
		if (progress == 1) {
			var player:SSSPlayer = new SSSPlayer(this.loader.project);
			player.startAnime("nameOfYourAnime");
			player.play();
			this.addChild(player);
		}
	}
