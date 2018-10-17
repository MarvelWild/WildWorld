local _={}

_.new=function(options)
	local result=BaseEntity.new()
	
	
	Entity.setSprite(result,"seeds")
	result.entity="Seed"
	result.id=Id.new(result.entity)
	result.stackCount=42
	
	BaseEntity.init(result,options)
	return result
end

_.use=function(seed,x,y)
	seed.stackCount=seed.stackCount-1
	-- todo: destroy on stack end
	
	log("Seed plant at:"..xy(x,y))
	
	local rnd=love.math.random()
	
	local placeable
	if rnd<0.5 then
		placeable=Grass.new()
	else
		placeable=Flower.new()
	end
	
	
	placeable.x=x
	placeable.y=y
	
	-- Entity.setActive(grass,true) placeInWorld does it
	Entity.placeInWorld(placeable)
	Entity.transferToServer({placeable})
end



return _