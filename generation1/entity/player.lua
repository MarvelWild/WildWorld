local _={}

_.name="Player"

_.new=function(options)
	-- try to keep it flat
	local name="player"
	
	local player=BaseEntity.new(options)
	player.x=0
	player.y=0
	player.hp=10
	player.maxHp=10
	
	player.energy=10
	player.maxEnergy=10
	
	player.xScale=1 -- todo: implement
	player.editorVisible=false
	player.isDrawable=true
	
	-- todo: comment
	player.worldId=nil
	player.worldName="main"
	
	player.riderX=7
	player.riderY=11
	
	player.originX=7
	player.originY=7
	
	player.footX=7
	player.footY=15

	
	-- name of controlling entity for this data
	player.entity="Player"
	-- player.isDrawable=true
	
	
	local spriteName=name
	local rnd=Lume.random()
	if rnd > 0.5 then
		spriteName="girl"
	end
	
	Entity.setSprite(player,spriteName)
	--player.spriteName=name
	
	player.inventory={}
	-- 8 on-screen items/actions.
	
	player.favorites={}
	player.abilities={}
	player.activeFavorite=nil
	
	
	Entity.afterCreated(player,_,options)
	
	-- todo: refactor
	if CurrentWorld~=nil then
		_.setWorld(CurrentWorld)
	end
	
	return player
end

_.draw=DrawableBehaviour.draw

--_.draw=function(player)
--	-- todo: opt
--	local sprite=Img[player.spriteName]
	
--	LG.draw(sprite,player.x,player.y)
	
--	-- animation proto
----	local animSprite1=Img.pantera_walk_1
----	local animSprite2=Img.pantera_walk_2
	
----	local time=Lume.round(Session.frame/60)
----	time=math.floor(time)
----	if (time % 2 == 0) then
----		log("frame1")
----    LG.draw(animSprite1,player.x,player.y)
----	else
----		log("frame2")
----		LG.draw(animSprite2,player.x,player.y)
----	end
--end




_.slowUpdate=function(player)
--	log("player slow update")
	
	EnergyBehaviour.changeEnergy(player, -0.01)
end

_.giveStarterPack=function(player)
	log("giveStarterPack")
	
	local seed=Seed.new()
	seed.type="mixed"
	
	assert(player.favorites[1]==nil)
	
	_.setFavorite(player,seed,1)
	
	
	local slot2=BirchSapling.new()
	_.setFavorite(player,slot2,2)
	
	local slot3=Cauldron.new()
	_.setFavorite(player,slot3,3)
	
	local slot4=Bucket.new()
	_.setFavorite(player,slot4,4)
	
	local slot5=Boombox.new()
	_.setFavorite(player,slot5,5)
end


_.setActiveFavorite=function(slot)
	local player=CurrentPlayer
	
	-- todo: remember slot number even if its empty (mc style)
	player.activeFavorite=player.favorites[slot]
end



-- fav slots
_.removeItem=function(item)
	local player=CurrentPlayer
	for k,v in pairs(player.favorites) do
		if v==item then player.favorites[k]=nil end
	end
	
	if player.activeFavorite==item then 
		player.activeFavorite=nil 
	end
end

-- set new item into fav slot
_.setFavorite=function(player,item,slot)
	if player.favorites[slot] then log("error: not implemented") end
		
	player.favorites[slot]=item
	
	if not player.activeFavorite then
		player.activeFavorite=item
	end
	
	-- ожидается что вещи в инвентаре обязательно неактивны (как сущность)
	Entity.setActive(item,false)
end

_.addFavorite=function(player,item)
	local favs=player.favorites
	local slot=1
	while true do
		local fav=favs[slot]
		if not fav then break end
		
		slot=slot+1
	end
	
	_.setFavorite(player,item,slot)
end




_.canPickup=function(player,entity)
	-- todo: available space, other checks
	return entity.worldId~=nil
end


-- each player saves self (like in diablo 2)
_.save=function()
	local player=CurrentPlayer
	local str=serialize(player)
	love.filesystem.write(Const.playerSaveFile, str)
	
	log("player saved")
end





_.load=function()
	local saveFile=Const.playerSaveFile
	local fs=love.filesystem
	
	local info=fs.getInfo(saveFile)
	
	if info==nil then return false end
	
	local packed=fs.read(saveFile)
	CurrentPlayer=deserialize(packed)
	Entity.register(CurrentPlayer)

	
	assert(CurrentPlayer)
	
	return true
end


_.setWorld=function(world)
	local player=CurrentPlayer
	
	player.worldId=world.id
	
	Entity.updateCollision(player)
end

-- todo: toggle


local initAnimation=function()
	local danceFrames=
	{
		Img.get("player1_dance1"),
		Img.get("player1_dance2"),
		Img.get("player1_dance3"),
		Img.get("player1_dance4"),
	}
	
	Anim.add(_.name, "dance", danceFrames)
	
	local walkFrames=
	{
		Img.get("player_move1"),
		Img.get("player_move2"),
	}
	
	Anim.add(_.name, "move", danceFrames)
end
initAnimation()


_.startDance=function()
	-- todo: networking
	
	local danceFrames=Anim.get(_.name, "dance")
	Anim.start(CurrentPlayer, danceFrames)
end



_.getByLogin=function(login)
	local allPlayers=Entity.getByName(_.name)
	for k,player in ipairs(allPlayers) do
		if player.login==login then
			return player
		end
	end
	
	return nil
end


return _
