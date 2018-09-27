-- global Taggable
local _={}

--does not checks if exists
_.addTag=function(entity,tag)
--	if entity.tags==nil then
--		local a=1
--	end
	
	
	table.insert(entity.tags, tag)
end

_.isTagged=function(entity, tag)
	local key=Lume.find(entity.tags,tag)
	local result=key~=nil
	return result
end





return _