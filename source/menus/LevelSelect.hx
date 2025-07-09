package menus;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.util.typeLimit.NextState;
import levels.pietotheface.PieToTheFace;
import levels.waterballoon.WaterBalloon;
import levels.whoopeecushion.WhoopeeCushion;

using StringTools;

class LevelSelect extends SelectMenuBase
{
	var level_difficulties:Array<Null<Int>> = [];

	var starGrp:FlxTypedGroup<Star> = new FlxTypedGroup<Star>();
	var stars:Int = 5;

	function addLevelEntry(name:String, difficulty:Null<Int>, disabled:Bool, state:NextState)
	{
		addEntry(name, disabled, state);

		#if NO_SHOW_DISABLED_ENTRIES
		if (disabled)
			return;
		#end

		level_difficulties.push(difficulty);
	}

	override function create()
	{
		PSAssets.cacheTexture('images/menus/levelselect/stars', PSAssets.bullshitFunctions);

		#if !html5
		addLevelEntry('back', null, false, () -> new MainMenu());
		#end
		addLevelEntry('water-balloon', 1, false, () -> new WaterBalloon());
		addLevelEntry('whoopee-cushion', 2, false, () -> new WhoopeeCushion());
		addLevelEntry('pie-to-the-face', 3, false, () -> new PieToTheFace());
		addLevelEntry('ding-dong-ditch', null, true, null);
		addLevelEntry('water-bucket-over-the-door', null, true, null);

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

		if (level_difficulties[selection] == null)
			return;

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

		if (!Preferences.assetCaching)
			return; // Don't waste our time

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
