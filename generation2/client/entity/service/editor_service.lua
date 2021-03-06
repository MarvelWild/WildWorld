local _=BaseEntity.new("editor_service",true)

-- todo: generic way to deactivate entity?
-- now its ok - its partially active listening for keys (F11)
local _isActive=false

--
local _editorItems=nil
local _isFetchingItems=false

local _activeItem=nil

-- 
local _save=nil


-- от сервера получен список сущностей редактора
local onItemsReceived=function(event)
	local items=event.items
	_editorItems=items
	
	
	_activeItem=Pow.lume.first(items)
	
	if _save then
		local active_item_entity_name=_save.active_item_entity_name
		if not active_item_entity_name then
			-- todo: fix
			log("error: save with no active item")
			return
		end
		
		
		log("load active item:"..active_item_entity_name)
		for k,item in pairs(items) do
			local entity_name=item.entity_name
			if entity_name==active_item_entity_name then
				_activeItem=item
				break
			end
			
			
		end
		
		
	end
	
	
	_isFetchingItems=false
end


local initItems=function()
	_isFetchingItems=true
	local requestItems=Event.new()
	requestItems.code="editor_items"
	requestItems.target="server"
	Event.process(requestItems,onItemsReceived)
end

local toggleActive=function()
	_isActive=not _isActive

	if _isActive then
		if _editorItems==nil and not _isFetchingItems then
			initItems()
		end
		
	end
	
end

local setActiveItem=function(item)
	_activeItem=item
end


local nextItem=function()
	local currentItem=_activeItem
	local items=_editorItems
	
	local currentPos=Pow.lume.find(items,currentItem)
	local maxPos=#items
	
	if currentPos==maxPos then
		currentPos=1
	else
		currentPos=currentPos+1
	end
	
	local nextItem=items[currentPos]
	setActiveItem(nextItem)
end

local prevItem=function()
	local currentItem=_activeItem
	local items=_editorItems
	
	local currentPos=Pow.lume.find(items,currentItem)
	local maxPos=#items
	
	if currentPos==1 then
		currentPos=maxPos
	else
		currentPos=currentPos-1
	end
	
	local nextItem=items[currentPos]
	setActiveItem(nextItem)
end


-- todo: visual help
_.keyPressed=function(key)
	if key=="f11" then
		toggleActive()
	elseif _isActive then
		if key=="kp+" then 
			nextItem()
		elseif key=="kp-" then 
			prevItem()
		end
	end
end

local placeItem=function()
	local event=Event.new()
	event.code="editor_place_item"
	
	local x,y=Pow.getMouseXY()
	_activeItem.x=x
	_activeItem.y=y

	event.item=_activeItem
	event.target="server"
	Event.process(event)
end


_.mousePressed=function(x,y,button)
	-- todo opt: unsub/sub on active
	if not _isActive then return end
	if button==2 then
		placeItem()
	end
end


_.drawUnscaledUi=function()
	if _isActive then
		local message="editor active."
		if _activeItem~=nil then 
			message=message.." item:".._ets(_activeItem)
		end
		
		love.graphics.print(message)
	end
end

_.update=function()
	if _activeItem==nil then return end
	local x,y=Pow.getMouseXY()
	
	_activeItem.x=x
	_activeItem.y=y

	-- todo: apply origin
--	activeItem.x=x-activeItem.originX
--	activeItem.y=y-activeItem.originY
end


_.draw=function()
	if _activeItem==nil then return end
	if not _isActive then return end
	
	BaseEntity.draw(_activeItem)
end







_.load=function()
	_save=Pow.read_object(_.entity_name)
	-- ставится в onItemsReceived
end

_.save=function()
	local save={}
	if _activeItem then
		save.active_item_entity_name=_activeItem.entity_name
	end
	
	Pow.write_object(_.entity_name,save)
	
end




_.set_item_by_name=function(name)
	for k,item in pairs(_editorItems) do
		if item.name=="" then
			setActiveItem(item)
			break
		end
	end
end

return _