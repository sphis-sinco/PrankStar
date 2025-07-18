package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.sound.FlxSound;
import lime.utils.Assets as LimeAssets;
import openfl.utils.Assets as OpenFLAssets;

using StringTools;

// Prank
// Star
// Assets
// When the project was still called that.
class PSAssets
{
	public static var bullshitFuncion:(tpSplit:Array<String>) -> Void = tpSplit -> {};
	public static var bullshitFunctions:
		{
			?onComplete:Void->Void,
			?onFail:(tpSplit:Array<String>) -> Void,
			?onSuccess:(tpSplit:Array<String>) -> Void,
			?onStart:(tpSplit:Array<String>) -> Void
		};

	public static function init()
	{
		bullshitFunctions = {
			onStart: bullshitFuncion,
			onSuccess: bullshitFuncion,
			onFail: bullshitFuncion,
			onComplete: () -> {}
		}

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
		if (!Preferences.assetCaching)
			return;

		for (asset in OpenFLAssets.list(SOUND))
		{
			cacheSound(asset, true);
		}
		for (asset in OpenFLAssets.list(TEXT))
		{
			cacheText(asset, true);
		}
		for (asset in OpenFLAssets.list(IMAGE))
		{
			cacheTexture(asset, bullshitFunctions, true);
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
		#if RECACHE_LOGS
		if (recache)
			FlxG.log.add('Recaching "$id"');
		#end

		#if CACHE_LOGS
		if (!recache)
			FlxG.log.add('Caching "$id"');
		#end
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
		if (!Preferences.assetCaching)
			return;

		var fullpath = fullPathInit(id, 'sound');

		if (!OpenFLAssets.cache.hasSound(fullpath) && assetExists(fullpath))
		{
			cacheMsg(fullpath, recache);
			FlxG.sound.cache(fullpath);
		}
	}

	public static function cacheText(id:String, recache:Bool = false)
	{
		if (!Preferences.assetCaching)
			return;

		var fullpath = fullPathInit(id, 'text');

		if (!FlxG.assets.list(TEXT).contains(fullpath) && assetExists(fullpath))
		{
			cacheMsg(fullpath, recache);
			FlxG.assets.loadText(fullpath, true);
		}
	}

	public static function playSound(id:String)
	{
		getSound(id).play();
	}

	public static function getSound(id:String):FlxSound
	{
		var fullpath = fullPathInit(id, 'sound');
		var sound:FlxSound;

		if (OpenFLAssets.cache.hasSound(fullpath) && Preferences.assetCaching)
		{
			sound = new FlxSound().loadEmbedded(OpenFLAssets.getSound(fullpath, true));
		}
		else
		{
			sound = new FlxSound().loadEmbedded(fullpath);
			cacheSound(fullpath); // Cache the sound afterwards
		}

		return sound;
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
		}, recache:Bool = false):Void
	{
		if (!Preferences.assetCaching)
			return;

		var fullpath:String = fullPathInit(key, 'image');

		var tpSplit:Array<String>;
		tpSplit = fullpath.split('/');

		// We don't want to cache the same texture twice.
		if (currentCachedTextures.exists(fullpath) || !Preferences.assetCaching)
			return;

		if (previousCachedTextures.exists(fullpath))
		{
			// Move the graphic from the previous cache to the current cache.
			var graphic = previousCachedTextures.get(fullpath);
			previousCachedTextures.remove(fullpath);
			currentCachedTextures.set(fullpath, graphic);
			return;
		}

		functions.onStart(tpSplit);

		// Else, texture is currently uncached.
		cacheMsg(fullpath, recache);
		var graphic:FlxGraphic = FlxGraphic.fromAssetKey(fullpath, false, null, true);
		var fail = graphic == null;
		if (fail)
		{
			FlxG.log.warn('Failed to cache graphic: $fullpath');
		}
		else
		{
			FlxG.log.add('Successfully cached graphic: $fullpath');
			graphic.persist = true;
			currentCachedTextures.set(fullpath, graphic);
		}

		functions.onComplete();

		if (fail)
		{
			functions.onFail(tpSplit);
		}
		else
		{
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
