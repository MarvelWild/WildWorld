local _={}

_.new=function(options)
	local result=BaseEntity.new()
	
	
	result.spriteName="birch_tree_1"
	result.entity="BirchTree"
	result.id=Id.new(result.entity)
	result.isDrawable=true
		
	BaseEntity.init(result,options)
	return result
end

_.draw=function(entity)
	-- todo: opt
	local sprite=Img[entity.spriteName]
	LG.draw(sprite,entity.x,entity.y)
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