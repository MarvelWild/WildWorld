local _={}

local image

_.load=function()
	local dir=Pow.current_dir()
	local sprite_path=dir.."res/tree.png"
	-- "entity/world/trees/tree1/res/tree.png"
	image=love.graphics.newImage(sprite_path)
end

_.new=function()
	local r={}
	
	r.x=100
	r.y=100
	
	return r
end


_.draw=function(tree)
	love.graphics.draw(image,tree.x,tree.y)
end



return _