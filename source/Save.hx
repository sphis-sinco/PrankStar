package;

import flixel.util.FlxSave;
import openfl.Lib;

class Save extends FlxSave
{
	public function initSave()
	{
		bind('Prankton', Lib.application.meta.get('company'));
		#if SAVE_TRACES
		trace(this.data);
		#end
		data.preferences ??= defaultPreferencesData();
		#if SAVE_TRACES
		trace(this.data);
		#end
	}

	public function readSave()
	{
		if (getAssetCaching() != null)
			Preferences.assetCaching = data.preferences.assetCaching;
		if (getPerformanceText() != null)
			Preferences.performanceText = data.preferences.performanceText;
	}

	public function setSave()
	{
		data.preferences.assetCaching = Preferences.assetCaching;
		data.preferences.performanceText = Preferences.performanceText;
	}

	public function defaultPreferencesData()
	{
		return {
			assetCaching: Preferences.assetCaching,
			performanceText: Preferences.performanceText
		};
	}

	function getAssetCaching():Null<Bool>
		return data.preferences.assetCaching;

	function getPerformanceText():Null<Bool>
		return data.preferences.performanceText;
}
