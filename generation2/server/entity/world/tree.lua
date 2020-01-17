local _={}

_.entityName="tree"

_.new=function()
	local result=BaseEntity.new(_.entityName)
	
	result.sprite="seed"
	-- result.sprite="tree_apple_9"
	result.plantedOn=Pow.getFrame()

	-- entityName
	
	-- при достижении финальной фазы во что превратиться дальше
	-- result.growInto="tree"
	
	-- todo: props of sprite, not entity?
	result.footX=15
	result.footY=46
	
	result.growPhase=1
	
	local secondsToGrow=love.math.random(30,90)
	result.growOn=secondsToGrow*ConfigService.serverFps
	
	BaseEntity.init_bounds_from_sprite(result)
	
	return result
end

-- todo grow

_.updateSimulation=function(entity)
	log("tree update sim")
	
--	local frame=Pow.getFrame()
--	local growOn=entity.growOn
--	if growOn~=nil then
--		if frame>growOn then
--			doGrow(entity)
--		else
--			log("not time to grow, now "..frame..", will grow on:"..growOn)
--		end
--	else
--		log("seed wont grow:")
		
end

return _

--[[ ex seed


local _={}

_.entityName="seed"


_.new=function()
	local result=BaseEntity.new(_.entityName)
	
	result.sprite="seed"
	
	local frame=Pow.getFrame()
	result.plantedOn=frame

	-- entityName
	result.growInto="tree"
	
	local secondsToGrow=love.math.random(5,20)
	result.growOn=secondsToGrow*ConfigService.serverFps+frame
	
	return result
end

local doGrow=function(entity)
	-- todo: выделить логику трансформации сущности 1 в 2
	local growInto=entity.growInto
	
	local entityCode=Entity.getCodeByName(growInto)
	local newInstance=entityCode.new()
	
	-- todo: use foot point
	newInstance.x=entity.x-newInstance.footX
	newInstance.y=entity.y-newInstance.footY
	
	local levelName=entity.levelName
	Db.add(newInstance,levelName)
	
	Db.remove(entity,levelName)
end


_.updateSimulation=function(entity)
	local frame=Pow.getFrame()
	local growOn=entity.growOn
	if growOn~=nil then
		if frame>growOn then
			doGrow(entity)
		else
			log("not time to grow, now "..frame..", will grow on:"..growOn)
		end
	else
		log("seed wont grow:")
		
	end
	
	
end





return _
]]--