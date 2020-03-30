local _=BaseEntity.new("animation_service",true)


local _animation_states={}


_.update_entity=function(entity)
	log("anim service update_entity:".._ets(entity))
	-- wip: detect animation state
	
	local animation_state="walk"
	
	local entity_animation=entity.animation
	
	-- contains frames for current state
	local state_animation=entity_animation[animation_state]
	
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
		entity_animation_state.next_game_frame=current_frame+first_animation_frame.duration
		entity.sprite=first_animation_frame.sprite_name
	end
	
	
	
	local next_frame=entity_animation_state.next_game_frame
	if next_frame==current_frame then
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
		entity_animation_state.next_game_frame=current_frame+next_anim_frame.duration
		entity.sprite=next_anim_frame.sprite_name
		
		
	else
		-- not time for next frame
	end
end



return _