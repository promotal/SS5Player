#!/bin/sh
aasdoc \
	-source-path src \
	-doc-sources src \
	-library-path '/Applications/Adobe Gaming SDK 1.2/Frameworks/Starling/Starling-Framework/starling/bin' \
	-window-title 'SS5Player for AS3 API Reference' \
	-main-title 'SS5Player for AS3 API Reference' \
	-output doc \
	-package ss5player 'Root package of SS5Player for AS3.' \
	-package ss5player.data 'Data structure for a SpriteStudio project.' \
	-package ss5player.net 'Tools for loading a SpriteStudio project.' \
	-package ss5player.players 'SpriteStudio animation playback engines.' \
	-package ss5player.players.starling 'SpriteStudio animation playback engine for Starling.' \
	-package ss5player.utils 'Utility classes.' \
