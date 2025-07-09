package levels.pietotheface;

import flixel.graphics.frames.FlxAtlasFrames;

class Dude extends FlxSprite
{
	override public function new()
	{
		super(0, 0);

		frames = FlxAtlasFrames.fromSparrow('assets/images/pie/dude.png', 'assets/images/pie/dude.xml');
		animation.addByPrefix('idle', 'Dude walking', 24, true);
		animation.addByPrefix('scared', 'Dude scared', 24, false);
		animation.addByPrefix('pied', 'Dude pied', 24, false);
		animation.play('idle');
	}
}
