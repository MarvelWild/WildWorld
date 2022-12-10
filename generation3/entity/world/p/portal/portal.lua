local _={}

_.name="portal"

local image

_.load=function()
	local dir=Pow.current_dir()
	local sprite_path=dir.."res/tree.png"
	-- "entity/world/trees/tree1/res/tree.png"
	image=love.graphics.newImage(sprite_path)
end

_.new=function()
	
	local r=BaseEntity.new(_.name)
	
	r.x=120
	r.y=120
	
	return r
end


_.draw=function(entity)
	love.graphics.draw(image,entity.x,entity.y)
end



return _