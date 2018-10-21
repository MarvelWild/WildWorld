local _={}

_.new=function(options)
	local result=BaseEntity.new()
	
	
	Entity.setSprite(result,"orangee1")
	result.entity="OrangeeTree"
	result.id=Id.new(result.entity)
	result.isDrawable=true
	result.growPhase=1
	result.isActive=false
	result.originX=7
	result.originY=27
	
	Taggable.addTag(result,"tree")
		
	BaseEntity.init(result,options)
	return result
end

_.draw=BaseEntity.draw

-- return sprite name
_.getSpriteForGrowPhase=function(phase)
	if phase<=22 then return "orangee"..tostring(phase) end
	
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