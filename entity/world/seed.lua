local _={}

_.new=function()
	local result=BaseEntity.new()
	
	
	result.spriteName="seeds"
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
	
	local grass=Grass.new()
	grass.x=x
	grass.y=y
	
	Entity.transferToServer({grass})
end



return _