-- client game state
-- global GameState

local _={}

_.level=nil

-- заполняется в client_service onStateReceived
_.lastState=nil
_.playerId=nil

_.getPlayer=function()
	if _.lastState~=nil then
		
		--todo optimize, cache
		-- wip: player now with regular entities
		local level=_.lastState.level
		local entities=level.entities
		local playerContainer=entities['player']
		local playerId=_.playerId
		for k, player in pairs(playerContainer) do
			if (player.id==playerId) then
				return player
			end
			
			
		end

		return nil
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