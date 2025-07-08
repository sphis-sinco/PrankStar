package levels.whoopeecushion;

import flixel.graphics.frames.FlxAtlasFrames;

class Leg extends FlxSprite
{
	override public function new()
	{
		super(0, 0);

		frames = FlxAtlasFrames.fromSparrow('assets/images/whoopee/leg.png', 'assets/images/whoopee/leg.xml');
		animation.addByPrefix('idle', 'Leg0', 24, false);
		animation.addByPrefix('lift', 'Leg lift', 12, false);
		animation.addByPrefix('stomp', 'Leg stomp', 24, false);
		animation.play('idle');
	}
}
