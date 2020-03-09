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
	
	local current_x=entity.x+entity.footX
	local current_y=entity.y+entity.footY
	
	local dx=random(-maxDistance,maxDistance)
	local dy=random(-maxDistance,maxDistance)
	
	-- local world=CurrentWorld
	-- todo actual level size
	local max_x=4096
	local max_y=4096
	
	
	-- opt, some calc could be done once
	if current_x<300 then 
		dx=dx+random(50)
	end
	
	if current_y<300 then
		dy=dy+random(50)
	end
	
	if current_x>max_x-300 then 
		dx=dx-random(50)
	end
	
	if current_y<max_y-300 then
		dy=dy-random(50)
	end
	

	local nextXRaw=current_x+dx
	local nextYRaw=current_y+dy
	
--	log(_ets(entity))
	
--	log("ai moveRandom. dx:".._n(dx).." dy:".._n(dy)..
--		" nextXRaw:".._n(nextXRaw).." nextYRaw:".._n(nextYRaw)
--		)
	

	local border=64
	
	local min=0+border
	local max_x_final=max_x-border
	local max_y_final=max_y-border
	
	local nextX=clamp(nextXRaw,min,max_x_final)
	local nextY=clamp(nextYRaw,min,max_y_final)
	
	--log("after clamp nextX:".._n(nextX).." nextY:".._n(nextY))
	
	
	-- todo: event factory? same event produced for player
	local responseEvent=_event.new("move")
	responseEvent.target="level"
	responseEvent.level=entity.level_name
	responseEvent.x=nextX
	responseEvent.y=nextY
	responseEvent.duration=Movable.calc_move_duration(entity,nextX,nextY)
	responseEvent.actorRef=BaseEntity.getReference(entity)
	_event.process(responseEvent)
end


return _