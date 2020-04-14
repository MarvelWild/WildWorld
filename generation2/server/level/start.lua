local _=Level.new()

_.name="start"
_.bg="main"


-- evo: any shape, collision layer
local land_area_start_x=48
local land_area_start_y=32

local land_area_end_x=144
local land_area_end_y=110

local plant_trees=function()
--	log("plant trees")
	
	local x=love.math.random(land_area_start_x,land_area_end_x)
	local y=love.math.random(land_area_start_y,land_area_end_y)
	

	local entity=Tree_birch.new()
	entity.x=x
	entity.y=y
	
	Db.add(entity,_.name)
	
	
	
	
	x=love.math.random(land_area_start_x,land_area_end_x)
	y=love.math.random(land_area_start_y,land_area_end_y)
	
	entity=Stone_1.new()
	entity.x=x
	entity.y=y
	Db.add(entity,_.name)
	
	
	x=love.math.random(land_area_start_x,land_area_end_x)
	y=love.math.random(land_area_start_y,land_area_end_y)
	
	entity=Stone_1.new()
	entity.x=x
	entity.y=y
	Db.add(entity,_.name)
	
	entity=Stick_1.new()
	entity.x=x
	entity.y=y
	Db.add(entity,_.name)
	
end


_.init=function()
	log("level start init")
	
	local counter=0
	local increment_counter=function(entity)
		local s=_ets(entity)
		if s==nil then
			nop() -- disappeared? no, happens on client login.
		end
		
		log("counting:"..s)
		counter=counter+1
	end
	
	Db.each_entity(increment_counter)
	
	log("level before init. entity count:"..counter)
	
	
	plant_trees()
end


return _