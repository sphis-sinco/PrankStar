package levels.waterballoon;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;

class WaterBalloon extends FlxState
{
	var player:FlxSprite;

	override function create()
	{
		player = new FlxSprite().makeGraphic(64, 32, FlxColor.RED);
		add(player);
		player.screenCenter();

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
