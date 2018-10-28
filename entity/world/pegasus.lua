local _={}

_.name="Pegasus"

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.x=0
	result.y=0
	
	result.mountX=27
	result.mountY=31
	
	result.originX=27
	result.originY=31	
	
	result.footX=22
	result.footY=46
	
	Entity.setSprite(result,"pegasus")
	result.isDrawable=true
	result.aiEnabled=Session.isServer
	result.isMountable=true
	
	Entity.afterCreated(result,_,options)
	
	return result
end

_.draw=DrawableBehaviour.draw

--_.update=function(pantera,dt)
--	log("pantera update ")
-- yes, it working
--end


local _ai=require("misc/ai/pantera_ai")

-- managed by Entity
_.updateAi=_ai


return _