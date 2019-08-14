-- todo: make it part of pow
-- цель - коллизии по уровням,
-- следующий уровень абстракции: collision (одноуровневая модель)

-- на клиенте пока что не используется

local _entityName='CollisionService'
local _=BaseEntity.new(_entityName, true)


local _levelCollisions={}



_.addEntity=function(entity)
end

_.onEntityMoved=function(entity)
end


_.removeEntity=function(entity)
end

return _
