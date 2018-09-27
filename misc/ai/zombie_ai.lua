-- 0-idle (random walk)
-- 1-chase player


--local stateCode=0

-- seekbox for target
local seekRadiusX=18
local seekRadiusY=18
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

local dealDamage=function(target,amount)
	-- todo: networking
	
	DamageableBehaviour.takeDamage(target,amount)
	
end



local updateAi=function(zombie)
	-- random walk

	-- todo: make calls less frequent, remove such checks
	
	local r=Lume.random() 
	if r>0.1 then 
		--log("not upd")
		return 
	end -- 50%?
	
	--todo: fov instead of box
	
	local seekX=zombie.x+zombie.originX-seekRadiusX
	local seekY=zombie.y+zombie.originY-seekRadiusY
	
	local w=seekRadiusX*2
	local h=seekRadiusY*2
	
	local allInRange=Collision.getAtRect(seekX,seekY,w,h)
	
	
	-- hack: draw debug seek
	zombie._seekRectX=seekX
	zombie._seekRectY=seekY
	zombie._seekRectW=w
	zombie._seekRectH=h
	
	-- done: debug area (draw rectangle)
	
	local isPossibleTarget=function(entity)
		
		-- exclude self
		if entity==zombie then return false end
		
		-- todo: collision should not return some entities like pointer by default?
		if entity.entity=="Pointer" then return false end
		
		if Taggable.isTagged(entity, "tree") then return false end
		
		return true
	end

	local allTargetable=Lume.filter(allInRange,isPossibleTarget)
	
	local easyToRead=""
	
	for k,entity in pairs(allTargetable) do
		-- Entity.toString
		easyToRead=easyToRead.._ets(entity).."\n"
	end
	
	local pickedTarget=Lume.randomchoice(allTargetable)
	
	--		local msg="I am zombie, and i see:"..easyToRead
--		log(msg)
	
--		zombie._debugText=msg

	
	if pickedTarget==nil then
		log("no targets")
	else
		log("Attack target:"+pickedTarget.entity)
		dealDamage(pickedTarget,1)
	end
	
	
	-- todo: approach target if far
	
	-- todo: attack animation
	
	-- todo: cooldown (now works on every ai update, ait ok)
	
	
	moveRandomly(zombie)
end

return updateAi