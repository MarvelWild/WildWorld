-- global Worlds on server

local _={}

-- todo: calc size based on res

local main=World.new()
main.name="Island"
main.tileMapName="main"
main.worldName="main"
World.setSize(main,4096,4096)
_.main=main

local dev=World.new()
dev.name="Developer level"
dev.bgSprite="dev"
dev.worldName="dev"
World.setSize(dev,1024,1024)
_.dev=dev

-- todo: add sky level
--local sky=World.new()
--sky.name="Sky"
--sky.tileMapName="sky"
--_.sky=sky


return _