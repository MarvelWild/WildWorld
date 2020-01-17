-- todo: make it part of pow
-- цель - коллизии по уровням,
-- следующий уровень абстракции: collision (одноуровневая модель)

-- на клиенте пока что не используется

local _entity_name='CollisionService'
local _=BaseEntity.new(_entity_name, true)


local _levelCollisions={}



_.addEntity=function(entity)
end

_.onEntityMoved=function(entity)
end


_.removeEntity=function(entity)
end

local onCollisionsReceived=function(event)
	log("collisions received")
	-- todo: debug draw them
end


_.update=function()
	
-- collisions debug unfinished	
--	local frameNumber=Pow.getFrame()
--	if frameNumber%600~=0 then return end
	
--	local requestCollisions=Event.new()
--	requestCollisions.code="collisions_get"
--	requestCollisions.target="server"
--	Event.process(requestCollisions,onCollisionsReceived)
end



--_.draw=function()
--end


return _
