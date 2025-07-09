package menus;

import flixel.FlxG;
import flixel.text.FlxText;
import openfl.Lib;

class MainMenu extends SelectMenuBase
{
	override public function new()
	{
		super();

		addEntry('levels', false, () -> new LevelSelect());
		addEntry('credits', true, null);
		addEntry('settings', false, () -> new SettingsMenu());

		var releaseText:FlxText = new FlxText(2, FlxG.height - 20, 0, Lib.application.meta.get('version'), 16);
		add(releaseText);
	}
}
