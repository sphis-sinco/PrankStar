package levels.waterballoon;

class WaterBalloon extends FlxState
{
	var player:WaterBalloonAsset;
	var thrown:Bool = false;

	var door1:Door;
	var door2:Door;
	var door3:Door;

	var the_door:Int;
	var selectedDoor:Int;

	var endingCutscenePlayed:Bool = false;

	override function create()
	{
		door1 = new Door();
		door2 = new Door();
		door3 = new Door();

		add(door1);
		add(door2);
		add(door3);

		door1.x = door1.width;
		door2.screenCenter(X);
		door3.x = FlxG.width - (door3.width * 2);

		the_door = FlxG.random.int(1, 3);

		player = new WaterBalloonAsset();
		add(player);
		player.screenCenter();

		FlxTimer.wait(3, () ->
		{
			var sound = PSAssets.getSound('sounds/gameplay/door-knock');
			sound.volume = 0.1;

			switch (selectedDoor)
			{
				case 1:
					if (the_door == 1)
						sound.pan = 0;
					if (the_door == 2)
						sound.pan = 0.5;
					if (the_door == 3) sound.pan = 1;
				case 2:
					if (the_door == 2)
						sound.pan = 0;
					if (the_door == 1)
						sound.pan = -0.5;
					if (the_door == 3) sound.pan = 0.5;
				case 3:
					if (the_door == 3)
						sound.pan = 0;
					if (the_door == 2)
						sound.pan = -0.5;
					if (the_door == 1) sound.pan = 1;

				case 0:
					sound.pan = 0;

					if (the_door == 3)
						sound.pan = 1;
					if (the_door == 2)
						sound.pan = 0;
					if (the_door == 1) sound.pan = -1;
			}

			sound.play();
		});

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (!thrown)
		{
			player.setPosition(FlxG.mouse.x - (player.width / 2), FlxG.mouse.y - (player.height / 2));

			selectedDoor = 0;
			if (FlxG.mouse.overlaps(door1))
				selectedDoor = 1;
			if (FlxG.mouse.overlaps(door2))
				selectedDoor = 2;
			if (FlxG.mouse.overlaps(door3))
				selectedDoor = 3;

			if (FlxG.mouse.justReleased)
			{
				if (selectedDoor == the_door)
				{
					trace('Water balloon victory');
				}
				else
				{
					trace('Water balloon defeat');
				}

				thrown = true;
			}
		}

		if (thrown)
		{
			if (!endingCutscenePlayed)
			{
				// Each door plays an open animation
				door1.animation.play('open');
				door2.animation.play('open');
				door3.animation.play('open');

				PSAssets.playSound('sounds/gameplay/door');

				FlxTimer.wait(1, () ->
				{
					var suffix:String = '';

					// The right door will show a person and they get splashed
					if (selectedDoor == the_door)
						suffix = ' splashed';
					else
					{
						if (selectedDoor == 1)
							door1.animation.play('splashed');
						if (selectedDoor == 2)
							door2.animation.play('splashed');
						if (selectedDoor == 3)
							door3.animation.play('splashed');
					}
					player.animation.play('toss');

					PSAssets.playSound('sounds/gameplay/waterballoon');

					if (the_door == 1)
						door1.animation.play('person$suffix');
					if (the_door == 2)
						door2.animation.play('person$suffix');
					if (the_door == 3)
						door3.animation.play('person$suffix');

					FlxTimer.wait(2, () ->
					{
						FlxG.switchState(() -> new LevelSelect());
					});
				});

				endingCutscenePlayed = true;
			}
		}

		super.update(elapsed);
	}
}
