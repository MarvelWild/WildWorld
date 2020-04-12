local _={}

_.entity_name=Pow.currentFile()
_.draw=BaseEntity.draw


local animation_update=Animation_service.update_entity

_.update=function(dt,entity)
	animation_update(entity)
end

return _