package levels.waterballoon;

import flixel.graphics.frames.FlxAtlasFrames;

class Door extends FlxSprite
{
	override public function new()
	{
		super(0, 0);

		frames = FlxAtlasFrames.fromSparrow('assets/images/waterballoon/door.png', 'assets/images/waterballoon/door.xml');
		animation.addByPrefix('idle', 'Door0', 24, false);
		animation.addByPrefix('open', 'Door open0', 24, false);
		animation.addByPrefix('person', 'Door open person0', 24, false);
		animation.addByPrefix('person splashed', 'Door open person splashed0', 24, false);
		animation.addByPrefix('splashed', 'Door open splashed0', 24, false);
		animation.play('idle');

		y = FlxG.height - height;
	}
}
