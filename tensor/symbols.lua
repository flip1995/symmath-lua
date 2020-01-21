local table = require 'ext.table'
local range = require 'ext.range'

local greekSymbolsAndNames = table{
	{alpha = 'α'},		--άλφα 	[a] [aː] 	[a]
	{beta = 'β'},		--βήτα 	[b] 	[v]
	{gamma = 'γ'},		--γάμμα 	[ɡ], [ŋ][ex 1] 	[ɣ] ~ [ʝ], [ŋ][ex 2] ~ [ɲ][ex 3]
	{delta = 'δ'},		--δέλτα 	[d] 	[ð]
	{epsilon = 'ε'},	--έψιλον 	[e]
	{zeta = 'ζ'},		--ζήτα 	[zd]A 	[z]
	{eta = 'η'},		--ήτα 	[ɛː] 	[i]
	{theta = 'θ'},		--θήτα 	[tʰ] 	[θ]
	{iota = 'ι'},		--ιώτα 	[i] [iː] 	[i], [ʝ],[ex 4] [ɲ][ex 5]
	{kappa = 'κ'},		--κάππα 	[k] 	[k] ~ [c]
	{lambda = 'λ'},		--λάμδα 	[l]
	{mu = 'μ'},			--μυ 	[m]
	{nu = 'ν'},			--νυ 	[n]
	{xi = 'ξ'},			--ξι 	[ks]
	{omicron = 'ο'},	--όμικρον 	[o]
	{pi = 'π'},			--πι 	[p]
	{rho = 'ρ'},		--ρώ 	[r]
	{sigma = 'σ'},		--σίγμα 	[s] 	[s] ~ [z]		/ς[note 1]
	{tau = 'τ'},		--ταυ 	[t]
	{upsilon = 'υ'},	--ύψιλον 	[y] [yː] 	[i]
	{phi = 'φ'},		--φι 	[pʰ] 	[f]
	{chi = 'χ'},		--χι 	[kʰ] 	[x] ~ [ç]
	{psi = 'ψ'},		--ψι 	[ps]
	{omega = 'ω'},		--ωμέγα 	[ɔː] 	[o]

	{Alpha = 'Α'},
	{Beta = 'Β'},
	{Gamma = 'Γ'},
	{Delta = 'Δ'},
	{Epsilon = 'Ε'},
	{Zeta = 'Ζ'},
	{Eta = 'Η'},
	{Theta = 'Θ'},
	{Iota = 'Ι'},
	{Kappa = 'Κ'},
	{Lambda = 'Λ'},
	{Mu = 'Μ'},
	{Nu = 'Ν'},
	{Xi = 'Ξ'},
	{Omicron = 'Ο'},
	{Pi = 'Π'},
	{Rho = 'Ρ'},
	{Sigma = 'Σ'},
	{Tau = 'Τ'},
	{Upsilon = 'Υ'},
	{Phi = 'Φ'},
	{Chi = 'Χ'},
	{Psi = 'Ψ'},
	{Omega = 'Ω'},
}

local greekSymbolNames = greekSymbolsAndNames:mapi(function(kv)
	return (next(kv))
end)

local greekSymbolForNames = greekSymbolsAndNames:mapi(function(kv)
	local k,v = next(kv)
	return v,k
end)

local latinSymbols = range(1,26):mapi(function(i)
	return string.char(('a'):byte()+i-1)
end)

return {
	greekSymbolsAndNames = greekSymbolsAndNames,
	greekSymbolForNames = greekSymbolForNames,
	greekSymbolNames = greekSymbolNames,
	latinSymbols = latinSymbols,
}
