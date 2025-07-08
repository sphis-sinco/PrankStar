package menus;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import levels.pietotheface.PieToTheFace;
import levels.waterballoon.WaterBalloon;
import levels.whoopeecushion.WhoopeeCushion;

using StringTools;

class LevelSelect extends SelectMenuBase
{
	var level_difficulties:Array<Null<Int>> = [1, 4, 3];

	var starGrp:FlxTypedGroup<Star> = new FlxTypedGroup<Star>();
	var stars:Int = 5;

	override function create()
	{
		PSAssets.cacheTexture('images/menus/levelselect/stars', PSAssets.bullshitFunctions);

		entries = ['water-balloon', 'whoopee-cushion', 'pie-to-the-face'];
		entries_enabled = [false, false, false];
		entries_states = [() -> new WaterBalloon(), () -> new WhoopeeCushion(), () -> new PieToTheFace()];

		add(starGrp);

		super.create();
	}

	override function changeSelection(increment:Int = 0)
	{
		super.changeSelection(increment);

		reloadStars();
	}

	function reloadStars(changedSelection:Bool = false)
	{
		var filledStars:Array<Bool> = [];

		if (starGrp.length > 0)
		{
			for (star in starGrp)
			{
				try
				{
					filledStars.push(star.animation.name.contains('full'));
				}
				catch (e)
				{
					filledStars.push(false);
				}
				starGrp.remove(star);
				star.destroy();
			}
		}

		for (i in 0...5)
		{
			var star:Star = new Star([0, 0]);
			star.position = [10 + (i * 80), FlxG.height - 100];
			star.ID = i;
			if (!filledStars[star.ID])
				star.play('empty');
			else
				star.play('empty-anim');

			if (level_difficulties[selection] > star.ID)
			{
				if (filledStars[star.ID])
					star.play('full');
				else
				{
					star.play('full-anim');
				}
			}

			starGrp.add(star);
		}
	}

	override function preStateSwitchEvent(entry:String)
	{
		super.preStateSwitchEvent(entry);

		switch (entry)
		{
			case 'water-balloon':
				PSAssets.cacheSound('sounds/gameplay/door');
				PSAssets.cacheSound('sounds/gameplay/door-knock');
				PSAssets.cacheSound('sounds/gameplay/waterballoon');
				PSAssets.cacheTexture('images/waterballoon/door', PSAssets.bullshitFunctions);
				PSAssets.cacheTexture('images/waterballoon/waterballoon', PSAssets.bullshitFunctions);
			case 'whoopee-cushion':
				PSAssets.cacheSound('sounds/gameplay/whoopie');
				PSAssets.cacheTexture('images/whoopee/leg', PSAssets.bullshitFunctions);
				PSAssets.cacheTexture('images/whoopee/whoopee', PSAssets.bullshitFunctions);
			case 'pie-to-the-face':
				PSAssets.cacheSound('sounds/gameplay/pie');
		}
	}
}
