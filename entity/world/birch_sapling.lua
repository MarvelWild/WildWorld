local _={}

_.new=function(options)
	local result=BaseEntity.new()
	
	
	Entity.setSprite(result,"birch_sapling")
	result.entity="BirchSapling"
	result.id=Id.new(result.entity)
	result.stackCount=42
	result.isActive=false
	
	BaseEntity.init(result,options)
	return result
end

_.use=function(seed,x,y)
	seed.stackCount=seed.stackCount-1
	-- todo: destroy on stack end
	
	log("Seed plant at:"..xy(x,y))
	
	local spawned=BirchTree.new()
	spawned.x=x
	spawned.y=y
	
	Entity.placeInWorld(spawned)
	Entity.transferToServer({spawned})
end



return _