package;

import sys.io.File;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import openfl.Lib;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.filters.ShaderFilter;
import openfl.display.Shader;
import lime.app.Application;
import lime.utils.Assets;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;
import sys.FileSystem;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.2'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'credits',
		'options'
	];

	var normalspr:FlxSprite;
	var staticspr:FlxSprite;
	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	override function create()
	{	
		var dasavefolder:String = 'assets';

		if(FlxG.save.data.ModCompleted == null) FlxG.save.data.ModCompleted = false; //dummy crash lololololol
		if(FlxG.save.data.ModCompleted) dasavefolder = 'dumb';

		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		WeekData.reloadWeekFiles(true);
		
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		//TVshader = new TVWarp();
   		//var shaderFilter = new ShaderFilter(TVshader);

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

	//	FlxG.camera.setFilters([shaderFilter]);

		Conductor.changeBPM(180);
		
		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(dasavefolder+'/images/art/bg.png');
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		var scrollbg:FlxSprite = new FlxBackdrop('', X);
		scrollbg.loadGraphic(dasavefolder+'/images/art/checkerboard.png');
		scrollbg.antialiasing = FlxG.save.data.ModCompleted;
		scrollbg.velocity.x = -50;
		add(scrollbg);

		normalspr = new FlxSprite().loadGraphic(dasavefolder+'/images/art/menuart.png');
		normalspr.antialiasing = ClientPrefs.globalAntialiasing;
		add(normalspr);

		staticspr = new FlxSprite().loadGraphic(dasavefolder+'/images/art/menuartStatic.png');
		staticspr.antialiasing = ClientPrefs.globalAntialiasing;
		add(staticspr);

		var ourple:FlxSprite = new FlxSprite().loadGraphic(dasavefolder+'/images/art/purple.png');
		ourple.antialiasing = ClientPrefs.globalAntialiasing;
		if(FlxG.save.data.ModCompleted)	add(ourple);

		var blackCorner:FlxSprite = new FlxSprite().loadGraphic(dasavefolder+'/images/art/blackcorner.png');
		blackCorner.antialiasing = ClientPrefs.globalAntialiasing;
		add(blackCorner);

		var menuLogo:FlxSprite = new FlxSprite().loadGraphic(dasavefolder+'/images/art/logo.png');
		menuLogo.antialiasing = ClientPrefs.globalAntialiasing;
		add(menuLogo);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 0);
			menuItem.screenCenter();
			menuItem.y += (i * 85);
			menuItem.x -= 600 - (i * 140);
			menuItem.frames = FlxAtlasFrames.fromSparrow(dasavefolder+'/images/menu.png', Assets.getText(dasavefolder+'/images/menu.xml'));
			menuItem.animation.addByPrefix('idle', optionShit[i] + '0', FlxG.save.data.ModCompleted ? 6 : 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + "select0", FlxG.save.data.ModCompleted ? 12 : 24, FlxG.save.data.ModCompleted);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			/*if (FlxG.keys.justPressed.SPACE){
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxG.save.data.ModCompleted = !FlxG.save.data.ModCompleted;
			}*/

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'freeplay' && !FlxG.save.data.ModCompleted)
				{
					FlxG.sound.play(Paths.sound('confirmMenu'));
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':			
										PlayState.storyPlaylist = ['Dumber', 'Dumbest'];
										PlayState.isStoryMode = true;
										PlayState.storyDifficulty = 2;

										PlayState.SONG = Song.loadFromJson('dumber-hard', 'dumber');

										PlayState.campaignScore = 0;
										PlayState.campaignMisses = 0;
										LoadingState.loadAndSwitchState(new PlayState(), true);
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										LoadingState.loadAndSwitchState(new options.OptionsState());
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;
		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		normalspr.visible = (optionShit[curSelected] != 'story_mode');
		staticspr.visible = (optionShit[curSelected] == 'story_mode');

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
			}
		});
	}
}
