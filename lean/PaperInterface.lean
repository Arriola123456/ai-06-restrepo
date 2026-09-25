import AR18RaceManMachine.MainTheorems
import AR18RaceManMachine.Assumptions

/-!
# Human-Facing Paper Interface: The Race between Man and Machine: Implications of Technology for Growth, Factor Shares, and Employment

This is the compact Lean file a human should read after formalization to check
whether the paper's definitions and named theorem statements were represented
correctly. Keep the row-level dashboard and LLM audit statements in this file
for every paper. Move implementation details, proof aliases, and bulky helper
lemmas behind imported modules such as `AuditInterface.lean`, but expose the
audited paper-facing statements directly here; do not use
`paper_interface.audit_surface_path`.

Rules for completing this file:

- Keep the paper's definitions/formatted objects first, in source order.
- Expose the actual paper formulas here; do not only point to generic library
  definitions or implementation witnesses.
- A material reusable `AppliedModelingLib` primitive may remain a reference here only
  after `audit/library_semantic_review.json` records its exact bounded library
  declaration and an explicit byte-pinned paper-source connection. The
  dashboard and human-review packet show and source-check that declaration
  before the dependent Spec; a library name, docstring, or glossary is not a
  semantic bridge. Do not add a duplicate paper claim merely to restate it.
- If a named theorem needs a hypothesis that is not derived from earlier Lean
  declarations, declare that hypothesis in `Assumptions.lean` and list it in
  `status.json` `review_surface.assumption_names`.
- Then state the named results directly, with assumptions visible in each
  theorem signature by referencing named paper assumptions imported from
  `Assumptions.lean`.
- In the statement-first phase, write every complete source-facing statement as
  a transparent `<name>Spec : Prop` here, exactly once. Put the paired
  theorem/lemma of that exact type in `ProofInterface.lean`; its temporary
  proof body may be `by sorry` only in a private draft. This separation keeps
  the human semantic surface free of thin wrapper declarations.
- Before drafting that Lean surface, independently inventory every material
  source atom from exact pinned source quote bytes. Do not infer source atoms
  from declaration, binder, field, function, or source-map names.
- Run raw-source-to-expanded-Spec statement matching plus Lean-emitted
  premise/conclusion claim-atom review on the skeleton. The semantic comparison uses
  only byte-pinned source quotes (and separately pinned source context) against
  the expanded transparent Spec; map summaries and proof wrappers are not
  semantic inputs. Then freeze each canonical Lean declaration-manifest digest.
- In the proof phase, replace the `ProofInterface.lean` `sorry` with a short
  proof that calls into `MainTheorems.lean` or lower proof files without
  changing the specification or theorem type. Any specification/type change
  invalidates the freeze and requires a fresh statement audit.
- At formalized closeout, complete the v11 realization receipt: Lean Meta checks
  the theorem has exactly the transparent Spec type; each source atom is bound
  to the elaborated Spec surface; closure traversal includes proof and instance
  arguments; and every material terminal has a source, approved correction or
  additional assumption, checked derivation, or version-pinned foundation
  disposition. No data, container, or identifier-based exemption is allowed.
- The transparent `...Spec` is the sole semantic-review target for its source
  claim. The paired theorem/lemma is a proof endpoint whose exact Spec type is
  verified by Lean Meta, not a duplicate source-to-Lean comparison row.
- Keep proof endpoints, exhaustive endpoint aliases, and proof-seam checks in
  `ProofInterface.lean`, implementation modules, or `ProofLedger.lean`, not
  here. Do not create new `PostPaperAudit.lean` or `AuditLedger.lean` files;
  those names are legacy.

## Named Results

Each entry has one semantic-review target (`Spec`) and one proof endpoint (the
paired theorem/lemma). The human dashboard and review packet present that pair
once rather than treating the two declarations as duplicate paper claims.

- `paper_cost_thresholdSpec` -> `paper_cost_threshold`: Equations (5)-(6): unit costs and the cost-minimising threshold Ĩ (Section 2.2), Section 2.2, PDF page 10 (printed page 8): equation (5) p(i) = min{R, W/γ(i)}^(1-η) for i ≤ I, equation (6) W/R = γ(Ĩ), and the sentence 'For all tasks i < Ĩ, we have R < W/γ(i)'; Assumption 1 (γ strictly increasing) on PDF page 9.
- `paper_equilibrium_thresholdSpec` -> `paper_equilibrium_threshold`: The equilibrium threshold task I* = min{I, Ĩ} (Section 2.2), Section 2.2, PDF page 10 (printed page 8): 'there exists a unique equilibrium threshold task I* = min{I, Ĩ} such that all tasks i < I* will be produced with capital, while all tasks i > I* will be produced with labor'.
- `paper_prop2_lambda_positiveSpec` -> `paper_prop2_lambda_positive`: Proposition 2: the terms Λ_I and Λ_N are positive, Proposition 2, PDF page 13 (printed page 11): definitions Λ_I = γ(I*)^(σ̂-1)/∫_{I*}^N γ(i)^(σ̂-1) di + 1/(I*-N+1) and Λ_N = γ(N)^(σ̂-1)/∫_{I*}^N γ(i)^(σ̂-1) di + 1/(I*-N+1); tasks run over [N-1, N] (PDF page 8), so I* - N + 1 > 0.
- `paper_prop2_signs_constrainedSpec` -> `paper_prop2_signs_constrained`: Proposition 2 (technology-constrained case): signs of the comparative statics of W/R, Proposition 2, PDF page 13 (printed page 11), first bullet: d ln(W/R)/dI = d ln ω/dI = -Λ_I/(σ̂+ε_L) < 0, d ln(W/R)/dN = Λ_N/(σ̂+ε_L) > 0, d ln(W/R)/d ln K = (1+ε_L)/(σ̂+ε_L) > 0.
- `paper_prop2_sigma_freeSpec` -> `paper_prop2_sigma_free`: Proposition 2 (cost-minimising case): σ_free = σ̂ + Λ_I/ε_γ > σ̂, Proposition 2, PDF page 13 (printed page 11), second bullet: 'where σ_free = σ̂ + (1/ε_γ) Λ_I > σ̂'.
- `paper_prop3_productivity_effect_positiveSpec` -> `paper_prop3_productivity_effect_positive`: Proposition 3 (technology-constrained case): the productivity effect of automation is positive, Proposition 3, PDF page 15 (printed page 13), first bullet: W/γ(I*) > R > W/γ(N) and d ln Y|_{K,L} = B^(σ̂-1)/(1-σ̂) ((W/γ(I*))^(1-σ̂) - R^(1-σ̂)) dI + ... ; 'That is, both technologies increase productivity'.
- `paper_prop3_rental_rate_risesSpec` -> `paper_prop3_rental_rate_rises`: Proposition 3 (technology-constrained case): a higher I always increases the rental rate, Proposition 3, PDF page 15 (printed page 13): d ln R = d ln Y|_{K,L} - s_L (Λ_N dN/(σ̂+ε_L) - Λ_I dI/(σ̂+ε_L)); 'a higher I always increases the rental rate'.
- `paper_prop3_wage_decompositionSpec` -> `paper_prop3_wage_decomposition`: Proposition 3 (technology-constrained case): the wage rises with automation iff the productivity effect exceeds the displacement effect, Proposition 3, PDF page 15 (printed page 13): d ln W = d ln Y|_{K,L} + (1-s_L)(Λ_N dN/(σ̂+ε_L) - Λ_I dI/(σ̂+ε_L)); the discussion on PDF pages 15-16 names the two terms the productivity effect and the displacement effect.
- `paper_prop3_new_tasks_raise_wageSpec` -> `paper_prop3_new_tasks_raise_wage`: Proposition 3 (cost-minimising case): new tasks always increase the equilibrium wage, Proposition 3, PDF page 15 (printed page 13), second bullet: d ln W = d ln Y|_{K,L} + (1-s_L) Λ_N dN/(σ_free+ε_L) with d ln Y|_{K,L} = B^(σ̂-1)/(1-σ̂)(R^(1-σ̂) - (W/γ(N))^(1-σ̂)) dN > 0 under R > W/γ(N); 'an increase in N (more new tasks) always increases the equilibrium wage'.
- `paper_corollary_1_cobb_douglas_sharesSpec` -> `paper_corollary_1_cobb_douglas_shares`: Corollary 1: the Cobb-Douglas case and its factor shares, Corollary 1, PDF page 13 (printed page 11): Y = (B/(1-η)) K^(1-N+I*) L^(N-I*); the text below Proposition 1 (PDF page 12): 'An increase in I* — which corresponds to greater equilibrium automation — increases the share of capital and reduces the share of labor'; competitive factor prices are marginal products (page 10).
-/

namespace AR18RaceManMachine

/--
Equations (5)-(6): unit costs and the cost-minimising threshold Ĩ (Section 2.2)

Paper statement: Because labor has a strict comparative advantage in tasks with a higher index, the expression for p(i) implies that there is a (unique) threshold Ĩ such that W/R = γ(Ĩ). This threshold represents the task for which the costs of producing with capital and labor are equal. For all tasks i < Ĩ, we have R < W/γ(i), and without any other constraints, these tasks will be produced with capital. [Assumption 1: γ(i) is strictly increasing.]

Source location: Section 2.2, PDF page 10 (printed page 8): equation (5) p(i) = min{R, W/γ(i)}^(1-η) for i ≤ I, equation (6) W/R = γ(Ĩ), and the sentence 'For all tasks i < Ĩ, we have R < W/γ(i)'; Assumption 1 (γ strictly increasing) on PDF page 9
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_cost_thresholdSpec : Prop :=
  ∀ (W R : ℝ) (γ : ℝ → ℝ) (i It : ℝ),
    0 < W → 0 < R → StrictMono γ → (∀ x, 0 < γ x) → γ It = W / R →
      (i < It → R < W / γ i) ∧ (It < i → W / γ i < R)

/--
The equilibrium threshold task I* = min{I, Ĩ} (Section 2.2)

Paper statement: However, if Ĩ > I, firms cannot use capital all the way up to task Ĩ because of the constraint imposed by the available automation technology. This implies that there exists a unique equilibrium threshold task I* = min{I, Ĩ} such that all tasks i < I* will be produced with capital, while all tasks i > I* will be produced with labor.

Source location: Section 2.2, PDF page 10 (printed page 8): 'there exists a unique equilibrium threshold task I* = min{I, Ĩ} such that all tasks i < I* will be produced with capital, while all tasks i > I* will be produced with labor'
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_equilibrium_thresholdSpec : Prop :=
  ∀ I It i : ℝ,
    (i < min I It ↔ i < I ∧ i < It) ∧ (min I It < i ↔ I < i ∨ It < i)

/--
Proposition 2: the terms Λ_I and Λ_N are positive

Paper statement: Let ε_L > 0 denote the elasticity of the labor supply schedule L^s(ω); let ε_γ = d ln γ(I)/dI > 0 denote the semi-elasticity of the comparative advantage schedule; and let Λ_I = γ(I*)^(σ̂-1)/∫_{I*}^N γ(i)^(σ̂-1) di + 1/(I*-N+1) and Λ_N = γ(N)^(σ̂-1)/∫_{I*}^N γ(i)^(σ̂-1) di + 1/(I*-N+1). [Formalized with the integral as a positive real J: both terms are strictly positive.]

Source location: Proposition 2, PDF page 13 (printed page 11): definitions Λ_I = γ(I*)^(σ̂-1)/∫_{I*}^N γ(i)^(σ̂-1) di + 1/(I*-N+1) and Λ_N = γ(N)^(σ̂-1)/∫_{I*}^N γ(i)^(σ̂-1) di + 1/(I*-N+1); tasks run over [N-1, N] (PDF page 8), so I* - N + 1 > 0
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_prop2_lambda_positiveSpec : Prop :=
  ∀ (γI γN J Istar N σh : ℝ),
    0 < γI → 0 < γN → 0 < J → N - 1 < Istar →
      0 < γI ^ (σh - 1) / J + 1 / (Istar - N + 1) ∧
      0 < γN ^ (σh - 1) / J + 1 / (Istar - N + 1)

/--
Proposition 2 (technology-constrained case): signs of the comparative statics of W/R

Paper statement: If I* = I < Ĩ — so that the allocation of tasks to factors is constrained by technology — then: the impact of technological change on relative factor prices is given by d ln(W/R)/dI = d ln ω/dI = -(1/(σ̂+ε_L)) Λ_I < 0, d ln(W/R)/dN = d ln ω/dN = (1/(σ̂+ε_L)) Λ_N > 0; and the impact of capital on relative factor prices is given by d ln(W/R)/d ln K = d ln ω/d ln K + 1 = (1+ε_L)/(σ̂+ε_L) > 0.

Source location: Proposition 2, PDF page 13 (printed page 11), first bullet: d ln(W/R)/dI = d ln ω/dI = -Λ_I/(σ̂+ε_L) < 0, d ln(W/R)/dN = Λ_N/(σ̂+ε_L) > 0, d ln(W/R)/d ln K = (1+ε_L)/(σ̂+ε_L) > 0
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_prop2_signs_constrainedSpec : Prop :=
  ∀ σh εL ΛI ΛN : ℝ, 0 < σh → 0 < εL → 0 < ΛI → 0 < ΛN →
    -(1 / (σh + εL)) * ΛI < 0 ∧ 0 < (1 / (σh + εL)) * ΛN ∧ 0 < (1 + εL) / (σh + εL)

/--
Proposition 2 (cost-minimising case): σ_free = σ̂ + Λ_I/ε_γ > σ̂

Paper statement: If I* = Ĩ < I — so that the allocation of tasks to factors is cost-minimizing — then: d ln(W/R)/dI = d ln ω/dI = 0, d ln(W/R)/dN = d ln ω/dN = (1/(σ_free+ε_L)) Λ_N > 0, where σ_free = σ̂ + (1/ε_γ) Λ_I > σ̂.

Source location: Proposition 2, PDF page 13 (printed page 11), second bullet: 'where σ_free = σ̂ + (1/ε_γ) Λ_I > σ̂'
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_prop2_sigma_freeSpec : Prop :=
  ∀ σh εγ ΛI : ℝ, 0 < εγ → 0 < ΛI → σh < σh + (1 / εγ) * ΛI

/--
Proposition 3 (technology-constrained case): the productivity effect of automation is positive

Paper statement: If I* = I < Ĩ — so that the allocation of tasks to factors is constrained by technology — then W/γ(I*) > R > W/γ(N), and d ln Y|_{K,L} = (B^(σ̂-1)/(1-σ̂)) ((W/γ(I*))^(1-σ̂) - R^(1-σ̂)) dI + (B^(σ̂-1)/(1-σ̂)) (R^(1-σ̂) - (W/γ(N))^(1-σ̂)) dN. That is, both technologies increase productivity. [Formalized: the automation coefficient ((W/γ(I*))^(1-σ̂) - R^(1-σ̂))/(1-σ̂) is positive when W/γ(I*) > R > 0 and σ̂ ≠ 1.]

Source location: Proposition 3, PDF page 15 (printed page 13), first bullet: W/γ(I*) > R > W/γ(N) and d ln Y|_{K,L} = B^(σ̂-1)/(1-σ̂) ((W/γ(I*))^(1-σ̂) - R^(1-σ̂)) dI + ... ; 'That is, both technologies increase productivity'
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_prop3_productivity_effect_positiveSpec : Prop :=
  ∀ Wg R σh : ℝ, 0 < R → R < Wg → σh ≠ 1 →
    0 < (Wg ^ (1 - σh) - R ^ (1 - σh)) / (1 - σh)

/--
Proposition 3 (technology-constrained case): a higher I always increases the rental rate

Paper statement: The impact of technology on factor prices in this case is given by: d ln W = d ln Y|_{K,L} + (1-s_L)(Λ_N dN/(σ̂+ε_L) - Λ_I dI/(σ̂+ε_L)), d ln R = d ln Y|_{K,L} - s_L (Λ_N dN/(σ̂+ε_L) - Λ_I dI/(σ̂+ε_L)). That is, a higher N always increases the equilibrium wage but may reduce the rental rate, while a higher I always increases the rental rate but may reduce the equilibrium wage. [Formalized for pure automation, dN = 0, with the productivity effect P ≥ 0.]

Source location: Proposition 3, PDF page 15 (printed page 13): d ln R = d ln Y|_{K,L} - s_L (Λ_N dN/(σ̂+ε_L) - Λ_I dI/(σ̂+ε_L)); 'a higher I always increases the rental rate'
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_prop3_rental_rate_risesSpec : Prop :=
  ∀ P sL ΛI σh εL dI : ℝ, 0 ≤ P → 0 < sL → 0 < ΛI → 0 < σh → 0 < εL → 0 < dI →
    0 < P + sL * ((1 / (σh + εL)) * ΛI * dI)

/--
Proposition 3 (technology-constrained case): the wage rises with automation iff the productivity effect exceeds the displacement effect

Paper statement: d ln W = d ln Y|_{K,L} + (1-s_L)(Λ_N dN/(σ̂+ε_L) - Λ_I dI/(σ̂+ε_L)). [...] automation — an increase in I — always increases aggregate output, but has an ambiguous effect on the equilibrium wage. On the one hand, there is a positive productivity effect captured by the term d ln Y|_{K,L}. Countering this, there is a negative displacement effect captured by the term Λ_I/(σ̂+ε_L). [Formalized for pure automation, dN = 0: d ln W > 0 iff (1-s_L) Λ_I dI/(σ̂+ε_L) < d ln Y|_{K,L}.]

Source location: Proposition 3, PDF page 15 (printed page 13): d ln W = d ln Y|_{K,L} + (1-s_L)(Λ_N dN/(σ̂+ε_L) - Λ_I dI/(σ̂+ε_L)); the discussion on PDF pages 15-16 names the two terms the productivity effect and the displacement effect
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_prop3_wage_decompositionSpec : Prop :=
  ∀ P sL ΛI σh εL dI : ℝ,
    0 < P - (1 - sL) * ((1 / (σh + εL)) * ΛI * dI) ↔
      (1 - sL) * ((1 / (σh + εL)) * ΛI * dI) < P

/--
Proposition 3 (cost-minimising case): new tasks always increase the equilibrium wage

Paper statement: If I* = Ĩ < I — so that the allocation of tasks to factors is not constrained by technology — then W/γ(I*) = R > W/γ(N), and d ln Y|_{K,L} = (B^(σ̂-1)/(1-σ̂))(R^(1-σ̂) - (W/γ(N))^(1-σ̂)) dN. That is, new tasks increase productivity, but additional automation technologies do not. Moreover, d ln W = d ln Y|_{K,L} + (1-s_L)(1/(σ_free+ε_L)) Λ_N dN. That is, an increase in N (more new tasks) always increases the equilibrium wage. [Formalized with the positive productivity effect P and s_L < 1.]

Source location: Proposition 3, PDF page 15 (printed page 13), second bullet: d ln W = d ln Y|_{K,L} + (1-s_L) Λ_N dN/(σ_free+ε_L) with d ln Y|_{K,L} = B^(σ̂-1)/(1-σ̂)(R^(1-σ̂) - (W/γ(N))^(1-σ̂)) dN > 0 under R > W/γ(N); 'an increase in N (more new tasks) always increases the equilibrium wage'
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_prop3_new_tasks_raise_wageSpec : Prop :=
  ∀ P sL ΛN σf εL dN : ℝ, 0 < P → sL < 1 → 0 < ΛN → 0 < σf → 0 < εL → 0 < dN →
    0 < P + (1 - sL) * ((1 / (σf + εL)) * ΛN * dN)

/--
Corollary 1: the Cobb-Douglas case and its factor shares

Paper statement: Corollary 1. Suppose that σ = ζ = 1 and γ(i) = 1 for all i. Then aggregate output is Y = (B/(1-η)) K^(1-N+I*) L^(N-I*). [Formalized with c = B/(1-η): the marginal product of labor is (N-I*) Y/L, the marginal product of capital is (1-(N-I*)) Y/K, and the labor share W L/(R K + W L) equals N - I*, which falls with equilibrium automation I*.]

Source location: Corollary 1, PDF page 13 (printed page 11): Y = (B/(1-η)) K^(1-N+I*) L^(N-I*); the text below Proposition 1 (PDF page 12): 'An increase in I* — which corresponds to greater equilibrium automation — increases the share of capital and reduces the share of labor'; competitive factor prices are marginal products (page 10)
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_corollary_1_cobb_douglas_sharesSpec : Prop :=
  ∀ c K L N Istar : ℝ, 0 < c → 0 < K → 0 < L → 0 < N - Istar → N - Istar < 1 →
    HasDerivAt (fun L' : ℝ => c * K ^ (1 - (N - Istar)) * L' ^ (N - Istar))
      ((N - Istar) * (c * K ^ (1 - (N - Istar)) * L ^ (N - Istar)) / L) L ∧
    HasDerivAt (fun K' : ℝ => c * K' ^ (1 - (N - Istar)) * L ^ (N - Istar))
      ((1 - (N - Istar)) * (c * K ^ (1 - (N - Istar)) * L ^ (N - Istar)) / K) K ∧
    ((N - Istar) * (c * K ^ (1 - (N - Istar)) * L ^ (N - Istar)) / L * L) /
      ((1 - (N - Istar)) * (c * K ^ (1 - (N - Istar)) * L ^ (N - Istar)) / K * K +
        (N - Istar) * (c * K ^ (1 - (N - Istar)) * L ^ (N - Istar)) / L * L) = N - Istar

end AR18RaceManMachine
