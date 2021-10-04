local _={}

_.entity_name=Pow.currentFile()



local build_animation=function()
	local result={}
	
	local frames_idle={}
	result.idle=frames_idle
	
	local frame1={}
	frame1.sprite_name="crow/crow_eat_1"
	frame1.duration=30
	
	local frame2={}
	frame2.sprite_name="crow/crow_eat_2"
	frame2.duration=30

	table.insert(frames_idle,frame1)
	table.insert(frames_idle,frame2)
	
	result.eat=frames_idle
	
	-- todo
--	result.idle=frames_walk
	
	return result
end

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="crow/crow_eat_1"
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.foot_x=18
	result.foot_y=12
	
	
	result.mount_slots=nil
	
	result.move_speed=30
	
	result.animation=build_animation()
	
	return result
end

_.updateAi=function(entity)
--	Ai.moveRandom(entity)
end

--_.interact=Mountable.toggle_mount


return _