-- Pathfinder contains the following functions:
--		.new(graph, estimateDistance, comparator) - Creates a new node-based Pathfinder
--			graph: The map of nodes that will be traversed
--				Graph must have the following functions:
--					:Neighbors(node) - Returns a table of all adjacent nodes
--					:GetConnectionCost(node1, node2) - Returns how "far" node2 is from node1
--			estimateDistance(node1, node2): A function that estimates how far node1 is from node2
--				Must be admissible - Can never overestimate "distance" from node1 to node2
--			comparator(node1, node2): A function that compares total cost of two nodes
--				Should return -1 if node1 is further than node2, 1 if node1 is shorter than node2, and 0 if they are even
--				Should accept nodes as format node = {nodeData, costSoFarTable, estimatedCostTable} where costSoFarTable and estiamtedCostTable are indexed by nodeData
-- A Pathfinder object has the following functions:
--		:FindPath(start, goal) - Find a path between the start and goal nodes. Returns nil if no path is found, otherwise returns path in reverse order

local SortedList = require(303863742) -- This is the Roblox Wiki asset id for the SortedList module

local Pathfinder = {}
Pathfinder.__index = Pathfinder

-- Should accept nodes as format node = {nodeData, costSoFarTable, estimatedCostTable} 
-- where costSoFarTable and estiamtedCostTable are indexed by nodeData
local function Compare(node1, node2)
	if node1[3][node1[1]] > node2[3][node2[1]] then
		return -1
	elseif node1[3][node1[1]] < node2[3][node2[1]] then
		return 1
	else
		return 0
	end
end

local function reconstructPath(cameFrom, current)
	local path = { current }
	while cameFrom[current] do
		current = cameFrom[current]
		table.insert(path, current)
	end
	return path
end

function Pathfinder.new(graph, estimateDistance, comparator)
	local newPathfinder = { }
	newPathfinder.Graph = graph
	newPathfinder.EstimateDistance = estimateDistance
	if not comparator then
		comparator = Compare
	end
	setmetatable(newPathfinder, Pathfinder)
	newPathfinder.Open = SortedList.new(comparator)
	return newPathfinder
end

function Pathfinder:FindPath(start, goal)
	local closed = { }
	local open = self.Open
	open:Clear()
	local cameFrom = { }
	local estimateDistance = self.EstimateDistance
	
	local gs = { }
	local fs = { }
	
	gs[start] = 0
	fs[start] = estimateDistance(start, goal)
	
	open:Add({start, gs, fs})
	
	while open:Size() > 0 do
		local current = open:Pop()
		
		if current[1] == goal then
			return reconstructPath(cameFrom, current[1])
		end
		
		closed[current[1]] = true

		local neighbors = self.Graph:Neighbors(current[1])
		for i = 1, #neighbors do
			local n = neighbors[i]
			if not closed[n] then
				local ng = gs[current[1]] + self.Graph:GetConnectionCost(current[1], n)
				local contains = open:Contains({n, gs, fs})
				if not contains or ng < gs[n] then
					local nh = estimateDistance(n, goal)
					gs[n] = ng
					fs[n] = ng+nh
					cameFrom[n] = current[1]
					if not contains then open:Add({n, gs, fs})
					else open:Sort() end
				end
			end
		end
	end
	
	return nil
end

return Pathfinder
