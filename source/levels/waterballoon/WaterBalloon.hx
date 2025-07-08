package levels.waterballoon;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class WaterBalloon extends FlxState
{
	var player:FlxSprite;
	var thrown:Bool = false;

	override function create()
	{
		player = new FlxSprite().makeGraphic(64, 64, FlxColor.CYAN);
		add(player);
		player.screenCenter();

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (!thrown)
		{
			player.setPosition(FlxG.mouse.x - (player.width / 2), FlxG.mouse.y - (player.height / 2));

			if (FlxG.mouse.justReleased)
				thrown = true;
		}

		super.update(elapsed);
	}
}
