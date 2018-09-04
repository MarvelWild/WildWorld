local _={}

_.name="World"

_.new=function()
	local entity=BaseEntity.new()
	entity.editorVisible=false
	entity.isDrawable=false
	entity.isInWorld=false

	entity.entity="World"
	
	BaseEntity.init(entity)
	return entity
end

-- todo: register, name conflict

return _