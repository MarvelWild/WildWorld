-- World entity
local _={}

_.name="World"

_.new=function(options)
	local newWorld=BaseEntity.new(options)
	newWorld.editorVisible=false
	newWorld.isDrawable=false
	newWorld.worldId=nil
	
	-- use setSize
	
	newWorld.wTiles=128
	newWorld.hTiles=128
	
	newWorld.wPx=4096
	newWorld.hPx=4096

	newWorld.entity="World"
	
	-- user name
	newWorld.name="New world"
	
	-- internal name (portal target)
	newWorld.worldName="main"
	
	-- should have tiles under res\img\level\_worldName_
	newWorld.tileMapName=nil
	
	
	-- res\img\level\%.png, alternative to tiles mode
	newWorld.bgSprite=nil
	
	newWorld.entities={}
	
	Entity.afterCreated(newWorld,_,options)
	return newWorld
end

_.setCurrent=function(world)
	assert(world)
	CurrentWorld=world
	
	
	-- tiles unused now
	-- Tile.setLevel(world.worldName)
	
	Cam:setWorld(0,0,world.wPx,world.hPx)
	
	Entity.registerWorld(CurrentWorld)
	
	Player.setWorld(world)
end

-- in pixels
_.setSize=function(world,wPx,hPx)
	world.wPx=wPx
	world.hPx=hPx
	
	world.wTiles=wPx/TILE_SIZE
	world.hTiles=hPx/TILE_SIZE
end






-- server only
_.getById=function(worldId)
	if Session.isServer then
		for name,world in pairs(CurrentUniverse.worlds) do
			if world.id==worldId then
				return world
			end
		end
	else
		if worldId~=CurrentWorld.id then
			log("error: accessing other world on client")
		else
			return CurrentWorld
		end
	end
	
	
	return nil
end

return _