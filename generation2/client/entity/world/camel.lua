--todo: handle client entities without code generic way

local _={}

_.entity_name=Pow.currentFile()
_.draw=function(entity)
--	BaseEntity.draw
	Generic.draw(entity)
end



return _