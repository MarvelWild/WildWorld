local _={}

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.entity="Pantera"
	result.x=0
	result.y=0
	Entity.setSprite(result,"pantera")
	result.isDrawable=true
	result.aiEnabled=Session.isServer
	
	BaseEntity.init(result,options)
	
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