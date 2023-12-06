local dumbshitX = {-60, 0, 0, 60}
local dumbshitY = {0, 60, -60, 0}

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if not isSustainNote then
		_G['dadGhostData.strumTime'] = getPropertyFromGroup('notes', id, 'strumTime')
		updateGData('dad')	
		createGhost('dad', id, direction + 1)
	end
end

function createGhost(char, id, direction)
	songPos = getSongPosition() --in case game stutters
	tag = char..'Ghost'..songPos..id
    makeAnimatedLuaSprite(tag, getProperty(char..'.imageFile'),getProperty(char..'.x'),getProperty(char..'.y'))
    addLuaSprite(tag, false)
    setProperty(tag..'.scale.x',getProperty(char..'.scale.x'))
	setProperty(tag..'.scale.y',getProperty(char..'.scale.y'))
	setProperty(tag..'.flipX', getProperty(char..'.flipX'))
	setProperty(tag..'.alpha', 1)
	
	if dumbshitX[direction] == 0 then setProperty(tag..'.velocity.x', getRandomInt(-20, 20))
	else setProperty(tag..'.velocity.x', dumbshitX[direction]) end
		
	if dumbshitY[direction] == 0 then setProperty(tag..'.velocity.y', getRandomInt(-20, 20))
	else setProperty(tag..'.velocity.y', dumbshitY[direction]) end
		
	doTweenAlpha(tag..'delete', tag, 0, 0.4)
	setProperty(tag..'.animation.frameName', _G[char..'GhostData.frameName'])
	setProperty(tag..'.offset.x', _G[char..'GhostData.offsetX'])
	setProperty(tag..'.offset.y', _G[char..'GhostData.offsetY'])
	setObjectOrder(tag, getObjectOrder(char..'Group')-1)
end

function onTweenCompleted(tag)
-- i like number 45 :thumbs_up:
	if (tag:sub(#tag- 5, #tag)) == 'delete' then
		removeLuaSprite(tag:sub(1, #tag - 6), true)
	end
end

function updateGData(char)
	_G[char..'GhostData.frameName'] = getProperty(char..'.animation.frameName')
	_G[char..'GhostData.offsetX'] = getProperty(char..'.offset.x')
	_G[char..'GhostData.offsetY'] = getProperty(char..'.offset.y')
end
