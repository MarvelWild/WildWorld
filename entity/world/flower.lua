local _={}

_.name="Flower"

_.new=function(options)
	local result=BaseEntity.new(options)
	
	local isProto=false
	if options then
		isProto = options.isProto or false
	end
	
	local spriteName=Lume.randomchoice({"flower_yellow", "flower_yellow_2","flower_red","blueberry","strawberry",
			"carrot_small","wheat_1","cactus_1", "watermelon",
			"bush_1","grass_1","grass_2","grass_3",
			"grass_4","grass_5","grass_6","grass_7","flower_camella", "mushroom_1","wheat_2"})
	
	Entity.setSprite(result,spriteName)
	result.x=0
	result.y=0
	result.isDrawable=true
	
	Entity.afterCreated(result,_,options)
	
	return result
end

_.draw=DrawableBehaviour.draw



return _