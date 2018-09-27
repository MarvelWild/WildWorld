-- World entity
local _={}

_.name="World"

_.new=function()
	local entity=BaseEntity.new()
	entity.editorVisible=false
	entity.isDrawable=false
	entity.isInWorld=false
	
	-- use setSize
	
	-- wip: rename from w,h
	entity.wTiles=128
	entity.hTiles=128
	
	entity.wPx=4096
	entity.hPx=4096

	entity.entity="World"
	
	-- user name
	entity.name="New world"
	
	-- internal name (portal target)
	entity.worldName="main"
	
	-- should have tiles under res\img\level\_worldName_
	entity.tileMapName=nil
	
	
	-- res\img\level\%.png, alternative to tiles mode
	entity.bgSprite=nil
	
	BaseEntity.init(entity)
	return entity
end

_.setCurrent=function(world)
	CurrentWorld=world
	Tile.setLevel(world.worldName)
	
	-- wip: camera boundaries
	
	Cam:setWorld(0,0,world.wPx,world.hPx)
end

-- in pixels
_.setSize=function(world,wPx,hPx)
	world.wPx=wPx
	world.hPx=hPx
	
	world.wTiles=wPx/TILE_SIZE
	world.hTiles=hPx/TILE_SIZE
end





return _