package levels.pietotheface;

class PieToTheFace extends FlxState
{
	var player:FlxSprite;
	var pie:Pie;
	var thrown:Bool = false;

	var target:FlxSprite;

	var endingCutscenePlayed:Bool = false;

	override function create()
	{
		target = new FlxSprite().makeGraphic(64, 80, FlxColor.YELLOW);
		target.ID = 0;
		add(target);
		target.y = FlxG.height - target.height;

		pie = new Pie();
		pie.scale.set(0.5, 0.5);
		add(pie);

		player = new FlxSprite().makeGraphic(64, 64);
		add(player);
		player.screenCenter();
		player.visible = false;

		super.create();
	}

	override function update(elapsed:Float)
	{
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

			pie.setPosition(FlxG.mouse.x - (pie.width / 2), FlxG.mouse.y - (pie.height / 2));

			if (FlxG.mouse.justReleased)
			{
				thrown = true;
			}
		}

		if (thrown)
		{
			if (!endingCutscenePlayed)
			{
				PSAssets.playSound('sounds/gameplay/pie');

				if (pie.overlaps(target))
				{
					trace('Pie victory');
				}
				else
				{
					trace('Pie defeat');
				}

				pie.animation.play('splat');

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
