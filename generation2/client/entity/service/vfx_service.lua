-- visual effects service

local _entity_name='VfxService'
local _=BaseEntity.new(_entity_name, true)



-- тут храним активные эффекты
local _vfx={}

-- duration - кол-во фреймов, за которое происходит эффект
local new_effect=function(name,x,y,duration)
	
	if not duration then duration=60 end
	
	local image=Img.get(name)
	local effect={}
	effect.image=image
	effect.x=x
	effect.y=y
	effect.dx=0.1
	effect.dy=-0.3
	
	local frame=Pow.get_frame()
	effect.last_frame=frame+duration
	
	table.insert(_vfx,effect)
	return effect
end


-- летающий объект например сердечко вылетело
_.flying=function(name,x,y)
	local effect=new_effect(name,x,y)
end



local _to_delete={}

_.update=function()
	-- log("vfx service update")
	
	
	
	for index,effect in pairs(_vfx) do
		effect.x=effect.x+effect.dx
		effect.y=effect.y+effect.dy
		
		local frame=Pow.get_frame()
		if frame>effect.last_frame then
			table.insert(_to_delete,index)
		end
	end
	
	for i,index_to_delete in pairs(_to_delete) do
		table.remove(_vfx,index_to_delete)
	end
	
	table.clear(_to_delete)
end

_.draw=function()
	for index,effect in pairs(_vfx) do
		love.graphics.draw(effect.image,effect.x,effect.y)
	end
end

return _