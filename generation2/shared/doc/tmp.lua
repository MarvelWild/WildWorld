local editor_place_item=function(event)
	local login=event.login
	local player=Player.getByLogin(login)
	local item=event.item
	local entityCode=Entity.get_code(item)
	local instance=entityCode.new()
	instance.x=item.x
	instance.y=item.y
	
	-- custom prop: portal dest, sprite
	instance.sprite=item.sprite
	instance.location=item.location
	
	local level_name=player.level_name
	Db.add(instance,level_name)
end