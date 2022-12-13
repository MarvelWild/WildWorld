-- swiss knife for love2d


--config
local _base_path="lib/pow2/"

-- pow2 libpack+
local _={}

_.allen=require(_base_path.."allen.allen")
_.debug=require(_base_path.."debug.debug")

_.debug.bind_deps(_.allen,_)

_.log=_.debug.log

_.saveDir="save/"

--internalization
local _entity=nil
local _entity_draw=nil
local _entity_update=nil
local _entity_mousepressed=nil
--internalization end


local _frame=0
_.update=function()
	_frame=_frame+1
	_entity_update()
end

_.draw=function()
	_entity_draw()
end

_.mousepressed=function(x,y,button)
	_entity_mousepressed(x,y,button)
end


_.get_frame=function()
	return _frame
end




-- "@entity/world/t/tree1/tree1.lua"
local current_path=function(depth)
  if depth==nil then depth=2 end
	local debug_info=debug.getinfo(depth, "S")
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

-- example: @entity/world/t/tree1/tree1.lua->entity/world/t/tree1/
_.current_dir=function()
	local full_path=current_path(3)
  local path_no_header=full_path:sub(2)
  local dir=path_no_header:match("^(.+/).+$")
  return dir
end


local init_camera=function()
	local _gamera=require(_base_path.."gamera.gamera")

	--todo: explain magic
	local _cam=_gamera.new(0,0,128,128)
end

init_camera()



local init_entity=function()
	_entity=require(_base_path.."entity.entity_service")
	_.entity=_entity
	_entity_draw=_entity.draw
	_entity_update=_entity.update
	_entity_mousepressed=_entity.mouse_pressed
end

init_entity()



return _