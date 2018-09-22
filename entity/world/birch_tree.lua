local _={}

_.new=function(options)
	local result=BaseEntity.new()
	
	
	Entity.setSprite(result,"birch_tree_1")
	result.entity="BirchTree"
	result.id=Id.new(result.entity)
	result.isDrawable=true
	result.growPhase=1
	result.isActive=false
	result.originX=8
	result.originY=15
	
	Entity.addTag(result,"tree")
		
	BaseEntity.init(result,options)
	return result
end

_.draw=BaseEntity.draw

_.getSpriteForGrowPhase=function(phase)
	if phase==1 then return "birch_tree_1" end
	if phase==2 then return "birch_tree_2" end
	if phase==3 then return "birch_tree_3" end
	if phase==4 then return "birch_tree_4" end
	if phase==5 then return "birch_tree_5" end

	return nil
end


if Session.isServer then
	_.slowUpdate=function(entity)
--		log("birch tree slow update")
		
		-- можно попробовать на активации на сервере вешаться на какой либо медленный таймер
		local rnd=Lume.random()
		if rnd>0.9 then
			GrowableBehaviour.grow(entity)
		end
		
	end
end



return _