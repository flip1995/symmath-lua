package = "symmath"
version = "dev-1"
source = {
	url = "git+https://github.com/thenumbernine/symmath-lua.git"
}
description = {
	summary = "Symbolic Math library for Lua",
	detailed = "Symbolic Math library for Lua",
	homepage = "https://github.com/thenumbernine/symmath-lua",
	license = "MIT"
}
dependencies = {
	"lua >= 5.1"
}
build = {
	type = "builtin",
	modules = {
		["symmath"] = "symmath.lua",
		["symmath.Array"] = "Array.lua",
		["symmath.Constant"] = "Constant.lua",
		["symmath.Derivative"] = "Derivative.lua",
		["symmath.Expression"] = "Expression.lua",
		["symmath.Function"] = "Function.lua",
		["symmath.Heaviside"] = "Heaviside.lua",
		["symmath.Integral"] = "Integral.lua",
		["symmath.Invalid"] = "Invalid.lua",
		["symmath.Matrix"] = "Matrix.lua",
		["symmath.Sum"] = "Sum.lua",
		["symmath.Tensor"] = "Tensor.lua",
		["symmath.Variable"] = "Variable.lua",
		["symmath.Vector"] = "Vector.lua",
		["symmath.abs"] = "abs.lua",
		["symmath.acos"] = "acos.lua",
		["symmath.acosh"] = "acosh.lua",
		["symmath.asin"] = "asin.lua",
		["symmath.asinh"] = "asinh.lua",
		["symmath.atan"] = "atan.lua",
		["symmath.atan2"] = "atan2.lua",
		["symmath.atanh"] = "atanh.lua",
		["symmath.cbrt"] = "cbrt.lua",
		["symmath.clone"] = "clone.lua",
		["symmath.commutativeRemove"] = "commutativeRemove.lua",
		["symmath.complex"] = "complex.lua",
		["symmath.cos"] = "cos.lua",
		["symmath.cosh"] = "cosh.lua",
		["symmath.distributeDivision"] = "distributeDivision.lua",
		["symmath.eval"] = "eval.lua",
		["symmath.exp"] = "exp.lua",
		["symmath.expand"] = "expand.lua",
		["symmath.export.C"] = "export/C.lua",
		["symmath.export.Console"] = "export/Console.lua",
		["symmath.export.Export"] = "export/Export.lua",
		["symmath.export.GnuPlot"] = "export/GnuPlot.lua",
		["symmath.export.JavaScript"] = "export/JavaScript.lua",
		["symmath.export.LaTeX"] = "export/LaTeX.lua",
		["symmath.export.Language"] = "export/Language.lua",
		["symmath.export.Lua"] = "export/Lua.lua",
		["symmath.export.MathJax"] = "export/MathJax.lua",
		["symmath.export.Mathematica"] = "export/Mathematica.lua",
		["symmath.export.MultiLine"] = "export/MultiLine.lua",
		["symmath.export.SingleLine"] = "export/SingleLine.lua",
		["symmath.export.SymMath"] = "export/SymMath.lua",
		["symmath.export.Verbose"] = "export/Verbose.lua",
		["symmath.factor"] = "factor.lua",
		["symmath.factorDivision"] = "factorDivision.lua",
		["symmath.factorLinearSystem"] = "factorLinearSystem.lua",
		["symmath.log"] = "log.lua",
		["symmath.make_README"] = "make_README.lua",
		["symmath.map"] = "map.lua",
		["symmath.matrix.EulerAngles"] = "matrix/EulerAngles.lua",
		["symmath.matrix.Rotation"] = "matrix/Rotation.lua",
		["symmath.matrix.determinant"] = "matrix/determinant.lua",
		["symmath.matrix.diagonal"] = "matrix/diagonal.lua",
		["symmath.matrix.eigen"] = "matrix/eigen.lua",
		["symmath.matrix.exp"] = "matrix/exp.lua",
		["symmath.matrix.identity"] = "matrix/identity.lua",
		["symmath.matrix.inverse"] = "matrix/inverse.lua",
		["symmath.matrix.nullspace"] = "matrix/nullspace.lua",
		["symmath.matrix.pseudoInverse"] = "matrix/pseudoInverse.lua",
		["symmath.matrix.trace"] = "matrix/trace.lua",
		["symmath.matrix.transpose"] = "matrix/transpose.lua",
		["symmath.multiplicity"] = "multiplicity.lua",
		["symmath.nodeCommutativeEqual"] = "nodeCommutativeEqual.lua",
		["symmath.op.Binary"] = "op/Binary.lua",
		["symmath.op.Equation"] = "op/Equation.lua",
		["symmath.op.add"] = "op/add.lua",
		["symmath.op.div"] = "op/div.lua",
		["symmath.op.eq"] = "op/eq.lua",
		["symmath.op.ge"] = "op/ge.lua",
		["symmath.op.gt"] = "op/gt.lua",
		["symmath.op.le"] = "op/le.lua",
		["symmath.op.lt"] = "op/lt.lua",
		["symmath.op.mod"] = "op/mod.lua",
		["symmath.op.mul"] = "op/mul.lua",
		["symmath.op.ne"] = "op/ne.lua",
		["symmath.op.pow"] = "op/pow.lua",
		["symmath.op.sub"] = "op/sub.lua",
		["symmath.op.unm"] = "op/unm.lua",
		["symmath.physics.Faraday"] = "physics/Faraday.lua",
		["symmath.physics.StressEnergy"] = "physics/StressEnergy.lua",
		["symmath.physics.diffgeom"] = "physics/diffgeom.lua",
		["symmath.physics.units"] = "physics/units.lua",
		["symmath.polyCoeffs"] = "polyCoeffs.lua",
		["symmath.primeFactors"] = "primeFactors.lua",
		["symmath.prune"] = "prune.lua",
		["symmath.replace"] = "replace.lua",
		["symmath.set.sets"] = "set/sets.lua",
		["symmath.set.Complex"] = "set/Complex.lua",
		["symmath.set.EvenInteger"] = "set/EvenInteger.lua",
		["symmath.set.Integer"] = "set/Integer.lua",
		["symmath.set.NegativeReal"] = "set/NegativeReal.lua",
		["symmath.set.NonNegativeReal"] = "set/NonNegativeReal.lua",
		["symmath.set.NonPositiveReal"] = "set/NonPositiveReal.lua",
		["symmath.set.OddInteger"] = "set/OddInteger.lua",
		["symmath.set.PositiveReal"] = "set/PositiveReal.lua",
		["symmath.set.RealInterval"] = "set/RealInterval.lua",
		["symmath.set.RealDomain"] = "set/RealDomain.lua",
		["symmath.set.Set"] = "set/Set.lua",
		["symmath.set.Null"] = "set/Null.lua",
		["symmath.set.Universal"] = "set/Universal.lua",
		["symmath.setup"] = "setup.lua",
		["symmath.simplify"] = "simplify.lua",
		["symmath.sin"] = "sin.lua",
		["symmath.sinh"] = "sinh.lua",
		["symmath.solve"] = "solve.lua",
		["symmath.sqrt"] = "sqrt.lua",
		["symmath.tableCommutativeEqual"] = "tableCommutativeEqual.lua",
		["symmath.tan"] = "tan.lua",
		["symmath.tanh"] = "tanh.lua",
		["symmath.taylor"] = "taylor.lua",
		["symmath.tensor.KronecherDelta"] = "tensor/KronecherDelta.lua",
		["symmath.tensor.LeviCivita"] = "tensor/LeviCivita.lua",
		["symmath.tensor.TensorCoordBasis"] = "tensor/TensorCoordBasis.lua",
		["symmath.tensor.TensorIndex"] = "tensor/TensorIndex.lua",
		["symmath.tensor.TensorRef"] = "tensor/TensorRef.lua",
		["symmath.tensor.dual"] = "tensor/dual.lua",
		["symmath.tensor.symbols"] = "tensor/symbols.lua",
		["symmath.tensor.wedge"] = "tensor/wedge.lua",
		["symmath.tests.ADM Levi-Civita"] = "tests/ADM Levi-Civita.lua",
		["symmath.tests.ADM gravity using expressions"] = "tests/ADM gravity using expressions.lua",
		["symmath.tests.ADM metric"] = "tests/ADM metric.lua",
		["symmath.tests.ADM metric - mixed"] = "tests/ADM metric - mixed.lua",
		["symmath.tests.Alcubierre"] = "tests/Alcubierre.lua",
		["symmath.tests.BSSN"] = "tests/BSSN.lua",
		["symmath.tests.Building Curvature by ADM"] = "tests/Building Curvature by ADM.lua",
		["symmath.tests.EFE discrete solution - 1-var"] = "tests/EFE discrete solution - 1-var.lua",
		["symmath.tests.EFE discrete solution - 2-var"] = "tests/EFE discrete solution - 2-var.lua",
		["symmath.tests.Einstein field equations - expression"] = "tests/Einstein field equations - expression.lua",
		["symmath.tests.Ernst"] = "tests/Ernst.lua",
		["symmath.tests.FLRW"] = "tests/FLRW.lua",
		["symmath.tests.Faraday tensor in general relativity"] = "tests/Faraday tensor in general relativity.lua",
		["symmath.tests.Faraday tensor in special relativity"] = "tests/Faraday tensor in special relativity.lua",
		["symmath.tests.FiniteVolume"] = "tests/FiniteVolume.lua",
		["symmath.tests.GLM-Maxwell"] = "tests/GLM-Maxwell.lua",
		["symmath.tests.Gravitation 16.1 - dense"] = "tests/Gravitation 16.1 - dense.lua",
		["symmath.tests.Gravitation 16.1 - expression"] = "tests/Gravitation 16.1 - expression.lua",
		["symmath.tests.Gravitation 16.1 - mixed"] = "tests/Gravitation 16.1 - mixed.lua",
		["symmath.tests.Kaluza-Klein"] = "tests/Kaluza-Klein.lua",
		["symmath.tests.Kaluza-Klein - index"] = "tests/Kaluza-Klein - index.lua",
		["symmath.tests.Kaluza-Klein - varying scalar field - index"] = "tests/Kaluza-Klein - varying scalar field - index.lua",
		["symmath.tests.Kerr-Schild - dense"] = "tests/Kerr-Schild - dense.lua",
		["symmath.tests.Kerr-Schild - expression"] = "tests/Kerr-Schild - expression.lua",
		["symmath.tests.Kerr-Schild degenerate case"] = "tests/Kerr-Schild degenerate case.lua",
		["symmath.tests.MHD inverse"] = "tests/MHD inverse.lua",
		["symmath.tests.MHD symmetrization"] = "tests/MHD symmetrization.lua",
		["symmath.tests.Maxwell equations in hyperbolic conservation form"] = "tests/Maxwell equations in hyperbolic conservation form.lua",
		["symmath.tests.Newton method"] = "tests/Newton method.lua",
		["symmath.tests.Parallel Propagators"] = "tests/Parallel Propagators.lua",
		["symmath.tests.SRHD"] = "tests/SRHD.lua",
		["symmath.tests.SRHD_1D"] = "tests/SRHD_1D.lua",
		["symmath.tests.Schwarzschild - isotropic"] = "tests/Schwarzschild - isotropic.lua",
		["symmath.tests.Schwarzschild - spherical"] = "tests/Schwarzschild - spherical.lua",
		["symmath.tests.Schwarzschild - spherical - derivation"] = "tests/Schwarzschild - spherical - derivation.lua",
		["symmath.tests.Schwarzschild - spherical - derivation - varying time"] = "tests/Schwarzschild - spherical - derivation - varying time.lua",
		["symmath.tests.Schwarzschild - spherical - derivation - varying time 2"] = "tests/Schwarzschild - spherical - derivation - varying time 2.lua",
		["symmath.tests.Schwarzschild - spherical - mass varying with time"] = "tests/Schwarzschild - spherical - mass varying with time.lua",
		["symmath.tests.TOV"] = "tests/TOV.lua",
		["symmath.tests.console_spherical_metric"] = "tests/console_spherical_metric.lua",
		["symmath.tests.electrovacuum.black hole electron"] = "tests/electrovacuum/black hole electron.lua",
		["symmath.tests.electrovacuum.general case"] = "tests/electrovacuum/general case.lua",
		["symmath.tests.electrovacuum.infinite wire"] = "tests/electrovacuum/infinite wire.lua",
		["symmath.tests.electrovacuum.infinite wire no charge"] = "tests/electrovacuum/infinite wire no charge.lua",
		["symmath.tests.electrovacuum.uniform field - Cartesian"] = "tests/electrovacuum/uniform field - Cartesian.lua",
		["symmath.tests.electrovacuum.uniform field - cylindrical"] = "tests/electrovacuum/uniform field - cylindrical.lua",
		["symmath.tests.electrovacuum.uniform field - spherical"] = "tests/electrovacuum/uniform field - spherical.lua",
		["symmath.tests.electrovacuum.verify cylindrical transform"] = "tests/electrovacuum/verify cylindrical transform.lua",
		["symmath.tests.hydrodynamics"] = "tests/hydrodynamics.lua",
		["symmath.tests.linearized Euler fluid equations"] = "tests/linearized Euler fluid equations.lua",
		["symmath.tests.metric catalog"] = "tests/metric catalog.lua",
		["symmath.tests.natural units"] = "tests/natural units.lua",
		["symmath.tests.numeric integration"] = "tests/numeric integration.lua",
		["symmath.tests.remove beta from adm metric"] = "tests/remove beta from adm metric.lua",
		["symmath.tests.rotation group"] = "tests/rotation group.lua",
		["symmath.tests.run all tests"] = "tests/run all tests.lua",
		["symmath.tests.scalar metric"] = "tests/scalar metric.lua",
		["symmath.tests.simple_ag"] = "tests/simple_ag.lua",
		["symmath.tests.spacetime embedding radius"] = "tests/spacetime embedding radius.lua",
		["symmath.tests.spinors"] = "tests/spinors.lua",
		["symmath.tests.spring force"] = "tests/spring force.lua",
		["symmath.tests.tensor coordinate invariance"] = "tests/tensor coordinate invariance.lua",
		["symmath.tests.toy-1+1 spacetime"] = "tests/toy-1+1 spacetime.lua",
		["symmath.tests.unit.determinant_performance"] = "tests/unit/determinant_performance.lua",
		["symmath.tests.unit.linear solver"] = "tests/unit/linear solver.lua",
		["symmath.tests.unit.matrix"] = "tests/unit/matrix.lua",
		["symmath.tests.unit.partial replace"] = "tests/unit/partial replace.lua",
		["symmath.tests.unit.sub-tensor assignment"] = "tests/unit/sub-tensor assignment.lua",
		["symmath.tests.unit.sets"] = "tests/unit/sets.lua",
		["symmath.tests.unit.tensor use case"] = "tests/unit/tensor use case.lua",
		["symmath.tests.unit.test"] = "tests/unit/test.lua",
		["symmath.tests.unit.tidyIndexes"] = "tests/unit/tidyIndexes.lua",
		["symmath.tests.wave equation in spacetime"] = "tests/wave equation in spacetime.lua",
		["symmath.tests.wave equation in spacetime - flux eigenvectors"] = "tests/wave equation in spacetime - flux eigenvectors.lua",
		["symmath.tidy"] = "tidy.lua",
		["symmath.visitor.DistributeDivision"] = "visitor/DistributeDivision.lua",
		["symmath.visitor.Eval"] = "visitor/Eval.lua",
		["symmath.visitor.Expand"] = "visitor/Expand.lua",
		["symmath.visitor.ExpandPolynomial"] = "visitor/ExpandPolynomial.lua",
		["symmath.visitor.Factor"] = "visitor/Factor.lua",
		["symmath.visitor.FactorDivision"] = "visitor/FactorDivision.lua",
		["symmath.visitor.Prune"] = "visitor/Prune.lua",
		["symmath.visitor.Tidy"] = "visitor/Tidy.lua",
		["symmath.visitor.Visitor"] = "visitor/Visitor.lua"
	},
	copy_directories = {
		"tests/output"
	}
}
