-- emitter: Entity.notifyUpdated

local _updateValues=Entity.updateValues

local _=function(event)
	log("entities_updated event")
	
	local entities=event.entities
	for k,entity in pairs(entities) do
		_updateValues(entity)
	end
end

return _