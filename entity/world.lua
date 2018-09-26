
local _={}

_.name="World"

_.new=function()
	local entity=BaseEntity.new()
	entity.editorVisible=false
	entity.isDrawable=false
	entity.isInWorld=false

	entity.entity="World"
	entity.name="New world"
	
	BaseEntity.init(entity)
	return entity
end


return _