package;

import flixel.FlxG;
import flixel.FlxState;

class InitState extends FlxState
{
	override public function create()
	{
		trace('Running Flixel ${FlxG.VERSION.toString().split(' ')[1]}');

		// No preloading code yet

		proceed();

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
		FlxG.switchState(() -> new levels.whoopiecushion.WhoopieCushion());
		return;
		#end

		FlxG.switchState(() -> new menus.LevelSelect());
	}
}
