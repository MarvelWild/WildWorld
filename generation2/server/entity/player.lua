local _={}

_.new=function()
	local result=BaseEntity.new("player")
	
	result.name='Joe'
	result.levelName='start'
	
	-- todo это свойства спрайта
	result.footX=7
	result.footY=15
	
	result.sprite="player"
	result.login=nil
	
	return result
end

_.getById=function(playerId)
	-- special level for storing logged off players
	local magicLevelContainer=Db.getLevelContainer("player")
	local playerContainer=Db.getEntityContainer(magicLevelContainer, "player")
	local result = playerContainer[playerId]
	return result
end

_.getByLogin=function(login)
	local magicLevelContainer=Db.getLevelContainer("player")
	local playerContainer=Db.getEntityContainer(magicLevelContainer, "player")
	for k,player in pairs(playerContainer) do
		if player.login==login then return player end
	end
	
	return nil
end



return _