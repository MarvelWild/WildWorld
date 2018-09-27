local updateAi=function(pantera)
	local r=Lume.random() 
	if r>0.1 then 
		--log("not upd")
		return 
	end -- 50%?
	
--	log("pantera update ai")
	local x=pantera.x+Lume.random(-200,200)
	local y=pantera.y+Lume.random(-200,200)
	
	local world=CurrentWorld
	
	
	local nextX=Lume.clamp(x,0,world.wPx)
	local nextY=Lume.clamp(y,0,world.hPx)
	
	local moveEvent=Event.new()
	moveEvent.code="move"
	moveEvent.x=nextX
	moveEvent.y=nextY
	moveEvent.duration=12
	
	moveEvent.entityRef=Entity.getReference(pantera)
end

return updateAi