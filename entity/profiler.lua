-- frontend to lib/profile/profile

local _={}

_.name="Profiler"

_.new=function(options)
	if options==nil then options={} end
	
	options.isService=true
	local r=BaseEntity.new(options)
	r.isDrawable=false
	r.isUiDrawable=false --4x
	r.isScaledUiDrawable=true -- 1x
	r.isActive=false
	
	r.engine=require('lib/profile/profile') 
	r.report="no report yet"
	
	Entity.afterCreated(r,_,options)
	
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


_.deactivate=function(profiler)
	log("profiler deactivated")
	profiler.engine.stop()
end


return _