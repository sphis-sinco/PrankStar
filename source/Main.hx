package;

import com.akifox.plik.debug.Performance;
import flixel.FlxGame;
import openfl.display.Sprite;
import openfl.text.Font;

class Main extends Sprite
{
	public static var performanceText:Performance;
	public static var saveData:Save;

	public function new()
	{
		performanceText = new Performance(true);
		saveData = new Save();
		saveData.initSave();
		saveData.readSave();

		super();

		addChild(new FlxGame(0, 0, InitState));
		addChild(performanceText);
		performanceText.visible = Preferences.performanceText;
	}
}
