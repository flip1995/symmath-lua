#!/usr/bin/env luajit
require 'ext'
local env = setmetatable({}, {__index=_G})
if setfenv then setfenv(1, env) else _ENV = env end
require 'symmath'.setup{env=env, MathJax={title='Platonic Solids'}}

printbr[[
$n =$ dimension of manifold which our shape resides in.<br>
$\tilde{T}_i \in \mathbb{R}^{n \times n} =$ i'th isomorphic transform in the minimal set.<br>
$\tilde{\textbf{T}} = \{ 1 \le i \le p, \tilde{T}_i \} =$ minimum set of isomorphic transforms that can be used to recreate all isomorphic transforms.<br>
$p = |\tilde{\textbf{T}}| =$ the number of minimal isomorphic transforms.<br>
$T_i \in \mathbb{R}^{n \times n} =$ i'th isomorphic transform in the set of all unique transforms.<br>
$\textbf{T} = \{ T_i \} = \{ 1 \le k, i_1, ..., i_k \in [1,m], \tilde{T}_{i_1} \cdot ... \cdot \tilde{T}_{i_k} \} =$ set of all unique isomorphic transforms.<br>
$q = |\textbf{T}| =$ the number of unique isomorphic transforms.<br>
$v_1 \in \mathbb{R}^n =$ some arbitrary initial vertex.<br>
$\textbf{v} = \{v_i \} = \{ T_i \cdot v_1 \} =$ the set of all vertices.<br>
$m = |\textbf{v}| =$ the number of vertices.<br>
(Notice that $m \le q$, i.e. the number of vertices is $\le$ the number of unique isomorphic transforms.) <br>
$V \in \mathbb{R}^{n \times m}=$ matrix with column vectors the set of all vertices, such that $V_{ij} = (v_j)_i$.<br>
$P_i \in \mathbb{R}^{m \times m} =$ permutation transform of vertices corresponding with i'th transformation, such that $T_i V = V P_i$.<br>
<br>
]]

--[[
ok here's another thought ...
rotation from a to b, assuming a and b are orthonormal:

R v 
	= v - a (v.a) - b (v.b) 
	+ (a (v.a) + b (v.b)) cos(θ)
	+ (b (v.a) - a (v.b)) sin(θ)
	
	= v - a (v.a) - b (v.b) 
	+ (a (v.a) + b (v.b)) cos(θ)
	+ (b (v.a) - a (v.b)) sin(θ)
	
	= (I + (cos(θ)-1) aa' - sin(θ) ab' + sin(θ) ba' + (cos(θ)-1) bb') v
	= (I + (cos(θ)-1) (aa' + bb') + sin(θ) (ba' - ab')) v
--]]
local function rotfromto(theta, from, to)
	from = from:unit()
	to = (Matrix.projection(from:T()[1]) * to)():unit()
	return (
		Matrix.identity(#from) 
		+ (cos(theta) - 1) * (from * from:T() + to * to:T())
		+ sin(theta) * (to * from:T() - from * to:T())
	)()
end

--[=[
--[[
for a 3D platonic solid, if you know the vertices, you can make a rotation
from (proj a) * b to (proj a) * c
--]]
printbr(rotfromto(
	frac(2*pi,3), 
	(Matrix.projection{1,0,0} * Matrix{-frac(1,3), sqrt(frac(2,3)), -frac(sqrt(2),3)}:T())(),
	(Matrix.projection{1,0,0} * Matrix{-frac(1,3), 0, frac(sqrt(8),3)}:T())()
))
os.exit()
--]=]

local phi = (sqrt(5) - 1) / 2

-- [[
local tetRot = Matrix.identity(3)
--]]

--[[ matrix to rotate 1/sqrt(3) (1,1,1) to (1,0,0)
-- applying this isn't as isometric as I thought it would be
-- cubeRot = Matrix.rotation(acos(1/sqrt(3)), Matrix(1,1,1):cross{1,0,0}:unit())		-- rotate from unit(1,1,1) to (1,0,0)
local cubeRot = Matrix(
	{ 1/sqrt(3), 1/sqrt(3), 1/sqrt(3) },
	{ -1/sqrt(3), (1 + sqrt(3))/(2*sqrt(3)), (1 - sqrt(3))/(2*sqrt(3)) },
	{ -1/sqrt(3), (1 - sqrt(3))/(2*sqrt(3)), (1 + sqrt(3))/(2*sqrt(3)) }
)
--]]
-- [[ use [1,1,1]/sqrt(3)
local cubeRot = Matrix.identity(3)
--]]


--[[
local dodVtx = Matrix{
	(-1 - sqrt(5)) / (2 * sqrt(3)),
	0,
	(1 - sqrt(5)) / (2 * sqrt(3))
}
local dodRot = Matrix.rotation(acos(dodVtx[1][1]), dodVtx[1]:cross{1, 0, 0}:unit())
--]]
-- [[
local dodRot = Matrix.identity(3)
--]]


--[[ produces an overly complex poly that can't simplify 
--[=[
local icoRot = Matrix.rotation(acos(0), Array(0, 1, phi):cross{1,0,0}:unit())
--]=]
local icoVtx = Matrix{0, 1, phi}
printbr(icoVtx)
local icoRot = Matrix.rotation(
	acos(icoVtx[1][1]), 
	icoVtx[1]:cross{1,0,0}:unit())
--]]
-- [[ works
local icoRot = Matrix.identity(3)
--]]


--[[
how to define the transforms?
these should generate the vertexes, right?
the vertex set should be some identity vertex times any combination of these transforms

so we should be able to define a cube by a single vertex 
v_0 = [1,1,1] 
times any combination of traversals along its edges
which for [1,1,1] would just three transforms, where the other 3 are redundant:


identity transforms:
this can be the axis from the center of object to any vertex, with rotation angle equal to the edge-vertex-edge angle
or it can be the axis from center of object to center of any face, with rotation angle equal to 2π/n for face with n edges
or it can be the axis through any edge (?right?) with ... some other kind of rotation ...
--]]
local shapes = {
-- [=[
	{	-- self-dual
		name = 'Tetrahedron',
		vtx1 = (tetRot * Matrix{0, 0, 1}:T())(),
		
		dim = 3,
		xforms = (function()
			local a = {-sqrt(frac(2,3)), -sqrt(2)/3, -frac(1,3)}
			local b = {sqrt(frac(2,3)), -sqrt(2)/3, -frac(1,3)}
			local c = {0, sqrt(8)/3, -frac(1,3)}
			local d = {0, 0, 1}
			return table{
				
				(tetRot * 
					--Matrix.rotation(frac(2*pi,3), {	-frac(1,3),	0, 					sqrt(frac(8,9))		}) 
					rotfromto(
						frac(2*pi,3),
						(Matrix.projection(c) * Matrix(a):T())(),
						(Matrix.projection(c) * Matrix(b):T())()
					)
					* tetRot:T())(),
				
				(tetRot * 
					--Matrix.rotation(frac(2*pi,3), {	-frac(1,3),	-sqrt(frac(2,3)), 	-sqrt(frac(2,9))	}) 
					rotfromto(
						frac(2*pi,3),
						(Matrix.projection(d) * Matrix(a):T())(),
						(Matrix.projection(d) * Matrix(b):T())()
					)
					* tetRot:T())(),
			}
		end)(),
	},
--]=]
--[=[
	-- dual of octahedron
	{
		name = 'Cube',
		dim = 3,
		
		--vtx1 = (cubeRot * Matrix{ 1/sqrt(3), 1/sqrt(3), 1/sqrt(3) }:T())(),
		vtx1 = (cubeRot * Matrix{ 1, 1, 1 }:T())(),
		
		xforms = {
			(cubeRot * Matrix.rotation(frac(pi,2), {1,0,0}) * cubeRot:T())(),
			(cubeRot * Matrix.rotation(frac(pi,2), {0,1,0}) * cubeRot:T())(),
			--(cubeRot * Matrix.rotation(frac(pi,2), {0,0,1}) * cubeRot:T())(),	-- z = x*y
			
			--(cubeRot * Matrix.diagonal(-1, 1, 1) * cubeRot:T())(),	reflection?
		},
	},
--]=]
--[=[
	-- dual of cube
	{
		name = 'Octahedron',
		dim = 3,
		
		xforms = {
			Matrix.rotation(frac(pi,2), {1,0,0})(),
			Matrix.rotation(frac(pi,2), {0,1,0})(),
			--Matrix.rotation(frac(pi,2), {0,0,1})(),	-- z = x*y
		},
	},
--]=]
--[=[
	-- dual of icosahedron
	{
		name = 'Dodecahedron',
		dim = 3,

		--vtx1 = (dodRot * Matrix{1/phi, 0, phi}:T():unit())(),
		vtx1 = (dodRot * Matrix{1/phi, 0, phi}:T())(),

		xforms = {
			-- axis will be the center of the face adjacent to the first vertex at [1,0,0]
			(dodRot * Matrix.rotation(frac(2*pi,3), Matrix{-1/phi, 0, phi}:unit()[1] ) * dodRot:T())(),	-- correctly produces 3 vertices 
			(dodRot * Matrix.rotation(frac(2*pi,3), Matrix{0, phi, 1/phi}:unit()[1] ) * dodRot:T())(),	-- the first 2 transforms will produces 12 vertices and 12 transforms
			(dodRot * Matrix.rotation(frac(2*pi,3), Matrix{1,1,1}:unit()[1] ) * dodRot:T())(),		-- all 3 transforms produces all 20 vertices and 60 transforms 
		},
	},
--]=]
--[=[
	-- dual of dodecahedron
	{
		name = 'Icosahedron',
		dim = 3,
	
		--vtx1 = (icoRot * Matrix{ 0, 1, phi }:T():unit())(),
		vtx1 = (icoRot * Matrix{ 0, 1, phi }:T())(),		-- don't unit.

		xforms = {
			(icoRot * Matrix.rotation(frac(2*pi,5), Matrix{0, -1, phi}:unit()[1] ) * icoRot:T())(),
			(icoRot * Matrix.rotation(frac(2*pi,5), Matrix{1, phi, 0}:unit()[1] ) * icoRot:T())(),
			(icoRot * Matrix.rotation(frac(2*pi,5), Matrix{-1, phi, 0}:unit()[1] ) * icoRot:T())(),
		},
	},
--]=]
--[=[
	{	-- self-dual
		name = '5-cell',
		dim = 4,
		
		vtx1 = Matrix{frac(sqrt(15),4), 0, 0, -frac(1,4)}:T(),
		--vtx1 = Matrix{0, 0, 0, 1}:T(),
	
		xforms = (function()
			local a = {sqrt(15)/4, 0, 0, -frac(1,4)}
			local b = {-sqrt(frac(5,3))/4, 0, sqrt(frac(5,6)), -frac(1,4)}
			local c = {-sqrt(frac(5,3))/4, sqrt(frac(5,2))/2, -sqrt(frac(5,24)), -frac(1,4)}
			local d = {0,0,0,1}	
			--local e = {-sqrt(frac(5,3))/4, -sqrt(frac(5,2))/2, -sqrt(frac(5,24)), -frac(1,4)}		-- not used, in the cd rotation plane anyways
			return table{
				-- generate a tetrahedron:
				rotfromto(
					frac(2*pi,3), 
					(Matrix.projection(d) * Matrix.projection( (Matrix.projection(d) * Matrix(c):T())():T()[1] ) * Matrix(a):T())(),
					(Matrix.projection(d) * Matrix.projection( (Matrix.projection(d) * Matrix(c):T())():T()[1] ) * Matrix(b):T())()
				),
				rotfromto(
					frac(2*pi,3), 
					(Matrix.projection(d) * Matrix.projection( (Matrix.projection(d) * Matrix(a):T())():T()[1] ) * Matrix(c):T())(),
					(Matrix.projection(d) * Matrix.projection( (Matrix.projection(d) * Matrix(a):T())():T()[1] ) * Matrix(b):T())()
				),
				-- generate the entire 5-cell
				rotfromto(
					frac(2*pi,3), 
					(Matrix.projection(a) * Matrix.projection( (Matrix.projection(a) * Matrix(b):T())():T()[1] ) * Matrix(c):T())(),
					(Matrix.projection(a) * Matrix.projection( (Matrix.projection(a) * Matrix(b):T())():T()[1] ) * Matrix(d):T())()
				),			
			}
			--]]
		end)(),
	}
--]=]
--[=[
	{	-- hypercube, dual to 16-cell
		name = '8-cell',
		dim = 4,
		
		--vtx1 = Matrix{1/sqrt(4), 1/sqrt(4), 1/sqrt(4), 1/sqrt(4)}:T(),
		vtx1 = Matrix{1, 1, 1, 1}:T(),

		xforms = {
			Matrix(	-- xy
				{0,-1,0,0},
				{1,0,0,0},
				{0,0,1,0},
				{0,0,0,1}
			)(),
			Matrix(	-- xz
				{0,0,1,0},
				{0,1,0,0},
				{-1,0,0,0},
				{0,0,0,1}
			)(),
			Matrix(	-- xw
				{0,0,0,-1},
				{0,1,0,0},
				{0,0,1,0},
				{1,0,0,0}
			)(),
		},
	},
--]=]
--[=[
	{	-- dual to 8-cell
		name = '16-cell',
		dim = 4,
		
		vtx1 = Matrix{1, 0, 0, 0}:T(),

		xforms = {
			Matrix(
				{0,-1,0,0},
				{1,0,0,0},
				{0,0,1,0},
				{0,0,0,1}
			)(),
			Matrix(
				{0,0,1,0},
				{0,1,0,0},
				{-1,0,0,0},
				{0,0,0,1}
			)(),
			Matrix(
				{0,0,0,-1},
				{0,1,0,0},
				{0,0,1,0},
				{1,0,0,0}
			)(),
		},
	},
--]=]
-- TODO 4D 24-cell self-dual
-- TODO 4D 600-cell dual to 120-cell
-- TODO 4D 120-cell dual to 600-cell

-- TODO 5D 5-simplex self-dual
-- TODO 5D 5-cube dual to 5-orthoplex
-- TODO 5D 5-orthoplex dual to 5-cube

-- TODO 6D 6-simplex
-- TODO 6D 6-orthoplex
-- TODO 6D 6-cube

-- TODO 7D 7-simplex self-dual
-- TODO 7D 7-cube dual to 7-orthoplex
-- TODO 7D 7-orthoplex dual to 7-cube

-- TODO 8D 8-simplex self-dual
-- TODO 8D 8-cube dual to 8-orthoplex
-- TODO 8D 8-orthoplex dual to 8-cube
}

for _,shape in ipairs(shapes) do
	shapes[shape.name] = shape
end



local MathJax = symmath.export.MathJax
MathJax.header.pathToTryToFindMathJax = '..'
symmath.tostring = MathJax

os.mkdir'output/Platonic Solids'
for _,shape in ipairs(shapes) do
	printbr('<a href="Platonic Solids/'..shape.name..'.html">'..shape.name..'</a> ('..shape.dim..' dim)')
end
printbr()

local cache = {}
local cacheFilename = 'Platonic Solids - cache.lua'
if io.fileexists(cacheFilename) then
	cache = load('return '..io.readfile(cacheFilename), nil, nil, env)()
end

for _,shape in ipairs(shapes) do

	io.stderr:write(shape.name,'\n')
	io.stderr:flush()

	MathJax.header.title = shape.name

	local f = assert(io.open('output/Platonic Solids/'..shape.name..'.html', 'w'))
	local function write(...)
		return f:write(...)
	end
	local function print(...)
		write(table{...}:mapi(tostring):concat'\t'..'\n')
	end
	local function printbr(...)
		print(...)
		print'<br>'
	end
	
	print(MathJax.header)

	print[[
<style>
table {
	border : 1px solid black;
	border-collapse : collapse;
}
table td {
	border : 1px solid black;
}
</style>
]]

	local shapeCache = cache[shape.name]
	if not shapeCache then
		shapeCache = {}
		cache[shape.name] = shapeCache
	end

--print('<a name="'..shape.name..'">')
	print('<h3>'..shape.name..'</h3>')

	local n = shape.dim
	shapeCache.n = shape.dim

	local vtx1 = shape.vtx1 or Matrix:lambda({n,1}, function(i,j) return i==1 and 1 or 0 end)
	shapeCache.vtx1 = vtx1

	printbr('Initial vertex:', var'v''_1':eq(vtx1))
	printbr()

	local xforms = table(shape.xforms)
	xforms:insert(1, Matrix.identity(n))
	shapeCache.xforms = xforms
	
	printbr'Transforms for vertex generation:'
	printbr()
	printbr(var'\\tilde{T}''_i', [[$\in \{$]], xforms:mapi(tostring):concat',', [[$\}$]])
	printbr()

	printbr'Vertexes:'
	printbr()

	local vtxs = table{vtx1()}
	shapeCache.vtxs = vtxs

	local function buildvtxs(j, depth)
		depth = depth or 1
		local v = vtxs[j]
		for i,xform in ipairs(xforms) do
			local xv = (xform * v)()
			local k = vtxs:find(xv)
			if not k then
				vtxs:insert(xv)
				k = #vtxs
				printbr((var'T'('_'..i) * var'V'('_'..j)):eq(xv):eq(var'V'('_'..k)))
				buildvtxs(k, depth + 1)
			else
--				printbr((var'T'('_'..i) * var'V'('_'..j)):eq(xv):eq(var'V'('_'..k)))
			end
		end
	end
	buildvtxs(1)
	printbr()

	-- number of vertexes
	local nvtxs = #vtxs
	shapeCache.nvtxs = nvtxs

	local allxforms = table(xforms)
	shapeCache.allxforms = allxforms
-- [[
	printbr'All Transforms:'
	printbr()

	local function buildxforms(j, depth)
		depth = depth or 1
		local M = allxforms[j]
		for i,xform in ipairs(xforms) do
			local xM = (xform * M)()
			local k = allxforms:find(xM)
			if not k then
				allxforms:insert(xM)
				k = #allxforms
				printbr((var'T'('_'..i) * var'T'('_'..j)):eq(xM):eq(var'T'('_'..k)))
				buildxforms(k, depth + 1)
			else
--				printbr((var'T'('_'..i) * var'V'('_'..j)):eq(xv):eq(var'V'('_'..k)))
			end
		end
	end
	for i=1,#xforms do
		buildxforms(i)
	end
	printbr()
--]]

	local VmatT = Matrix(vtxs:mapi(function(v) return v:T()[1] end):unpack())
	local Vmat = VmatT:T()
	shapeCache.Vmat = Vmat

	printbr'Vertexes as column vectors:'
	printbr()

	printbr(var'V':eq(Vmat))
	printbr()

	printbr'Vertex inner products:'
	printbr()

	local vdots = (Vmat:T() * Vmat)()
	shapeCache.vdots = vdots 
	printbr((var'V''^T' * var'V'):eq(Vmat:T() * Vmat):eq(vdots))
	printbr()

	printbr'Transforms of all vertexes vs permutations of all vertexes:'
	printbr()
	printbr(var'T''_i', [[$\in \{$]], allxforms:mapi(tostring):concat',', [[$\}$]])
	printbr()

	for i,xform in ipairs(allxforms) do
		local xv = (xform * Vmat)()	
		local xvT = xv:T()

		local rx = Matrix:lambda({nvtxs, nvtxs}, function(i,j)
			return xvT[j]() == VmatT[i]() and 1 or 0 
		end)
		
		printbr((var'T'('_'..i) * var'V'):eq(xv):eq(var'V' * rx))
		printbr()

		local Vmat_rx = (Vmat * rx)()
		local diff = (xv - Vmat_rx)()
		local zeros = Matrix:zeros{n, nvtxs}
		if diff ~= zeros then
			printbr('expected', xv:eq(Vmat * rx), 'found difference', (xv - Vmat * rx)())
		end
	end
	
	-- show if there are any simplification errors
	for j=2,#allxforms do
		for i=1,j-1 do
			if (allxforms[i] - allxforms[j])() == Matrix:zeros{n,n} then
				printbr(var'T'('_'..i), 'should equal', var'T'('_'..j), ':',
					allxforms[i], ',', allxforms[j])
			end
		end
	end


	-- show vtx multiplication table
	-- btw, do i need to show the details of this above?  or should I just show this?
	local function printVtxMulTable()
		print'<table>\n'
		print'<tr><td></td>'
		for j=1,#vtxs do
			print('<td>V'..j..'</td>')
		end
		print'</tr>\n'
		-- print the multiplcation table
		for i,xi in ipairs(allxforms) do
			print('<tr><td>T'..i..'</td>')
			for j,vj in ipairs(vtxs) do
				local k = vtxs:find((xi * vj)())
				print'<td>'
				if not k then
					print("couldn't find xform for ", var'T'('_'..i) * var'V'('_'..j))
				else
					print('V'..k)
				end
				print'</td>'
			end
			print('</tr>\n')
		end
		print'</table>\n'
		printbr()
		printbr()
	end
	printVtxMulTable()


	local mulTable = {}
	shapeCache.mulTable = mulTable
	for i,xi in ipairs(allxforms) do
		mulTable[i] = {}
		for j,xj in ipairs(allxforms) do
			mulTable[i][j] = allxforms:find((xi * xj)())
		end
	end

	local function printXformMulTable()
		print'<table>\n'
		print'<tr><td></td>'
		for i=1,#allxforms do
			print('<td>T'..i..'</td>')
		end
		print'</tr>\n'
		-- print the multiplcation table
		for i=1,#allxforms do
			print('<tr><td>T'..i..'</td>')
			for j=1,#allxforms do
				local k = mulTable[i][j]
				print'<td>'
				if not k then
					print("couldn't find xform for ", var'T'('_'..i) * var'T'('_'..j))
				else
					print('T'..k)
				end
				print'</td>'
			end
			print('</tr>\n')
		end
		print'</table>\n'
		printbr()
		printbr()
	end

	printXformMulTable()


	--[=[ rename by trying to put the Ti*Tj=T1 transforms closest to the diagonal:
	
	local dist = table()
	for i=1,#allxforms do
		for j=1,#allxforms do
			if mulTable[i][j] == 1 then
				dist[i] = math.abs(i - j)
				break
			end
		end
	end
	dist = dist:mapi(function(v,k) return {k,v} end):sort(function(a,b)
		if a[2] == b[2] then return a[1] < b[1] end	-- for matching dist's, keep smallest indexes first
		return a[2] < b[2]
	end)
	-- ok now, the renaming: dist[i][1] is the 'from', i is the 'to'
	local rename = table()
	for i=1,#dist do
		rename[dist[i][1]] = i
	end
	--]=]

	--[=[ rename by grouping transforms

	-- rename[to] = from
	local whatsleft = range(#allxforms)
	local rename = table()
	rename:insert(whatsleft:remove(1))
	
	local function process(last)
		if not last then
			if #whatsleft == 0 then return end
			last = whatsleft:remove(1)
			rename:insert(last)
			return process(last)
		end
		
		local next = mulTable[2][last]
		local k = whatsleft:find(next)
		if not k then return process() end
		
		whatsleft:remove(k)
		rename:insert(next)
		return process(next)
	end
	process()

	-- change to rename[from] = to
	rename = rename:mapi(function(v,k) return k,v end)
	--]=]

	--[=[
	-- now first remap mulTable[i][j]
	-- then remap the indexes of mulTable
	local mulTableRenamed = {}
	for i=1,#allxforms do
		mulTableRenamed[rename[i]] = {}
		for j=1,#allxforms do
			mulTableRenamed[rename[i]][rename[j]] = rename[mulTable[i][j]]
		end
	end
	
	printbr('relabeled', tolua(rename))
	printbr()

	mulTable = mulTableRenamed
	printXformMulTable()
	--]=]

--[=[ not sure if this is useful.  can't seem to visualize anything useful from it.
	file['tmp.dot'] = table{
		'digraph {',
	}:append(edges:mapi(function(e)
		return '\t'..table.concat(e, ' -> ')..';'
	end)):append{
		'}',
	}:concat'\n'

	os.execute('circo tmp.dot -Tsvg > "Platonic Solids/'..shape.name..'.svg"')
	os.remove'tmp.dot'

	printbr("<img src='"..shape.name..".svg'>/")
--]=]


	print(MathJax.footer)
	f:close()
end

-- can symmath.export.SymMath export Lua tables?
--io.writefile(cacheFilename, symmath.export.SymMath(cache))
io.writefile(cacheFilename, tolua(cache, {
	serializeForType = {
		table = function(state, x, tab, path, keyRef, ...)
			local mt = getmetatable(x)
			if mt and (
				Expression:isa(mt) 
				-- TODO 'or' any other classes in symmath that aren't subclasses of Expression (are there any?)
			) then
				return symmath.export.SymMath(x)	
			end
			return tolua.defaultSerializeForType.table(state, x, tab, path, keyRef, ...)
		end,
	}
}))
-- is there some sort of tolua args that will encode the symmath with symmath.export.SymMath?
--[[
local s = table()
s:insert'{'
for k,v in pairs(cache) do
	
end
s:insert'}'
io.writefile(cacheFilename, s:concat'\n')
--]]

print(export.MathJax.footer)