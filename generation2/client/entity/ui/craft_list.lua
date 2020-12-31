-- craft ui
-- global CraftList

local entity_name=Pow.currentFile()
local _=BaseEntity.new(entity_name,true)

local _craftables=nil

--_.drawUnscaledUi=function()
--	love.graphics.print(entity_name.."unscaled")
--end

_.draw_ui=function()
	-- overlay
	love.graphics.setColor(0, 0.2, 0.2, 0.8)
	
	local width, height = love.window.getMode( )
	love.graphics.rectangle("fill",0,0,width,height)
	
	love.graphics.setColor( 1, 1, 1, 1)
	
	-- items
	local x=16
	local y=16
	for k,craftable in pairs(_craftables) do
		local craftable_name=craftable.name
		local icon=Img.get(craftable_name)
		love.graphics.draw(icon,x,y)
		
		
		-- todo: not calc this at draw
		craftable.x=x
		craftable.y=y
		craftable.w=icon:getWidth()
		craftable.h=icon:getHeight()
		
		love.graphics.rectangle("line", x, y,craftable.w, craftable.h)
		
		y=y+24
	end
	
--	love.graphics.print("wasted",94,116)
end

_.set=function(craftables)
	_craftables=craftables
end


_.mouse_pressed_exclusive=true


local _is_open=false

_.open=function()
	if _is_open then return end
	Entity.add(CraftList)
	_is_open=true
end


_.close=function()
	if not _is_open then return end
	Entity.remove(CraftList)
	_is_open=false
end


_.mousePressed=function(gameX,gameY,button,istouch)
	if button~=1 then 
		_.close()
	end
	
	local ui_x,ui_y=Pow.get_ui_coords(gameX,gameY)
	
	-- todo: generic bbox hit
	for k,craftable in pairs(_craftables) do

		local x1=craftable.x
		local x2=x1+craftable.w
		if ui_x>x1 and ui_x<x2 then
			local y1=craftable.y
			local y2=y1+craftable.h
			if ui_y>y1 and ui_y<y2 then
				log("clicked:"..craftable.name)
				
				-- todo: lock until server response
				local event=Event.new("craft_request")
				event.target="server"
				event.craftable=craftable
				Event.process(event)
			end
		end
	end
	
end



return _