-- BinarySearch contains the following functions:
-- 		:Search(tableToSearch, toFind, compareFunction) - Search the provided table for the requested value
--			comparator: Uses this function to compare values. If none is given, will assume the largest value is table[1]
--						Comparator should accept two values and return 1 if a > b, -1 if a < b, and 0 if a == b
--		:FindInsertPoint(tableToSearch, toInsert, comparator) - Returns the index of an insertion point for the provided value in the provided table
--			comparator: Uses this function to compare values. If none is given, will assume the largest value is table[1]
--						Comparator should accept two values and return 1 if a > b, -1 if a < b, and 0 if a == b
-- BinarySearch assumes a sorted table and returns nil if there is no valid value/index

local BinarySearch = {}

function BinarySearch.DefaultCompare(a, b)
	if b > a then
		return -1
	elseif b < a then
		return 1
	else
		return 0
	end
end

function BinarySearch:Search(tableToSearch, toFind, comparator)
	if not comparator then
		comparator = BinarySearch.DefaultCompare
	end
	
	local minIndex = 1
	local maxIndex = #tableToSearch
	
	while minIndex <= maxIndex do
		local mid = math.floor((maxIndex+minIndex)/2)
		
		local compareVal = comparator(tableToSearch[mid], toFind)
		if compareVal == 0 then
			return mid
		elseif compareVal > 0 then
			minIndex = mid + 1
		else
			maxIndex = mid - 1
		end
	end
	
	return nil
end

function BinarySearch:FindInsertPoint(tableToSearch, toInsert, comparator)
	if #tableToSearch == 0 then
		return 1
	end
	
	if not comparator then
		comparator = BinarySearch.DefaultCompare
	end
	
	local minIndex = 1
	local maxIndex = #tableToSearch
	local mid
	
	while true do
		mid = math.floor((maxIndex+minIndex)/2)
		local compareVal = comparator(tableToSearch[mid], toInsert)
		if compareVal == 0 then
			return mid
		elseif compareVal > 0 then
			minIndex = mid+1
			if minIndex > maxIndex then
				return mid+1
			end
		else
			maxIndex = mid-1
			if minIndex > maxIndex then
				return mid
			end
		end
	end
end

return BinarySearch
