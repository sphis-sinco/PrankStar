package;

import flixel.FlxG;
import lime.utils.Assets as LimeAssets;
import openfl.utils.Assets as OpenFLAssets;

class PSAssets
{
	public static function uncache()
	{
		LimeAssets.cache.clear();
		OpenFLAssets.cache.clear();
	}

	public static function recache()
	{
		for (asset in OpenFLAssets.list(SOUND))
		{
			FlxG.log.add('Recaching $asset from OpenFL audio cache list');
			cacheSound(asset);
		}
	}

	public static function cacheSound(id:String)
	{
		FlxG.log.add('Caching sound: "$id" into OpenFL audio cache list');
		OpenFLAssets.loadSound(id, true);
	}

	public static function playSound(id:String)
	{
		FlxG.sound.play(OpenFLAssets.getSound(id, true));
	}
}
