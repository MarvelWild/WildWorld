local _={}

_.new=function()
	local r=BaseEntity.new()
	r.entity="Actionbar"
	r.isUiDrawable=true
	r.editorVisible=false
	
	Entity.register(r)
	
	return r
end --new

_.drawUi=function(bar)
	local player=CurrentPlayer
	if player==nil then return end
	
	LG.draw(Img.ui_low,0,0)
	
	
	local y=2
	local x
	local activeFavorite=player.activeFavorite
	for k,v in pairs(player.favorites) do
		-- opt: no lookups every frame
		
		x=k*16-14
		local sprite=Img[v.spriteName]
		LG.draw(sprite,x,y)
		
		if v==activeFavorite then
			LG.draw(Img.frame_active_item,x,y)
		end
	end
	
end --drawUi



_.keypressed=function(entity,key,unicode)
	-- log("actionbar keypressed:"..key)
	
	if key=="1" then
		Player.setActiveFavorite(1)
	elseif key=="2" then
		Player.setActiveFavorite(2)
	elseif key=="3" then
		Player.setActiveFavorite(3)
	elseif key=="4" then
		Player.setActiveFavorite(4)		
	elseif key=="5" then
		Player.setActiveFavorite(5)
	end
	
end -- keypressed


return _
