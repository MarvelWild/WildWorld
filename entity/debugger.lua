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
	--Util.debugPrint(World.player)
	love.graphics.printf("Player: "..Entity.toString(World.player), 0, 94,Session.windowWidth)
	
	local x=love.mouse.getX()
	local y=love.mouse.getY()
	local gameX,gameY=Cam:toWorld(x,y)
	love.graphics.print("Mouse: "..xy(gameX,gameY), 0, Session.windowHeight-24)		

end

local dumpAll=function()
	log("wip dump all")
	
	local all={}
	all.world=World
	
	local data=serialize(all)
	
	local now = os.date('*t') --get the date/time
--print(Now.hour)
--print(Now.min)
--print(Now.sec)
	
	love.filesystem.write("dump_"..now.hour.."."..now.min.."."..now.sec, data)
	
end


_.keypressed=function(debugger, key)
	log("debugger receive key:"..key)
	
	if key==Config.keyDebuggerDump then
		dumpAll()
	end
	
	
end



return _