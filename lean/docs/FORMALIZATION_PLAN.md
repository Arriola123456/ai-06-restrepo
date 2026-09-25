# Formalization Plan: The Race between Man and Machine

This is a working scratchpad for outside-Lean proof thinking. Keep it short and
useful; it is not the final validation report.

- Namespace: `AR18RaceManMachine`

## Initial Outside-Lean Paper Audit

- Source version / local files inspected: NBER Working Paper 22252, revised
  June 2017 (87 pp., SHA-256 `441d0120…16b7`), the course PDF. Section 2
  (static model: environment, equilibrium, Propositions 1-3, Corollary 1)
  read in full; Appendix B's proof of Proposition 3 read (PDF pages 64-65).
- Source/version mismatch notes: the AER version (108(6), 2018) reverses the
  title order and has different pagination; not read. Page locators below are
  PDF pages of the NBER file (printed page = PDF page - 2).
- Complete named-result ledger status: Assumptions 1-3; Propositions 1-3 and
  Corollary 1 (static); Propositions 4-5 (dynamics), 6-9 (endogenous
  technology, extensions); equations (1)-(13). Ten static targets selected.
- Formula sanity check:
  - Signs, constants, normalizations, quantifiers, domains: `γ` strictly
    increasing gives `R < W/γ(i)` below `Ĩ`; tasks run over `[N-1, N]`, so
    `I* - N + 1 > 0` makes `Λ_I, Λ_N > 0`; the productivity coefficient
    `((W/γ)^{1-σ̂} - R^{1-σ̂})/(1-σ̂)` is positive on both sides of `σ̂ = 1`
    (the Cobb-Douglas case `σ̂ = 1` is a limit, kept out of the Spec).
  - Checked numerically (course repository, `analysis/task_model.py`): the
    numerical total derivative `d ln W / dI` of the static equilibrium equals
    Proposition 3's formula to four decimals.
  - Dependency map: (5)-(6) → `I* = min{I, Ĩ}` → (12)-(13) → Proposition 2
    (differentiation of (13)) → Proposition 3 (B9-B10). Corollary 1 is the
    `σ = ζ = 1` case of (12).
- Named result sanity check:
  - Results that look correct as stated: the selected rows.
  - Suspected bugs or ambiguous wording: Proposition 3's sentence "there
    exists `K̄ > K̲` such that an increase in `I` increases the equilibrium wage
    when `K < K̄` and reduces it when `K > K̄`" appears to have the inequalities
    reversed. In the Cobb-Douglas case of Corollary 1,
    `d ln W / d I* = ln(K/L) - 1/(N - I*)` (proved in `MainTheorems.lean`), so
    the wage rises with automation only when `K/L > e^{1/(N-I*)}`, i.e. for
    abundant capital, while Assumption 3 (`K < K̲`, with `K̲/L = (1-s)/s < e^{1/s}`)
    puts the economy where the wage falls. The general-σ̂ numerics show the
    same: `d ln W/dI < 0` throughout the Assumption-3 window and positive only
    beyond a `K̄ > K̲`. The correct condition for automation to raise the wage
    is a large enough cost saving `W/γ(I*) - R` relative to the displacement
    term `(1-s_L)Λ_I/(σ̂+ε_L)`, which requires abundant capital.
- Formalization risks: the equilibrium map (13) and its differentiation are
  out of reach in the time available; rows are stated over the primitives with
  the paper's displays as hypotheses.

## Statement-First Setup

- Ten transparent Specs over reals; `n`, `I*`, `Ĩ` are reals, `γ : ℝ → ℝ`.
- `Assumptions.lean` empty; every premise is a binder.
- Tactics: `lt_div_iff₀`, `div_lt_iff₀`, `lt_min_iff`, `min_lt_iff`,
  `Real.rpow_pos_of_pos`, `Real.rpow_lt_rpow`, `Real.rpow_lt_rpow_of_neg`,
  `div_pos`, `div_pos_of_neg_of_neg`, `Real.hasDerivAt_rpow_const`,
  `Real.rpow_sub_one`, `Real.hasDerivAt_log`, `Real.lt_log_iff_exp_lt`,
  `field_simp`, `ring`, `linarith`.

## Next Proof Obligations

- State equation (13) and derive Proposition 2's derivatives in Lean (needs
  the integral `∫_{I*}^N γ^{σ̂-1}` as a Mathlib interval integral and implicit
  differentiation of (13)).
- Prove the existence of `K̄` of Proposition 3 in the Cobb-Douglas case from
  the closed form `ln(K/L) - 1/(N - I*)` (monotone in `K`), and state the
  corrected direction.
- Run the statement precheck and the LLM audit lanes.
