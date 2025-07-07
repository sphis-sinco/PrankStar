package;

import flixel.FlxG;
import flixel.FlxState;

class InitState extends FlxState
{
	override public function create()
	{
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function proceed()
	{
		FlxG.switchState(() -> new menus.LevelSelect());
	}
}
