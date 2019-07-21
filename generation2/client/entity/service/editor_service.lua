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
	-- wip show current item under cursor when active
	
	if _isActive then
		if _editorItems==nil and not _isFetchingItems then
			initItems()
		end
		
	end
	
end


_.keyPressed=function(key)
	if key=="f11" then
		toggleActive()
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