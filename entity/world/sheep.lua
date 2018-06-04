local _={}

_.new=function(options)
	local result=BaseEntity.new()
	
	result.entity="Sheep"
	result.x=0
	result.y=0
	result.spriteName="sheep2"
	result.isDrawable=true
	result.aiEnabled=true
	
	BaseEntity.init(result,options)
	
	return result
end

_.draw=function(sheep)
	local sprite=Img[sheep.spriteName]
	LG.draw(sprite,sheep.x,sheep.y)
end


-- managed by Entity
_.updateAi=function(sheep)
	
	-- log("sheep update ai")
--	local nextX=sheep.x+Lume.random(-20,20)
--	local nextY=sheep.y+Lume.random(-20,20)
	local nextX=World.player.x+Lume.random(-40,40)
	local nextY=World.player.y+Lume.random(-40,40)
	
	local moveEvent={}
	moveEvent.code="move"
	moveEvent.x=nextX
	moveEvent.y=nextY
	moveEvent.duration=6
	
	moveEvent.entity=sheep.entity
	moveEvent.entityId=sheep.id
	
	Event.new(moveEvent)
end


return _