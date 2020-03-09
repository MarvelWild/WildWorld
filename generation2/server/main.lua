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
Config=require("shared.entity.service.config")
WorldEntities=nil
DebugFlag=
{
	create_tree=false,
	create_camel=false,
}

local loadEntity=function(path)
	local entity=require(path)
	
	log("loadEntity:"..path,"verbose")
	if entity==true then
		log("error:entity not loaded:"..path)
	end
	
	local globalVarName=Pow.allen.capitalizeFirst(entity.entity_name)
	Pow.registerGlobal(globalVarName, entity)
	Entity.addCode(entity.entity_name,entity)
	if entity.load~=nil then entity.load() end
	
	return entity
end

local mod={}

-- dirName sample: entity/world
mod.loadEntitiesFromDir=function(dirName)
	local result={}
	local dirItems=love.filesystem.getDirectoryItems(dirName)
	for k,fileName in ipairs(dirItems) do
		
		local file_path=dirName.."/"..fileName
		if Pow.allen.endsWith(fileName, ".lua") then
			local entity_name=Pow.replace(fileName,".lua","")
			local entityPath=dirName.."."..entity_name
		
			local entity=loadEntity(entityPath)
			table.insert(result,entity)
		elseif Pow.is_dir(file_path) then
			
			-- Error: main.lua:75: attempt to call global 'loadEntitiesFromDir' (a nil value)
			local sub_result=mod.loadEntitiesFromDir(file_path)
			table.append(result,sub_result)
		end
	end
	return result
end

local loadEntities=function()
	Movable=Pow.multirequire("shared.entity.trait.movable", "entity.trait.movable")
	Growable=Pow.multirequire("shared.entity.trait.growable", "entity.trait.growable")
	Mountable=Pow.multirequire("shared.entity.trait.mountable","entity.trait.mountable")
	
	WorldEntities=mod.loadEntitiesFromDir("entity/world")
	loadEntity("entity.level")
	loadEntity("entity.player")
	loadEntity("entity.service.ai")
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
	
	Entity.add(EnergyService)
	Entity.add(ServerService)
	loadEntities()
	
	Entity.on_removed=entity_on_removed
	
	--loadLevels()
	ServerService.start()
	
	Level.activate("start")
	
	if DebugFlag.create_tree then
		
		-- todo: destroy all prev trees
		local tree=Tree.new()
		tree.x=0
		tree.y=0
		
		Db.add(tree,"start")
	end
	
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




love.draw=function()
	love.graphics.print("server up")
	love.graphics.print("frame:".._frm(),0,12)
end

love.quit=function()
	Db.save()
	Pow.quit()
end



