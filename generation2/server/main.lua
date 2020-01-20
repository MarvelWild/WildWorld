-- server main

local isDebug=arg[#arg] == "-debug"
if isDebug then require("mobdebug").start() end

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

BaseEntity=Pow.baseEntity
Db=require("shared.lib.db.db")
Db.init(Pow.saveDir)
ServerService=require("entity.service.server_service")
CollisionService=require("entity.service.collision_service")
ConfigService=require("shared.entity.service.config")
WorldEntities=nil


local loadEntity=function(path)
	local entity=require(path)
	
	log("loadEntity:"..path)
	if entity==true then
		log("error:entity not loaded:"..path)
	end
	
	local globalVarName=Pow.allen.capitalizeFirst(entity.entity_name)
	Pow.registerGlobal(globalVarName, entity)
	Entity.addCode(entity.entity_name,entity)
	if entity.load~=nil then entity.load() end
	
	return entity
end



local loadEntitiesFromDir=function(dirName)
	local result={}
	local dirItems=love.filesystem.getDirectoryItems(dirName)
	for k,fileName in ipairs(dirItems) do
		local entity_name=Pow.replace(fileName,".lua","")
		local entityPath=dirName.."."..entity_name
		local entity=loadEntity(entityPath)
		table.insert(result,entity)
	end
	
	return result
end


local loadEntities=function()
	Movable=require "shared.entity.trait.movable"
	Mountable=Pow.multirequire("shared.entity.trait.mountable","entity.trait.mountable")
	
	WorldEntities=loadEntitiesFromDir("entity/world")
	loadEntity("entity.level")
	loadEntity("entity.player")
	loadEntity("entity.service.ai")
end

local entity_on_removed=function(entity)
	if entity.is_movable then
		Movable.destroy(entity)
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
	
	Entity.add(ServerService)
	loadEntities()
	
	Entity.on_removed=entity_on_removed
	
	--loadLevels()
	ServerService.start()
	
	Level.activate("start")
end

love.update=function(dt)
	Pow.update(dt)
end

love.keypressed=function(key, scancode, isrepeat)
	Entity.keyPressed(key)
end




love.draw=function()
	love.graphics.print("server up")
end

love.quit=function()
	Db.save()
	Pow.quit()
end



