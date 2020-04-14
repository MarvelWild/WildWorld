-- client

local _=BaseEntity.new("animation_service",true)


-- local _animation_states={}


_.update_entity=function(entity)
--	log("anim service update_entity:".._ets(entity))
	
	local entity_animation=entity.animation
	
--	local animation_state="walk"
	local animation_state=entity_animation.state
	
	if not animation_state then 
		-- todo: return to
		-- idle/default sprite
		return
	end
	
	
	if animation_state=="idle" then
		nop()
	end	
	
	if animation_state=="walk" then
		nop()
	end
	
	-- contains frames for current state
	local state_animation=entity_animation[animation_state]
	
	if state_animation==nil then
		-- todo: back to idle / define idle state dyn
		return
	end
	
	
	local entity_animation_state=entity.animation_state
	
	local current_frame=_frm()
	
	if entity_animation_state==nil then  
		entity_animation_state={}
		entity.animation_state=entity_animation_state
		
		local first_animation_frame=state_animation[1]
		
		-- todo: function
		-- duck typing: introducing animation_state.current_frame_number
		entity_animation_state.current_frame_index=1
		entity_animation_state.current_frame=first_animation_frame
		
		local duration=first_animation_frame.duration
		if duration then
			entity_animation_state.next_game_frame=current_frame+duration
		end
		
		Entity.set_sprite(entity,first_animation_frame.sprite_name)
	end
	
	
	
	local next_frame=entity_animation_state.next_game_frame
	if next_frame and next_frame<=current_frame then
		-- switch to next frame
		local current_animation_frame_index=entity_animation_state.current_frame_index
		local next_anim_index=current_animation_frame_index+1
		
		local next_anim_frame=state_animation[next_anim_index]
		if not next_anim_frame then
			-- restart loop
			next_anim_index=1
			next_anim_frame=state_animation[1]
		end
		
		
		entity_animation_state.current_frame_index=next_anim_index
		entity_animation_state.current_frame=next_anim_frame
		
		local duration=next_anim_frame.duration
		if duration then
			entity_animation_state.next_game_frame=current_frame+duration
		else
			entity_animation_state.next_game_frame=nil
		end
	
		
		
		Entity.set_sprite(entity, next_anim_frame.sprite_name)
		
	else
		-- not time for next frame
	end
end



return _