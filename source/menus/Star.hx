package menus;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class Star extends FlxSprite
{
	public var animationOffsets:Map<String, Array<Float>> = ['empty' => [0, 0], 'full' => [0, 0], 'full-anim' => [-38, -52]];
	public var position:Array<Float> = [0, 0];

	override public function new(pos:Array<Float>)
	{
		super(0, 0);

		position = pos;

		frames = FlxAtlasFrames.fromSparrow('assets/images/menus/levelselect/stars.png', 'assets/images/menus/levelselect/stars.xml');
		animation.addByPrefix('empty', 'Star empty', 24, false);
		animation.addByPrefix('full', 'Star full', 24, false);
		animation.addByPrefix('full-anim', 'Star Animation emptyToFull', 24, false);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (animation.finished && animation.name == 'full-anim')
			play('full');
	}

	public function play(anim:String)
	{
		setPosition(position[0], position[1]);
		animation.play(anim);

		x += animationOffsets.get(anim)[0];
		y += animationOffsets.get(anim)[1];
	}
}
