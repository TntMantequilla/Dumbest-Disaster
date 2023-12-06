function onCreate()
	-- background shit
	makeLuaSprite('blackpeoplebelike', 'blackpeoplebelike', -250, -25);
	setScrollFactor('blackpeoplebelike', 0.7, 0.7);
	scaleObject('blackpeoplebelike', 0.9, 0.9);

	makeLuaSprite('leftplatform', 'leftplatform', 75, 720);
	setScrollFactor('leftplatform', 1.0, 1.0);
	scaleObject('leftplatform', 0.9, 0.9);

	makeLuaSprite('rightplatform', 'rightplatform', 185, 720);
	setScrollFactor('rightplatform', 1.0, 1.0);
	scaleObject('rightplatform', 0.9, 0.9);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
		
	end

	addLuaSprite('blackpeoplebelike', false);
	addLuaSprite('leftplatform', false);
	addLuaSprite('rightplatform', false);
	
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end