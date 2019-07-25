local _=BaseEntity.new("editor_service",true)

-- todo: generic way to deactivate entity?
-- now its ok - its partially active listening for keys (F11)
local _isActive=false

--
local _editorItems=nil
local _isFetchingItems=false

local _activeItem=nil


local onItemsReceived=function(event)
	local items=event.items
	_editorItems=items
	
	_activeItem=Pow.lume.first(items)
	
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
	
	-- wip
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


-- todo: visual help
_.keyPressed=function(key)
	if key=="f11" then
		toggleActive()
	elseif key=="kp+" then
		nextItem()
	end
end

local placeItem=function()
	local event=Event.new()
	event.code="editor_place_item"
	event.item=_activeItem
	event.target="server"
	Event.process(event)
end


_.mousePressed=function(x,y,button)
	if not _isActive then return end
	if button==2 then
		placeItem()
	end
end


_.drawUnscaledUi=function()
	if _isActive then
		love.graphics.print("editor active")
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






return _