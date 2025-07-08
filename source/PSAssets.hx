package;

import flixel.FlxG;
import lime.utils.Assets as LimeAssets;
import openfl.utils.Assets as OpenFLAssets;

class PSAssets
{
	public static function init()
	{
		LimeAssets.cache.enabled = true;
		OpenFLAssets.cache.enabled = true;

		uncache();
		recache();
	}

	public static function uncache()
	{
		LimeAssets.cache.clear('assets/');
		OpenFLAssets.cache.clear('assets/');
	}

	public static function recache()
	{
		for (asset in OpenFLAssets.list(SOUND))
		{
			// FlxG.log.add('Recaching "$asset"');
			cacheSound(asset);
		}
	}

	public static function cacheSound(id:String)
	{
		// FlxG.log.add('Caching "$id"');
		OpenFLAssets.loadSound(id, !OpenFLAssets.cache.hasSound(id));
	}

	public static function playSound(id:String)
	{
		FlxG.sound.play(OpenFLAssets.getSound(id, true));
	}
}
