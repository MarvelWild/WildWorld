-- World entity
local _={}

_.name="World"

_.new=function()
	local newWorld=BaseEntity.new()
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
	
	BaseEntity.init(newWorld)
	return newWorld
end

_.setCurrent=function(world)
	assert(world)
	CurrentWorld=world
	
	
	-- tiles unused now
	-- Tile.setLevel(world.worldName)
	
	Cam:setWorld(0,0,world.wPx,world.hPx)
	
	Entity.registerWorld(CurrentWorld)
end

-- in pixels
_.setSize=function(world,wPx,hPx)
	world.wPx=wPx
	world.hPx=hPx
	
	world.wTiles=wPx/TILE_SIZE
	world.hTiles=hPx/TILE_SIZE
end





return _