local _={}

_.name="Zombie"

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.x=0
	result.y=0
	
	result.originX=3
	result.originY=7
	
	Entity.setSprite(result,"zombie_1")
	result.isDrawable=true
	result.aiEnabled=true
	
	Entity.afterCreated(result,_,options)
	
	return result
end

_.draw=function(zombie)
	local sprite=Img[zombie.spriteName]
	LG.draw(sprite,zombie.x,zombie.y)
	
--	debug seek
	
--	if zombie._seekRectX~=nil then
--		LG.rectangle("line",zombie._seekRectX,zombie._seekRectY,zombie._seekRectW,zombie._seekRectH)
--	end
	
--	-- todo: generic solution
--	if zombie._debugText~=nil then
--		-- text too big
--		LG.print(zombie._debugText, zombie.x,zombie.y)
--	end
	
	
	
end


_.updateAi=require("misc/ai/zombie_ai")


return _