local _={}

_.entity_name=Pow.currentFile()

_.draw=BaseEntity.draw

_.draw_ui=function(entity)
	-- todo: in debug mode
	
	-- opt: do it once on player receive
	local controlled_entity=_deref(entity.controlled_entity_ref)
	
	love.graphics.print("hp:".._n(controlled_entity.hp))
	love.graphics.print("energy:".._n(controlled_entity.energy), 0, 12)
end


return _