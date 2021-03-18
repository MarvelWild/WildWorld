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
			sprite_name="phoenix_sit",
			duration=nil
		}
	}
	
	-- todo
--	result.idle=frames_walk
	
	return result
end -- build_animation



_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	-- дата
	
	result.x=0
	result.y=0
	
	result.sprite="phoenix_sit"
	
	result.foot_x=35
	result.foot_y=28
	
	
	result.mount_slots=
	{
		{
			x=27,
			y=12,
			rider=nil,
		},
	}
	
	result.riderX=7
	result.riderY=11

	-- код
	
	BaseEntity.init_bounds_from_sprite(result)

	result.animation=build_animation()
	
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