package;

import flixel.util.FlxSave;
import openfl.Lib;

class Save extends FlxSave
{
	public function initSave()
	{
		bind('Prankton', Lib.application.meta.get('company'));
		trace(this.data);
		data.preferences ??= defaultPreferencesData();
		trace(this.data);
	}

	public function readSave()
	{
		if (getAssetCaching() != null)
			Preferences.assetCaching = data.preferences.assetCaching;
		if (getPerformanceText() != null)
			Preferences.assetCaching = data.preferences.performanceText;
	}

	public function defaultPreferencesData()
	{
		return {
			assetCaching: Preferences.assetCaching,
			performanceText: Preferences.performanceText
		};
	}

	function getAssetCaching():Bool
		return data.preferences.assetCaching;

	function getPerformanceText():Bool
		return data.preferences.performanceText;
}
