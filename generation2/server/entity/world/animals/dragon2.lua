local _={}

_.entity_name=Pow.currentFile()


local build_animation=function()
	local result={}
	
	local frames_idle={}
	result.idle=frames_idle
	
	local frame1={}
	frame1.sprite_name="dragon_stand1"
	frame1.duration=30
	
	local frame2={}
	frame2.sprite_name="dragon_stand2"
	frame2.duration=30
	
	local frame3={}
	frame3.sprite_name="dragon_stand3"
	frame3.duration=30
	
	local frame4={}
	frame4.sprite_name="dragon_stand4"
	frame4.duration=30
	
	local frame5={}
	frame5.sprite_name="dragon_stand5"
	frame5.duration=30
	
	
	table.insert(frames_idle,frame1)
	table.insert(frames_idle,frame2)
	table.insert(frames_idle,frame3)
	table.insert(frames_idle,frame4)
	table.insert(frames_idle,frame5)
	
--	result.idle=
--	{
--		{
--			sprite_name="phoenix_sit",
--			duration=nil
--		}
--	}
	
	-- todo
--	result.idle=frames_walk
	
	return result
end -- build_animation

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	-- todo: animation
	result.sprite="dragon_stand1"
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.foot_x=62
	result.foot_y=64
	
	
	result.mount_slots=
	{
		{
			x=56,
			y=25,
			rider=nil,
		},
	}
	
	Mountable.init(result)
	
	result.move_speed=100
	
	result.animation=build_animation()
	
	return result
end

_.updateAi=function(entity)
	Ai.moveRandom(entity)
end

_.interact=Mountable.toggle_mount


return _