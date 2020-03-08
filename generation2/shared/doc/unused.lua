-- p is percentage running from 0 to 1
-- $e is exression from easing
-- result is percentrage from 0 to 1
-- start easing at 80%, linear before
-- log and research that
flux.easing["quadout_edge"]=function(p)
		p = 1-p -- out
		
		-- linear first
		if p>0.2 then
			return 1-p
		end
		
		-- bug: this switch chages coord, makes jump
		-- google something ready
		
		-- then quad
    return 1 - (p*p)
end