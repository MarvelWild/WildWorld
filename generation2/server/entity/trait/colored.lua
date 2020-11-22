local _={}


_.set_random_color=function(entity)
	entity.color={
		r=_rnd(),
		g=_rnd(),
		b=_rnd(),
	}
end

return _