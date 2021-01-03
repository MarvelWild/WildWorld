-- todo: multi observables
-- todo: observable sort
-- todo: observable filter
local _=BaseEntity.new("debugger_service",true)

local _isActive=false

local _observable=nil




local debug_to_string=function(entity)
	local r=""
	
	local entity_addr=get_mem_addr(entity)
	
	r=r..entity_addr.." "
	r=r.._ets(entity)
	
	local animation=entity.animation
	if animation then
		r=r.." anim state:"..tostring(entity.animation.state)
	end
	
	r=r.." sprite:"..tostring(entity.sprite)
	
--	if entity.is_watching_left then
--		r=r.." watching left"
--	end
	
	return r
end


-- substates

--- todo: implement convenient table browser
-- zbs is fine, just need easy way to put anythng from game to zbs

local state_explore_table={}


-- examine single entity
local state_entity={}


local state_show_all_entities={}


state_show_all_entities.draw=function()

	-- todo server
	if not GameState then return end
	
	local state=GameState.get()
	if not state then return end
	
	
	local message=""
	
	-- bonus: cursor coord
	
	local x,y = love.mouse.getPosition()
	local wx,wy = Pow.getWorldCoords(x,y)
	
	local coord="cursor w:".._xy(wx,wy).." s:".._xy(x,y)
	
	message=message..coord.."\n"
	
	for entity_name,entity_container in pairs(state.level.entities) do
		for k,entity in pairs(entity_container) do
		
			message=message..debug_to_string(entity).."\n"
		end
	end
	
	love.graphics.print(message,0,50)
end


local _state=state_show_all_entities

-- substates end




_.is_active=function()
	return _isActive
end


local toggleActive=function()
	_isActive=not _isActive

	if _isActive then
		-- init
	end
	
end


local full_dump=function()
	log("full dump")
	
	local mem_state=_G
	
	local debug_serialized=Pow.tserial.pack_debug(mem_state)
	
	-- stack overflow here
	--local serialized=serialize(mem_state)
	
	local filename="debugger_dump_"..os.time()
	love.filesystem.write(filename, debug_serialized)

	log("full dump done")
end


local entity_dump=function()
	log("entity dump")
	
	local data=Entity.get_all()
	
	local debug_serialized=Pow.tserial.pack_debug(data)
	
	local filename="entity_dump_"..os.time()
	love.filesystem.write(filename, debug_serialized)

	log("entity dump done")
end



local next_observable=function()
	local all_entities=Entity.get_all()
	
	local first=nil
	local pick_next=false
	for entity,v in pairs(all_entities) do
		
		if first==nil then first=entity end
		
		if pick_next then
			_observable=entity
			break
		end
		
		if _observable==nil then
			_observable=entity
			break
		else
			if _observable==entity then
				pick_next=true
			end
		end
		
		-- no cycling from last to first
	end -- for all_entities
end -- next_observable

local prev_observable=function()
	local all_entities=Entity.get_all()

	local prev=nil
	for entity,v in pairs(all_entities) do
		
		if _observable==entity then
			_observable=prev
			break
		end
		
		prev=entity
	end -- for all_entities
end -- prev_observable


local entity_log=function()
	Entity.log()
end

local collision_log=function()
	local prev_state=Debug.channel.collision.useConsole
	Debug.channel.collision.useConsole=true
	
	CollisionService.log_state()
	
	Debug.channel.collision.useConsole=prev_state
end



local keys={}

local show_help=function()
	for k,info in pairs(keys) do
		log(k.." "..info.description)		
	end
end


keys.f1={description="help",action=show_help}
keys.f3={description="prev_observable",action=prev_observable}
keys.f4={description="next_observable",action=next_observable}
keys.f8={description="collision log",action=collision_log}
keys.f9={description="entity log",action=entity_log}
keys.f10={description="entity dump",action=full_dump}
keys.f11={description="full dump",action=entity_dump}


local on_key_pressed=function(key)
	
	local handler_info=keys[key]
	if not handler_info then return end
	
	handler_info.action()

end


_.keyPressed=function(key)
	if key=="f12" then
		toggleActive()
	elseif _isActive then
		on_key_pressed(key)
	end
end


local draw_observable=function()
	if _observable==nil then return end
	local serialized=Pow.tserial.pack(_observable)
	
	local name=_ets(_observable)
	love.graphics.print(name,0,90)
	love.graphics.print(serialized,0,100)
end


_.draw_overlay=function()
	if _isActive then
		local message="debugger active. fps:".. love.timer.getFPS()
		love.graphics.print(message)
		
		draw_observable()
		
		_state.draw()
	end
end




local _draw_overlay=_.draw_overlay

_.do_draw=function()
	if not _isActive then return end

	love.graphics.setColor(0, 0.2, 0.2, 0.8)
	
	local width, height = love.window.getMode( )
	love.graphics.rectangle("fill",0,0,width,height)
	
	love.graphics.setColor( 1, 1, 1, 1)
	
	-- todo: think generic overlay system
	_draw_overlay()
end

return _




