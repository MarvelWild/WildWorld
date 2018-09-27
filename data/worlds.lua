-- global Worlds on server

local _={}

-- todo: calc size based on res

local main=World.new()
main.name="Island"
main.worldName="main"

local dev=World.new()
dev.name="Developer level"
dev.worldName="dev"

--1024*1024px
dev.w=32
dev.h=32

local sky=World.new()
sky.name="Sky"
sky.worldName="sky"

_.main=main
_.dev=dev
_.sky=sky


return _