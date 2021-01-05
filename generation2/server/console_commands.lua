-- todo global-> console only
give=function(name,quantity)
	if not quantity then quantity=1 end
	local entity_code=Entity.getCodeByName(name)
	if entity_code== nil then 
		log("no entity:"..name)
		return
	end
	
	local humanoid=Db.get_any("humanoid")
	
	if not humanoid then 
		humanoid={
			x=100,y=100,
			level_name="start"
		}
	end
	local level_name=humanoid.level_name
	
	
	
	
	local count=0
	
	repeat
		count=count+1
		local entity=entity_code.new()
		entity.x=humanoid.x+_rnd(-10,10)
		entity.y=humanoid.y+_rnd(-10,10)
		Db.add(entity,level_name)
	until count>=quantity
end
