local _={}

_.entityName="tree"

_.new=function()
	local result=BaseEntity.new(_.entityName)
	
	result.sprite="tree_apple_9"
	result.plantedOn=Pow.getFrame()

	-- entityName
	
	-- при достижении финальной фазы во что превратиться дальше
	result.growInto="tree"
	
	result.growPhase=1
	
	local secondsToGrow=love.math.random(30,90)
	result.growOn=secondsToGrow*ConfigService.serverFps
	
	return result
end

-- todo grow

return _