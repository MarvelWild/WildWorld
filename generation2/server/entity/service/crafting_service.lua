local _={}


-- описание что молжно крафтить вообще
local _recipes=
{
	axe=
	{
		quantity=1,
		from=
		{
			{
				name="stick",
				quantity=1 -- for reference, game should accept default 1
			},
			{
				name="stone_1"
			}
		}
	}
}


_.get_recipes=function(item)
		-- test
		local entity_name=item.entity_name
		
		local result={}
		for craft_name, craft_props in pairs(_recipes) do
			if entity_name==craft_name then
				table.insert(result, craft_props)
			end
		end
		
		return result
end




local get_=function()
	-- wip
end


-- items - из чего крафт
_.is_craftable_from=function(recipe_from, items)
	
	for k_recipe,item_recipe in pairs(recipe_from) do
			-- wip
			local from_name=item_from.name
			local from_quantity=item_from.quantity or 1
			-- вп теперь нужно проверить что нужное кол-во есть
			
			for k_item,item in pairs(items) do
				local item_name=item.entity_name
			end
			
			
			
			
			
	end
	
	
	return true
	
		
end


-- получили вещи вокруг, что можно из них скрафтить?
-- пример items:


_.get_craftables_from_items=function(items)
	-- wip
	local result={}
	

	for craft_name, craft_props in pairs(_recipes) do
		-- wip можно ли скрафтить из данного рецепта
		
		local from=craft_props.from
		
		
	end
	
	
	
	return result
end




return _