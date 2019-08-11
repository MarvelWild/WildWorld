-- main entity for game state
-- global GameService

local _=BaseEntity.new('game',true)
_.drawLayer=-1

_.start=function()
	log('GameService start','verbose')
	ClientService.start()
end

local drawBg=function()
--	log('drawBg','verbose',true)
	if (GameState.get()==nil) then return end
	
	local level=GameState.level
	local bgName=level.bg
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
	end
	
end





return _