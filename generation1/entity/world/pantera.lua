local _={}

_.name="Pantera"

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.x=0
	result.y=0
	
	result.mountX=12
	result.mountY=5	
	
	result.originX=15
	result.originY=7	
	
	result.footX=15
	result.footY=11
	
	
	Entity.setSprite(result,"pantera")
	result.isDrawable=true
	-- todo: move to afterCreated
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