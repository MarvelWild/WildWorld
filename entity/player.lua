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
	
	player.spriteName=name
	
	local sprite=Img[player.spriteName]
	player.height=sprite:getHeight()
	
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
end


_.setActiveFavorite=function(slot)
	local player=World.player
	player.activeFavorite=player.favorites[slot]
end


-- set new item into fav slot
_.setFavorite=function(player,item,slot)
	if player.favorites[slot] then log("error: not implemented") end
		
	player.favorites[slot]=item
	
	if not player.activeFavorite then
		player.activeFavorite=item
	end
	
end


return _