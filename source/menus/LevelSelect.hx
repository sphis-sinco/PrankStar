package menus;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

using StringTools;

class LevelSelect extends FlxState
{
	var levels:Array<String> = ['water-balloon', 'whoopee-cushion', 'pie-to-the-face'];
	var level_difficulties:Array<Int> = [1, 2, 3];

	var levelTextGrp:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

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
			var levelText:FlxText = new FlxText(10, 10 + (i * 40), 0, levels[i].toUpperCase().replace('-', ' '), 32);
			levelText.ID = i;
			trace('Adding new text for ${levelText.text}');

			levelTextGrp.add(levelText);
		}
	}
}
