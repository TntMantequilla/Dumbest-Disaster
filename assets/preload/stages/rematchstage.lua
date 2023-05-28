function onCreate()

	makeAnimatedLuaSprite('theBackground','slystuff',-700,-400)
		addAnimationByPrefix('theBackground', 'state1', 'bgWalls0', 1, false)
		addAnimationByPrefix('theBackground', 'state2', 'bgWalls2', 1, false)
		setLuaSpriteScrollFactor('theBackground', 0.3, 0.3);
		scaleObject('theBackground', 0.7, 0.7);

	makeAnimatedLuaSprite('theEscalator','slystuff',-900,-500)
		addAnimationByPrefix('theEscalator', 'state1', 'escalator0', 1, false)
		addAnimationByPrefix('theEscalator', 'state2', 'escalator2', 1, false)
		setLuaSpriteScrollFactor('theEscalator', 0.4, 0.4)
		scaleObject('theEscalator', 0.8, 0.8);
	
	makeAnimatedLuaSprite('theGround','slystuff',-400,620)
		addAnimationByPrefix('theGround', 'state1', 'fgSnow0', 1, false)
		addAnimationByPrefix('theGround', 'state2', 'fgSnowreal', 1, false)
	
	--bg bois--
	makeAnimatedLuaSprite('bgCharacters','upperBopwhite',-50,20)
	addAnimationByPrefix('bgCharacters','bop','Upper Crowd Bob',24,true)
	objectPlayAnimation('bgCharacters','bop',false);
	setLuaSpriteScrollFactor('bgCharacters', 0.4, 0.4)
	scaleObject('bgCharacters', 0.7, 0.7);


	addLuaSprite('theBackground',false)
	addLuaSprite('bgCharacters',false)
	addLuaSprite('theEscalator',false)
	addLuaSprite('theGround',false);

end

function onBeatHit()
	objectPlayAnimation('bgCharacters','bop',true)
end