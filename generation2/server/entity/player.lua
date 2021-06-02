-- controlling player.
-- server.
-- Надигровая сущность - описывает живого игрока.

local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.controlled_entity_ref=nil -- attached later
	result.level_name='start'
	result.login=nil
	result.shapeless=true
	
	return result
end



-- привязка игрока к управляемой сущности
_.attach=function(player,entity_ref)
	player.controlled_entity_ref=entity_ref
	
	-- кэш, чистим
	player.controlled_entity=nil
end




local get_db_container=function()
	-- special level for storing logged off players
	local magicLevelContainer=Db.getLevelContainer("player")
	local playerContainer=Db.getEntityContainer(magicLevelContainer, "player")
	
	return playerContainer
end

_.getById=function(playerId)
	
	local playerContainer=get_db_container()
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





-- todo: any entity can go levels
_.gotoLevel=function(player, level_name)
	
	
	local controlled_entity=player.controlled_entity
	
	local prev_level=controlled_entity.level_name
	log("gotoLevel:"..level_name.." from:"..prev_level)
	-- delete from db because db stores entities in level containers
	
	-- hanlded by db->entity
	-- update collision container
	-- CollisionService.removeEntity(player)
	
	-- local prevLevel=player.level_name
	
	
	Db.remove(controlled_entity,prev_level,true)
	
	
	local mount_ref=controlled_entity.mounted_on
	local extra_entities={}
	if mount_ref then
		local mount=_deref(mount_ref)
		table.insert(extra_entities, mount)
		mount_ref.level_name=level_name
		for k,slot in pairs(mount.mount_slots) do
			local rider=slot.rider
			if rider then
				rider.level_name=level_name
			end
		end
		
--		mount.mounted_by.level_name=level_name
	end
	
	-- перенос связанных сущностей
	for k,entity in pairs(extra_entities) do
		Db.remove(entity,prev_level,true)
		-- todo: обновить её рефы?
		entity.level_name=level_name
	end
	

	
	
	
	
	-- remove from prev level,send to all on that level
	-- ServerService.notifyEntityRemoved(player, prevLevel)
	
	-- update prop
	
	-- устранить дублирование? пусть будет уровень и у игрока
	-- и у сущности им управляемой
	controlled_entity.level_name=level_name
	player.level_name=level_name
	
	-- можно ли так? да, ид уникален между левелами.
	player.controlled_entity_ref.level_name=level_name
	
	
	Level.activate(level_name)
	
	-- тут лишний раз шлётся актёру todo можно оптимизировать. пока что решено не трогать, не критично.
	
	Db.add(controlled_entity)
	
	for k,entity in pairs(extra_entities) do
		Db.add(entity,level_name,true)
	end
	
	
	-- CollisionService.addEntity(player) - happens in Db.add
	
	-- update entity container
	-- not needed - single container for all levels
	
	
	-- todo отправлять стейт игроку, но разрешить переход и аи сущностям
	-- send updated player,level
	ServerService.sendFullState(player)
end





_.get_controlled_entity=function(player)
	local cached=player.controlled_entity
	if cached~=nil then return cached end
	
	local fresh=_deref(player.controlled_entity_ref)
	player.controlled_entity=fresh
	return fresh
end





return _