local _={}


_.new=function()
	local r={}
	r.entity="Debugger"
	r.isActive=false
	r.isUiDrawable=false --4x
	r.isScaledUiDrawable=true -- 1x
	
	Entity.register(r)
	
	return r
end

_.drawScaledUi=function(debugger)
	LG.print("debugger")
	love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 100, 22)
	love.graphics.printf("Player: "..Util.debugPrint(World.player), 0, 44,Session.windowWidth)
	
	local x=love.mouse.getX()
	local y=love.mouse.getY()
	local gameX,gameY=Cam:toWorld(x,y)
	love.graphics.print("Mouse: "..xy(gameX,gameY), 0, Session.windowHeight-24)		

end


--[[
local initDebugger=function(debugger)
	debugger.type="debugger"
	debugger.isActive=false
	debugger.drawUi=function()
		LG.print("debugger")
		love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 0, 22)
		love.graphics.print("Player: "..pack(Player), 0, 44)
		
		local x=love.mouse.getX()
		local y=love.mouse.getY()
		local gameX,gameY=Cam:toWorld(x,y)
		love.graphics.print("Mouse: "..xy(gameX,gameY), 0, 66)
	end
end


local newDebugger=function()
	local result=Entity.new(initDebugger)
	return result
end


return newDebugger

]]--

return _