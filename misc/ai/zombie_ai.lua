-- 0-idle (random walk)
-- 1-chase player


local stateCode=0

-- seekbox for target
local seekRadiusX=200
local seekRadiusY=200
local walkRadius=30


local moveRandomly=function(actor)
	local x=actor.x+Lume.random(-walkRadius,walkRadius)
	local y=actor.y+Lume.random(-walkRadius,walkRadius)
	local nextX=Lume.clamp(x,0,Config.levelWidth)
	local nextY=Lume.clamp(y,0,Config.levelHeight)
	
	local moveEvent=Event.new()
	
	-- event.target="all" by default
	moveEvent.code="move"
	moveEvent.x=nextX
	moveEvent.y=nextY
	moveEvent.duration=12
	
	moveEvent.entityRef=Entity.getReference(actor)
end


local updateAi=function(zombie)
	if stateCode==0 then -- idle
	
		
		-- random walk
	
		-- todo: make calls less frequent, remove such checks
		
-- wip commented for debug		
--		local r=Lume.random() 
--		if r>0.1 then 
--			--log("not upd")
--			return 
--		end -- 50%?
		
		
		--local target=Entity.inRange(w,h,)
		-- wip get all entities in area
		
		-- wip: seek rect
		
		
		--todo: fov instead of box
		
		local seekX=zombie.x+zombie.originX-seekRadiusX
		local seekY=zombie.y+zombie.originY-seekRadiusY
		
		local w=seekRadiusX*2
		local h=seekRadiusY*2
		
		-- wip: exclude self
		local allInRange=Collision.getAtRect(seekX,seekY,w,h)
		
		local easyToRead=""
		
		for k,entity in pairs(allInRange) do
			-- Entity.toString
			easyToRead=easyToRead.._ets(entity).."\n"
		end
		
		
		
		-- log("I am zombie, and i see:"..Inspect(allInRange))
		log("I am zombie, and i see:"..easyToRead)
		
		-- wip test this
		
		
		moveRandomly(zombie)
		
		
		-- wip: seek for player
		
		
		
		
		
	else
		log("error: unk ai state")
	end
end

return updateAi