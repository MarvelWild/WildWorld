local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.x=0
	result.y=0
	
	result.name='Joe'
	result.level_name='start'
	
	-- todo это свойства спрайта
	-- но и в сущности оставить спрайто независимые
	result.footX=7
	result.footY=15
	
	
	-- откуда начинается квадрат коллизии
	result.collisionX=3
	result.collisionY=0
	
	-- todo: вторые 2 координаты квадрата коллизии
	
	
	-- used for collisions
	result.w=9
	result.h=16
	
	result.riderX=7
	result.riderY=11
	
	result.hp=10
	result.hp_max=10
	
	result.energy=100
	result.energy_max=100
	
	
	
	result.sprite="player_7"
	
	BaseEntity.init_bounds_from_sprite(result)

	
	return result
end







--local take_damage=function(player)
--	-- todo detect damage source
	
--	local collsions=CollisionService.getEntityCollisions(player)
--	for k,entity in pairs(collsions) do
--		log("collision:".._ets(entity))
--		-- todo
		
--	end
	
	
--end


--_.update=function(dt,player)
----	take_damage(player)
--end


return _