local _=BaseEntity.new("debugger_service",true)

local _isActive=false




local debug_to_string=function(entity)
	local r=_ets(entity)
	
	local animation=entity.animation
	if animation then
		r=r.." anim state:"..tostring(entity.animation.state)
	end
	
	return r
end


-- substates

--- todo: implement convenient table browser
-- zbs is fine, just need easy way to put anythng from game to zbs

local state_explore_table={}


local state_show_all_entities={}
state_show_all_entities.draw=function()

	local state=GameState.get()
	if not state then return end
	
	
	local message=""
	
	for entity_name,entity_container in pairs(state.level.entities) do
		for k,entity in pairs(entity_container) do
		
			message=message..debug_to_string(entity).."\n"
		end
	end
	
	love.graphics.print(message,0,50)
end


local _state=state_show_all_entities

-- substates end




_.is_active=function()
	return _isActive
end


local toggleActive=function()
	_isActive=not _isActive

	if _isActive then
		-- init
	end
	
end


local on_key_pressed=function(key)
end


_.keyPressed=function(key)
	if key=="f12" then
		toggleActive()
	elseif _isActive then
		on_key_pressed(key)
	end
end



_.draw_overlay=function()
	if _isActive then
		local message="debugger active."
		love.graphics.print(message)
		
		_state.draw()
	end
end



return _




