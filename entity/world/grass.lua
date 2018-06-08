local _={}

_.new=function(options)
	local result=BaseEntity.new(options)
	
	local isProto=false
	if options then
		isProto = options.isProto or false
	end
	
	result.spriteName=Lume.randomchoice({"grass","grass2","grass3"})	
	result.entity="Grass"
	result.x=0
	result.y=0
	result.isDrawable=true
	
	if not isProto then
		result.id=Id.new("grass")
		Entity.register(result)
	end
	
	return result
end

_.draw=function(entity)
	-- todo: opt
	local sprite=Img[entity.spriteName]
	LG.draw(sprite,entity.x,entity.y)
end



return _