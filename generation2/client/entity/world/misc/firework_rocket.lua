local _={}

_.entity_name=Pow.currentFile()


_.draw=BaseEntity.draw

_.update=Generic.update

_.on_move_complete=function(entity)
	log("on_move_complete rocket client")
	VfxService.flying("firework_explosion",entity.x,entity.y)
end

return _