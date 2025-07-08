package levels.whoopiecushion;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;

class WhoopieCushion extends FlxState
{
	var player:FlxSprite;
	var whoopie:FlxSprite;
	var placed:Bool;

	override function create()
	{
		whoopie = new FlxSprite().makeGraphic(64, 64, FlxColor.PINK);
		add(whoopie);

		player = new FlxSprite().makeGraphic(80, 64);
		add(player);

		super.create();
	}

	override function update(elapsed:Float)
	{
		player.setPosition(FlxG.mouse.x - (player.width / 2), FlxG.mouse.y - (player.height / 2));
		if (!placed)
			whoopie.setPosition(player.x, player.y + (whoopie.height / 2));

		if (FlxG.mouse.justReleased && !placed)
			placed = true;

		super.update(elapsed);
	}
}
