--[[
expr = expression to change
callback(node) = callback that returns nil if it leaves the tree untouched, returns a value if it wishes to change the tree
--]]
local function map(expr, callback)
	-- clone
	expr = expr:clone()
	-- process children
	if expr.xs then
		for i=1,#expr.xs do
			expr.xs[i] = map(expr.xs[i], callback)
		end
	end
	-- process this node
	expr = callback(expr) or expr
	-- done
	return expr
end

return map

