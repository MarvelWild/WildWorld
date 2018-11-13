-- открывается по F11
local _={}

_.name="Editor"

-- indexed table
local getEditorItems=function()
	local result={}
	
	-- todo: autoload all editor-allowed entities
	local editorEntities={Pantera,Grass,Sheep,Dragon,Pegasus,Zombie,SheepBlack,HorseSmall,Camel,Elephant,Jiraffe,LionFemale,Tiger,Zebra,Grape,Chest}
	
	for k,entity in pairs(editorEntities) do
		local proto=entity.new({isProto=true})
		table.insert(result,proto)	
	end

	
	return result
end

_.setActiveItem=function(editor, entity)
	editor.activeItem=entity
	editor.activeItemCode=Entity.get(entity.entity)
end


_.new=function(options)
	if options==nil then options={} end
	
	options.isService=true
	
	local r=BaseEntity.new(options)
	r.items=getEditorItems()
	r.activeItem=nil
	r.activeItemCode=nil
--	r.activeItemPos=nil
	_.setActiveItem(r, r.items[1])
	r.isActive=false
	r.isDrawable=true
	r.isUiDrawable=false --4x
	r.isScaledUiDrawable=true -- 1x
	
	Entity.afterCreated(r,_,options)
	
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

_.prevItem=function(editor)
	
	local currentItem=editor.activeItem
	local items=editor.items
	local currentPos=Lume.find(items,currentItem)
	local maxPos=#items
	
	if currentPos==1 then
		currentPos=maxPos
	else
		currentPos=currentPos-1
	end
	
	local nextItem=items[currentPos]
	_.setActiveItem(editor,nextItem)
end


_.update=function(editor)
	local x,y=Util.getMouseXY()
	local activeItem=editor.activeItem
	activeItem.x=x-activeItem.originX
	activeItem.y=y-activeItem.originY
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
	local activeItem=editor.activeItem
	newEntity.x=activeItem.x+activeItem.originX
	newEntity.y=activeItem.y+activeItem.originY
	
	Entity.usePlaceable(newEntity,newEntity.x,newEntity.y,true)
	
	return newEntity
end


return _