package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import lime.utils.Assets as LimeAssets;
import openfl.utils.Assets as OpenFLAssets;

using StringTools;

// Prank
// Star
// Assets
// When the project was still called that.
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
		preparePurgeTextureCache();
		purgeTextureCache();
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
			if (type == 'image')
				fullpath += '.png';
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

	/**
	 * An internal list of all the textures cached with `cacheTexture`.
	 * This excludes any temporary textures like those from `FlxText` or `makeSolidColor`.
	 */
	static var currentCachedTextures:Map<String, FlxGraphic> = [];

	/**
	 * An internal list of textures that were cached in the previous state.
	 * We don't know whether we want to keep them cached or not.
	 */
	static var previousCachedTextures:Map<String, FlxGraphic> = [];

	/**
	 * Ensure the texture with the given key is cached.
	 * @param key The key of the texture to cache.
	 */
	public static function cacheTexture(key:String, ?functions:
		{
			?onComplete:Void->Void,
			?onFail:(tpSplit:Array<String>) -> Void,
			?onSuccess:(tpSplit:Array<String>) -> Void,
			?onStart:(tpSplit:Array<String>) -> Void
		}):Void
	{
		var fullpath:String = fullPathInit(key, 'image');

		var tpSplit:Array<String>;
		tpSplit = fullpath.split('/');

		// We don't want to cache the same texture twice.
		if (currentCachedTextures.exists(fullpath))
			return;

		if (previousCachedTextures.exists(fullpath))
		{
			// Move the graphic from the previous cache to the current cache.
			var graphic = previousCachedTextures.get(fullpath);
			previousCachedTextures.remove(fullpath);
			currentCachedTextures.set(fullpath, graphic);
			return;
		}

		if (functions.onStart != null)
			functions.onStart(tpSplit);

		// Else, texture is currently uncached.
		var graphic:FlxGraphic = FlxGraphic.fromAssetKey(fullpath, false, null, true);
		var fail = graphic == null;
		if (fail)
		{
			FlxG.log.warn('Failed to cache graphic: $fullpath');
		}
		else
		{
			trace('Successfully cached graphic: $fullpath');
			graphic.persist = true;
			currentCachedTextures.set(fullpath, graphic);
		}

		if (functions.onComplete != null)
			functions.onComplete();

		if (fail)
		{
			if (functions.onFail != null)
				functions.onFail(tpSplit);
		}
		else
		{
			if (functions.onSuccess != null)
				functions.onSuccess(tpSplit);
		}
	}

	/**
	 * Determine whether the texture with the given key is cached.
	 * @param key The key of the texture to check.
	 * @return Whether the texture is cached.
	 */
	public static function isTextureCached(key:String):Bool
	{
		return FlxG.bitmap.get(key) != null;
	}

	/**
	 * Call this, then `cacheTexture` to keep the textures we still need, then `purgeTextureCache` to remove the textures that we won't be using anymore.
	 */
	public static function preparePurgeTextureCache():Void
	{
		previousCachedTextures = currentCachedTextures;
		currentCachedTextures = [];
	}

	public static function purgeTextureCache():Void
	{
		// Everything that is in previousCachedTextures but not in currentCachedTextures should be destroyed.
		for (graphicKey in previousCachedTextures.keys())
		{
			var graphic = previousCachedTextures.get(graphicKey);
			if (graphic == null)
				continue;
			FlxG.bitmap.remove(graphic);
			graphic.destroy();
			previousCachedTextures.remove(graphicKey);
		}
	}
}
