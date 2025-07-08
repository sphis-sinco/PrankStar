package menus;

class MainMenu extends SelectMenuBase
{
	override public function new()
	{
		super();

		entries = ['levels', 'credits', 'settings'];
		entries_disabled = [false, true, true];
		entries_states = [() -> new LevelSelect(), null, null];
	}
}
