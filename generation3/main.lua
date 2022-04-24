-- client main
if (arg[#arg] == "-debug") then require("mobdebug").start() end

-- globals
_traceback=debug.traceback
_frame=0


local load_start_level=function()
	local tree1_instance=world.tree1.new()
	Entity.add(world.tree1,tree1_instance)
end


love.load=function()
	
	-- globals 2
	Pow=require("lib.pow2.pow")
	log=Pow.log
	
	Res=require("res.res")

	BaseEntity=require("entity.base.base_entity")
	Entity=require("service.entity_service")
	

	Player=require("entity.player.player")
	Level=require("level.level1.level")
	Simulation=require("entity.system.simulation.simulation")
	
	-- контейтер world сущностей чтобы не засорять глобал
	world={}
	-- globals 2 end
	
	-- todo: auto load world
	-- посмотреть как в 2 поколении
	world={}
	world.tree1=require("entity.world.t.tree1.tree1")
	
	
	-- code+data (service/singleton)
	Entity.add(Level,Level)
	Entity.add(Player,Player)
	Entity.add(Simulation,Simulation)
	
	load_start_level()
end


love.draw=function()
	Entity.draw()
end

love.update=function(dt)
	Pow.update()
	Entity.update()
end

love.mousepressed=function(x,y,button,istouch)
	Entity.mouse_pressed(x,y,button)
end