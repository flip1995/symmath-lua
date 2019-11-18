local class = require 'ext.class'
local table = require 'ext.table'
local range = require 'ext.range'
local string = require 'ext.string'
local Export = require 'symmath.export.Export'
local LaTeX = class(Export)

local function omit(t)
	t.omit = true
	return t
end

local function tableConcat(t, mid)
	for i=#t,2,-1 do
		table.insert(t,i,mid)
	end
	return t
end

-- just like super except uses a table combine
function LaTeX:wrapStrOfChildWithParenthesis(parentNode, childIndex)
	local node = parentNode[childIndex]
	
	-- tostring() needed to call MultiLine's conversion to tables ...
	--local s = tostring(node)
	local s = self:apply(node)
	
	if self:testWrapStrOfChildWithParenthesis(parentNode, childIndex) then
		if type(s) == 'string' then
			return table{'(', s, ')'}
		else
			s = table{'(', s, ')'}
		end
	end
	s:insert(1, '{')
	s:insert('}')
	return s
end

local function prepareName(name)
	if name:find'%^' or name:find'_' then
		return '{'..name..'}'
	end
	return name
end

local function explode(s)
	assert(type(s) == 'string')
	local t = table()
	for i=1,#s do
		t[i] = s:sub(i,i)
	end
	return t
end

LaTeX.lookupTable = {
	[require 'symmath.Constant'] = function(self, expr)
		if expr.symbol then 
			return table{prepareName(expr.symbol)}
		end
		local value = expr.value
		local fv = math.floor(value)
		if value == fv then value = fv end	-- get rid of decimal place in tostring() on lua 5.3
		local s = tostring(value)
		local a,b = s:match('([^e]*)e(.*)')
		if a and b then
			if b:sub(1,1) == '+' then b = b:sub(2) end
			b = explode(b)
			return table{a, '\\cdot', table{'10', '^', b}}
		end
		s = explode(s)
		return s
	end,
	[require 'symmath.Invalid'] = function(self, expr)
		return table{'?'}
	end,
	[require 'symmath.Function'] = function(self, expr)
		return table{prepareName(expr.name), '\\left(', 
			tableConcat(range(#expr):map(function(i)
				return self:apply(expr[i])
			end), ','),
			'\\right)'}
	end,
	[require 'symmath.sqrt'] = function(self, expr)
		return table{'\\sqrt', self:apply(expr[1])}
	end,
	[require 'symmath.op.unm'] = function(self, expr)
		local res = table{'-'}:append(self:wrapStrOfChildWithParenthesis(expr, 1))
		res.omit = true
		return res
	end,
	[require 'symmath.op.Binary'] = function(self, expr)
		local res = table()
		for i=1,#expr do
			if i > 1 then res:insert(expr:getSepStr()) end
			res:append(self:wrapStrOfChildWithParenthesis(expr, i))
		end
		return res
	end,
	[require 'symmath.op.mul'] = function(self, expr)
		local Variable = require 'symmath.Variable'
		local Constant = require 'symmath.Constant'
		local div = require 'symmath.op.div'
		local pow = require 'symmath.op.pow'
		local res = table()
		for i=1,#expr do
			res[i] = self:wrapStrOfChildWithParenthesis(expr, i)
		end
		for i=#expr,2,-1 do
			-- insert \cdot between neighboring variables if any have a length > 1 ... or if the lhs has a length > 1 ...
			-- TODO don't do this if those >1 length variables are LaTeX strings for single-char greek letters
			if Variable.is(expr[i-1])
			and #expr[i-1].name > 1
			--and Variable.is(expr[i])
			then
				res:insert(i, '\\cdot')
			-- insert \cdot between neighboring numbers
			elseif Constant.is(expr[i-1]) then
				if Constant.is(expr[i])
				or div.is(expr[i])
				or (pow.is(expr[i]) and Constant.is(expr[i][1]))
				then
					res:insert(i, '\\cdot')
				end
			end
		end
		return tableConcat(res, expr:getSepStr())
	end,
	[require 'symmath.op.div'] = function(self, expr)
		local Constant = require 'symmath.Constant'
		local Variable = require 'symmath.Variable'
		-- TODO if the second term is small enough ...
		-- for now, just look for single constants or Variables (or both?)
		-- this could be done in tidy ...
		local a,b = table.unpack(expr)
		if not a.is(Constant) then
			if Constant.is(b) 
			or Variable.is(b)
			then
				return table{
					table{'\\frac', '{1}', table(self:apply(b), {force=true})},
					table{'(', table(self:apply(a), {force=true}), ')'},
				}
			end
		end

		return table{'\\frac', 
			table(self:apply(a), {force=true}),
			table(self:apply(b), {force=true})
		}
	end,
	[require 'symmath.op.pow'] = function(self, expr)
		local res = table()
		for i=1,#expr do
			if i > 1 then res:insert(expr:getSepStr()) end
			res:append(self:wrapStrOfChildWithParenthesis(expr, i))
		end
		return res
	end,
	[require 'symmath.Variable'] = function(self, expr)
		local symmath = require 'symmath'
		local name = expr.name
		if symmath.fixVariableNames then
			name = symmath.tostring:fixVariableName(name)
		end
		local s = table{prepareName(name)}
		--if expr.value then s:append{'|', expr.value} end
		return s
	end,
	[require 'symmath.Derivative'] = function(self, expr) 
		local Variable = require 'symmath.Variable'

		local diffVars = table.sub(expr, 2)
		local diffPower = #diffVars
		
		local diffExpr = expr[1]
		local diffExprStr = self:apply(diffExpr)
		local diffExprOnTop = Variable.is(diffExpr)

		if self.useCommaDerivative then
			return table{ 
				table{diffExprStr}, 
				'_', 
				table{','}:append(range(#diffVars):map(function(i)
					return table{'{'}:append(self:apply(diffVars[i])):append{'}'}
				end))
			}
		end
		
		if self.usePartialLHSForDerivative then
			local s = table{'\\partial_', 
				range(#diffVars):map(function(i)
					return table{'{'}:append(self:apply(diffVars[i])):append{'}'}
				end)}
			--if not diffExprOnTop then 
				s:insert'('
			--end
			s:insert(diffExprStr)
			--if not diffExprOnTop then 
				s:insert')'
			--end
			return s
		end

		local top = table{'\\partial'}
		if diffPower > 1 then
			top:insert('^')
			top:insert(explode(tostring(diffPower)))
		end

		if diffExprOnTop then
			top:insert(diffExprStr)
		end
	
		local powersForDeriv = {}
		for _,var in ipairs(diffVars) do
		
			local varname = var.name
			if symmath.fixVariableNames then
				varname = symmath.tostring:fixVariableName(varname)
			end
			
			powersForDeriv[varname] = (powersForDeriv[varname] or 0) + 1
		end
	
		local bottom = table()
		for name,power in pairs(powersForDeriv) do	
			bottom:insert'\\partial'
			bottom:insert(name)
			if power > 1 then
				bottom:insert('^')
				bottom:insert(explode(tostring(power)))
			end
		end
		local s = table{top, '\\over', bottom}
		
		if not diffExprOnTop then
			s = table{s, '\\left(', diffExprStr, '\\right)'}
		end
		return s
	end,
	[require 'symmath.Array'] = function(self, expr)
		-- non-Matrix Arrays that are rank-2 can be displayed as Matrixes
		if expr:rank() % 2 == 0 then
			return self.lookupTable[require 'symmath.Matrix'](self, expr)
		end
		
		local result = table(omit{'\\left[', '\\begin{matrix}'})
		result:append(omit(tableConcat(range(#expr):map(function(i)
			return omit(self:apply(expr[i]))
		end), ' \\\\')))
		result:append(omit{'\\end{matrix}', '\\right]'})
		return omit(result)
	end,
	[require 'symmath.Matrix'] = function(self, expr)
		local rows = table()
		for i=1,#expr do
			if type(expr[i]) ~= 'table' then 
				error("expected matrix children to be Arrays (or at least tables), but got ("..type(expr[i])..") "..tostring(expr[i]))
			end
			rows[i] = omit(tableConcat(range(#expr[i]):map(function(j)
				return omit(self:apply(expr[i][j]))
			end), ' & '))
			if #expr > 1 then rows[i] = omit(rows[i]) end
		end
		
		local result = table{'\\left[', '\\begin{matrix}'}
		result:append(omit(tableConcat(rows, ' \\\\')))
		result:append{'\\end{matrix}', '\\right]'}
		return omit(result)
	end,
	[require 'symmath.Tensor'] = function(self, expr)
		local s = self.lookupTable[require 'symmath.Array'](self, expr)
		local arrows = {'\\downarrow', '\\rightarrow'}
		if #expr.variance > 0 then
			local prefix = table()
			for i=#expr.variance,1,-1 do
				local var = expr.variance[i]
				local arrowIndex = (#expr.variance + i + 1) % 2 + 1
				prefix = table{var.symbol, (i == 1 and arrows[1] or arrows[arrowIndex])}:append(prefix)
				if arrowIndex == 1 and i ~= 1 then prefix = table{'[', prefix, ']'} end
			end
			prefix.force = true
			s.force = true
			s = table{'\\overset', prefix, s}
		end
		return s
	end,
	[require 'symmath.abs'] = function(self, expr)
		return table{'|', self:apply(expr[1]), '|'}
	end,
	[require 'symmath.Sum'] = function(self, expr)
		local s = table{'\\sum'}
		local sumexpr, var, from, to = table.unpack(expr)
		if var or from or to then
			if var or from then
				s:insert'_'
				local lower = table()
				s:insert(lower)
				if var then
					lower:insert(self:apply(var))
				end
				if from then
					lower:insert'='
					lower:insert(self:apply(from))
				end
			end
			if to then
				s:insert'^'
				local upper = table()
				s:insert(upper)
				upper:insert(self:apply(to))
			end
		end
		s:insert(table{self:apply(sumexpr)})
		return s
	end,
	[require 'symmath.Integral'] = function(self, expr)
		local s = table{'\\int'}
		local intexpr, var, from, to = table.unpack(expr)
		if from or to then
			s:insert'\\limits'
			s:insert'_'
			if from then
				s:insert(table{'{'}:append(self:apply(from)):append{'}'})
			end
			if to then
				s:insert'^'
				s:insert(table{'{'}:append(self:apply(to)):append{'}'})
			end
		end
		if var then
			s:insert'd'
			s:insert(self:apply(var))
		end
		s:insert'\\left('
		s:insert(self:apply(intexpr))
		s:insert'\\right)'
		return s
	end,
	[require 'symmath.tensor.TensorRef'] = function(self, expr)
		local symmath = require 'symmath'
		local Array = symmath.Array
		local TensorRef = require 'symmath.tensor.TensorRef'
		local Variable = symmath.Variable

		local t = expr[1]
		local indexes = {table.unpack(expr, 2)}

		local s = self:applyLaTeX(t)
		if not (Variable.is(t) or Array.is(t) or TensorRef.is(t)) then s = '\\left(' .. s .. '\\right)' end
		
		for _,index in ipairs(indexes) do
			s = '{' .. s .. '}' .. self:apply(index)
		end
		
		return table{s}
	end,
	-- looks a lot like TensorIndex.__tostring, except with some {}'s wrapping stuff
	[require 'symmath.tensor.TensorIndex'] = function(self, expr)
		local s = ''
		if expr.derivative == 'covariant' then
			s = ';' .. s 
		elseif expr.derivative then 
			s = ',' .. s 
		end
		if expr.symbol then
			s = s .. expr.symbol
		elseif expr.number then
			s = s .. expr.number
		else
			error("TensorIndex expected a symbol or a number")
		end
		if #s > 1 then s = '{' .. s .. '}' end
		if expr.lower then s = '_' .. s else s = '^' .. s end
		return s
	end,
}

-- not quite apply, because that returns a table
-- but not quite call, because MathJax overloads that
function LaTeX:applyLaTeX(...)
	local result = LaTeX.super.__call(self, ...)
	
	-- now combine the symbols conscious of LaTeX grammar ... 

	local function flatten(result)
		if type(result) == 'string' then return result end
		if type(result) == 'number' then return tostring(result) end
		if type(result) ~= 'table' then
			error("don't know how to handle type "..type(result))
		end
		
		local omit = result.omit
		local force = result.force
		local count = #result

		for i=1,#result do
			result[i] = flatten(result[i])
		end
		for i=2,#result do
			assert(type(result[i]) == 'string', "got type "..type(result[i]))
			if result[i-1]:match('%a$') and result[i]:match('^%a') then
				result[i] = ' '..result[i]
			end
		end
		result = result:concat()
		
		--result = range(#result):map(function(i) return flatten(result[i]) end):concat' '
		if force then
			result = '{' .. result .. '}' 
		elseif count > 1 and not omit then 
			result = '{' .. result .. '}' 
		else
			result = ' ' .. result
		end
		
		return result
	end

	result.omit = true
	return flatten(result)--:gsub('%s+', ' ')
end

LaTeX.openSymbol = '$'
LaTeX.closeSymbol = '$'
function LaTeX:__call(...)
	local result = self:applyLaTeX(...)
	result = string.trim(result)
	return self.openSymbol .. result .. self.closeSymbol
end

local texSymbols = {}
for k in ([[
alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu
nu xi omicron pi rho sigma tau upsilon phi chi psi omega
hBar infty
]]):gmatch'%S+' do
	table.insert(texSymbols, k)
	k = k:sub(1,1):upper() .. k:sub(2)
	table.insert(texSymbols, k)
end
-- sort these largest to smallest so replacements work
table.sort(texSymbols, function(a,b) return #a > #b end)

LaTeX.header = [[
\documentclass{article}
\usepackage{amsmath}
\usepackage{geometry}
\geometry{
	a4paper%,
%	papersize={10000mm,257mm},
%	left=20mm,
%	top=20mm,
}
\setcounter{MaxMatrixCols}{50}
\begin{document}

\catcode`\^ = 13 \def^#1{\sp{#1}{}}
\catcode`\_ = 13 \def_#1{\sb{#1}{}}
]]
--170mm width is typical.  my equations are just over 6000mm

LaTeX.footer = [[
\end{document}
]]

function LaTeX:fixVariableName(name)
	local i=1
	while i < #name do
		if i>1 and name:sub(i):match('^[%^_]') then
			name = name:sub(1,i-1) .. '_{' .. name:sub(i+1) .. '}'
		end
		for _,w in ipairs(texSymbols) do
			if name:sub(i):match('^'..w) then
				name = name:sub(1,i-1) .. '\\' .. name:sub(i)
				i = i + #w
			end
		end
		i=i+1
	end
	return name
end

return LaTeX()	-- singleton