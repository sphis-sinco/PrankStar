package levels.whoopeecushion;

import flixel.graphics.frames.FlxAtlasFrames;

class Whoopee extends FlxSprite
{
	override public function new()
	{
		super(0, 0);

		frames = FlxAtlasFrames.fromSparrow('assets/images/whoopee/whoopee.png', 'assets/images/whoopee/whoopee.xml');
		animation.addByPrefix('idle', 'Whoopee0', 24, false);
		animation.addByPrefix('land', 'Whoopee land0', 24, false);
		animation.play('idle');
	}
}
