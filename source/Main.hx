package;

import com.akifox.plik.debug.Performance;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var performanceText:Performance;

	public function new()
	{
		performanceText = new Performance(true);
		FlxG.save.bind('Prankton', Lib.application.meta.get('company'));

		super();

		addChild(new FlxGame(0, 0, InitState));
		addChild(performanceText);
	}
}
