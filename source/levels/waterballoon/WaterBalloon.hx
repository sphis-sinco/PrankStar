package levels.waterballoon;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import menus.LevelSelect;

class WaterBalloon extends FlxState
{
	var player:FlxSprite;
	var thrown:Bool = false;

	var door1:FlxSprite;
	var door2:FlxSprite;
	var door3:FlxSprite;

	var door_dimensions:Array<Int> = [64, 128];

	var the_door:Int;
	var selectedDoor:Int;

	var endingCutscenePlayed:Bool = false;

	override function create()
	{
		door1 = new FlxSprite().makeGraphic(door_dimensions[0], door_dimensions[1], FlxColor.BROWN);
		door2 = new FlxSprite().makeGraphic(door_dimensions[0], door_dimensions[1], FlxColor.BROWN);
		door3 = new FlxSprite().makeGraphic(door_dimensions[0], door_dimensions[1], FlxColor.BROWN);

		add(door1);
		add(door2);
		add(door3);

		door1.x = door1.width;
		door2.screenCenter(X);
		door3.x = FlxG.width - (door3.width * 2);

		door1.y = FlxG.height - door1.height;
		door2.y = FlxG.height - door2.height;
		door3.y = FlxG.height - door3.height;

		the_door = FlxG.random.int(1, 3);

		player = new FlxSprite().makeGraphic(32, 32, FlxColor.CYAN);
		add(player);
		player.screenCenter();

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (!thrown)
		{
			player.setPosition(FlxG.mouse.x - (player.width / 2), FlxG.mouse.y - (player.height / 2));

			selectedDoor = 0;
			if (FlxG.mouse.overlaps(door1))
				selectedDoor = 1;
			if (FlxG.mouse.overlaps(door2))
				selectedDoor = 2;
			if (FlxG.mouse.overlaps(door3))
				selectedDoor = 3;

			if (FlxG.mouse.justReleased)
			{
				if (selectedDoor == the_door)
				{
					trace('Water balloon victory');
				}
				else
				{
					trace('Water balloon defeat');
				}

				thrown = true;
			}
		}

		if (thrown)
		{
			if (!endingCutscenePlayed)
			{
				// Each door plays an open animation
				door1.color = FlxColor.BLACK;
				door2.color = FlxColor.BLACK;
				door3.color = FlxColor.BLACK;

				FlxTimer.wait(1, () ->
				{
					// The right door will show a person and they get splashed

					if (the_door == 1)
						door1.color = FlxColor.LIME;
					if (the_door == 2)
						door2.color = FlxColor.LIME;
					if (the_door == 3)
						door3.color = FlxColor.LIME;

					FlxTimer.wait(1, () ->
					{
						FlxG.switchState(() -> new LevelSelect());
					});
				});

				endingCutscenePlayed = true;
			}
		}

		super.update(elapsed);
	}
}
