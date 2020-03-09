-- empower lua itself

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

-- Allen.includes(str,sub)
--function string.contains(str,what)
--end


-- numbered only
table.clear=function(t)
	local count = #t
	for i=0, count do t[i]=nil end
end

table.append=function(t,other)
	for k,v in pairs(other) do
		table.insert(t,v)
	end
end


function get_mem_addr (object)
    local str = tostring(object)    
    return str:sub(str:find(' ') + 1)
end