package levels.whoopeecushion;

import flixel.tweens.FlxTween;

class WhoopeeCushion extends FlxState
{
	var player:FlxSprite;
	var whoopie:Whoopee;
	var whoopie_placed:Bool;

	var foot:FlxSprite;
	var footNewX:Float = 0.0;

	var cutsceneHappened:Bool = false;

	override function create()
	{
		whoopie = new Whoopee();
		add(whoopie);

		foot = new FlxSprite().makeGraphic(128, 512, FlxColor.BROWN);
		add(foot);
		foot.visible = true;
		foot.setPosition(footNewX, 32);
		foot.screenCenter(X);
		footNewX = FlxG.random.float(0, FlxG.width - foot.width);

		final footNewXTweenDivider = 5;
		FlxTween.tween(foot, {
			y: -foot.height - 32,
			x: (footNewX > foot.x) ? foot.x + (footNewX / footNewXTweenDivider) : foot.x - (footNewX / footNewXTweenDivider)
		}, 1, {
			onStart: tween ->
			{
				foot.flipX = footNewX < foot.x;
			},
			onComplete: tween ->
			{
				foot.visible = false;
			}
		});

		player = new FlxSprite().makeGraphic(80, 64);
		add(player);

		super.create();
	}

	override function update(elapsed:Float)
	{
		player.setPosition(FlxG.mouse.x - (player.width / 2), FlxG.mouse.y - (player.height / 2));
		if (!whoopie_placed)
			whoopie.setPosition(player.x - (whoopie.width / 4), foot.height - 64);

		if (FlxG.mouse.justReleased && !whoopie_placed)
			whoopie_placed = true;

		if (whoopie_placed && !cutsceneHappened)
		{
			cutsceneHappened = true;
			foot.x = footNewX;
			// foot.x = FlxG.mouse.x;
			foot.y = -foot.height - 32;
			foot.visible = true;

			FlxTween.tween(foot, {y: -32}, 0.25, {
				onComplete: tween ->
				{
					if (whoopie.overlaps(foot))
					{
						// play an sfx
						PSAssets.playSound('sounds/gameplay/whoopie');
						whoopie.animation.play('land');
						trace('Whoopie success');
					}
					else
					{
						trace('Whoopie failure');
					}

					FlxTimer.wait(1, () ->
					{
						FlxG.switchState(() -> new LevelSelect());
					});
				}
			});
		}
		super.update(elapsed);
	}
}
