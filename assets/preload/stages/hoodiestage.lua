function onCreate()

	makeLuaSprite('theBackground','theBackground',-700,-400)
		scaleObject('theBackground', 0.7, 0.7);
		setLuaSpriteScrollFactor('theBackground', 0.3, 0.3);

	makeAnimatedLuaSprite('bgCharacters','upperBopwhite',-50,20)
		addAnimationByPrefix('bgCharacters','bop','Upper Crowd Bob',24,true)
		setLuaSpriteScrollFactor('bgCharacters', 0.4, 0.4)
		scaleObject('bgCharacters', 0.7, 0.7);

	makeLuaSprite('theEscalator','theEscalator',-900,-500)
		scaleObject('theEscalator', 0.8, 0.8);
		setLuaSpriteScrollFactor('theEscalator', 0.4, 0.4)

	makeLuaSprite('theGround','theGround',-400,620)

	addLuaSprite('theBackground',false)
	addLuaSprite('bgCharacters',false)
	addLuaSprite('theEscalator',false)
	addLuaSprite('theGround',false);
	
end

function onBeatHit()
	objectPlayAnimation('bgCharacters','bop',true)
end	