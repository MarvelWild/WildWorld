local _={}

_.entityName="player"

_.new=function()
	local result=BaseEntity.new(_.entityName)
	
	result.name='Joe'
	result.levelName='start'
	
	-- todo это свойства спрайта
	result.footX=7
	result.footY=15
	
	
	-- откуда начинается квадрат коллизии
	result.collisionX=3
	result.collisionY=0
	
	-- todo: вторые 2 координаты квадрата коллизии
	
	
	-- used for collisions
	result.w=9
	result.h=16
	
	
	
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




_.gotoLevel=function(player, levelName)
	log("gotoLevel:"..levelName)
	-- wip:
	-- update prop
	-- update entity container
	-- update collision container
	-- send updated
	-- unload prev on client
	-- load new on client
end


_.interact=function(player,target)
	if target.entityName=="portal" then
		local levelName=target.location
		_.gotoLevel(player,levelName)
	else
		log("interact not implemented:"..Entity.toString(target))
	end
end

return _