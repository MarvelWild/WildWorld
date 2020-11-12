-- server item entity

local _={}

_.entity_name=Pow.currentFile()

_.get_quantity=function(item)
	local result=item.quantity or 1
	return result
end


return _