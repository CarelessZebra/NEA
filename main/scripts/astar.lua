local heap = require("main/scripts/heap")
local M = {}
--gets heuristic value for point
function M.heuristic(x1, y1, x2, y2)
	local distance = math.abs(x1-x2) + math.abs(y1-y2)
	return distance
end

function M.astar(grid_size, costs, goal, start)
	--A "queue" to tell it what node to go to next. It's really just a haep
	local queue = heap()
	queue:add(0, start)
	--keeps track of last node visited
	local last = {}
	last[start] = start
	--keeps track of current cost. would be more accurate to use heuristic for cost of start but not needed
	local cost = {}
	cost[start] = 0

	local width = grid_size[1]
	local height = grid_size[2]
	local goalX = math.floor((goal-1) % width)
	local goalY = math.floor((goal-1) / width)

	--iterates through queue while it's not empty
	while not queue:empty() do
		priority, current = queue:pop()
		--once destination reached it breaks
		if current == goal then
			break
		end
			local x = math.floor((current-1) % width)
			local y = math.floor((current-1) / width)
			
			--do the A* thing for all the neighbours of the current node 
			--these are just the neighbouring tiles left, right, up and down
			--down tile
			if x >= 0 and x < width and y-1 >= 0 and y-1<height then
				--gets the relevant index
				local next = (y-1)*width + x + 1
				local current_cost = cost[current]
				--finds new cost of path
				local new_cost = current_cost+costs[next]
				local next_cost = cost[next]
				
				if next_cost == nil or new_cost < next_cost then
					cost[next] = new_cost
					--gets f value of tile
					local prio = new_cost + M.heuristic(x, y-1, goalX, goalY)
					--adds tile to priority queue
					queue:add(prio, next)
					last[next] = current
				end
			end
			--up tile
			if x >= 0 and x < width and y+1 >= 0 and y+1<height then
				local next = (y+1) * width + x + 1
				local current_cost = cost[current]
				local new_cost = current_cost + costs[next]
				local next_cost = cost[next]

				if next_cost == nil or new_cost < next_cost then
					cost[next] = new_cost
					local prio = new_cost + M.heuristic(x, y+1, goalX, goalY)
					queue:add(prio, next)
					last[next] = current
				end
			end
			--left tile
			if x-1 >= 0 and x-1 < width and y >= 0 and y<height then
				local next = (y)*width + x - 1 + 1
				local current_cost = cost[current]
				local new_cost = current_cost+costs[next]
				local next_cost = cost[next]

				if next_cost == nil or new_cost < next_cost then
					cost[next] = new_cost
					local prio = new_cost + M.heuristic(x-1, y, goalX, goalY)
					queue:add(prio, next)
					last[next] = current
				end
			end
			--right tile
			if x+1 >= 0 and x+1 < width and y >= 0 and y<height then
				local next = (y)*width + x + 1 + 1
				local current_cost = cost[current]
				local new_cost = current_cost+costs[next]
				local next_cost = cost[next]

				if next_cost == nil or new_cost < next_cost then
					cost[next] = new_cost
					local prio = new_cost + M.heuristic(x+1, y, goalX, goalY)
					queue:add(prio, next)
					last[next] = current
				end
			end
	end
	return last, cost
end

return M






	