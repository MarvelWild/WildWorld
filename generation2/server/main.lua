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
ConfigService=require("shared.entity.service.config")


local loadEntity=function(path)
	local entity=require(path)
	local globalVarName=Pow.allen.capitalizeFirst(entity.entityName)
	Pow.registerGlobal(globalVarName, entity)
	Entity.addCode(entity.entityName,entity)
end

Player=require("entity.player")

local loadEntities=function()
	loadEntity("entity.world.seed")
	loadEntity("entity.world.panther")
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
	ServerService.start()
end

love.update=function(dt)
	Pow.update(dt)
end

love.keypressed=function(key, scancode, isrepeat)
	Entity.keyPressed(key)
end



love.quit=function()
	Db.save()
	Pow.quit()
end



