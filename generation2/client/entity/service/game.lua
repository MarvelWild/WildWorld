-- main entity for game state
-- global GameService

local _=BaseEntity.new('game',true)
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
	drawBg()
	
	if GameState.lastState~=nil then
		local player=GameState.lastState.player
		if player~=nil then
			draw(Img.get("player"), player.x, player.y)
		end
	end
end

-- screen coord
_.mousepressed=function(x,y,button)
	log('mouse pressed:'..x..','..y..' b:'..button)
	
	if (button==1) then
		-- wip transform screen to game
		ClientService.move(x,y)
	end
	
end




return _