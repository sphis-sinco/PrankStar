package levels.whoopiecushion;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;

class WhoopieCushion extends FlxState
{
	var player:FlxSprite;
	var whoopie:FlxSprite;
	var whoopie_placed:Bool;

	override function create()
	{
		whoopie = new FlxSprite().makeGraphic(96, 64, FlxColor.PINK);
		add(whoopie);

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

		super.update(elapsed);
	}
}
