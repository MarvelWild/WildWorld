-- main entity for game state
-- global GameService

local _=BaseEntity.new('game',true)
_.draw_layer=-1

_.start=function()
	log('GameService start','verbose')
	ClientService.start()
end

--opt: один раз получили левел, проставили спрайт
local drawBg=function()
--	log('drawBg','verbose',true)
	if (GameState.get()==nil) then return end
	
	-- todo: why container?
	local level_container=GameState.level
	local bgName=level_container.level.bg
	local bgSprite=Img.get("level/"..bgName)
	draw(bgSprite)
end

_.draw=function()
	drawBg()
end

_.mousePressed=function(gameX,gameY,button)
	log('mouse pressed:'..gameX..','..gameY..' b:'..button,'input')
	
	if (button==1) then
		ClientService.move(gameX,gameY)
	end
	
end

_.keyPressed=function(key)
	if key=="=" then
		Pow.zoomIn()
	elseif key=="-" then
		Pow.zoomOut()
	elseif key=="space" then
		ClientService.defaultAction()
	elseif key=="m" then
		ClientService.mount_dismount()
	elseif key=="u" then
		ClientService.use_item()
	end
	
end





return _