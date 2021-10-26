-- server main

local isDebug=arg[#arg] == "-debug"
if isDebug then require("mobdebug").start() end

--[[
package.cpath = package.cpath .. ';C:/Users/mw/AppData/Roaming/JetBrains/IntelliJIdea2021.1/plugins/EmmyLua/classes/debugger/emmy/windows/x64/?.dll'
local dbg = require('emmy_core')
dbg.tcpConnect('localhost', 9966)
]]--


_traceback=debug.traceback

require("shared.libs")
require("console_commands")

local cleanSave=function()
	log('cleanSave','fs')
	local fs=love.filesystem
	local saveParts=fs.getDirectoryItems(Pow.saveDir)
	for k,file in pairs(saveParts) do
		love.filesystem.remove(Pow.saveDir..file)
	end
end


Pow.setup(
	{
		"server",
		-- "client"
	}
)
Id=Pow.id

Event=Pow.net.event
BaseEntity=Pow.baseEntity
Db=require("shared.lib.db.db")
Db.init(Pow.saveDir)
_deref=Db.getByRef
ServerService=require("entity.service.server_service")
CollisionService=require("entity.service.collision_service")
DebuggerService=require("shared.entity.service.debugger_service")
HelpScreen=require("entity.service.help_screen")
EnergyService=require("entity.service.energy_service")
Crafting_service=require("entity.service.crafting_service")
Config=require("shared.entity.service.config")
Animation_service=require("shared.entity.service.animation_service")
Pin_service=require("shared.entity.service.pin_service")
WorldEntities=nil
DebugFlag=
{
	fireworks=true,
--	create_tree=false,
	create_camel=false,
	create_horse=false,
	create_apple=true,
	-- horse_do_not_move=true,
	-- do not create trees
	dev_mode=true,
}

-- dirName sample: entity/world

local load_traits=function()
	
	-- todo: autoload from traits dir
	
	Movable=Pow.multirequire("shared.entity.trait.movable", "entity.trait.movable")
	Growable=Pow.multirequire("shared.entity.trait.growable", "entity.trait.growable")
	Mountable=Pow.multirequire("shared.entity.trait.mountable","entity.trait.mountable")
	Colored=Pow.multirequire("shared.entity.trait.colored","entity.trait.colored")
	Carrier=Pow.multirequire("entity.trait.carrier")
	Bond=Pow.multirequire("entity.trait.bond")
	Eater=Pow.multirequire("entity.trait.eater")
	Swap=Pow.multirequire("entity.trait.swap")
	Hp=Pow.multirequire("entity.trait.hp")
end


local loadEntities=function()
	load_traits()
	
	WorldEntities=Pow.loadEntitiesFromDir("entity/world")
	Pow.loadEntity("entity.level")
	Pow.loadEntity("entity.item")
	Pow.loadEntity("entity.player")
	Pow.loadEntity("entity.service.ai")
end

local entity_on_removed=function(entity)
	if entity.is_movable then
		Movable.destroy(entity)
	end
	
	if entity.is_mountable then
		Mountable.destroy(entity)
	end
	
end


love.load=function()
	Pow.load()
	local isClean=Pow.arg.get("clean",false)~=false
	if isClean then
		cleanSave()
	end
	
	local seed=Pow.arg.get("seed=",nil)
	if seed then
		love.math.setRandomSeed(seed)
	else
		love.math.setRandomSeed(love.timer.getTime())
	end
	
	
	local netState=Pow.net.state
	netState.isServer=true
	netState.isClient=false
	
	Db.load()
	local frame=Db.get_var("frame")
	if frame then 
		Pow.set_frame(frame)
	end
	
	Entity.add(EnergyService)
	Entity.add(ServerService)
	Entity.add(Pin_service)
	Entity.add(DebuggerService)
	loadEntities()
	
	Entity.on_removed=entity_on_removed
	
	--loadLevels()
	ServerService.start()
	
	Level.activate("start")
	
--	if DebugFlag.create_tree then
		
--		local tree=Tree_birch.new()
--		tree.x=0
--		tree.y=0
		
--		Db.add(tree,"start")
--	end
	

	-- give("apple")
end

love.update=function(dt)
	Pow.update(dt)
end

love.keypressed=function(key, scancode, isrepeat)
	Entity.keyPressed(key)
end



local _print=love.graphics.print
local _debug=Pow.debug


local _fps=love.timer.getFPS

love.draw=function()
	
	local y=0
	local line_spacing=12
	
	local log_last_message=_debug.last_message
	local log_prev_message=_debug.prev_message
	
	_print("server up. fps:".._fps(),y)
	y=y+line_spacing
	
	_print("frame:".._frm(),0,y)
	y=y+line_spacing
	
	_print("log:"..log_last_message,0,y)
	y=y+line_spacing
	
	_print(log_prev_message,0,y)
	y=y+line_spacing
	
	Pow.draw()
	DebuggerService.do_draw() 
end

love.quit=function()
	Db.set_var("frame", _frm())
	Db.save()
	Pow.quit()
end



function love.textinput(text)
	Pow.console_toggle(text)
end