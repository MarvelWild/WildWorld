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

_.draw=function(pantera)
	local sprite=Img[pantera.spriteName]
	LG.draw(sprite,pantera.x,pantera.y)
end

--_.update=function(pantera,dt)
--	log("pantera update ")
-- yes, it working
--end


-- managed by Entity
_.updateAi=function(pantera)
--	local r=Lume.random() 
--	if r>0.1 then 
--		--log("not upd")
--		return 
--	end -- 50%?
	
--	log("pantera update ai")
	local x=pantera.x+Lume.random(-200,200)
	local y=pantera.y+Lume.random(-200,200)
	local nextX=Lume.clamp(x,0,Config.levelWidth)
	local nextY=Lume.clamp(y,0,Config.levelHeight)
	
	local moveEvent=Event.new()
	moveEvent.code="move"
	moveEvent.x=nextX
	moveEvent.y=nextY
	moveEvent.duration=12
	
	moveEvent.entity=pantera.entity
	moveEvent.entityId=pantera.id
end


return _