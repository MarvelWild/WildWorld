local _entity_name='AiService'
local _=BaseEntity.new(_entity_name, true)

local _maxDistance=50

local _event=nil
_.load=function()
	_event=Pow.net.event
end

_.moveRandom=function(entity)
	local maxDistance=_maxDistance
	local random=Pow.lume.random
	local clamp=Pow.lume.clamp
	
	local nextXRaw=entity.x+random(-maxDistance,maxDistance)
	local nextYRaw=entity.y+random(-maxDistance,maxDistance)
	
	-- local world=CurrentWorld
	-- todo actual level size
	local nextX=clamp(nextXRaw,0,4096)
	local nextY=clamp(nextYRaw,0,4096)
	
	local responseEvent=_event.new("move")
	responseEvent.target="level"
	responseEvent.level=entity.level_name
	responseEvent.x=nextX
	responseEvent.y=nextY
	responseEvent.actorRef=BaseEntity.getReference(entity)
	_event.process(responseEvent)
end


return _