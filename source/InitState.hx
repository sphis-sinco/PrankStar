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
		FlxG.assets.loadSound('assets/sounds/ui/accepted.wav', true);
		FlxG.assets.loadSound('assets/sounds/ui/denied.wav', true);
		FlxG.assets.loadSound('assets/sounds/ui/scroll.wav', true);

		FlxG.assets.loadSound('assets/sounds/door.wav', true);
		FlxG.assets.loadSound('assets/sounds/waterballoon.wav', true);
		FlxG.assets.loadSound('assets/sounds/whoopie.wav', true);

		proceed();
	}
}
