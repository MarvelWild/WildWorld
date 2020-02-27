local _entity_name='AiService'
local _=BaseEntity.new(_entity_name, true)

local _maxDistance=50

local _event=nil
_.load=function()
	_event=Pow.net.event
end

_.moveRandom=function(entity)
	
	if entity.entity_name=="camel" then
		local a=1
	end
	
	 
	
	local maxDistance=_maxDistance
	local random=Pow.lume.random
	local clamp=Pow.lume.clamp
	
	local nextXRaw=entity.x+random(-maxDistance,maxDistance)
	local nextYRaw=entity.y+random(-maxDistance,maxDistance)
	
	-- local world=CurrentWorld
	-- todo actual level size
	
	local border=64
	
	local min=0+border
	local max=4096-border
	
	local nextX=clamp(nextXRaw,min,max)
	local nextY=clamp(nextYRaw,min,max)
	
	local responseEvent=_event.new("move")
	responseEvent.target="level"
	responseEvent.level=entity.level_name
	responseEvent.x=nextX
	responseEvent.y=nextY
	responseEvent.actorRef=BaseEntity.getReference(entity)
	_event.process(responseEvent)
end


return _