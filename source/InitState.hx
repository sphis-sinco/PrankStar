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
		PSAssets.uncache();
		PSAssets.recache();

		proceed();
	}
}
