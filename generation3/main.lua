-- client main
if (arg[#arg] == "-debug") then require("mobdebug").start() end
love.load=function()
	
	-- globals
	_traceback=debug.traceback

	Pow=require("lib.pow2.pow")
	Res=require("res.res")

	Entity=require("service.entity_service")

	Player=require("entity.player.player")
	Level=require("level.level1.level")
	-- globals end
	
	Entity.add(Level)
	Entity.add(Player)
	
end


love.draw=function()
	Entity.draw()
end

love.update=function(dt)
	Entity.update()
end
