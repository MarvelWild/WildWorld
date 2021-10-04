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
	
	result.foot_x=7
	result.foot_y=15
	
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
	
	result.origin_x=7
	result.origin_y=7
	
	
	
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




local try_pickup=function(actor,entity)
	log("try_pickup:".._ets(actor).." : ".._ets(entity))
	-- todo: generic pickable
	
	if entity.carried_by~=nil then return end

	if not entity.is_item then return end
	
	
	local result=Carrier.do_pickup(actor,entity)
	return result
end


-- todo: player получать из entity как управляющую ей сущность
_.interact=function(entity,target,player)
	local target_code=Entity.get_code(target)
	
	local interact=target_code.interact
	if interact~=nil and interact~=_.interact then
		return interact(entity,target,player)
	else
		return try_pickup(entity,target)
	end
end




local is_enemy=function(entity,other)
	if other.entity_name=="zombie" then
		return true
	end
	
	return false
end

local ai_options={
	attack_only=true
}
_.updateAi=function(entity)
	if Ai.update_combat(entity, is_enemy, ai_options) then return end
end

return _