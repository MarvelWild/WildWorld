-- Graph contains the following Enums:
-- 		Graph.GraphType - Values: OneWay, TwoWay
--			OneWay: The Graph will assume connections are one-way (Connect('A', 'B', 1) will connect 'A' to 'B', but not 'B' to 'A'
--			TwoWay: The Graph will assume connections are two-way (Conenct('A', 'B', 1) will connect 'A' to 'B' and 'B' to 'A'
-- Graph contains the following functions:
--		.new(graphType) - Creates a new Graph
--			graphType - Enum value Graph.GraphType
-- A Graph object has the following functions:
--		:AddVertex(newVertex) - Adds a vertex to the graph
--		:ReplaceVertex(oldVertex, newVertex) - Replaces the oldVertex with the newVertex in all connections in the Graph
--		:RemoveVertex(vertex) - Removes the vertex, all of its connections, and all connections to it
--		:Connect(vertex1, vertex2, cost) - Connects vertex1 to vertex2 with a connection value cost - This also functions as SetConnectionCost
--			cost: Values of false are treated as nil, defaults to true if no cost is given
--		:GetConnectionCost(vertex1, vertex2) - Gets the connection value between vertex1 and vertex2
--		:Disconnect(vertex1, vertex2) - Removes the connection between vertex1 and vertex2
--		:Adjacent(vertex1, vertex2) - Returns true if the two vertices are connected, false if not. If TwoWay Graph, the connection must be both ways to return true
--		:Neighbors(vertex) - Return a table of all connected vertices to vertex. Returns nil if empty. If TwoWay Graph, the connection must be both ways to be returned
--		:Clone() - Creates and returns a new copy of the Graph

local Graph = {}
Graph.__index = Graph

Graph.GraphType = { OneWay = 1, TwoWay = 2 }

-- Assumes costs are non-false values
-- This is an adjacency matrix
function Graph.new(graphType)
	if not graphType then
		graphType = Graph.GraphType.TwoWay
	end
	
	local newGraph = { }
	newGraph.Type = graphType
	setmetatable(newGraph, Graph)
	return newGraph
end

function Graph:AddVertex(newVertex)
	if not self[newVertex] then
		self[newVertex] = { }
	end
end

function Graph:ReplaceVertex(oldVertex, newVertex)
	if not self[oldVertex] then
		self:AddVertex(newVertex)
	else
		self[newVertex] = self[oldVertex]
		self[oldVertex] = nil
		
		for v, e in pairs(self) do
			if v ~= "Type" and e[oldVertex] then
				e[newVertex] = e[oldVertex]
				e[oldVertex] = nil
			end
		end
	end
end

function Graph:RemoveVertex(vertex)
	if self[vertex] then
		self[vertex] = nil
	end
	
	for v, e in pairs(self) do
		if v ~= "Type" and e[vertex] then
			e[vertex] = nil
		end
	end
end

function Graph:Connect(vertex1, vertex2, cost)
	if not cost then
		cost = true
	end
	
	if self[vertex1] and self[vertex2] then
		self[vertex1][vertex2] = cost
		if self.Type == Graph.GraphType.TwoWay then
			self[vertex2][vertex1] = cost
		end
	end
end

function Graph:GetConnectionCost(vertex1, vertex2)
	if self[vertex1] and self[vertex2] then
		if self.Type == Graph.GraphType.TwoWay then
			if self[vertex2][vertex1] and self[vertex1][vertex2] then
				return self[vertex1][vertex2]
			else
				return nil
			end
		else
			if self[vertex1][vertex2] then
				return self[vertex1][vertex2]
			else
				return nil
			end
		end
	end	
end

function Graph:Disconnect(vertex1, vertex2)
	if self[vertex1] then
		self[vertex1][vertex2] = nil
		
		if self.Type == Graph.GraphType.TwoWay and self[vertex2] then
			self[vertex2][vertex1] = nil
		end
	end
end

function Graph:Adjacent(vertex1, vertex2)
	if self[vertex1] and self[vertex2] then
		if self[vertex1][vertex2] then
			if self.Type == Graph.GraphType.TwoWay then
				if self[vertex2][vertex1] then
					return true
				end
			else
				return true
			end
		end
	end
	return false
end

function Graph:Neighbors(vertex)
	if self[vertex] then
		local neighbors = { }
		for v, c in pairs(self[vertex]) do
			if self.Type == Graph.GraphType.OneWay then
				table.insert(neighbors, v)
			else
				if self[v] and self[v][vertex] then
					table.insert(neighbors, v)
				end
			end
		end
		
		if #neighbors > 0 then
			return neighbors
		end
	end
	
	return nil
end

function Graph:Clone()
	local newGraph = { }
	for k, v in pairs(self) do
		newGraph[k] = v
		if k ~= "Type" then
			for k2, v2 in pairs(v) do
				newGraph[k][k2] = v2
			end
		end
	end
	setmetatable(newGraph, Graph)
	return newGraph
end

return Graph
