--config
local _base_path="lib/pow2/"

-- pow2 libpack+
local _={}

_.allen=require(_base_path.."allen.allen")
_.debug=require(_base_path.."debug.debug")

_.debug.bind_deps(_.allen,_)

_.log=_.debug.log

_.saveDir="save/"


local _frame=0
_.update=function()
	_frame=_frame+1
end

_.get_frame=function()
	return _frame
end




-- "@entity/world/t/tree1/tree1.lua"
local current_path=function()
	-- 3 - stack level
		-- 1- this, 2 - caller from pow, 3 - outside pow
	-- S	selects fields source, short_src, what, and linedefined
	local debug_info=debug.getinfo(3, "S")
    local source = debug_info.source
	return source
end

-- stack level different, so internal
--_.current_path=current_path

-- filename, no ext
-- entity\world\panther.lua -> panther
_.current_file=function()
	local source=current_path()
    if source:sub(1,1) == "@" then
        return source:sub(2):match("^.+/(.+)$"):sub(1,-5)
    else
        error("Caller was not defined in a file", 2)
    end
end


-- example: entity/world/t/tree1/
_.current_dir=function()
	local full_path=current_path()
	local result=full_path:match("@(.*/)")
	return result
end



return _