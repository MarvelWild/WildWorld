-- 0-idle
local stateCode=0


local updateAi=function(actor)
	if stateCode==0 then -- idle
	
		
		-- random walk
	
		-- todo: make calls less frequent, remove such checks
		local r=Lume.random() 
		if r>0.1 then 
			--log("not upd")
			return 
		end -- 50%?
		
		local x=actor.x+Lume.random(-200,200)
		local y=actor.y+Lume.random(-200,200)
		local nextX=Lume.clamp(x,0,Config.levelWidth)
		local nextY=Lume.clamp(y,0,Config.levelHeight)
		
		local moveEvent=Event.new()
		
		-- event.target="all" by default
		moveEvent.code="move"
		moveEvent.x=nextX
		moveEvent.y=nextY
		moveEvent.duration=12
		
		moveEvent.entityRef=Entity.getReference(actor)
		
		
		-- wip: smell for player
	else
		log("error: unk ai state")
	end
end

return updateAi