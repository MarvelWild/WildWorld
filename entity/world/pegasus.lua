local _={}

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.entity="Pegasus"
	result.x=0
	result.y=0
	Entity.setSprite(result,"pegasus")
	result.isDrawable=true
	result.aiEnabled=Session.isServer
	result.isMountable=true
	
	BaseEntity.init(result,options)
	
	return result
end

_.draw=function(entity)
	local sprite=Img[entity.spriteName]
	LG.draw(sprite,entity.x,entity.y)
end

--_.update=function(pantera,dt)
--	log("pantera update ")
-- yes, it working
--end


local _ai=require("misc/ai/pantera_ai")

-- managed by Entity
_.updateAi=_ai


return _