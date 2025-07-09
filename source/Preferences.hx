package;

import flixel.FlxG;

class Preferences
{
	/**
	 * Toggles the asset caching in PSAssets
	 */
	public static var assetCaching:Null<Bool> = null;

	/**
	 * Toggles the performance text
	 */
	public static var performanceText:Null<Bool> = null;

	public static function togglePerformanceText()
	{
		performanceText = !performanceText;
		FlxG.resetGame();
	}
}
