-- client main
if (arg[#arg] == "-debug") then require("mobdebug").start() end

-- globals
_traceback=debug.traceback
_frame=0

--internalization
local _pow_update=nil
local _pow_draw=nil
local _pow_mousepressed=nil
--internalization end


local load_start_level=function()
	local tree1_instance=world.tree1.new()
	Entity.add(world.tree1,tree1_instance)
end



love.load=function()
	
	-- globals 2
	Pow=require("lib.pow2.pow")
	log=Pow.log
	_pow_update=Pow.update
	_pow_draw=Pow.draw
	_pow_mousepressed=Pow.mousepressed
	
	Res=require("res.res")

	BaseEntity=require("entity.base.base_entity")
	Entity=Pow.entity
	

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
	_pow_draw()
end

love.update=function(dt)
	_pow_update(dt)
end

love.mousepressed=function(x,y,button,istouch)
	_pow_mousepressed(x,y,button)
end