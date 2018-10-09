
local initWorlds=function(universe)
	-- todo: calc size based on res
	
	assert(Session.isServer)

	local main=Universe.newWorld("main")
	main.name="Island"
	--main.tileMapName="main"
	main.bgSprite="main"
	-- main.worldName="main" -- set from new
	
	-- todo: size from sprite
	World.setSize(main,4096,4096)

	local dev=Universe.newWorld("dev")
	dev.name="Developer level"
	dev.bgSprite="dev"
	-- dev.worldName="dev"
	World.setSize(dev,1024,1024)
	
	
	local clouds=Universe.newWorld("clouds")
	clouds.name="Clouds"
	clouds.bgSprite="clouds"
	World.setSize(clouds,4096,4096)
	
	log("worlds initialized")
end

return initWorlds
