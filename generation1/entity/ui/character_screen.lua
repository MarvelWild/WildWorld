-- todo: implement

local _={}

_.name="CharacterScreen"

_.new=function()
	local r=BaseEntity.new()
	r.isUiDrawable=true
	r.editorVisible=false
	
	Entity.register(r)
	
	return r
end --new

_.drawUi=function(bar)
	
end --drawUi



_.keypressed=function(entity,key,unicode)
end -- keypressed


return _
