-- World entity
local _={}

_.name="World"

_.new=function()
	local entity=BaseEntity.new()
	entity.editorVisible=false
	entity.isDrawable=false
	entity.isInWorld=false
	
	-- wip: implement this
	-- in tiles
	entity.w=128
	entity.h=128

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
end



return _