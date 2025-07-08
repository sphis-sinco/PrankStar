package levels.whoopeecushion;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import menus.LevelSelect;

class WhoopeeCushion extends FlxState
{
	var player:FlxSprite;
	var whoopie:FlxSprite;
	var whoopie_placed:Bool;

	var foot:FlxSprite;

	var cutsceneHappened:Bool = false;

	override function create()
	{
		whoopie = new FlxSprite().makeGraphic(96, 64, FlxColor.PINK);
		add(whoopie);

		foot = new FlxSprite().makeGraphic(128, 512, FlxColor.BROWN);
		add(foot);
		foot.visible = false;

		player = new FlxSprite().makeGraphic(80, 64);
		add(player);

		super.create();
	}

	override function update(elapsed:Float)
	{
		player.setPosition(FlxG.mouse.x - (player.width / 2), FlxG.mouse.y - (player.height / 2));
		if (!whoopie_placed)
			whoopie.setPosition(player.x - (whoopie.width / 4), player.y + (whoopie.height / 4));

		if (FlxG.mouse.justReleased && !whoopie_placed)
			whoopie_placed = true;

		if (whoopie_placed && !cutsceneHappened)
		{
			cutsceneHappened = true;
			foot.x = FlxG.random.float(0, FlxG.width - foot.width);
			// foot.x = FlxG.mouse.x;
			foot.y = -foot.height;
			foot.visible = true;

			FlxTween.tween(foot, {y: 0}, 0.25, {
				onComplete: tween ->
				{
					if (whoopie.overlaps(foot))
					{
						// play an sfx
						PSAssets.playSound('assets/sounds/whoopie.wav');
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
