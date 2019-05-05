-- client game state
-- global GameState

local _={}

_.level=nil

-- заполняется в client_service onStateReceived
_.lastState=nil

_.getPlayer=function()
	if _.lastState~=nil then
		local player=_.lastState.player
		return player
	end
end

_.findEntity=function(entityRef)
	-- todo: improve
	local player=_.getPlayer()
	
	local playerRef=BaseEntity.getReference(player)
	if BaseEntity.referenceEquals(playerRef, entityRef) then
		return player
	end
	
end




return _