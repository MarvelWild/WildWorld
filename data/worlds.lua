-- global Worlds on server

local _={}

-- todo: calc size based on res

local main=World.new()
main.name="Island"
main.tileMapName="main"
main.worldName="main"
_.main=main

local dev=World.new()
dev.name="Developer level"
dev.bgSprite="dev"
dev.worldName="dev"
--1024*1024px
dev.w=32
dev.h=32
_.dev=dev

-- todo: add sky level
--local sky=World.new()
--sky.name="Sky"
--sky.tileMapName="sky"
--_.sky=sky


return _