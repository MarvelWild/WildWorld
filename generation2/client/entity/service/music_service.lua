local _=BaseEntity.new("music_service",true)


local _source_ambient=nil

-- todo: crossfade
-- wip
_.play_ambient=function(name)
	
	local path="shared/res/sound/"..name..".ogg"
	
	_source_ambient = love.audio.newSource(path, "stream")
	love.audio.play(_source_ambient)
end


return _