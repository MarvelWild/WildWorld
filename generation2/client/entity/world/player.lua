-- controlling entity represents physical player, but no ingame entity directly

local _={}

_.entity_name=Pow.currentFile()

_.draw=BaseEntity.draw

_.draw_ui=function(entity)
	-- todo: in debug mode
	
	-- opt: do it once on player receive
	local controlled_entity=_deref(entity.controlled_entity_ref)
	
--	love.graphics.print("hp:".._n(controlled_entity.hp))
--	love.graphics.print("energy:".._n(controlled_entity.energy), 0, 12)
end

-- c - craft
_.keyPressed=function(key)
	if key=="c" then
		log("craft start")
		local event=Event.new()
		-- craft start - request what we can craft
		event.code="craft"
		event.target="server"
		Event.process(event)
	end
end


return _