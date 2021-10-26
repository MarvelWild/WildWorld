-- global Firework_rocket
local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite=_.entity_name
	result.is_item=true
	result.origin_x=7
	result.origin_y=14
	
	result.foot_x=7
	result.foot_y=14
	
	BaseEntity.init_bounds_from_sprite(result)
	
	return result
end

-- [u]se
_.use=function(firework_rocket)
	-- не юзабельно из руки. зажигалкой.
	
	
--	log("firework use wip")
--	-- todo move top
	
--	local x=firework_rocket.x
--	local y=firework_rocket.y-120
	
--	Movable.move_event(firework_rocket,x,y)
	
--	-- wip then explode
	
	
end

_.ignite=function(rocket)

	if rocket.is_ignited then
		return
	end
	
	rocket.is_ignited=true
	-- log("firework ignite")
	
	local x=rocket.x
	local y=rocket.y-120
	
	Movable.move_event(rocket,x,y)
	
	-- wip then explode
end



return _