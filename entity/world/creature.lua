-- WIP: move common logic, inherit pantera and sheep from here?
local _={}

_.new=function()
	local result=BaseEntity.new()
	
	result.id=Id.new("creature")
	result.entity="Creature"
	result.x=0
	result.y=0
	result.spriteName="creature"
	result.isDrawable=true
	
	Entity.register(result)
	
	return result
end

_.draw=function(creature)
	local sprite=Img[creature.spriteName]
	LG.draw(sprite,creature.x,creature.y)
end

--_.update=function(pantera,dt)
--	log("pantera update ")
-- yes, it working
--end


-- managed by Entity
_.updateAi=function(creature)
	local r=Lume.random() 
	if r>0.1 then 
		--log("not upd")
		return 
	end -- 50%?
	
	log("pantera update ai")
	local nextX=creature.x+Lume.random(-20,20)
	local nextY=creature.y+Lume.random(-20,20)
	
	local moveEvent=Event.new()
	moveEvent.code="move"
	moveEvent.x=nextX
	moveEvent.y=nextY
	moveEvent.duration=6
	
	moveEvent.entity=creature.entity
	moveEvent.entityId=creature.id
end


---- i need to place them somehow.. some generic
--_.use=function(pantera,x,y)
--	log("Place pantera at:"..xy(x,y))
	


return _