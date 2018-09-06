local _={}

_.new=function()
	local r=BaseEntity.new()
	r.entity="PlayerUi"
--	r.isUiDrawable=true
	r.isScaledUiDrawable=true
	r.editorVisible=false
	
	Entity.register(r)
	
	return r
end --new

_.drawScaledUi=function()
	local player=World.player
	
	
	local hp=string.format("%0d",player.hp)
	LG.print("hp:"..hp, 5,84)
	
end


_.drawUi=function(bar)


	
end --drawUi



--_.keypressed=function(entity,key,unicode)
--	-- log("actionbar keypressed:"..key)
	
--	if key=="1" then
--		Player.setActiveFavorite(1)
--	elseif key=="2" then
--		Player.setActiveFavorite(2)
--	elseif key=="3" then
--		Player.setActiveFavorite(3)
--	elseif key=="4" then
--		Player.setActiveFavorite(4)		
--	elseif key=="5" then
--		Player.setActiveFavorite(5)
--	end
	
--end -- keypressed


return _
