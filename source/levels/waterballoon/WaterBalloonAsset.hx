package levels.waterballoon;

import flixel.graphics.frames.FlxAtlasFrames;

class WaterBalloonAsset extends FlxSprite
{
	override public function new()
	{
		super(0, 0);

		frames = FlxAtlasFrames.fromSparrow('assets/images/waterballoon/waterballoon.png', 'assets/images/waterballoon/waterballoon.xml');
		animation.addByPrefix('idle', 'Water ballooon0', 24, false);
		animation.addByPrefix('toss', 'Water ballooon toss0', 24, false);
		animation.play('idle');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (animation.finished && animation.name == 'toss')
			visible = false;
	}
}
