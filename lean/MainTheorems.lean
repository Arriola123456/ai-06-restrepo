import Mathlib.Tactic
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Deriv

/-!
# Paper-Facing Theorems: The Race between Man and Machine

This file is the implementation theorem layer for the source paper. Keep
source-faithful definitions and theorem wrappers here, and expose only the
compact human-review subset in `PaperInterface.lean`.

During the statement-first phase, each exact paper-facing proposition lives in a
transparent `<name>Spec : Prop` declaration in `PaperInterface.lean`; the paired
theorem/lemma endpoint belongs in `ProofInterface.lean` and has exactly that
type.

Import note (student run, 2026-09-24): the scaffold writes `import Mathlib`
here and validates the statement spec under `import AppliedModelingLib`. On the
laptop used for this run the library root could not be built after the
EconCSLib → AppliedModelingLib rename (see `docs/RUN_LOG.md`), so the paper
modules import only the Mathlib modules they use: tactics, the reals, and real
powers with their derivatives. No library declaration is used by any Spec or
proof.

## Source model (Section 2 of NBER w22252, revised June 2017)

Objects are reals at a fixed static equilibrium: `W` wage, `R` rental rate, `γ`
the comparative-advantage schedule (Assumption 1: strictly increasing), `I` the
automation frontier, `It` = Ĩ the cost-minimising threshold of equation (6),
`Istar` = I* = min{I, Ĩ}, `σh` = σ̂, `εL` the labor-supply elasticity, `ΛI`, `ΛN`
the terms of Proposition 2, `sL` the labor share, `P` the productivity effect
d ln Y|_{K,L}. The equilibrium itself (Proposition 1) is not modelled: the Specs
take the paper's displayed formulas as hypotheses and prove their sign and
threshold consequences.
-/

namespace AR18RaceManMachine

/-- In the Cobb-Douglas corollary, `ln W = ln c + ln s + (1 - s) ln K + (s - 1) ln L` with
`s = N - I*`; since `I*` enters only through `s`, the derivative of `ln W` in `s` is
`1/s - ln K + ln L`, so `d ln W / d I* = ln(K/L) - 1/(N - I*)`: automation raises the
Cobb-Douglas wage iff `K / L > exp(1/(N - I*))`. -/
theorem cobb_douglas_log_wage_deriv (c K L s : ℝ) (hs : 0 < s) :
    HasDerivAt (fun s' : ℝ => Real.log c + Real.log s' + (1 - s') * Real.log K + (s' - 1) * Real.log L)
      (1 / s - Real.log K + Real.log L) s := by
  have h1 : HasDerivAt (fun s' : ℝ => Real.log s') (1 / s) s := by
    simpa [one_div] using Real.hasDerivAt_log hs.ne'
  have h2 : HasDerivAt (fun s' : ℝ => (1 - s') * Real.log K) (-Real.log K) s := by
    have := ((hasDerivAt_id' (x := s)).const_sub 1).mul_const (Real.log K)
    simpa using this
  have h3 : HasDerivAt (fun s' : ℝ => (s' - 1) * Real.log L) (Real.log L) s := by
    have := ((hasDerivAt_id' (x := s)).sub_const 1).mul_const (Real.log L)
    simpa using this
  have h := (((hasDerivAt_const s (Real.log c)).add h1).add h2).add h3
  refine h.congr_deriv ?_
  ring

/-- Sign of the Cobb-Douglas wage response to automation: `ln(K/L) - 1/s > 0 ↔ exp(1/s) < K/L`. -/
theorem cobb_douglas_wage_rises_iff (K L s : ℝ) (hK : 0 < K) (hL : 0 < L) (hs : 0 < s) :
    0 < Real.log (K / L) - 1 / s ↔ Real.exp (1 / s) < K / L := by
  have hKL : 0 < K / L := div_pos hK hL
  rw [sub_pos]
  exact Real.lt_log_iff_exp_lt hKL

end AR18RaceManMachine
