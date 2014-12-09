require 'ext'

local ToString = require 'symmath.tostring.ToString'

local LaTeX = class(ToString)

LaTeX.lookupTable = {
	[require 'symmath.Constant'] = function(self, expr)
		local s = tostring(expr.value)	
		local a,b = s:match('([^e]*)e(.*)')
		if a and b then
			if b:sub(1,1) == '+' then b = b:sub(2) end
			return a .. [[\cdot 10^{]]..b..'}'
		end
		return s
	end,
	[require 'symmath.Invalid'] = function(self, expr)
		return '?'
	end,
	[require 'symmath.Function'] = function(self, expr)
		return expr.name .. '\\left (' .. table.map(expr, function(x,k)
			if type(k) ~= 'number' then return end
			return '{' .. self:apply(x) .. '}'
		end):concat(',') .. '\\right )'
	end,
	[require 'symmath.sqrt'] = function(self, expr)
		return '\\sqrt{'..self:apply(expr[1])..'}'
	end,
	[require 'symmath.unmOp'] = function(self, expr)
		return '-{'..self:wrapStrOfChildWithParenthesis(expr, 1)..'}'
	end,
	[require 'symmath.BinaryOp'] = function(self, expr)
		return table.map(expr, function(x,i)
			if type(i) ~= 'number' then return end
			return '{' .. self:wrapStrOfChildWithParenthesis(expr, i) .. '}'
		end):concat(expr:getSepStr())
	end,
	[require 'symmath.mulOp'] = function(self, expr)
		local Variable = require 'symmath.Variable'
		local Constant = require 'symmath.Constant'
		local res = table()
		for i=1,#expr do
			res:insert(self:wrapStrOfChildWithParenthesis(expr, i))
			if i > 1 then
				-- insert \cdot between neighboring variables if any have a length > 1 ... or if the lhs has a length > 1 ...
				-- TODO don't do this if those >1 length variables are LaTeX strings for single-char greek letters
				if expr[i-1]:isa(Variable)
				and #expr[i-1].name > 1
				--and expr[i]:isa(Variable)
				then
					res[i-1] = res[i-1] .. '\\cdot'
				-- insert \cdot between neighboring numbers
				elseif expr[i-1]:isa(Constant)
				and expr[i]:isa(Constant)
				then
					res[i-1] = res[i-1] .. '\\cdot'
				end
			end
		end
		for i=1,#res do
			res[i] = '{'..res[i]..'}'
		end
		return res:concat(expr:getSepStr())
	end,
	[require 'symmath.divOp'] = function(self, expr)
		return '{{' .. self:apply(expr[1]) .. '} \\over {' .. self:apply(expr[2]) .. '}}'
	end,
	[require 'symmath.Variable'] = function(self, expr)
		local s = expr.name
		if expr.value then
			s = s .. '|' .. expr.value
		end
		return '{'..s..'}'
	end,
	[require 'symmath.Derivative'] = function(self, expr) 
		local Variable = require 'symmath.Variable'

		local diffVars = table.sub(expr, 2)
		local diffPower = #diffVars
		
		local diffExpr = expr[1]
		local diffExprStr = self:apply(diffExpr)
		local diffExprOnTop = diffExpr:isa(Variable)
		
		local s = '{d'
		if diffPower > 1 then
			s = s .. '^{' .. diffPower .. '}'
		end

		if diffExprOnTop then
			s = s .. diffExprStr
		end
	
		s = s .. ' \\over {'
		
		local powersForDeriv = {}
		for _,var in ipairs(diffVars) do
			powersForDeriv[var.name] = (powersForDeriv[var.name] or 0) + 1
		end
		
		for name,power in pairs(powersForDeriv) do	
			s = s .. ' d{' .. name .. '}'
			if power > 1 then
				s = s .. '^{' .. power .. '}'
			end
		end
		s = s .. '}}'
		if not diffExprOnTop then
			s = s .. '\\left ( ' .. diffExprStr .. ' \\right )'
		end
		return s
	end,
	[require 'symmath.Tensor'] = function(self, expr)
		-- non-Matrix Tensors that are rank-2 can be displayed as Matrixes
		if expr:rank() == 2 then
			return self.lookupTable[require 'symmath.Matrix'](self, expr)
		end
		local s = table()
		for i=1,#expr do
			s:insert(self:apply(expr[i]))
		end
		return ' \\left[ \\matrix{ ' .. s:concat(' && ') .. ' } \\right] '
	end,
	[require 'symmath.Matrix'] = function(self, expr)
		local rows = table()
		for i=1,#expr do
			if type(expr[i]) ~= 'table' then 
				error("expected matrix children to be Tensors (or at least tables), but got ("..type(expr[i])..") "..tostring(expr[i]))
			end
			for j=1,#expr[i] do
				rows[i] = table.map(expr[i], function(x,k)
					if type(k) ~= 'number' then return end
					return self:apply(x)
				end):concat(' && ')
			end
		end
		return ' \\left[ \\matrix{ ' .. rows:concat(' \\\\ ') .. ' } \\right] '
	end,
}

return LaTeX()	-- singleton

