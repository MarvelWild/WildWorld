local _={}

_.new=function(options)
	local result=BaseEntity.new()
	
	result.entity="Pantera"
	result.x=0
	result.y=0
	result.spriteName="pantera"
	result.isDrawable=true
	result.aiEnabled=true
	
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
	local r=Lume.random() 
	if r>0.2 then 
		--log("not upd")
		return 
	end -- 50%?
	
	log("pantera update ai")
	local nextX=pantera.x+Lume.random(-20,20)
	local nextY=pantera.y+Lume.random(-20,20)
	
	local moveEvent={}
	moveEvent.code="move"
	moveEvent.x=nextX
	moveEvent.y=nextY
	moveEvent.duration=6
	
	moveEvent.entity=pantera.entity
	moveEvent.entityId=pantera.id
	
	Event.new(moveEvent)
end


return _