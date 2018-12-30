local _={}

_.name="PlayerUi"

_.new=function(options)
	if options==nil then options={} end
	
	options.isService=true
	
	local r=BaseEntity.new(options)
	
--	r.isUiDrawable=true
	r.isScaledUiDrawable=true
	r.editorVisible=false
	
	Entity.afterCreated(r,_,options)
	
	return r
end --new

_.drawScaledUi=function()
	local player=CurrentPlayer
	if player==nil then return end
	
	
	local hp=string.format("%0d",player.hp)
	local energy=string.format("%.2f",player.energy)
	
	-- todo: display when it makes sense
	LG.print("hp:"..hp, 5,84)
	LG.print("e:"..energy, 5,104)
	
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
