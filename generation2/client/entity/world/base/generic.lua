-- global Generic<-entity_name
-- обрабатываются сущности, не описанные явно
local _={}

_.entity_name=Pow.currentFile()
_.draw=function(entity)
	if entity.entity_name=="camel" then
		local a=1
	end
	
	local debugger_active=DebuggerService.is_active()
	if debugger_active then
		
		local debug_info=entity.id
		love.graphics.print(debug_info,entity.x,entity.y)
	end
	
	
	
	local color=entity.color
	if color then
		love.graphics.setColor(color.r,color.g,color.b)
		BaseEntity.draw(entity)
		love.graphics.setColor(1,1,1)
	else
		BaseEntity.draw(entity)	
	end
	
	
	
end




local animation_update=Animation_service.update_entity
_.update=function(dt,entity)
	
	if entity.animation then
		animation_update(entity)
	end
	
end
return _