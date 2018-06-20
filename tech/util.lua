local serpentOptions=
{
	nocode=true,
	indent = '  ',
}
-- local scope

local _={}

-- easy data
_.debugPrint=function(data)
	return TSerial.pack(data,true,false)
end

-- max info
_.dump=function(data)
	return Serpent.dump(data)
end

-- save
_.serialize=function(data)
	return Serpent.dump(data, serpentOptions)
end

-- load
_.deserialize=function(str)
	return loadstring(str)()
end


--serialize=function(data)
--	return TSerial.pack(data,true,true)
--end

--deserialize=function(str)
--	return TSerial.unpack(str)
--end


_.xy=function(x,y)
	if type(x) == "table" then
		assert(y==nil)
		y=x.y
		x=x.x
	end
	
	if x==nil then x="nil" end
	if y==nil then y="nil" end
	
	return x..","..y
end

-- example: loadScripts("server/handlers/", destTable)
_.loadScripts=function(dir, container)
	local files=love.filesystem.getDirectoryItems(dir)
	for k,item in ipairs(files) do
		if Allen.endsWith(item, ".lua") then
			local name=Allen.strLeftBack(item, ".lua")
			container[name]=require(dir..name)
		end
	end
end

_.table_delete=function(t,fnIsDeleteItem)
	local toDelete=nil

	for k,v in pairs(t) do
		if fnIsDeleteItem(v) then
			if toDelete==nil then toDelete={} end
			table.insert(toDelete,k)
		end
	end
	
	if toDelete~=nil then
		for k,v in pairs(toDelete) do
			t[v]=nil
		end
	end
end

_.table_isEmpty=function(t)
	return next(t)~=nil
end


-- returns isRemoved
_.table_removeByVal=function(t, x)
  local iter = Lume.getiter(t)
	local result=false
  for i, v in iter(t) do
    if v == x then
			result=true
      if Lume.isarray(t) then
        table.remove(t, i)
        break
      else
        t[i] = nil
        break
      end
    end
  end
  return result
end

_.hasArg=function(name)
	return Lume.find(arg, name)~=nil
end

-- game coords
_.getMouseXY=function()
	local x=love.mouse.getX()
	local y=love.mouse.getY()
	local gameX,gameY=Cam:toWorld(x,y)
	return gameX,gameY
end

function string.split(str, div)
    assert(type(str) == "string" and type(div) == "string", "invalid arguments")
    local result = {}
    while true do
			if str==nil or str=="" then break end
			local pos1,pos2 = str:find(div)
			if not pos1 then
					result[#result+1] = str
					break
			end
			
			local part=str:sub(1,pos1-1)
			if part~="" then
				result[#result+1]=part
				str=str:sub(pos2+1)
			end
    end
    return result
end







-- global exports (frequently used)
table_removeByVal=_.table_removeByVal
table_delete=_.table_delete
table_isEmpty=_.table_isEmpty
loadScripts=_.loadScripts
xy=_.xy
serialize=_.serialize
deserialize=_.deserialize


return _