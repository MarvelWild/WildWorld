
local initWorlds=function(universe)
	-- todo: calc size based on res
	
	assert(Session.isServer)

	local main=Universe.newWorld("main")
	main.name="Island"
	--main.tileMapName="main"
	main.bgSprite="main"
	-- main.worldName="main" -- set from new
	World.setSize(main,4096,4096)

	local dev=Universe.newWorld("dev")
	dev.name="Developer level"
	dev.bgSprite="dev"
	-- dev.worldName="dev"
	World.setSize(dev,1024,1024)

	-- todo: add sky level
	--local sky=World.new()
	--sky.name="Sky"
	--sky.tileMapName="sky"
	--_.sky=sky

	log("world initialized")
end

return initWorlds
