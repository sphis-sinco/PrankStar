package levels.pietotheface;

class PieToTheFace extends FlxState
{
	var player:FlxSprite;
	var pie:FlxSprite;
	var thrown:Bool = false;

	var target:FlxSprite;

	var endingCutscenePlayed:Bool = false;

	override function create()
	{
		target = new FlxSprite().makeGraphic(64, 80, FlxColor.YELLOW);
		target.ID = 0;
		add(target);
		target.y = FlxG.height - target.height;

		pie = new FlxSprite().makeGraphic(80, 80, FlxColor.BROWN);
		add(pie);

		player = new FlxSprite().makeGraphic(64, 64);
		add(player);
		player.screenCenter();

		super.create();
	}

	override function update(elapsed:Float)
	{
		player.setPosition(FlxG.mouse.x - (player.width / 2), FlxG.mouse.y - (player.height / 2));

		if (!thrown)
		{
			if (target.ID == 0)
				target.x += 32;
			if (target.ID == 1)
				target.x -= 32;

			if (target.ID == 0 && target.x == FlxG.width - (target.width * 2))
				target.ID = 1;
			if (target.ID == 1 && target.x == target.width * 2)
				target.ID = 0;

			pie.setPosition(player.x - (pie.width / 4), player.y + (pie.height / 4));

			if (FlxG.mouse.justReleased)
			{
				thrown = true;
			}
		}

		if (thrown)
		{
			if (!endingCutscenePlayed)
			{
				PSAssets.playSound('assets/sounds/gameplay/pie.wav');

				if (pie.overlaps(target))
				{
					trace('Pie victory');
				}
				else
				{
					trace('Pie defeat');
				}

				FlxTimer.wait(1, () ->
				{
					FlxG.switchState(() -> new LevelSelect());
				});

				endingCutscenePlayed = true;
			}
		}

		super.update(elapsed);
	}
}
