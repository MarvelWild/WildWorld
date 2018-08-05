-- global GrowableBehavoiur
local _={}

_.setup=function(entity)
	-- wip: set/check required data
	
	-- getSpriteForGrowPhase function
	-- growPhase prop
end


_.grow=function(entity)
		-- log("tree grow:")
	local nextPhase=entity.growPhase+1
	local entityCode=Entity.get(entity.entity)
	local nextSprite=entityCode.getSpriteForGrowPhase(nextPhase)
	if nextSprite==nil then 
		-- max grow
		return 
	end
	
	entity.growPhase=nextPhase
	Entity.setSprite(entity,nextSprite)
	
	
	Entity.notifyUpdated(entity)
end


return _