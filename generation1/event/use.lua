local _=function(event)
	local entity=Entity.find(event.entity, event.entityId,event.login)
	local entityCode=Entity.get(event.entity)
	if entityCode.use~=nil then
		log("use:"..entity.entity)
		entityCode.use(entity,event.x,event.y)
	else
		log("entity has no 'use' func:"..event.entity)
	end
end

return _