package menus;

import levels.pietotheface.PieToTheFace;
import levels.waterballoon.WaterBalloon;
import levels.whoopeecushion.WhoopeeCushion;

class LevelSelect extends SelectMenuBase
{
	var level_difficulties:Array<Null<Int>> = [1, 4, 3];

	override function create()
	{
		entries = ['water-balloon', 'whoopee-cushion', 'pie-to-the-face'];
		entries_enabled = [false, false, false];
		entries_states = [() -> new WaterBalloon(), () -> new WhoopeeCushion(), () -> new PieToTheFace()];

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
				PSAssets.cacheSound('sounds/gameplay/door');
				PSAssets.cacheSound('sounds/gameplay/door-knock');
				PSAssets.cacheSound('sounds/gameplay/waterballoon');
				PSAssets.cacheTexture('images/waterballoon/door', PSAssets.bullshitFunctions);
				PSAssets.cacheTexture('images/waterballoon/waterballoon', PSAssets.bullshitFunctions);
			case 'whoopee-cushion':
				PSAssets.cacheSound('sounds/gameplay/whoopie');
			case 'pie-to-the-face':
				PSAssets.cacheSound('sounds/gameplay/pie');
		}
	}
}
