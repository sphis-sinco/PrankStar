package menus;

import flixel.FlxG;
import flixel.util.typeLimit.NextState;
import menus.SelectMenuBase.ScriptReturns;

class SettingsMenu extends SelectMenuBase
{
	var entry_values:Array<Dynamic> = [];

	public static var savedSelection:Int = 0;

	override public function new()
	{
		super();

		selection = savedSelection;

		addOptionEntry('back', null, false, () -> new MainMenu());
		addOptionEntry('clear-save', null, false, null);
		addOptionEntry('asset-caching', Preferences.assetCaching, false, null);
		addOptionEntry('performance-text', Preferences.performanceText, false, null);
	}

	function addOptionEntry(name:String, value:Dynamic, disabled:Bool, state:NextState)
	{
		addEntry(name, disabled, state);

		#if NO_SHOW_DISABLED_ENTRIES
		if (disabled)
			return;
		#end

		entry_values.push(value);
	}

	override function pressedEnter():Null<ScriptReturns>
	{
		if (entries_states[selection] == null)
		{
			preStateSwitchEvent(entries[selection]);
			return EVENT_STOP;
		}
		else
		{
			return super.pressedEnter();
		}
	}

	override function reloadEntryText()
	{
		super.reloadEntryText();

		for (i in 0...entries.length)
		{
			var optiontextstring:String = entryTextString(entries[i]);
			if (entry_values[i] != null)
				optiontextstring += ' : ${entry_values[i]}';

			entriesTextGrp.members[i].text = optiontextstring;
		}

		changeSelection();
	}

	override function preStateSwitchEvent(entry:String)
	{
		super.preStateSwitchEvent(entry);
		savedSelection = selection;

		switch (entry)
		{
			case 'back':
				FlxG.save.data.preferences.assetCaching = Preferences.assetCaching;
				FlxG.save.data.preferences.performanceText = Preferences.performanceText;
				FlxG.save.flush();

			case 'clear-save':
				FlxG.save.data.preferences = null;

				Preferences.assetCaching = null;
				Preferences.performanceText = null;

				savedSelection = 0;

				FlxG.resetGame();

			case 'asset-caching':
				Preferences.assetCaching = !Preferences.assetCaching;
				FlxG.resetState();
			case 'performance-text':
				Preferences.performanceText = !Preferences.performanceText;
				Main.performanceText.visible = Preferences.performanceText;
				FlxG.resetState();
		}
	}
}
