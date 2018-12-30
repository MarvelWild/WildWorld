local _={}

_.name="BirchSapling"

_.new=function(options)
	local result=BaseEntity.new(options)
	
	Entity.setSprite(result,"birch_sapling")
	
	result.stackCount=42
	result.isActive=false
	
	Entity.afterCreated(result,_,options)
	return result
end

_.use=function(seed,x,y)
	seed.stackCount=seed.stackCount-1
	-- todo: destroy on stack end
	
	log("Seed plant at:"..xy(x,y))
	
	local spawned
	local rnd=Lume.random()
	if rnd>0.8 then
		spawned=BirchTree.new()
	elseif rnd>0.6 then
		spawned=AppleTree.new()
	elseif rnd>0.4 then
		spawned=FirTree.new()
	else
		spawned=OrangeeTree.new()		
	end
	
	if spawned==nil then
		local a=1
	end
	spawned.x=x-spawned.originX
	spawned.y=y-spawned.originY
	
	Entity.placeInWorld(spawned)
	Entity.transferToServer({spawned})
end



return _