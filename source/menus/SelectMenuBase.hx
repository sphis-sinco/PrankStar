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
	var entries_disabled:Array<Bool> = [];
	var entries_states:Array<NextState> = [];

	var entriesTextGrp:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

	var selection:Int = 0;
	var selecting:Bool = false;

	function addEntry(name:String, disabled:Bool, state:NextState)
	{
		#if NO_SHOW_DISABLED_ENTRIES
		if (disabled)
			return;
		#end

		entries.push(name);
		entries_disabled.push(disabled);
		entries_states.push(state);
	}

	override function create()
	{
		PSAssets.cacheSound('sounds/ui/accepted');
		PSAssets.cacheSound('sounds/ui/denied');
		PSAssets.cacheSound('sounds/ui/scroll');

		add(entriesTextGrp);

		reloadEntryText();

		super.create();
	}

	public var changeStateCondition(get, never):Bool;

	function get_changeStateCondition():Bool
	{
		return (entries_states[selection] != null && !entries_disabled[selection]);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justReleased.R)
		{
			trace('SelectMenuBase reload entry text hotkey');
			reloadEntryText();
		}

		if (FlxG.keys.justReleased.UP && !selecting)
		{
			changeSelection(-1);
		}
		else if (FlxG.keys.justReleased.DOWN && !selecting)
		{
			changeSelection(1);
		}

		if (FlxG.keys.justReleased.ENTER && !selecting)
		{
			selecting = true;
			var entryText:FlxText = entriesTextGrp.members[selection];

			var customFunc = pressedEnter();
			if (customFunc == ScriptReturns.EVENT_STOP)
			{
				selecting = false;
				return;
			}

			entryText.color = changeStateCondition ? FlxColor.GREEN : FlxColor.RED;

			if (!changeStateCondition)
			{
				PSAssets.playSound('sounds/ui/denied');
				selecting = false;
			}
			else
			{
				PSAssets.playSound('sounds/ui/accepted');
				preStateSwitchEvent(entries[selection]);
			}

			FlxFlicker.flicker(entryText, 1, 0.05, true, true, flicker ->
			{
				changeSelection();
				if (changeStateCondition)
				{
					FlxG.switchState(entries_states[selection]);
				}
				selecting = false;
			});
		}

		super.update(elapsed);
	}

	function pressedEnter():Null<ScriptReturns>
	{
		return null;
	}

	function preStateSwitchEvent(entry:String) {}

	function reloadEntryText()
	{
		if (entriesTextGrp.length > 0)
		{
			for (entryText in entriesTextGrp)
			{
				#if NEW_ENTRY_TEXT_LOG
				trace('Trying to remove the previous text for ${entryText.text}');
				#end
				entriesTextGrp.remove(entryText);
				entryText.destroy();
			}
		}

		for (i in 0...entries.length)
		{
			var entryText:FlxText = new FlxText(10, ((Main.performanceText.visible) ? 20 : 10) + (i * 40), 0, entryTextString(entries[i]), 32);
			entryText.ID = i;
			#if NEW_ENTRY_TEXT_LOG
			trace(entryLog(entries[i]));
			#end

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
			PSAssets.playSound('sounds/ui/scroll');
		}
		else if (selection == prevsel && increment != 0)
		{
			PSAssets.playSound('sounds/ui/denied');
		}

		for (entryText in entriesTextGrp)
		{
			if (FlxFlicker.isFlickering(entryText))
			{
				FlxFlicker.stopFlickering(entryText);
			}

			entryText.color = selection == entryText.ID ? FlxColor.YELLOW : FlxColor.WHITE;
			entryText.alpha = entries_disabled[entryText.ID] ? 0.5 : 1.0;
		}
	}
}

enum ScriptReturns
{
	EVENT_STOP;
	EVENT_CONTINUE;
}
