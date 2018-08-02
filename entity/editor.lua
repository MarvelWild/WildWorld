-- открывается по F11
local _={}

-- indexed table
local getEditorItems=function()
	local result={}
	-- todo: autoload all editor-allowed entities
	local pantera=Pantera.new({isProto=true})
	table.insert(result,pantera)
	
	local grass=Grass.new({isProto=true})
	table.insert(result,grass)
	
	local item=Sheep.new({isProto=true})
	table.insert(result,item)
	
	item=Dragon.new({isProto=true})
	table.insert(result,item)
	
	item=Pegasus.new({isProto=true})
	table.insert(result,item)
	
	item=Zombie.new({isProto=true})
	table.insert(result,item)
	
	return result
end

_.setActiveItem=function(editor, entity)
	editor.activeItem=entity
	editor.activeItemCode=Entity.get(entity.entity)
end


_.new=function()
	local r=BaseEntity.new()
	r.items=getEditorItems()
	r.entity="Editor"
	r.activeItem=nil
	r.activeItemCode=nil
--	r.activeItemPos=nil
	_.setActiveItem(r, r.items[1])
	r.isActive=false
	r.isDrawable=true
	r.isUiDrawable=false --4x
	r.isScaledUiDrawable=true -- 1x
	
	Entity.register(r)
	
	return r
end

--_.activate=function(editor)
--	log("editor activated")
--end

--_.deactivate=function(editor)
--	log("editor deactivated")
--end

_.nextItem=function(editor)
	
	local currentItem=editor.activeItem
	local items=editor.items
	local currentPos=Lume.find(items,currentItem)
	local maxPos=#items
	
	if currentPos==maxPos then
		currentPos=1
	else
		currentPos=currentPos+1
	end
	
	local nextItem=items[currentPos]
	_.setActiveItem(editor,nextItem)
end


_.update=function(editor)
	local x,y=Util.getMouseXY()
	editor.activeItem.x=x
	editor.activeItem.y=y
end


_.draw=function(editor)
--	log("editor draw item")
	editor.activeItemCode.draw(editor.activeItem)
end


-- 1x
_.drawScaledUi=function(editor)
	LG.print("I am editor")
end

_.placeItem=function(editor)
	local newEntity=editor.activeItemCode.new()
	newEntity.x=editor.activeItem.x
	newEntity.y=editor.activeItem.y
	
	Entity.usePlaceable(newEntity,newEntity.x,newEntity.y,true)
	
	return newEntity
end


return _