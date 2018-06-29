-- frontend to lib/profile/profile

local _={}

_.new=function()
	local r=BaseEntity.new()
	r.entity="Profiler"
	r.isDrawable=false
	r.isUiDrawable=false --4x
	r.isScaledUiDrawable=true -- 1x
	r.isActive=false
	
	r.engine=require('lib/profile/profile') 
	r.report="no report yet"
	
	Entity.register(r)
	
	return r	
end
	
	
			
--			profiler.drawUi=function()
--				LG.print(profiler.report)
--			end
			
--			profiler.update=function()
--				if Session.frame%100 == 0 then
--					profiler.report = profiler.engine.report('time', 20)
--					profiler.engine.reset()
--				end
--			end
			
			
			
--		end
--	)
--	return result
--end

_.drawScaledUi=function(profiler)
	LG.print("I am profiler")
	LG.print(profiler.report,0,42)
end

_.activate=function(profiler)
	log("profiler activated")
	profiler.engine.hookall("Lua")
	profiler.engine.start()
end

_.update=function(profiler)
	if Session.frame%100 == 0 then
		profiler.report = profiler.engine.report('time', 20)
		profiler.engine.reset()
	end
end


_.deactivate=function(editor)
	log("profiler deactivated")
-- wip
end


return _