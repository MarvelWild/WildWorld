-- server main

local isDebug=arg[#arg] == "-debug"
if isDebug then require("mobdebug").start() end

_traceback=debug.traceback

require("shared.libs")

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
EnergyService=require("entity.service.energy_service")
Crafting_service=require("entity.service.crafting_service")
Config=require("shared.entity.service.config")
Animation_service=require("shared.entity.service.animation_service")
Pin_service=require("shared.entity.service.pin_service")
WorldEntities=nil
DebugFlag=
{
--	create_tree=false,
	create_camel=false,
	
	
	-- do not create trees
	dev_mode=true,
}




-- dirName sample: entity/world


local loadEntities=function()
	Movable=Pow.multirequire("shared.entity.trait.movable", "entity.trait.movable")
	Growable=Pow.multirequire("shared.entity.trait.growable", "entity.trait.growable")
	Mountable=Pow.multirequire("shared.entity.trait.mountable","entity.trait.mountable")
	
	WorldEntities=Pow.loadEntitiesFromDir("entity/world")
	Pow.loadEntity("entity.level")
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
	local isClean=Pow.arg.get("clean",false)~=false
	if isClean then
		cleanSave()
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
	
	if DebugFlag.create_camel then
		
		local entity=Camel.new()
		entity.x=0
		entity.y=0
		
		Db.add(entity,"start")
	end
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
end

love.quit=function()
	Db.set_var("frame", _frm())
	Db.save()
	Pow.quit()
end



