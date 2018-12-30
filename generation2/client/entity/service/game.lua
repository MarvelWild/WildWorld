-- main entity for game state

local _=BaseEntity.new()
_.isService=true


_.start=function()
	log('GameService start')
	ClientService.start()
end


_.draw=function()
	draw(Img.get("player"))
end



return _