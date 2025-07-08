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
			cacheSound(asset, true);
		}
	}

	public static function cacheSound(id:String, recache:Bool = false)
	{
		if (!OpenFLAssets.cache.hasSound(id))
		{
			FlxG.log.add('${recache ? 'Recaching' : 'Caching'} "$id"');
			FlxG.sound.cache(id);
		}
	}

	public static function playSound(id:String)
	{
		if (OpenFLAssets.cache.hasSound(id))
			FlxG.sound.play(OpenFLAssets.getSound(id, true));
		else
		{
			FlxG.sound.play(id);
			cacheSound(id); // Cache the sound afterwards
		}
	}
}
