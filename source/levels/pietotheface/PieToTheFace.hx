package levels.pietotheface;

class PieToTheFace extends FlxState
{
	var player:FlxSprite;
	var pie:Pie;
	var thrown:Bool = false;

	var target:Dude;

	var endingCutscenePlayed:Bool = false;

	override function create()
	{
		target = new Dude();
		target.ID = 1;
		add(target);
		target.scale.set(0.5, 0.5);
		target.y = (FlxG.height - target.height) + 128;

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

			// Target Width Divided
			var twd = (target.width * 0.5);
			if (target.ID == 0 && target.x >= FlxG.width - twd)
			{
				target.ID = 1;
				target.flipX = false;
			}
			if (target.ID == 1 && target.x <= -twd)
			{
				target.ID = 0;
				target.flipX = true;
			}

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
					target.animation.play('pied');
				}
				else
				{
					trace('Pie defeat');
					target.animation.play('scared');
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
