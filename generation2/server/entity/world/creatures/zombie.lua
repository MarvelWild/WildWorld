-- server
local _={}

local _entity_name=Pow.currentFile()
_.entity_name=_entity_name

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="zombie_1"
	
	BaseEntity.init_bounds_from_sprite(result)
	
--	result.originX=3
--	result.originY=7
	result.foot_x=3
	result.foot_y=14
	
	
	
	return result
end

local is_enemy=function(entity,other)
	-- сейчас все кроме др зомби
	
	if other.entity_name==_entity_name then
		return false
	end
		
	
	return true
end

-- collisions are checked, do attack
local attack=function(actor,target)



	-- v1: через событие
	
----	log("emit attack event:".._ets(actor).." on ".._ets(target))
	
--	-- обработка сервером: 
--	-- клиентом:
--	local attack_event=Event.new('attack')
	
--	-- todo: think how to avoid this ref/deref on server,
--	-- exec with direct rf on server, then update to dto?
--	attack_event.actor=_ref(actor)
	
--	attack_event.attack_target=_ref(target)
--	attack_event.damage=0.1
--	attack_event.target="level"
--	attack_event.level=actor.level_name
--	Event.process(attack_event)
	
--	-- todo process on server
--	-- todo process on client
	
	
	-- v2: апдейт свойства цели
	
	local damage=0.1
	target.hp=target.hp-damage
	
	ServerService.entity_updated(target)
	-- wip: есть ли уже апдейт сущности?
	
	
	
end


local update_ai_combat=function(entity)
	-- todo: seek target, move to it
	
	-- detect target in melee range (collision check)
	local collsions=CollisionService.getEntityCollisions(entity)
	if collsions then
		for k,collision_entity in pairs(collsions) do
--			log("combat ai collision:".._ets(collision_entity))
			-- todo priority
			
			if is_enemy(entity,collision_entity) then
				attack(entity,collision_entity)
			end
		end
	end
	
	return false
end


_.updateAi=function(entity)
	
	if update_ai_combat(entity) then return end
	
	-- AiService.moveRandom(entity)
end



--_.interact=Mountable.toggle_mount

return _