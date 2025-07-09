package levels.pietotheface;

import flixel.graphics.frames.FlxAtlasFrames;

class Pie extends FlxSprite
{
	override public function new()
	{
		super(0, 0);

		frames = FlxAtlasFrames.fromSparrow('assets/images/pie/pie.png', 'assets/images/pie/pie.xml');
		animation.addByPrefix('idle', 'Pie0', 24, false);
		animation.addByPrefix('splat', 'Pie splat fail', 24, false);
		animation.play('idle');
	}
}
