local _={}

local _container={}

_.add=function(entity)
	assert(entity)
	local entityName=entity.entity
	
	local entityContainer=_container[entityName]
	if entityContainer==nil then
		entityContainer={}
		_container[entityName]=entityContainer
	end
	
	table.insert(entityContainer, entity)
	-- wip
	
end


_.save=function()
	-- wip
end

_.load=function()
	-- wip
end






return _