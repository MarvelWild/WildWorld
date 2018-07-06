local _={}

local _entityCount=0
local _print=love.graphics.print
local _printf=love.graphics.printf

local _drawCount=0
local _drawCountPrevFrame=0
local _originalDraw=nil

_.activate=function()
	-- some parts of code (tiles) cache draw function, so this number doesnt show all
	
	_originalDraw=LG.draw
	local drawProxy=function(...)
		_drawCount=_drawCount+1
		_originalDraw(...)
	end
	
	
	LG.draw=drawProxy
end

_.deactivate=function()
	LG.draw=_originalDraw
end

_.update=function()
	_drawCountPrevFrame=_drawCount
	_drawCount=0
end

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
	local perfInfo="FPS: "..tostring(love.timer.getFPS( )).." | Entity count: ".._entityCount..
		" | draws:".._drawCountPrevFrame
	_print(perfInfo, 0, 70)
	--Util.debugPrint(World.player)
	_printf("Player: "..Entity.toString(World.player), 0, 94,Session.windowWidth)
	
	
	local x=love.mouse.getX()
	local y=love.mouse.getY()
	local gameX,gameY=Cam:toWorld(x,y)
	_print("Mouse: "..xy(gameX,gameY), 0, Session.windowHeight-24)

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
	-- log("debugger receive key:"..key)
	
	if key==Config.keyDebuggerDump then
		dumpAll()
	elseif key==Config.keyDebuggerWriteLogs then
		Debug.writeLogs()
	end
	
	
end

_.slowUpdate=function()
	-- log("debugger slow update")
	_entityCount=Entity.getCount()
end



return _