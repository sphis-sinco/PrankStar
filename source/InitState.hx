package;

import flixel.FlxG;
import flixel.FlxState;
import menus.LevelSelect;
import menus.MainMenu;

class InitState extends FlxState
{
	override public function create()
	{
		trace('Running Flixel ${FlxG.VERSION.toString().split(' ')[1]}');
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

		FlxG.switchState(() -> new MainMenu());
	}

	public function preload()
	{
		PSAssets.init();
		PSAssets.cacheText('data/credits.json');

		FlxG.save.data.preferences.assetCaching ??= Preferences.assetCaching;
		FlxG.save.data.preferences.performanceText ??= Preferences.performanceText;

		Preferences.assetCaching = FlxG.save.data.preferences.assetCaching;
		Preferences.performanceText = FlxG.save.data.preferences.performanceText;

		FlxG.save.flush();
		Main.performanceText.visible = Preferences.performanceText;
		proceed();
	}
}
