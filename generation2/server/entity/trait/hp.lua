--[[ server part
global Hp

	данная сущность имеет хп и всё что с этим связано - получение дамага, гибель, отхил.
]]--
local _={}

_.change=function(entity,amount)
	
	local new_hp=entity.hp+amount
	log("hp change:"..entity.hp.." to:"..new_hp.." e:".._ets(entity))
	
	entity.hp=new_hp
	
	if new_hp<=0 then
		log("dead:".._ets(entity))
		Db.remove(entity)
	else
		ServerService.entity_updated(target)
	end
end



return _
