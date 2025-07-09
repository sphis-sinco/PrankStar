package menus;

class MainMenu extends SelectMenuBase
{
	override public function new()
	{
		super();

		addEntry('levels', false, () -> new LevelSelect());
		addEntry('credits', true, null);
		addEntry('settings', false, () -> new SettingsMenu());
	}
}
