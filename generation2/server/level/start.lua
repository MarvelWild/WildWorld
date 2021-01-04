local _=Level.new()

_.name="start"
_.bg="main"


-- evo: any shape, collision layer
local land_area_start_x=48
local land_area_start_y=32

local land_area_end_x=144
local land_area_end_y=110

local seed_items=function()
--	log("plant trees")
	
	local x=love.math.random(land_area_start_x,land_area_end_x)
	local y=love.math.random(land_area_start_y,land_area_end_y)
	

	if not DebugFlag.dev_mode then
		local entity=Tree_birch.new()
		entity.x=x
		entity.y=y
		
		Db.add(entity,_.name)
	end
	
	
	x=love.math.random(land_area_start_x,land_area_end_x)
	y=love.math.random(land_area_start_y,land_area_end_y)
	
	--if not DebugFlag.dev_mode then
		entity=Stone_1.new()
		entity.x=x
		entity.y=y
		Db.add(entity,_.name)
		
		entity=Stick_1.new()
		entity.x=x-1
		entity.y=y-1
		Db.add(entity,_.name)
	-- end
	
end


_.init=function()
	log("level start init")
	
	local counter=0
	local increment_counter=function(entity)
		if type(entity)=="number" then
			nop()
		end
		
		
		
		local s=_ets(entity)
		if s==nil then
			nop()
		else
			log("counting:"..s)
		end
		
		counter=counter+1
	end
	
	
	Db.self_test()
	
	Db.each_entity(increment_counter)
	
	log("level before init. entity count:"..counter,"verbose")
	
	if counter>2 then
		log("error: should not init loaded level")
	end
	
	
	
	seed_items()
end


return _