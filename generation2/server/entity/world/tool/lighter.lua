local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite=_.entity_name
	result.is_item=true
	
	result.origin_x=0
	result.origin_y=5
  
	result.foot_x=0
	result.foot_y=5
	
	BaseEntity.init_bounds_from_sprite(result)
	
	
	return result
end


local try_use_on=function(lighter,target)
	
	-- todo: 
	if target.entity_name=="firework_rocket" then
		
		log("use lighter on rocket")
		local firework_code=Entity.get_code(target)
		firework_code.ignite(target)
		return true
	end
	
	
	return false
end


_.use=function(lighter)
	local collisions=CollisionService.get_around(lighter, 10)
	
	for k,collision in pairs(collisions) do
		if try_use_on(lighter,collision) then
			break
		end
	end
end


return _