--global MusicService
local _=BaseEntity.new("music_service",true)


local _source_ambient=nil
local _source_fx=nil

local _sound_enabled=true

_.set_volume=function(value)
	if value<=0 then
		_sound_enabled=false
	end
	
end


-- todo: crossfade
-- todo: cancel prev
_.play_ambient=function(name)
	if not _sound_enabled then 
		return 
	end
	
	local path="shared/res/sound/"..name..".ogg"
	
	_source_ambient = love.audio.newSource(path, "stream")
	love.audio.play(_source_ambient)
end

_.fx=function(name, ext)
	if not _sound_enabled then 
		return 
	end
	
	if not ext then ext="ogg" end
	
	local path="shared/res/sound/fx/"..name.."."..ext
	
	_source_fx = love.audio.newSource(path, "stream")
	love.audio.play(_source_fx)
end


return _