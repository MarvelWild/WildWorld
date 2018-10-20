-- glue between game and animation library
-- global Anim

local _={}

local _anim

_.update=function(dt)
	if _anim==nil then return end
	
	_anim:update(dt)
end

_.draw=function()
	if _anim==nil then return end
	_anim:draw(CurrentPlayer.x, CurrentPlayer.y)
end



_.start=function(entity, frames)
	
	entity.spriteName=nil
	
	if timeline==nil then
		timeline=playerDanceTimeline
	end
	
	local onAnimLoop=function()
		log("onAnimEnd")
	end
	
	
	
	_anim=Walt.newAnimation(frames, 1)
	_anim:setLooping(true)
	_anim:setOnAnimationEnd(onAnimLoop)

	
	-- wip connect to lib
	
	-- wip: swap draw method in drawable
end

return _