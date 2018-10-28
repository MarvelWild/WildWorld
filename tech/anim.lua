-- glue between game and animation library
-- global Anim

local _={}

local _activeAnimations={}
local _animations={}

_.update=function(dt)
	for entity,anim in pairs(_activeAnimations) do
		anim:update(dt)
	end
end

_.draw=function()
	--local drawCount=0
	for entity,anim in pairs(_activeAnimations) do
		anim:draw(entity.x,entity.y)
		--drawCount=drawCount+1
	end
	
	--log("anims:"..drawCount)
end



_.start=function(entity, frames, isLoop)
	-- cancel prev: it will be overwritten by default
	local prevAnim=_activeAnimations[entity]
	if prevAnim~=nil then
		local animEndHandler=prevAnim.onAnimationEnd
		if animEndHandler~=nil then 
			animEndHandler() 
		end
	end
	
	local prevSprite=entity.spriteName
	entity.spriteName=nil
	-- assert(prevAnim==nil)
	
	local anim=Walt.newAnimation(frames, 1)
	
	_activeAnimations[entity]=anim
	-- table.insert(_activeAnimations, _anim)
	if isLoop then
		_anim:setLooping(true)
	end
	
	local onAnimEnd=function()
		-- log("onAnimEnd")
		entity.spriteName=prevSprite
		_activeAnimations[entity]=nil
	end
	anim:setOnAnimationEnd(onAnimEnd)
	
	-- we can swap draw method in drawable for optimization purpose
	-- now calls are made with empty sprite, they are avoidable
end


_.add=function(entityName,animName,frames)
	local entityAnimations=_animations[entityName]
	if entityAnimations==nil then
		entityAnimations={}
		_animations[entityName]=entityAnimations
	end
	
	-- todo: log collisions
	entityAnimations[animName]=frames
end

_.get=function(entityName,animName)
	local entityAnimations=_animations[entityName]
	if entityAnimations==nil then return nil end
	
	return entityAnimations[animName]
end

return _