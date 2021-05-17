local class = require 'ext.class'
local table = require 'ext.table'
-- single-line strings 
local Console = require 'symmath.export.Console'


local SingleLine = class(Console)

SingleLine.name = 'SingleLine'

local function precedence(x)
	return x.precedence or 10
end

function SingleLine:testWrapStrOfChildWithParenthesis(parentNode, childIndex)
	local div = require 'symmath.op.div'
	local childNode = parentNode[childIndex]
	local childPrecedence = precedence(childNode)
	local parentPrecedence = precedence(parentNode)
	if div:isa(parentNode) then parentPrecedence = parentPrecedence + .5 end
	if div:isa(childNode) then childPrecedence = childPrecedence + .5 end
	local sub = require 'symmath.op.sub'
	if sub:isa(parentNode) and childIndex > 1 then
		return childPrecedence <= parentPrecedence
	else
		return childPrecedence < parentPrecedence
	end
end

SingleLine.lookupTable = {
	--[[
	[require 'symmath.Expression'] = function(self, expr)
		local s = table()
		for k,v in pairs(expr) do s:insert(rawtostring(k)..'='..rawtostring(v)) end
		return 'Expression{'..s:concat(', ')..'}'
	end,
	--]]
	[require 'symmath.Constant'] = function(self, expr) 
		local symmath = require 'symmath'
		
		-- .symbol was a quick fix to give constants symbols ... keep it? 
		local symbol = expr.symbol
		if symbol then
			if symmath.fixVariableNames then
				symbol = symmath.tostring:fixVariableName(symbol)
			end
			return symbol
		end
		
		local s = tostring(expr.value) 
		if s:sub(-2) == '.0' then s = s:sub(1,-3) end
		return s
	end,
	[require 'symmath.Invalid'] = function(self, expr)
		return 'Invalid'
	end,
	[require 'symmath.Function'] = function(self, expr)
		local name = self:fixFunctionName(expr:nameForExporter(self))
		return name..'(' .. table.mapi(expr, function(x)
			return (self:apply(x))
		end):concat(', ') .. ')'
	end,
	[require 'symmath.abs'] = function(self, expr)
		return '|'..self:apply(expr[1])..'|'
	end,
	[require 'symmath.op.unm'] = function(self, expr)
		return '-'..self:wrapStrOfChildWithParenthesis(expr, 1)
	end,
	[require 'symmath.op.Binary'] = function(self, expr)
		return table.mapi(expr, function(x,i)
			return self:wrapStrOfChildWithParenthesis(expr, i)
		end):concat(expr:getSepStr(self))
	end,
	[require 'symmath.Variable'] = function(self, expr)
		local symmath = require 'symmath'
		local name = expr:nameForExporter(self)
		if symmath.fixVariableNames then
			name = symmath.tostring:fixVariableName(name)
		end
		
		local s = name
		--if expr.value then s = s .. '|' .. expr.value end
		return s
	end,
	[require 'symmath.Wildcard'] = function(self, expr)
		return '$'..expr.index
	end,
	[require 'symmath.Derivative'] = function(self, expr) 
		local symmath = require 'symmath'
		local topText = 'd'
		local diffVars = table.sub(expr, 2)
		local diffPower = #diffVars
		if diffPower > 1 then
			topText = topText .. '^'..diffPower
		end	
		local powersForDeriv = {}
		
		-- used to look the var back up for calling nameForExporter
		-- this means multiple Variable objects with separate nameForExporterTable's will have undefined behavior
		-- good thing Variable:clone() returns the original var
		local varForName = diffVars:mapi(function(var) return var, var.name end)
		
		for _,var in ipairs(diffVars) do
			-- don't fix name -- since var.name is used for variable equality
			powersForDeriv[var.name] = (powersForDeriv[var.name] or 0) + 1
		end
		local diffexpr = self:apply(assert(expr[1]))
		return topText..'/{'..table.map(powersForDeriv, function(power, name, newtable)
			
			-- get the var for this name
			local var = varForName[name]
			
			-- get the var's name for this exporter
			name = var:nameForExporter(self)
		
			-- see if it we are supposed to fix this
			-- when is it not a string?
			if type(name) == 'string'	
			and symmath.fixVariableNames
			then
				name = symmath.tostring:fixVariableName(name)
			end
			
			local s = 'd'..name
			if power > 1 then
				s = s .. '^' .. power
			end
			return s, #newtable+1
		end):concat(' ')..'}['..diffexpr..']'
	end,
	[require 'symmath.Integral'] = function(self, expr)
		return 'integrate('..table.mapi(expr, function(x) 
			return (self:apply(x)) 
		end):concat', '..' )'
	end,
	[require 'symmath.Array'] = function(self, expr)
		return '[' .. table.mapi(expr, function(x)
			return (self:apply(x))
		end):concat', ' .. ']'
	end,
	[require 'symmath.tensor.TensorIndex'] = function(self, expr)
		return expr:__tostring()
	end,
	[require 'symmath.tensor.TensorRef'] = function(self, expr)
		return table.mapi(expr, tostring):concat()
	end,
}

return SingleLine()		-- singleton
