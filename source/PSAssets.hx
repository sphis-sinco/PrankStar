package;

import flixel.FlxG;
import flixel.system.debug.log.LogStyle;

class PSAssets
{
	public static function cacheSound(id:String)
	{
		if (!FlxG.assets.exists(id, SOUND))
			FlxG.assets.loadSound(id, true);
		else
			trace('Sound already cached: $id');
	}

	public static function playSound(id:String)
	{
		FlxG.sound.play(FlxG.assets.getSoundAddExt(id, true, LogStyle.WARNING));
	}
}
