package;

import flixel.FlxG;
import lime.utils.Assets as LimeAssets;
import openfl.utils.Assets as OpenFLAssets;

using StringTools;

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
		for (asset in OpenFLAssets.list(TEXT))
		{
			cacheText(asset, true);
		}
	}

	public static function assetExists(id:String):Bool
	{
		var result = FlxG.assets.exists(id);

		if (result)
			FlxG.log.add('"$id" exists');
		else
			FlxG.log.warn('"$id" doesnt exist');
		return result;
	}

	private static function cacheMsg(id:String, recache:Bool = false)
	{
		FlxG.log.add('${recache ? 'Recaching' : 'Caching'} "$id"');
	}

	public static function fullPathInit(id:String, type:String = '')
	{
		var fullpath = id;

		if (!id.contains('.'))
		{
			if (type == 'sound')
				fullpath += '.wav';
		}

		if (!id.startsWith('assets/') && !id.startsWith('flixel/'))
			fullpath = 'assets/$fullpath';

		return fullpath;
	}

	public static function cacheSound(id:String, recache:Bool = false)
	{
		var fullpath = fullPathInit(id, 'sound');

		if (!OpenFLAssets.cache.hasSound(fullpath) && assetExists(fullpath))
		{
			cacheMsg(fullpath, recache);
			FlxG.sound.cache(fullpath);
		}
	}

	public static function cacheText(id:String, recache:Bool = false)
	{
		var fullpath = fullPathInit(id, 'text');

		if (!FlxG.assets.list(TEXT).contains(fullpath) && assetExists(fullpath))
		{
			cacheMsg(fullpath, recache);
			FlxG.assets.loadText(fullpath, true);
		}
	}

	public static function playSound(id:String)
	{
		var fullpath = fullPathInit(id, 'sound');

		if (OpenFLAssets.cache.hasSound(fullpath))
			FlxG.sound.play(OpenFLAssets.getSound(fullpath, true));
		else
		{
			FlxG.sound.play(fullpath);
			cacheSound(fullpath); // Cache the sound afterwards
		}
	}
}
