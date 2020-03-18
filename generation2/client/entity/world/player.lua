local _={}


_.draw=BaseEntity.draw

_.draw_ui=function(entity)
	-- todo: in debug mode
	love.graphics.print("hp:".._n(entity.hp))
	love.graphics.print("energy:".._n(entity.energy), 0, 12)
end


return _