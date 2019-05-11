local _={}

_.new=function()
	local result=BaseEntity.new("player")
	
	result.name='Joe'
	result.level='start'
	
	-- todo это свойства спрайта
	result.footX=7
	result.footY=15
	
	return result
end


return _