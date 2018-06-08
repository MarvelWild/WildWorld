local _={}

_.new=function()
	local result=BaseEntity.new()
	
	result.id=Id.new("seed")
	result.spriteName="seeds"
	result.entity="Seed"
	result.stackCount=42
	
	return result
end

_.use=function(seed,x,y)
	seed.stackCount=seed.stackCount-1
	-- todo: destroy on stack end
	
	log("Seed plant at:"..xy(x,y))
	
	local grass=Grass.new()
	grass.x=x
	grass.y=y
end



return _