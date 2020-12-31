-- shared


local _={}

_.set_state=function(actor,state)
	local animation=actor.animation
	if animation then
		local actor_text=_ets(actor)
		log("animation start:"..state.." for:"..actor_text, "verbose")
		
		local entity_animation_state=actor.animation_state
		animation.state=state
		
		if entity_animation_state then
			entity_animation_state.next_game_frame=_frm()
		end
		
	end
end


return _