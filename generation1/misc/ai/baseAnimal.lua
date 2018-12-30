local _={}

local maxDistance=100

_.updateAi=function(entity)
		local r=Lume.random() 
	if r>0.1 then 
		--log("not upd")
		return 
	end -- 50%?
	
--	log("entity update ai")

	local x=entity.x+Lume.random(-maxDistance,maxDistance)
	local y=entity.y+Lume.random(-maxDistance,maxDistance)
	
	local world=CurrentWorld
	
	
	local nextX=Lume.clamp(x,0,world.wPx)
	local nextY=Lume.clamp(y,0,world.hPx)
	
	local moveEvent=Event.new()
	moveEvent.code="move"
	moveEvent.x=nextX
	moveEvent.y=nextY
	moveEvent.duration=12
	
	moveEvent.entityRef=Entity.getReference(entity)
	
end


return _