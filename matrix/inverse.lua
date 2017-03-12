--[[
A = matrix to invert
AInv = vector to solve the linear system inverse of.  default: identity, to produce the inverse matrix.
callback = watch the progress!

TODO how to handle matrix inverses?
as a separate function? symmath.inverse.
same question with matrix multiplication
same question with per-component matrix multiplication
then there's the question of how to integrate arrays in general
then there's breaking down prune/simplify op visitors into rules, so I could quickly insert a new rule when using matrices 

returns AInv, A, and any errors encountered during the simplification
(should I favor consistency of return argument order, like pcall?
or should I favor assert() compatability?)
--]]
return function(A, b, callback, allowRectangular)
	local Array = require 'symmath.Array'
	local Matrix = require 'symmath.Matrix'
	local Constant = require 'symmath.Constant'
	local simplify = require 'symmath.simplify'
	local clone = require 'symmath.clone'
	
	if type(A) == 'number' then return 1/Constant(A) end
	if not Array.is(A) then return Constant(1)/A end

	-- expects A to be  
	local dim = A:dim()
	assert(#dim == 2, "expected A to be a rank-2 Array")

-- still toying with the notion of allowing rectangular matrices ...
-- and simply returning what progress was made in the inversion
-- along with any error messages along the way
-- I think I will make this assertion here for Matrix.inverse
-- then remove it for another function called 'linsolve'
-- and have the two use the same code
if not allowRectangular then
	assert(dim[1] == dim[2], "expected A to be square")
end

	local m, n = dim[1].value, dim[2].value

	A = clone(A)
	
	-- assumes A is a rank-2 array with matching height
	local AInv = b and clone(b) or Matrix.identity(m)
	local invdim = AInv:dim()
	assert(#invdim == 2, "expect b to be a rank-2 Array")
	if invdim[1] ~= dim[1] then
		if b then
			error("expected A number of rows to match b number of rows.\n"
				.."found A to have "..m.." rows and b to have "..invdim[1].value.." rows")
		else
			error("hmm, you picked the wrong default number of rows for the result")
		end
	end

	-- shortcuts:
	if m == 1 and n == 1 and not b then
		local A_11 = A[1][1]
		if A_11 == Constant(0) then
			return AInv, A, "determinant is zero"
		end
		local result = Matrix{(1/A_11)()}
		if b then result = (result * b)() end
		return result, Matrix.identity(invdim[1].value, invdim[2].value)
	elseif m == 2 and n == 2 and not b then
		local A_det = A:determinant()
		if A_det == Constant(0) then
			return AInv, A, "determinant is zero"
		end
		local result = (Matrix(
			{A[2][2], -A[1][2]},
			{-A[2][1], A[1][1]}) / A_det)()
		if b then result = (result * b)() end
		return result, Matrix.identity(invdim[1].value, invdim[2].value)
--[[	elseif n == 3 then
		-- transpose, +-+- sign stagger, for each element remove that row and column and 
		return (Matrix(
			{A[2][2]*A[3][3]-A[2][3]*A[3][2], A[1][3]*A[3][2]-A[1][2]*A[3][3], A[1][2]*A[2][3]-A[1][3]*A[2][2]},
			{A[2][3]*A[3][1]-A[2][1]*A[3][3], A[1][1]*A[3][3]-A[1][3]*A[3][1], A[1][3]*A[2][1]-A[1][1]*A[2][3]},
			{A[2][1]*A[3][2]-A[2][2]*A[3][1], A[1][2]*A[3][1]-A[1][1]*A[3][2], A[1][1]*A[2][2]-A[1][2]*A[2][1]}
		) / A:determinant()):simplify()
--]]
	end

	local min = math.min(m,n)

	for i=1,min do
		-- if we have a zero on the diagonal...
		if A[i][i] == Constant(0) then
			-- pivot with a row beneath this one
			local found = false
			for j=i+1,m do
				if A[j][i] ~= Constant(0) then
					for k=1,n do
						A[j][k], A[i][k] = A[i][k], A[j][k]
					end
					for k=1,invdim[2].value do
						AInv[j][k], AInv[i][k] = AInv[i][k], AInv[j][k]
					end
					A = simplify(A)
					AInv = simplify(AInv)
					found = true
					break
				end
			end
			if not found then
				-- return the progress if things fail
				return AInv, A, "couldn't find a row to pivot"
			end
		end
		-- rescale diagonal
		if A[i][i] ~= Constant(1) then
			-- rescale column
			local s = A[i][i]
--print('rescaling row '..i..' by \\('..(1/s):simplify()..'\\)<br>')
			for j=1,n do
				A[i][j] = A[i][j] / s
			end
			for j=1,invdim[2].value do
				AInv[i][j] = AInv[i][j] / s
			end
			A = simplify(A)
			AInv = simplify(AInv)
--print('\\(A =\\) '..A..', \\(A^{-1}\\) = '..AInv..'<br>')
			if callback then callback(AInv, A) end
		end
		-- eliminate columns apart from diagonal
		for j=1,m do
			if j ~= i then
				if A[j][i] ~= Constant(0) then
					local s = A[j][i]
--print('subtracting \\('..s..'\\) to row '..j..'<br>')
					for k=1,n do
						A[j][k] = A[j][k] - s * A[i][k]
					end
					for k=1,invdim[2].value do
						AInv[j][k] = AInv[j][k] - s * AInv[i][k]
					end
--print('\\(A = \\)'..A..'<br>')
--print('simplifying A...<br>')
					A = simplify(A)
--print('\\(A = \\)'..A..'<br>')
--print('\\(A^{-1} = \\)'..AInv..'<br>')
--print('simplifying A^{-1}...<br>')
					AInv = simplify(AInv)
--print('\\(A^{-1} = \\)'..AInv..'<br>')
					if callback then callback(AInv, A) end
				end
			end
		end
	end

	if m > n then
		-- if there are more rows than columns
		-- then the remaining columns must be zero
		-- and should be cut out?
		for i=n+1,m do
			for j=1,invdim[2].value do
				if AInv[i][j] ~= Constant(0) then
					return AInv, A, "system is overconstrained"
				end
			end
		end
	end

	return AInv, A
end
