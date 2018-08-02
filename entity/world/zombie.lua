local _={}

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.entity="Zombie"
	result.x=0
	result.y=0
	Entity.setSprite(result,"zombie_1")
	result.isDrawable=true
	result.aiEnabled=true
	
	BaseEntity.init(result,options)
	
	return result
end

_.draw=function(entity)
	local sprite=Img[entity.spriteName]
	LG.draw(sprite,entity.x,entity.y)
end


-- managed by Entity
_.updateAi=function(entity)
	
	-- log("sheep update ai")
--	local nextX=sheep.x+Lume.random(-20,20)
--	local nextY=sheep.y+Lume.random(-20,20)
	local nextX=World.player.x+Lume.random(-40,40)
	local nextY=World.player.y+Lume.random(-40,40)
	
	local moveEvent=Event.new()
	moveEvent.code="move"
	moveEvent.x=nextX
	moveEvent.y=nextY
	moveEvent.duration=6
	
	moveEvent.entity=entity.entity
	moveEvent.entityId=entity.id
end


return _