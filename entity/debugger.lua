local _={}


_.new=function()
	local r=BaseEntity.new()
	r.entity="Debugger"
	r.isActive=false
	r.isUiDrawable=false --4x
	r.isScaledUiDrawable=true -- 1x
	
	Entity.register(r)
	
	return r
end

_.drawScaledUi=function(debugger)
	LG.print("debugger")
	love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 0, 70)
	love.graphics.printf("Player: "..Util.debugPrint(World.player), 0, 94,Session.windowWidth)
	
	local x=love.mouse.getX()
	local y=love.mouse.getY()
	local gameX,gameY=Cam:toWorld(x,y)
	love.graphics.print("Mouse: "..xy(gameX,gameY), 0, Session.windowHeight-24)		

end




return _