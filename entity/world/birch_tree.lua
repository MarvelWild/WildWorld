local _={}

_.new=function(options)
	local result=BaseEntity.new()
	
	
	Entity.setSprite(result,"birch_tree_1")
	result.entity="BirchTree"
	result.id=Id.new(result.entity)
	result.isDrawable=true
	result.growPhase=1
		
	BaseEntity.init(result,options)
	return result
end

_.draw=function(entity)
	-- todo: opt
	local sprite=Img[entity.spriteName]
	draw(sprite,entity.x,entity.y)
end

local getSpriteForGrowPhase=function(phase)
	if phase==1 then return "birch_tree_1" end
	if phase==2 then return "birch_tree_2" end
	if phase==3 then return "birch_tree_3" end
	if phase==4 then return "birch_tree_4" end
	if phase==5 then return "birch_tree_5" end

	return nil
end


local grow=function(entity)
	-- log("tree grow:")
	local nextPhase=entity.growPhase+1
	local nextSprite=getSpriteForGrowPhase(nextPhase)
	if nextSprite==nil then 
		-- max grow
		return 
	end
	
	entity.growPhase=nextPhase
	Entity.setSprite(entity,nextSprite)
	
	
	Entity.notifyUpdated(entity)
end

if Session.isServer then
	_.slowUpdate=function(entity)
--		log("birch tree slow update")
		
		-- можно попробовать на активации на сервере вешаться на какой либо медленный таймер
		local rnd=Lume.random()
		if rnd>0.9 then
			grow(entity)
		end
		
	end
end


-- todo: growth

--_.use=function(seed,x,y)
--	seed.stackCount=seed.stackCount-1
--	-- todo: destroy on stack end
	
--	log("Seed plant at:"..xy(x,y))
	
--	local grass=Grass.new()
--	grass.x=x
--	grass.y=y
	
--	Entity.transferToServer({grass})
--end



return _