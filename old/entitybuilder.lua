-- билдер создан для достройки десериализованной сущности / инициализацию свежей
local _={}

local _builderByType={}

_builderByType.player=function(player)
	player.draw=function()
		LG.draw(player.sprite,player.x,player.y)
	end
	
	
	
end


_.build=function(e)
	if e.type=="player" then
		local a=1
	end
	
	
	if e.isBuilt then
		log("error:entity already built")
		return
	end
	
	
	local typedBuilder=_builderByType[e.type]
	if typedBuilder~=nil then
		typedBuilder(e)
		e.isBuilt=true
	end
	
	if e.spriteName~=nil then
		Entity.setSprite(e,e.spriteName)
	end
	
	
--	if not e.isBuilt then
--		log("error: failed to build entity:"..pack(e))
--	end

	e.isBuilt=true
	
end



return _