local _=BaseEntity.new("help_screen",true)

_.active=false

_.drawUnscaledUi=function()
	local message="F12 - debugger"
	love.graphics.print("Help:", 0, 80)
	love.graphics.print(message, 0, 100)
end


return _
