package levels.pietotheface;

class PieToTheFace extends FlxState
{
	var player:FlxSprite;
	var pie:FlxSprite;
	var thrown:Bool = false;

	var endingCutscenePlayed:Bool = false;

	override function create()
	{
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
				FlxTimer.wait(1, () ->
				{
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
