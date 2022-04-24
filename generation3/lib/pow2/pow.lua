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
	local debug_info=debug.getinfo(2, "S")
    local source = debug_info.source	
	return source
end

_.current_path=current_path

-- entity\world\panther.lua -> panther
_.current_file=function()
	local source=current_path()
    if source:sub(1,1) == "@" then
        return source:sub(2):match("^.+/(.+)$"):sub(1,-5)
    else
        error("Caller was not defined in a file", 2)
    end
end

-- example: @entity/world/t/tree1/tree1.lua
_.current_dir=function()
	-- wip
	local full_path=current_path()
end



return _