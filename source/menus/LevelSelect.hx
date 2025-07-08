package menus;

import flixel.FlxG;
import flixel.FlxState;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.misc.ShakeTween;
import flixel.util.FlxColor;
import flixel.util.typeLimit.NextState;
import levels.waterballoon.WaterBalloon;
import levels.whoopeecushion.WhoopeeCushion;

using StringTools;

class LevelSelect extends FlxState
{
	var levels:Array<String> = ['water-balloon', 'whoopee-cushion', 'pie-to-the-face'];
	var level_difficulties:Array<Null<Int>> = [1, 2, 3];
	var level_locks:Array<Bool> = [false, false, true];
	var level_states:Array<NextState> = [() -> new WaterBalloon(), () -> new WhoopeeCushion(), null];

	var levelTextGrp:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

	var selection:Int = 0;

	override function create()
	{
		add(levelTextGrp);

		reloadLevelText();

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justReleased.R)
		{
			trace('Levelselect reload level text hotkey');
			reloadLevelText();
		}

		if (FlxG.keys.justReleased.UP)
		{
			changeSelection(-1);
		}
		else if (FlxG.keys.justReleased.DOWN)
		{
			changeSelection(1);
		}

		if (FlxG.keys.justReleased.ENTER)
		{
			var levelText:FlxText = levelTextGrp.members[selection];
			levelText.color = (level_states[selection] != null && !level_locks[selection]) ? FlxColor.GREEN : FlxColor.RED;
			FlxFlicker.flicker(levelText, 1, 0.05, true, true, flicker ->
			{
				changeSelection();
				if (level_states[selection] != null)
					FlxG.switchState(level_states[selection]);
			});
		}

		super.update(elapsed);
	}

	function reloadLevelText()
	{
		if (levelTextGrp.length > 0)
		{
			for (levelText in levelTextGrp)
			{
				trace('Trying to remove the previous text for ${levelText.text}');
				levelTextGrp.remove(levelText);
				levelText.destroy();
			}
		}

		for (i in 0...levels.length)
		{
			var leveltextstring:String = levels[i].toUpperCase().replace('-', ' ');
			if (level_difficulties[i] != null)
			{
				leveltextstring += ' (Difficulty: ${level_difficulties[i]})';
			}

			var levelText:FlxText = new FlxText(10, 10 + (i * 40), 0, leveltextstring, 32);
			levelText.ID = i;
			trace('new SongText(song: ${levels[i]}, difficulty: ${level_difficulties[i]})');

			levelTextGrp.add(levelText);
		}

		changeSelection();
	}

	function changeSelection(increment:Int = 0)
	{
		selection += increment;

		if (selection < 0)
			selection = 0;

		if (selection > levels.length - 1)
			selection = levels.length - 1;

		for (levelText in levelTextGrp)
		{
			if (FlxFlicker.isFlickering(levelText))
			{
				FlxFlicker.stopFlickering(levelText);
			}

			levelText.color = selection == levelText.ID ? FlxColor.YELLOW : FlxColor.WHITE;
			levelText.alpha = level_locks[levelText.ID] ? 0.5 : 1.0;
		}
	}
}
