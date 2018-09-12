local table = require 'ext.table'
return function(A)
	local Array = require 'symmath.Array'
	local Matrix = require 'symmath.Matrix'
	local clone = require 'symmath.clone'
	if not Array.is(A) then return A end
	local dim = A:dim()
	assert(#dim == 2, "expected a rank-2 array")
	local rows = Matrix()
	for i=1,dim[2] do
		local row = Matrix()
		rows[i] = row
		for j=1,dim[1] do
			row[j] = A[j][i]
		end
	end
	return rows
end
