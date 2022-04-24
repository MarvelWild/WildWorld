local _={}

_.update=function()
	local frame=Pow.get_frame()
	if (frame%100==0) then
		log("sim update:"..frame)
	end
	
end


return _