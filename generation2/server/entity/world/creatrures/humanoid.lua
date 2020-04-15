-- server
local _={}

_.entity_name="humanoid"

local build_animation=function()
	local result={}
	
	local frames_walk={}
	result.walk=frames_walk
	
	local frame1={}
	frame1.sprite_name="player_7_walk_1"
	frame1.duration=30
	
	local frame2={}
	frame2.sprite_name="player_7_walk_2"
	frame2.duration=30
	
	
	table.insert(frames_walk,frame1)
	table.insert(frames_walk,frame2)
	
	result.idle=
	{
		{
			sprite_name="player_7",
			duration=nil
		}
	}
	
	return result
end



_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.x=0
	result.y=0
	
	result.name='Joe'
	result.level_name='start'
	
	result.footX=7
	result.footY=15
	
	
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
	
	
	
	result.sprite="player_7"
--	if _rnd(0,10)>5 then result.sprite="girl" end
	
	
	-- todo: presets
	if result.sprite=="player_7" then
		result.animation=build_animation()
	end
	
	
	
	
	BaseEntity.init_bounds_from_sprite(result)

	
	return result
end







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


local do_pickup=function(actor,entity)
	-- wip
	-- wip pin to hand
end


local try_pickup=function(actor,entity)
	log("try_pickup:".._ets(actor).." : ".._ets(entity))
	-- wip
	
	-- todo: generic pickable
	
	if entity.entity_name=="stone_1" then
		local r=do_pickup(actor,entity)
		if r then return true end
		
	end
	
	
end


_.interact=function(player,target)
	local target_code=Entity.get_code(target)
	
	local interact=target_code.interact
	if interact~=nil then
		interact(player,target)
	else
		try_pickup(player,target)
	end
end

return _