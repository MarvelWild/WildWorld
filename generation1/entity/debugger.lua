local _={}

_.name="Debugger"

local _entityCount=0
local _print=love.graphics.print
local _printf=love.graphics.printf

local _drawCount=0
local _drawCountPrevFrame=0
local _originalDraw=nil

local _drawable=Entity.getDrawable()

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

_.new=function(options)
	if options==nil then options={} end
	
	options.isService=true
	
	local r=BaseEntity.new()
	r.isActive=false
	r.isUiDrawable=false --4x
	r.isScaledUiDrawable=true -- 1x
	r.isDrawable=true
	
	Entity.afterCreated(r,_,options)
	
	return r
end

local help="debugger dump:"..Config.keyDebuggerDump.." logs:"..	Config.keyDebuggerWriteLogs..

" dump sel:"..Config.keyDebuggerDumpSelected..
" portal:"..Config.keyDebuggerPortal..
" log entities:"..Config.keyDebuggerLogEntities

_.drawScaledUi=function(debugger)
	LG.print(help)
	local perfInfo="FPS: "..tostring(love.timer.getFPS( )).." | Entity count: ".._entityCount..
		" | draws:".._drawCountPrevFrame
	_print(perfInfo, 0, 70)
	_printf("Player: "..Entity.toString(CurrentPlayer), 0, 94,Session.windowWidth)
	
	
	
	if Session.selectedEntity~=nil then
		local selectedInfo=pack(Session.selectedEntity)
		_print(selectedInfo, 0, 140)
	end
	
	local x=love.mouse.getX()
	local y=love.mouse.getY()
	local gameX,gameY=Cam:toWorld(x,y)
	_print("Mouse: "..xy(gameX,gameY), 0, Session.windowHeight-24)

end

_.draw=function()
	for entity,fnDraw in pairs(_drawable) do
		
	end
	
end

local dumpAll=function()
	log("dump all")
	
	local all={}
	
	if Session.isServer then
		all.universe=CurrentUniverse
	else
		all.world=CurrentWorld
	end
	
	local data=serialize(all)
	
	local now = os.date('*t') --get the date/time
--print(Now.hour)
--print(Now.min)
--print(Now.sec)
	
	love.filesystem.write("dump_"..now.hour.."."..now.min.."."..now.sec, data)
	
end

local dumpSelected=function()
	
	
	if Session.selectedEntity==nil then
		log("dump selected:no selection")
		return
	end
	
	
	local data=serialize(Session.selectedEntity)
	local now = os.date('*t')
	local fileName="dump_selected_"..now.hour.."."..now.min.."."..now.sec
	love.filesystem.write(fileName, data)
	log("dump selected:"..fileName)
end


local portal=function()
	log("dev portal")
	ClientAction.setWorld("clouds")
end


_.keypressed=function(debugger, key)
	-- log("debugger receive key:"..key)
	
	if key==Config.keyDebuggerDump then
		dumpAll()
	elseif key==Config.keyDebuggerWriteLogs then
		Debug.writeLogs()
	elseif key==Config.keyDebuggerDumpSelected then
		dumpSelected()
	elseif key==Config.keyDebuggerPortal then
		portal()	
	elseif key==Config.keyDebuggerLogEntities then
		Entity.debugPrint()
	end
	
	
end

_.slowUpdate=function()
	-- log("debugger slow update")
	_entityCount=Entity.getCount()
end



return _