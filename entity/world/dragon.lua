local _={}

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.entity="Dragon"
	result.x=0
	result.y=0
	Entity.setSprite(result,"dragon")
	result.isDrawable=true
	result.aiEnabled=Session.isServer
	result.isMountable=true
	result.mountX=11
	result.mountY=16
	
	BaseEntity.init(result,options)
	
	return result
end

_.draw=DrawableBehaviour.draw

--_.update=function(pantera,dt)
--	log("pantera update ")
-- yes, it working
--end


-- managed by Entity
_.updateAi=function(entity)
end


return _