-- connect all the libs
Pow=require "shared.lib.powlov.pow"
Img=require "shared.res.img"
Flux=Pow.flux

Entity=Pow.entity
BaseEntity=Pow.baseEntity



-- shortcuts
Debug=Pow.debug
log=Pow.debug.log
draw=love.graphics.draw
Inspect=Pow.inspect

serialize=Pow.pack
deserialize=Pow.unpack

_str=serialize
_obj=deserialize

_ets=Entity.toString
_ref=Entity.get_reference
_rnd=love.math.random
_frm=Pow.get_frame

-- resolve entity from reference dto
-- defined for client and server separatedly
_deref=nil

-- number default representation
_n=function(number)
	if number==nil then return "nil" end
	
	return string.format("%0.2f", number)
end

-- easy way to print coords
_xy=function(x,y)
	return _n(x)..",".._n(y)
end

nop=function()
end


--todo:describe console 1 liner?
_strc=function(s)
	local result=_str(s)
	result=Pow.allen.substitute("\n","")
	result=Pow.allen.substitute("\\n","")
	result=Pow.allen.substitute("\9","")
	result=Pow.allen.substitute("\\9","")
	-- todo: replace \n \9
	
	return result
end
