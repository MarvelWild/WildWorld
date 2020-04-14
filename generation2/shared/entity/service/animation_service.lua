-- shared


local _={}

_.set_state=function(actor,state)
	local animation=actor.animation
	if animation then
--		log("animation start:"..state)
		
		local entity_animation_state=actor.animation_state
		animation.state=state
		
		if entity_animation_state then
			entity_animation_state.next_game_frame=_frm()
		end
		
	end
end


return _