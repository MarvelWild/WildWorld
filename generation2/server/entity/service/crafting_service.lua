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
				name="stick_1", -- todo: generic items / item groups
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




-- items - из чего крафт

-- example: recipe_from {{name = "stick_1", quantity = 1}, {name = "stone_1"} 
-- items - inventory
_.is_craftable_from=function(recipe_from, items)
	
	for k_recipe,item_recipe in pairs(recipe_from) do
		local recipe_item_name=item_recipe.name -- wip test trace
		local recipe_quantity=item_recipe.quantity or 1

		for k_item,item in pairs(items) do
			local item_name=item.entity_name
			local item_quantity=item.quantity or 1
			if item_name==recipe_item_name then
				
				recipe_quantity=recipe_quantity-item_quantity
				
				if recipe_quantity<1 then
					break
				end
			end -- item match
		end -- inventory items
		
		
		if recipe_quantity>0 then
				return false
		end
	end -- recipe items
	
	
	return true
end


-- получили вещи вокруг, что можно из них скрафтить?
-- пример items:stick,stone > axe


_.get_craftables_from_items=function(items)
	local result={}
	

	for craft_name, craft_props in pairs(_recipes) do
		local from=craft_props.from
		
		if _.is_craftable_from(from,items) then
			-- todo: calc quantity?
			table.insert(result, craft_name)
		end
	end
	
	return result
end




return _