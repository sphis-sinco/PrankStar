package menus;

import flixel.FlxG;
import flixel.FlxState;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.typeLimit.NextState;

using StringTools;

class SelectMenuBase extends FlxState
{
	var entries:Array<String> = [];
	var entries_enabled:Array<Bool> = [];
	var entries_states:Array<NextState> = [];

	var entriesTextGrp:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

	var selection:Int = 0;

	override function create()
	{
		add(entriesTextGrp);

		reloadEntryText();

		super.create();
	}

	public var selectedColorCondition(get, never):Bool;

	function get_selectedColorCondition():Bool
	{
		return (entries_states[selection] != null && !entries_enabled[selection]);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justReleased.R)
		{
			trace('SelectMenuBase reload entry text hotkey');
			reloadEntryText();
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
			var entryText:FlxText = entriesTextGrp.members[selection];
			entryText.color = selectedColorCondition ? FlxColor.GREEN : FlxColor.RED;

			if (entryText.color == FlxColor.RED)
				FlxG.sound.play('assets/sounds/ui/denied.wav');
			else
				FlxG.sound.play('assets/sounds/ui/accepted.wav');

			FlxFlicker.flicker(entryText, 1, 0.05, true, true, flicker ->
			{
				changeSelection();
				FlxG.switchState(entries_states[selection]);
			});
		}

		super.update(elapsed);
	}

	function reloadEntryText()
	{
		if (entriesTextGrp.length > 0)
		{
			for (entryText in entriesTextGrp)
			{
				trace('Trying to remove the previous text for ${entryText.text}');
				entriesTextGrp.remove(entryText);
				entryText.destroy();
			}
		}

		for (i in 0...entries.length)
		{
			var entryText:FlxText = new FlxText(10, 10 + (i * 40), 0, entryTextString(entries[i]), 32);
			entryText.ID = i;
			trace(entryLog(entries[i]));

			entriesTextGrp.add(entryText);
		}

		changeSelection();
	}

	function entryTextString(entry:String):String
	{
		return entry.toUpperCase().replace('-', ' ');
	}

	function entryLog(entry:String):String
	{
		return 'new EntryText(entry: ${entry})';
	}

	function changeSelection(increment:Int = 0)
	{
		var prevsel = selection;
		selection += increment;

		if (selection < 0)
			selection = 0;

		if (selection > entries.length - 1)
			selection = entries.length - 1;

		if (selection != prevsel && increment != 0)
		{
			FlxG.sound.play('assets/sounds/ui/scroll.wav');
		}
		else if (selection == prevsel && increment != 0)
		{
			FlxG.sound.play('assets/sounds/ui/denied.wav');
		}

		for (entryText in entriesTextGrp)
		{
			if (FlxFlicker.isFlickering(entryText))
			{
				FlxFlicker.stopFlickering(entryText);
			}

			entryText.color = selection == entryText.ID ? FlxColor.YELLOW : FlxColor.WHITE;
			entryText.alpha = entries_enabled[entryText.ID] ? 0.5 : 1.0;
		}
	}
}
