package;

import flixel.FlxG;
import flixel.system.debug.log.LogStyle;

class PSAssets
{
	public static function uncache()
	{
		openfl.Assets.cache.clear();
		lime.utils.Assets.cache.clear();
		openfl.utils.Assets.cache.clear();
	}

	public static function recache()
	{
		for (asset in FlxG.assets.list(SOUND))
		{
			FlxG.log.add('Recaching $asset');
			cacheSound(asset);
		}
	}

	public static function cacheSound(id:String)
	{
		FlxG.log.add('Caching $id');
		FlxG.assets.loadSound(id, true);
	}

	public static function playSound(id:String)
	{
		FlxG.sound.play(FlxG.assets.getSoundAddExt(id, true, LogStyle.WARNING));
	}
}
