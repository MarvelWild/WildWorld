-- main entity for game state

local _=BaseEntity.new()
_.isService=true


_.start=function()
	log('GameService start')
	ClientService.start()
end

local drawBg=function()
	if (GameState.lastState==nil) then return end
	
	local level=GameState.level
	local bgName=level.bg
	local bgSprite=Img.get("level/"..bgName)
	draw(bgSprite)
	local a=1;
end

_.draw=function()
	draw(Img.get("player"))
	
	drawBg()
end



return _