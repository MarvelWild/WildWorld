-- server
local _={}

_.entity_name="phoenix"

local build_animation=function()
	local result={}
	
	local frames_walk={}
	result.walk=frames_walk
	
	local frame1={}
	frame1.sprite_name="phoenix_fly1"
	frame1.duration=30
	
	local frame2={}
	frame2.sprite_name="phoenix_fly2"
	frame2.duration=30
	
	local frame3={}
	frame3.sprite_name="phoenix_fly3"
	frame3.duration=30
	
	local frame4={}
	frame4.sprite_name="phoenix_fly4"
	frame4.duration=30
	
	
	table.insert(frames_walk,frame1)
	table.insert(frames_walk,frame2)
	table.insert(frames_walk,frame3)
	table.insert(frames_walk,frame4)
	
	result.idle=
	{
		{
			sprite_name="phoenix_fly1",
			duration=nil
		}
	}
	
	-- wip
--	result.idle=frames_walk
	
	return result
end



_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.x=0
	result.y=0
	
	result.name='Joe'
	result.level_name='start'
	
	result.foot_x=7
	result.foot_y=15
	
	result.mountX=7
	result.mountY=15
	
	result.hand_x=10
	result.hand_y=7
		
		
	result.hand_x_2=8
	result.hand_y_2=9
	
	
	
	-- collision sqquare start
	result.collisionX=3
	result.collisionY=0
	
	-- todo: collision end
	
	
	-- used for collisions
	result.w=9
	result.h=16
	
	result.riderX=7
	result.riderY=11
	
	result.hp=10
	result.hp_max=10
	
	result.energy=100
	result.energy_max=100
	
	-- ref? to pinned item
	result.hand_slot=nil
	result.hand_slot_2=nil
	
	
	
	result.sprite="phoenix_fly1"
--	if _rnd(0,10)>5 then result.sprite="girl" end
	
	
	-- todo: presets
	if result.sprite=="phoenix_fly1" then
		result.animation=build_animation()
	end
	
	
	
	
	BaseEntity.init_bounds_from_sprite(result)

	
	return result
end




_.updateAi=function(entity)
	AiService.moveRandom(entity)
end

_.interact=Mountable.toggle_mount



--local take_damage=function(player)
--	-- todo detect damage source
	
--	local collsions=CollisionService.getEntityCollisions(player)
--	for k,entity in pairs(collsions) do
--		log("collision:".._ets(entity))
--		-- todo
		
--	end
	
	
--end


--_.update=function(dt,player)
----	take_damage(player)
--end


return _