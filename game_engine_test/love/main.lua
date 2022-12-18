local entities={}
local sprite=nil

local custom_run=true
custom_run=false
local entity_count=50000

local rnd_x=function()
	return math.random(1,800)
end

local rnd_y=function()
	return math.random(10,600)
end


local make_entity=function()
	local entity={}
	
	entity.x=rnd_x()
	entity.y=rnd_y()
	entity.sprite=sprite
	
	table.insert(entities,entity)
end



love.load=function()

	love.window.setVSync(0)
	sprite=love.graphics.newImage("test64.png")
	
	for i=1,entity_count do
		make_entity()
	end
end


love.update=function()
end


love.draw=function()
	local fps = love.timer.getFPS( )
	love.graphics.print("fps:"..fps)
	--love.graphics.print("count:"..#entities)
	
	for k,entity in ipairs(entities) do
		love.graphics.draw(entity.sprite,entity.x,entity.y)
	end
	
end


if (custom_run) then

	function love.run()
		if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

		-- We don't want the first frame's dt to include time taken by love.load.
		if love.timer then love.timer.step() end

		local dt = 0

		-- Main loop time.
		return function()
			-- Process events.
			if love.event then
				love.event.pump()
				for name, a,b,c,d,e,f in love.event.poll() do
					if name == "quit" then
						if not love.quit or not love.quit() then
							return a or 0
						end
					end
					love.handlers[name](a,b,c,d,e,f)
				end
			end

			-- Update dt, as we'll be passing it to update
			if love.timer then dt = love.timer.step() end

			-- Call update and draw
			if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

			if love.graphics and love.graphics.isActive() then
				love.graphics.origin()
				love.graphics.clear(love.graphics.getBackgroundColor())

				if love.draw then love.draw() end

				love.graphics.present()
			end

			--if love.timer then love.timer.sleep(0.001) end
		end
	end
end