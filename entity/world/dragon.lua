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


-- managed by Entity
_.updateAi=function(entity)
--	local r=Lume.random() 
--	if r>0.1 then 
--		--log("not upd")
--		return 
--	end -- 50%?
	
--	log("pantera update ai")
--	local x=pantera.x+Lume.random(-200,200)
--	local y=pantera.y+Lume.random(-200,200)
--	local nextX=Lume.clamp(x,0,Config.levelWidth)
--	local nextY=Lume.clamp(y,0,Config.levelHeight)
	
--	local moveEvent=Event.new()
--	moveEvent.code="move"
--	moveEvent.x=nextX
--	moveEvent.y=nextY
--	moveEvent.duration=12
	
--	moveEvent.entity=pantera.entity
--	moveEvent.entityId=pantera.id
end


return _