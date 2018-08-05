local _={}

_.new=function(options)
	local result={}
	
	result.isActive=false
	result.x=0
	result.y=0
	
	-- default point of attachment
	result.originX=0
	result.originY=0
	
	result.w=0
	result.h=0
	
	-- change via Entity.setDrawable 
	result.isDrawable=false
	result.aiEnabled=false
	
	-- такие в будущем будут неинтерактивны, например подняли/положили предмет и ждём подтверждения от сервера
	result.isTransferring=nil
	result.isInWorld=false
	result.isFlying=false
	result.canPickup=false
	result.isMountable=nil
	
	-- entityRef or nil
	result.mountedBy=nil
	result.mountedOn=nil
	
	-- assert(Session.login~=nil) -- defaultLogin by default
	result.login=Session.login
	result.isRemote=false
	result.spriteName=nil -- use Entity.setSprite
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