package menus;

import levels.waterballoon.WaterBalloon;
import levels.whoopeecushion.WhoopeeCushion;

class LevelSelect extends SelectMenuBase
{
	var level_difficulties:Array<Null<Int>> = [1, 4, 3];

	override function create()
	{
		entries = ['water-balloon', 'whoopee-cushion', 'pie-to-the-face'];
		entries_enabled = [false, false, true];
		entries_states = [() -> new WaterBalloon(), () -> new WhoopeeCushion(), null];

		super.create();
	}

	override function reloadEntryText()
	{
		super.reloadEntryText();

		for (i in 0...entries.length)
		{
			var leveltextstring:String = entryTextString(entries[i]);
			if (level_difficulties[i] != null)
			{
				leveltextstring += ' (Difficulty: ${level_difficulties[i]})';
			}

			entriesTextGrp.members[i].text = leveltextstring;
			trace('new SongText(song: ${entries[i]}, difficulty: ${level_difficulties[i]})');
		}

		changeSelection();
	}

	override function preStateSwitchEvent(entry:String)
	{
		super.preStateSwitchEvent(entry);

		switch (entry)
		{
			case 'water-balloon':
				PSAssets.cacheSound('assets/sounds/door.wav');
				PSAssets.cacheSound('assets/sounds/waterballoon.wav');
			case 'whoopee-cushion':
				PSAssets.cacheSound('assets/sounds/whoopie.wav');
		}
	}
}
