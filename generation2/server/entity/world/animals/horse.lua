local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="horse_small"
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.foot_x=17
	result.foot_y=22
	
	result.mountX=17
	result.mountY=16
	
	result.move_speed=28
	
	return result
end

_.updateAi=function(entity)
	if entity.mounted_by==nil then
		AiService.moveRandom(entity)
	end
end


local eat_from_hand=function(actor, target)

	Carrier.remove_from_hand(actor)
	log("horse fed")
	
	-- +удалить из мира яблоко
	-- todo: удалить из руки яблоко на клиенте - проверить
	-- лошадь - увеличить привязанность
	-- лошадь - показать сердечко
end


-- с нами взаимодействует entity
_.interact=function(actor, target)
	-- wip feed apple or
	-- Mountable.toggle_mount
	
	local hand_ref=actor.hand_slot
	if hand_ref then
		-- todo: описать группу съедобных для лошади
		if hand_ref.entity_name=="apple" then
			eat_from_hand(actor, target)
			return
		end
	end
		
	Mountable.toggle_mount(actor,target)
	
end




return _