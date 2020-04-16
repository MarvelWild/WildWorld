-- shared
--[[
duck typing:
]]--
local _={}

_.do_grow=function(entity,sprite_name)
--	log("Growable.do_grow. sprite:"..sprite_name.." ent:"..Inspect(entity))
	entity.sprite=sprite_name
	entity.grow_phase_index=entity.grow_phase_index+1
end


return _