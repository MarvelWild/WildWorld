local _={}

_.new=function()
	local r=BaseEntity.new()
	r.entity="Actionbar"
	r.isUiDrawable=true
	r.editorVisible=false
	
	Entity.register(r)
	
	return r
end

_.drawUi=function(bar)
	local player=World.player
	
	LG.draw(Img.ui_low,0,0)
	
	
	local y=2
	local x=2
	local activeFavorite=player.activeFavorite
	for k,v in pairs(player.favorites) do
		-- opt: no lookups every frame
		local sprite=Img[v.spriteName]
		LG.draw(sprite,x,y)
		
		-- wip
		if v==activeFavorite then
			LG.draw(Img.frame_active_item,x,y)
		end
		x=x+16
	end
	
	
	
end






_.keypressed=function(entity,key,unicode)
	-- wip: subscribe
	log("actionbar keypressed:"..key)
	-- wip: handle
	if key=="1" then
		Player.setActiveFavorite(1)
	elseif key=="2" then
		Player.setActiveFavorite(2)
	end
	
end


return _

--[[

old

local newUi=function()
	
	
	local init=function(ui)
		local frameImg=Img.active_baritem_frame
		ui.drawUi=function()
			
			local player=Player
			LG.push()
			LG.scale(4)	
			local y=(Main.windowHeight/Main.scale)-16
	
			LG.draw(Img.ui_low,0,y)
			-- todo:display favorites
			for k,v in ipairs(player.favorites) do
				local x=(k-1)*16+3
				LG.draw(v.sprite,x,y)
				
				if v.stackCount then
--					LG.push()
--					LG.scale(1)
					-- todo: solve scaling
					LG.print(v.stackCount,x,y)
--					LG.pop()
				end
				
				-- wip hl active
				if player.activeFavorite==v then
					LG.draw(frameImg,x,y)
				end
				
				
				local a=1
			end
			
			
			
			LG.pop()
		end
	end
	
	
	local result=Entity.new(init)
	return result
end


return newUi

]]--