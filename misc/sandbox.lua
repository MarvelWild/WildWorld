local serpentTests=function()
	local item={name="mock"}
	local player=
	{
		name="player",
		inventory={item},
		activeItem=item,
		Sprite=Img.player,
		draw=function()
			LG.print("player")
		end
		
	}
	
	local world={
		player,
		item,
		update=function() local a=1	end
		
	}
	
	local playerTest=world[1]
	local itemTest=world[2]
	
	local ft={function() local a=1 end}
	
	local save=serialize(world)
	local loaded=deserialize(save)
	
	local playerTest2=loaded[1]
	local itemTest2=loaded[2]
	
--	local save=Serpent.dump(world)
--	local save2=Serpent.dump(ft)
--	local loaded=Serpent.load(save)
--	local loaded2=loadstring(save)
--	local loaded3=loaded2()
	local a=1
end







-- serpentTests() seems ok