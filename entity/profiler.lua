-- frontend to lib/profile/profile

local newProfiler=function()
	local result=Entity.new(
		function(profiler)
			profiler.engine=require('lib/profile/profile') 
			profiler.report="no report yet"
			profiler.editorVisible=false
			
			profiler.activate=function()
				profiler.engine.hookall("Lua")
				profiler.engine.start()
			end
		
			profiler.deactivate=function()
			end
			
			
			
			profiler.drawUi=function()
				LG.print(profiler.report)
			end
			
			profiler.update=function()
				if Session.frame%100 == 0 then
					profiler.report = profiler.engine.report('time', 20)
					profiler.engine.reset()
				end
			end
			
			
			
		end
	)
	return result
end

return newProfiler