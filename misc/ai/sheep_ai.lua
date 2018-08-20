local updateAi=function(sheep)
	if sheep.mountedBy~=nil then
		return
	end
	
	
	-- log("sheep update ai")
	--	local nextX=sheep.x+Lume.random(-20,20)
	--	local nextY=sheep.y+Lume.random(-20,20)
	local nextX=World.player.x+Lume.random(-40,40)
	local nextY=World.player.y+Lume.random(-40,40)
	
	local moveEvent=Event.new()
	moveEvent.code="move"
	moveEvent.x=nextX
	moveEvent.y=nextY
	moveEvent.duration=6
	
	moveEvent.entityRef=Entity.getReference(sheep)
end

return updateAi