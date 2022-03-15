local _=Level.new()

_.name="mine_1"
_.bg="mine"

_.init=function()
	log("level mine_1 init")
	
	local entity
	local level_name=_.name
	
	entity=Mine_exit.new()
	entity.x=50
	entity.y=50
	Db.add(entity,level_name)
end

return _