function onCreate()
	-- background shit
	makeLuaSprite('greenpeoplebelike', 'greenpeoplebelike', -250, -25);
	setScrollFactor('greenpeoplebelike', 0, 0);
	screenCenter('greenpeoplebelike');
	addLuaSprite('greenpeoplebelike', false);
		
	for bg = 1, 2 do

		makeLuaSprite('scrollMiddle'..bg,'patternmiddle', -700, -200)
		setScrollFactor('scrollMiddle', 0.5, 0.5);
		setProperty('scrollMiddle'..bg..'.velocity.x' , -100)
		addLuaSprite('scrollMiddle'..bg,false)

		makeLuaSprite('scrollBack'..bg,'patternfront', -700, -200)
		setScrollFactor('scrollBack', 0.3, 0.3);
		addLuaSprite('scrollBack'..bg,false)
		setProperty('scrollBack'..bg..'.velocity.x' , -50)
	end
	
	if songName == 'Dumbest' then
		setProperty('defaultCamZoom', 1.3)
		makeLuaSprite('whosedumbturnedthelightsoff', nil, 0, 0)
		luaSpriteMakeGraphic('whosedumbturnedthelightsoff', screenWidth, screenHeight, '000000')
		setScrollFactor('whosedumbturnedthelightsoff', 0, 0);
		screenCenter('whosedumbturnedthelightsoff');
		addLuaSprite('whosedumbturnedthelightsoff', false)
	end
	
	setProperty('scrollBack2.x', -700 + getProperty('scrollBack2.width'))
	setProperty('scrollMiddle2.x', -700 + getProperty('scrollMiddle2.width'))
	
	makeLuaSprite('leftplatform', 'leftplatform', 75, 720);
	setScrollFactor('leftplatform', 1.0, 1.0);
	scaleObject('leftplatform', 0.9, 0.9);

	makeLuaSprite('rightplatform', 'rightplatform', 185, 720);
	setScrollFactor('rightplatform', 1.0, 1.0);
	scaleObject('rightplatform', 0.9, 0.9);
	
	addHaxeLibrary('ColorSwap')
	
	addLuaSprite('leftplatform', false);
	addLuaSprite('rightplatform', false);
	
end

function onBeatHit()
	if curBeat == 100 and songName == 'Dumbest' then
		setProperty('defaultCamZoom', 1)
		cameraFlash('camGame.alpha', 'FFFFFF',1)
		setProperty('whosedumbturnedthelightsoff.alpha', 0)
	end
end
function onUpdate()
	for i = 1, 2 do
		if getProperty('scrollMiddle'..i..'.x') <= (-700 - getProperty('scrollMiddle2.width')) then
			setProperty('scrollMiddle'..i..'.x', -700 + getProperty('scrollMiddle2.width'))
		end
		if getProperty('scrollBack'..i..'.x') <= (-700 - getProperty('scrollMiddle2.width')) then
			setProperty('scrollBack'..i..'.x', -700 + getProperty('scrollMiddle2.width'))
		end
	end
end

local fakeiTime = 0
function onUpdatePost()
fakeiTime = fakeiTime + 0.0003
		runHaxeCode([[
		var colorS = new ColorSwap();
		colorS.hue =  ]]..fakeiTime..[[ ;
		game.getLuaObject('greenpeoplebelike').shader = colorS.shader;
		]])
-- this is definetly gotta be the dumbest shit ever 
end