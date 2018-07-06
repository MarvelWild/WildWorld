-- glob TilesView
local _={}

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
	
--	log("drawTiles("..l..","..t..","..w..","..h.." x:"..xy(startX,endX))
	
--	-- tile version (same performance)
--	local startTileX=startX/tileSize
--	local startTileY=startY/tileSize
--	local endTileX=endY/tileSize
--	local endTileY=endY/tileSize
	
--	for tileY=startTileY,endTileY,1 do
--		for tileX=startTileX,endTileX,1 do
--			--opt precalc tiles
--			local tileNumber=tileX+((tileY)*128)
--			local imgId="level_main/tile"..tileNumber
--			local img=Img[imgId]
			
--			LG.draw(img,x*tileSize,y*tileSize)
--		end
--	end
	
-- prev pixel version	
	for y=startY,endY,tileSize do
		for x=startX,endX,tileSize do
			local tileX=x/tileSize
			local tileY=y/tileSize
			--opt precalc tiles
			local tileNumber=tileX+((tileY)*128)
			
			local img=Tile[tileNumber]
			draw(img,x,y)
			-- drawTile(tileNumber,x,y)
		end
	end
end

return _