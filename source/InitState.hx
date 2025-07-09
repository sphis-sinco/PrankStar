package;

import flixel.FlxG;
import flixel.FlxState;
import menus.LevelSelect;
import menus.MainMenu;
import openfl.Lib;

class InitState extends FlxState
{
	override public function create()
	{
		trace('Prankton ${Lib.application.meta.get('version')}');
		trace('Running Flixel ${FlxG.VERSION.toString().split(' ')[1]}');
		if (Preferences.performanceText != null)
			Main.performanceText.visible = Preferences.performanceText;

		preload();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function proceed()
	{
		#if WaterBalloon
		FlxG.switchState(() -> new levels.waterballoon.WaterBalloon());
		return;
		#end

		#if WhoopieCushion
		FlxG.switchState(() -> new levels.whoopeecushion.WhoopeeCushion());
		return;
		#end

		#if Pie
		FlxG.switchState(() -> new levels.pietotheface.PieToTheFace());
		return;
		#end

		#if html5
		FlxG.switchState(() -> new menus.LevelSelect());
		return;
		#end

		FlxG.switchState(() -> new MainMenu());
	}

	public function preload()
	{
		PSAssets.init();
		PSAssets.cacheText('data/credits.json');

		#if !html5
		if (FlxG.save.data.preferences == null)
		{
			Preferences.assetCaching = FlxG.save.data.preferences.assetCaching;
			Preferences.performanceText = FlxG.save.data.preferences.performanceText;
		}
		#end

		Preferences.assetCaching ??= true;
		Preferences.performanceText ??= true;

		#if !html5
		FlxG.save.flush();
		#end
		Main.performanceText.visible = Preferences.performanceText;
		proceed();
	}
}
