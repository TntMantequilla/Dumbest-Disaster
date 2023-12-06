function onCreatePost()
	setProperty('camHUD.alpha', 0)
doTweenAlpha('dumbshid2','goddsmitanothersquare', 1 , 2)
end
function onCreate()
	if isStoryMode then
	setProperty('skipCountdown', true)
	end 
makeLuaSprite('goddsmitanothersquare', nil, 0, 0) 		luaSpriteMakeGraphic('goddsmitanothersquare', screenWidth, screenHeight, '000000') 		setScrollFactor('goddsmitanothersquare', 0, 0); 		screenCenter('goddsmitanothersquare'); 		addLuaSprite('goddsmitanothersquare', true)
setProperty('goddsmitanothersquare.alpha', 1)
end
function onUpdate(elapsed)

  if curStep >= 0 then

    songPos = getSongPosition()

    local currentBeat = (songPos/1000)*(bpm/80)

	setProperty('dad.y', 300-30*math.sin((currentBeat*0.25)*math.pi))

  end

end
function onBeatHit()
	if curBeat == 1 then
		doTweenAlpha('dumbshid2','goddsmitanothersquare', 0 , 3)
	end
	if curBeat == 16 then
		doTweenAlpha('dumbshid', 'camHUD', 1 ,2)
	end
end

local itsjoeover = false
function onEndSong()
    if not itsjoeover and isStoryMode then
		setProperty('camGame.alpha', 0)
		setProperty('camHUD.alpha', 0)
        startVideo('April Fools');
        itsjoeover = true;
        return Function_Stop;
    end
    return Function_Continue;
end
