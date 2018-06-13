local _={}

_.new=function(options)
	local result={}
	
	result.isActive=true
	
	-- change via Entity.setDrawable 
	result.isDrawable=false
	result.aiEnabled=false
	
	-- assert(Session.login~=nil) -- defaultLogin by default
	result.login=Session.login
	result.isRemote=false
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