local _={}

_.new=function(options)
	local result=BaseEntity.new()
	
	
	Entity.setSprite(result,"tree_fir_1")
	result.entity="FirTree"
	result.id=Id.new(result.entity)
	result.isDrawable=true
	result.growPhase=1
	result.isActive=false
	result.originX=16
	result.originY=60
	
	Taggable.addTag(result,"tree")
		
	BaseEntity.init(result,options)
	return result
end

_.draw=BaseEntity.draw

_.getSpriteForGrowPhase=function(phase)
	if phase==1 then return "tree_fir_1" end
	if phase==2 then return "tree_fir_2" end
	if phase==3 then return "tree_fir_3" end
	if phase==4 then return "tree_fir_4" end
	if phase==5 then return "tree_fir_5" end

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