local _={}

_.new=function(options)
	local result=BaseEntity.new()
	
	
	Entity.setSprite(result,"tree_apple_1")
	result.entity="AppleTree"
	result.id=Id.new(result.entity)
	result.isDrawable=true
	result.growPhase=1
	result.isActive=false
	result.originX=15
	result.originY=46
	
	Taggable.addTag(result, "tree")
		
	BaseEntity.init(result,options)
	return result
end

_.draw=BaseEntity.draw

_.getSpriteForGrowPhase=function(phase)
	if phase==1 then return "tree_apple_1" end
	if phase==2 then return "tree_apple_2" end
	if phase==3 then return "tree_apple_3" end
	if phase==4 then return "tree_apple_4" end
	if phase==5 then return "tree_apple_5" end
	if phase==6 then return "tree_apple_6" end
	if phase==7 then return "tree_apple_7" end
	if phase==8 then return "tree_apple_8" end
	if phase==9 then return "tree_apple_9" end
	if phase==10 then return "tree_apple_10" end

	return nil
end


if Session.isServer then
	_.slowUpdate=function(entity)
--		log("fir tree slow update")
		
		-- можно попробовать на активации на сервере вешаться на какой либо медленный таймер
		local rnd=Lume.random()
		if rnd>0.9 then
			GrowableBehaviour.grow(entity)
		end
		
	end
end



return _