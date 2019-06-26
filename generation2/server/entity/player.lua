local _={}

_.new=function()
	local result=BaseEntity.new("player")
	
	result.name='Joe'
	result.levelName='start'
	
	-- todo это свойства спрайта
	result.footX=7
	result.footY=15
	
	result.sprite="player"
	
	return result
end

_.getById=function(playerId)
	local magicLevelContainer=Db.getLevelContainer("player")
	local playerContainer=Db.getEntityContainer(magicLevelContainer, "player")
	local result = playerContainer[playerId]
	return result
end


return _