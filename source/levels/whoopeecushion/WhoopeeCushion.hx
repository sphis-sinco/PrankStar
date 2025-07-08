package levels.whoopeecushion;

import flixel.tweens.FlxTween;

class WhoopeeCushion extends FlxState
{
	var player:FlxSprite;
	var whoopie:Whoopee;
	var whoopie_placed:Bool;

	var foot:Leg;
	var footNewX:Float = 0.0;

	var introCutsceneHappened:Bool = false;
	var endCutsceneHappened:Bool = false;

	override function create()
	{
		whoopie = new Whoopee();
		add(whoopie);

		foot = new Leg();
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
				foot.flipX = footNewX > foot.x;
				foot.animation.play('lift');
			},
			onComplete: tween ->
			{
				foot.visible = false;
				introCutsceneHappened = true;
			}
		});

		player = new FlxSprite().makeGraphic(80, 64);
		add(player);
		player.visible = false;

		super.create();
	}

	override function update(elapsed:Float)
	{
		player.setPosition(FlxG.mouse.x - (player.width / 2), FlxG.mouse.y - (player.height / 2));
		if (!whoopie_placed)
			whoopie.setPosition(player.x - (whoopie.width / 4), FlxG.height - (whoopie.height * 2));

		if (FlxG.mouse.justReleased && !whoopie_placed && introCutsceneHappened)
			whoopie_placed = true;

		if (whoopie_placed && !endCutsceneHappened)
		{
			endCutsceneHappened = true;
			foot.x = footNewX;
			// foot.x = FlxG.mouse.x;
			foot.y = -foot.height - 32;

			FlxTween.tween(foot, {y: -35}, 0.25, {
				onStart: tween ->
				{
					foot.visible = true;
					foot.animation.play('stomp');
				},
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
