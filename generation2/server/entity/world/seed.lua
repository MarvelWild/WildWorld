
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
	newInstance.x=entity.x
	newInstance.y=entity.y
	
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