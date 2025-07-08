package;

import flixel.FlxG;
import flixel.FlxState;

class InitState extends FlxState
{
	override public function create()
	{
		trace('Running Flixel ${FlxG.VERSION.toString().split(' ')[1]}');

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

		FlxG.switchState(() -> new menus.LevelSelect());
	}

	public function preload()
	{
		PSAssets.cacheSound('assets/sounds/ui/accepted.wav');
		PSAssets.cacheSound('assets/sounds/ui/denied.wav');
		PSAssets.cacheSound('assets/sounds/ui/scroll.wav');

		PSAssets.cacheSound('assets/sounds/door.wav');
		PSAssets.cacheSound('assets/sounds/waterballoon.wav');
		PSAssets.cacheSound('assets/sounds/whoopie.wav');

		proceed();
	}
}
