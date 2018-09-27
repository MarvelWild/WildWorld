-- glob TilesView
local _={}

local _getTile=Tile.get
local _draw=love.graphics.draw

_.draw=function(l,t,w,h)
	-- log("drawTiles("..l..","..t..","..w..","..h)
	
	-- todo: optimize
	
	local tileSize=TILE_SIZE
	local dualTile=tileSize+tileSize
	
	local startY=Lume.round(t,tileSize)-tileSize
	local endY=startY+h+dualTile
	
	local startX=Lume.round(l,tileSize)-tileSize
	local endX=startX+w+dualTile
	
	if startY<0 then startY=0 end
	if startX<0 then startX=0 end
	local max=4096-tileSize
	if endX>max then endX=max end
	if endY>max then endY=max end
	

	for y=startY,endY,tileSize do
		for x=startX,endX,tileSize do
			local tileX=x/tileSize
			local tileY=y/tileSize
			--opt precalc tiles
			local tileNumber=tileX+((tileY)*128)
			
			local img=_getTile(tileNumber)
			
			_draw(img,x,y)
		end
	end
end

return _