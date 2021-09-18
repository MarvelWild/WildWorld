--global Crafting_service
local _={}

_.craft_range=42

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
	},
	shovel=
	{
		quantity=1,
		from=
		{
			{
				name="stick_1",
			},
			{
				name="stone_1"
			}			
		}
	},
	sword=
	{
		quantity=1,
		from=
		{
			{
				name="stick_1",
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

-- return: bool, cost={{item,quantity},...}
_.is_craftable_from=function(recipe_from, items)
	
	local result_items={}
	
	for k_recipe,item_recipe in pairs(recipe_from) do
		local recipe_item_name=item_recipe.name
		local recipe_quantity=item_recipe.quantity or 1

		for k_item,item in pairs(items) do
			local item_name=item.entity_name
			local item_quantity=Item.get_quantity(item)
			if item_name==recipe_item_name then
				
				local quantity_before=recipe_quantity
				
				recipe_quantity=recipe_quantity-item_quantity
				if recipe_quantity<0 then recipe_quantity=0 end
				
				local quantity_after=recipe_quantity
				
				-- посчитать сколько взято предметов из текущего стака
				local quantity_taken=quantity_before-quantity_after
				
				local result_item=
				{
					item=item,
					quantity=quantity_taken
				}
				
				table.insert(result_items, result_item)
				
				if recipe_quantity<1 then
					break
				end
			end -- item match
		end -- inventory items
		
		
		if recipe_quantity>0 then
				return false
		end
	end -- recipe items
	
	
	return true,result_items
end


-- получили вещи вокруг, что можно из них скрафтить?
-- пример items:stick,stone > axe


_.get_craftables_from_items=function(items)
	local result={}
	

	for craft_name, craft_props in pairs(_recipes) do
		local from=craft_props.from
		
		if _.is_craftable_from(from,items) then
			-- todo: calc quantity?
			local craftable=
			{
				name=craft_name,
				quantity=42, -- todo
				from=from
			}
			table.insert(result, craftable)
		end
	end
	
	return result
end







local craft_delete_source=function(craft_cost,level_name)
	for k,item_craft_info in pairs(craft_cost) do
		local item=item_craft_info.item
		local crafted_quantity=item_craft_info.quantity
		local item_quantity=Item.get_quantity(item)
		if crafted_quantity==item_quantity then
			--израсходован стак - удалить. пока что достаточно этого варианта
			Db.remove(item,level_name)
		else
			-- todo уменьшен стак - апдейт количества
		end
	end	
end


local craft_create_target=function(craftable,level_name,actor)
	local result_name=craftable.name
	local result_quantity=craftable.quantity
	local entity_code=Entity.getCodeByName(result_name)
	local created=entity_code.new()
	created.quantity=result_quantity
	created.x=actor.x+1
	created.y=actor.y+1
	Db.add(created,level_name)
end


local craft_respond_success=function(login,level_name)
	local event=Event.new("craft_ok")
	event.target="login"
	event.targetLogin=login
	
	-- todo: нужно ли это если отправляем логину?
	event.level=level_name
	
	-- todo: implement
	event.craft_time=5
	Event.process(event)
end



-- удаляет исходные
-- создаёт результирующее
--  вещи уже отправились. сказать запросившему что крафт выполнен.
_.do_craft=function(craftable,actor,login)
	local from=craftable.from
	local level_name=actor.level_name
	
	-- items still exists?
	local items=CollisionService.get_around(actor, Crafting_service.craft_range)
	
	local is_craftable,craft_cost=Crafting_service.is_craftable_from(from,items)
	if is_craftable then
		craft_delete_source(craft_cost,level_name)
		craft_create_target(craftable,level_name,actor)
		
		craft_respond_success(login,level_name)
		
	else
		-- todo cannot craft response, with new list of possibilities
	end
	
end

return _