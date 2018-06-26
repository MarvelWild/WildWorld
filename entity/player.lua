-- 2.0 ready

local _={}

_.name="Player"

_.new=function()
	-- try to keep it flat
	local name="player"
	
	local player=BaseEntity.new()
	player.x=0
	player.y=0
	player.xScale=1 -- todo: implement
	player.editorVisible=false
	player.isDrawable=true

	
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
	
	BaseEntity.init(player)
	return player
end

_.draw=function(player)
	-- todo: opt
	local sprite=Img[player.spriteName]
	
	LG.draw(sprite,player.x,player.y)
	
	if Session.isOnHorse then
		LG.draw(Img.horse_white,player.x,player.y+4)
	end
	
	
	
	-- animation proto
--	local animSprite1=Img.pantera_walk_1
--	local animSprite2=Img.pantera_walk_2
	
--	local time=Lume.round(Session.frame/60)
--	time=math.floor(time)
--	if (time % 2 == 0) then
--		log("frame1")
--    LG.draw(animSprite1,player.x,player.y)
--	else
--		log("frame2")
--		LG.draw(animSprite2,player.x,player.y)
--	end
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
end


_.setActiveFavorite=function(slot)
	local player=World.player
	
	-- todo: remember slot number even if its empty (mc style)
	player.activeFavorite=player.favorites[slot]
end



-- fav slots
_.removeItem=function(item)
	local player=World.player
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
	
end



_.canPickup=function(player,entity)
	-- todo: available space, other checks
	return entity.isInWorld==true
end





return _