local _={}

_.new=function()
	local result={}
	
	result.isActive=true
	
	-- change via Entity.setDrawable
	result.isDrawable=false
	result.aiEnabled=false
	-- result.entity="" через это связь данных с утилитным кодом класса
	
	return result
end

_.init=function(entity,options)
	local isProto=false
	if options then
		isProto = options.isProto or false
	end
		
	if not isProto then
		entity.id=Id.new(entity.entity)
		Entity.register(entity)
	end
end



return _