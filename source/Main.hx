package;

import com.akifox.plik.debug.Performance;
import flixel.FlxGame;
import openfl.display.Sprite;
import openfl.text.Font;

class Main extends Sprite
{
	public static var performanceText:Performance;

	public function new()
	{
		performanceText = new Performance(true);
		super();

		addChild(new FlxGame(0, 0, InitState));
		if (Preferences.performanceText)
			addChild(performanceText);
	}
}
