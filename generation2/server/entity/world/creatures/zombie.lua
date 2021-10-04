-- server
local _={}

local _entity_name=Pow.currentFile()
_.entity_name=_entity_name

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="zombie_1"
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.foot_x=3
	result.foot_y=14
	
	result.origin_x=3
	result.origin_y=7
	
	result.hp=6
	result.attack_damage=0.1
	
	result.move_speed=7
	
	
	return result
end

local is_enemy=function(entity,other)
	--todo: все живые
	if other.entity_name=="humanoid" then
		return true
	end
	
	return false
end







_.updateAi=function(entity)
	if Ai.update_combat(entity, is_enemy) then return end
	
	-- todo: рандомно двигаться медленнее, преследовать быстрее
	Ai.moveRandom(entity)
end



--_.interact=Mountable.toggle_mount

return _