local matHasAwakened = false

function onCreate()
    makeAnimatedLuaSprite('HEFUCKINGMOVES','characters/mat_walk',-500,300)
		addAnimationByPrefix('HEFUCKINGMOVES', 'Idle', 'walk', 24, true)
	scaleObject('HEFUCKINGMOVES', 0.8, 0.8)
	setProperty('HEFUCKINGMOVES.y', 570)
    addLuaSprite('HEFUCKINGMOVES', false)
	
	setProperty('dad.alpha', 0)
end
function onMoveCamera(focus)
	if focus == 'dad' and not matHasAwakened then
		matHasAwakened = true
		doTweenX('boey', 'HEFUCKINGMOVES', 303, 2.4, 'LINEAR')
	
	end
end
function onTweenCompleted(tag)
	if tag == 'boey' then
		setProperty('dad.alpha', 1)
		setProperty('HEFUCKINGMOVES.alpha', 0)
	
	end
end