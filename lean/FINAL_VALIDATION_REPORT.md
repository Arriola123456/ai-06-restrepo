# Final Validation Report: Acemoglu and Restrepo (2018), The Race between Man and Machine
Updated: 2026-09-24

## 1. Human Verdict
Partially formalized. The sign and threshold content of the static model
(Section 2 of NBER w22252, revised June 2017) is checked with closed Lean
proofs: the cost threshold of equations (5)-(6) (with $\gamma$ strictly
increasing and $W/R = \gamma(\tilde I)$, capital is cheaper below $\tilde I$
and labor above it) and the characterisation of $I^* = \min\{I, \tilde I\}$;
the positivity of $\Lambda_I$ and $\Lambda_N$; Proposition 2's signs in the
technology-constrained case (automation lowers $W/R$, new tasks and capital
raise it) and $\sigma_{free} > \hat\sigma$ in the cost-minimising case;
Proposition 3's productivity effect of automation is positive when
$W/\gamma(I^*) > R$ on both sides of $\hat\sigma = 1$, automation always raises
the rental rate, the wage rises iff the productivity effect exceeds the
displacement effect, and new tasks always raise the wage; and Corollary 1's
Cobb-Douglas output has marginal products $(N - I^*)Y/L$ and $(1 - N + I^*)Y/K$
with labor share $N - I^*$. The paper does not reach `formalized` for three
reasons. The equilibrium of Proposition 1 (existence, uniqueness, the relative
demand map (13)) and the differentiation of (13) behind Proposition 2 are not
modelled: the Specs take the displayed derivatives as hypotheses. The capital
threshold $\bar K$ of Proposition 3 is not derived in general, and the
extension shows that the printed direction of that sentence is reversed in the
Cobb-Douglas case. And the protocol's independent semantic audits were not
executed. The run was executed by Claude Code, not by the Codex configuration
named in the course issue.

## 2. Closeout Status
- Completion status: partially formalized
- One-sentence recap: ten of ten selected statements proved; the equilibrium
  map and the general $\bar K$ are declared boundaries; the Cobb-Douglas wage
  response is proved as an extension.

## 3. Source and Scope
- Paper: The Race between Man and Machine: Implications of Technology for
  Growth, Factor Shares, and Employment (Daron Acemoglu, Pascual Restrepo),
  AER 108(6), 2018.
- Source version: NBER Working Paper 22252, revised June 2017, 87 pp., SHA-256
  `441d0120…16b7` (the course PDF). Page locators are PDF pages (printed page
  = PDF page $-$ 2).
- Lean folder: `papers/AR18RaceManMachine`
- Human-facing theorem file: `papers/AR18RaceManMachine/PaperInterface.lean`
- Paper assumption file: `papers/AR18RaceManMachine/Assumptions.lean` (empty:
  every premise is a visible binder)
- DAG artifacts: `papers/AR18RaceManMachine/docs/DependencyDAG.tex`,
  `papers/AR18RaceManMachine/docs/DependencyDAG.pdf`
- Lean footprint: four paper modules; `lake build AR18RaceManMachine`
  completes with no errors.
- Scope: Section 2 (static model): equations (5)-(6), $I^*$, Corollary 1,
  Propositions 2 and 3. Out of scope: Proposition 1, Sections 3-5
  (balanced growth, endogenous technology, extensions), appendices.

## 4. Researcher Checked Results
With $\gamma$ strictly increasing, positive factor prices and
$W/R = \gamma(\tilde I)$, Lean checks that $R < W/\gamma(i)$ for $i < \tilde I$
and $W/\gamma(i) < R$ for $i > \tilde I$, and that $i < \min\{I, \tilde I\}$
iff both $i < I$ and $i < \tilde I$. With the integral
$J = \int_{I^*}^N \gamma^{\hat\sigma - 1}$ positive and $I^* > N - 1$,
$\Lambda_I$ and $\Lambda_N$ are positive; hence, in the technology-constrained
case, $-\Lambda_I/(\hat\sigma + \varepsilon_L) < 0$,
$\Lambda_N/(\hat\sigma + \varepsilon_L) > 0$ and
$(1 + \varepsilon_L)/(\hat\sigma + \varepsilon_L) > 0$ (Proposition 2), and
$\sigma_{free} = \hat\sigma + \Lambda_I/\varepsilon_\gamma > \hat\sigma$.

For Proposition 3, when $W/\gamma(I^*) > R > 0$ and $\hat\sigma \neq 1$, the
coefficient $((W/\gamma(I^*))^{1-\hat\sigma} - R^{1-\hat\sigma})/(1-\hat\sigma)$
is positive (for $\hat\sigma < 1$ the power is increasing, for $\hat\sigma > 1$
decreasing and the denominator negative). With the productivity effect
$P \ge 0$, $d\ln R = P + s_L\Lambda_I dI/(\hat\sigma + \varepsilon_L) > 0$;
$d\ln W = P - (1-s_L)\Lambda_I dI/(\hat\sigma + \varepsilon_L) > 0$ iff the
displacement term is below $P$; and with $P > 0$, $s_L < 1$,
$d\ln W = P + (1 - s_L)\Lambda_N dN/(\sigma_{free} + \varepsilon_L) > 0$.

For Corollary 1, with $Y = cK^{1-s}L^{s}$, $s = N - I^* \in (0,1)$, Lean checks
the two `HasDerivAt` statements giving $W = sY/L$ and $R = (1-s)Y/K$, and the
identity $WL/(RK + WL) = s$.

Extension (`MainTheorems.lean`): $\ln W = \ln c + \ln s + (1-s)\ln K +
(s-1)\ln L$ has derivative $1/s - \ln K + \ln L$ in $s$, so
$d\ln W/dI^* = \ln(K/L) - 1/(N - I^*)$, and this is positive iff
$K/L > e^{1/(N - I^*)}$.

## 5. Remaining Boundaries and Gaps
- Proposition 1 (existence and uniqueness of the static equilibrium, equation
  (13)) is not modelled; the derivatives of Proposition 2 are the paper's
  differentiation of (13), taken as displays.
- The threshold $\bar K$ of Proposition 3 is not derived in general. In the
  Cobb-Douglas case the extension gives it in closed form,
  $\bar K = L e^{1/(N-I^*)}$, with the wage rising for $K > \bar K$, which
  reverses the direction printed in the proposition (see Section 10).
- Proposition 3's productivity coefficient is stated for $\hat\sigma \neq 1$;
  the Cobb-Douglas limit $\ln(W/\gamma(I^*)) - \ln R$ is not formalized.
- The LLM/human semantic audit lanes were not run; `audit/` holds the
  scaffold stubs.
- Import deviation: `MainTheorems.lean` imports `Mathlib.Tactic`,
  `Mathlib.Data.Real.Basic` and `Mathlib.Analysis.SpecialFunctions.Pow.Deriv`
  instead of the scaffold's `import Mathlib`, and the scaffold's statement-spec
  validation ran under those imports instead of `import AppliedModelingLib`,
  because the library root was not built on this machine (`docs/RUN_LOG.md`).

## 6. Additional Assumptions Beyond Paper
None. Every hypothesis is a visible binder: positivity of factor prices,
elasticities and $\Lambda$ terms, $\gamma$ strictly increasing, $I^* > N - 1$,
$W/\gamma(I^*) > R$, $\hat\sigma \neq 1$, $0 < N - I^* < 1$.

## 7. Proof-Strategy Deviations
The paper differentiates the equilibrium map; the Lean rows take the displayed
derivatives and prove their signs and the threshold equivalence. Corollary 1
is taken as the Cobb-Douglas production function and its marginal products
are derived, rather than deriving the corollary from (12).

## 8. Proof Tricks Worth Reusing
- Two-sided `rpow` monotonicity: `Real.rpow_lt_rpow` for a positive exponent
  and `Real.rpow_lt_rpow_of_neg` for a negative one, then `div_pos` or
  `div_pos_of_neg_of_neg`.
- `Real.hasDerivAt_rpow_const` with `.const_mul`/`.mul_const` and
  `Real.rpow_sub_one` to turn $L^{s-1}$ into $L^s/L$ before `field_simp`.
- `Real.lt_log_iff_exp_lt` for threshold statements in logs.

## 9. Generalizations, Conjectures, and Extensions
- The Cobb-Douglas wage response and its threshold (Section 4 above).
- Conjecture (numerical, `analysis/task_model.py` in the course repository):
  for $\hat\sigma = 0.6$, $\varepsilon_L = 0.3$, $\gamma(i) = 0.3e^{3i}$, the
  wage effect of automation is negative throughout the Assumption-3 window
  and positive only beyond a $\bar K > \underline K$.

## 10. Mathematical Typos or Other Fixes Suggested in the Source Paper
Proposition 3 (PDF page 15): "there exists $\bar K > \underline K$ such that
an increase in $I$ increases the equilibrium wage when $K < \bar K$ and reduces
it when $K > \bar K$." Under Assumption 3 ($K < \underline K < \bar K$) this
would make automation always raise the wage, contradicting the same
proposition's "may reduce the equilibrium wage". In the Cobb-Douglas case the
extension proves $d\ln W/dI^* = \ln(K/L) - 1/(N - I^*)$, so the wage rises for
$K > \bar K = Le^{1/(N-I^*)}$ and falls below it; the numerics show the same
for $\hat\sigma \neq 1$. The two inequalities appear to be reversed; the
economic content ("the productivity gains depend on the cost savings
$W/\gamma(I^*) - R$", page 16) is consistent with the corrected direction.

## 11. Paper Issues or Caveats
See Section 10.

## 12. Detailed Formalization Evidence
- `lake build AR18RaceManMachine`: Build completed successfully (3313 jobs;
  the four paper modules in 21 s, 7.2 s, 2.4 s and 3.2 s).
- `python3 scripts/paper_contribution.py check AR18RaceManMachine --fast`:
  exit code 0 (`lake build +AR18RaceManMachine.PaperInterface` and
  `git diff --check` passed); see `docs/CHECK_FAST_OUTPUT.txt`.
- No declaration in the paper folder uses `sorry`, `axiom` or `unsafe`.
- `Assumptions.lean` declares nothing.

## 13. Paper Assumption Provenance
| Assumption declaration | Lean declaration | Source location / statement | Assumption validators | Comments |
| --- | --- | --- | --- | --- |
| None | `none` | Assumption 1 ($\gamma$ strictly increasing, page 9) enters as the binder `StrictMono γ`; Assumption 3 ($W/\gamma(I^*) > R$ in the constrained case, page 15) as `R < Wg` | None | No axiom-like premise. |

## 14. Displayed Formula Provenance
| Paper formula / subclaim | Lean declaration | Provenance | Validators | Comments |
| --- | --- | --- | --- | --- |
| (5)-(6), page 10 | `paper_cost_thresholdSpec` | derived in Lean | Lean build | strict monotonicity of $\gamma$ |
| $I^* = \min\{I,\tilde I\}$, page 10 | `paper_equilibrium_thresholdSpec` | derived in Lean | Lean build | `lt_min_iff`, `min_lt_iff` |
| $\Lambda_I, \Lambda_N$, page 13 | `paper_prop2_lambda_positiveSpec` | derived in Lean | Lean build | integral as a positive real |
| Prop. 2 derivatives, page 13 | `paper_prop2_signs_constrainedSpec` | signs derived; derivatives are displays | Lean build | boundary: (13) |
| Prop. 3 productivity term, page 15 | `paper_prop3_productivity_effect_positiveSpec` | derived in Lean | Lean build | $\hat\sigma \neq 1$ |
| Corollary 1, page 13 | `paper_corollary_1_cobb_douglas_sharesSpec` | derived in Lean | Lean build | marginal products as `HasDerivAt` |

## 15. Library Lift Pass
- Reusable library extraction candidates: the two-sided `rpow` sign lemma.
- Library certificate/source-boundary audit: not run; no certificate-taking
  library API is used.
- Paper-local hidden-premise audit: not run; all premises are visible binders.

## 16. DAG Audit
- Rendered artifact: `docs/DependencyDAG.pdf` rendered from
  `docs/DependencyDAG.tex`.
- Topology: the model feeds the cost threshold and the $\Lambda$ terms; the
  equilibrium map is a declared boundary feeding Proposition 2's signs and
  Corollary 1; the cost threshold feeds the productivity effect; Proposition
  2's signs and the productivity effect feed the wage decomposition and the
  new-tasks row; Corollary 1 feeds the extension.
- Layout: checked visually.

## 17. Validation Checks
- Targeted Lean build: passed.
- Statement precheck / assumption precheck / repository audit / LLM audits:
  not run (see Section 5).

## 18. Paper Definitions Checked
- Unit costs and the threshold $\tilde I$ (equations (5)-(6)); $I^*$.
- $\Lambda_I$, $\Lambda_N$ (Proposition 2).
- The Cobb-Douglas output of Corollary 1 and its factor shares.

## 19. Named Theorem Statements Checked
### Proposition 2 (comparative statics)
**Paper statement.** Constrained case: $d\ln\omega/dI = -\Lambda_I/(\hat\sigma+\varepsilon_L) < 0$,
$d\ln\omega/dN = \Lambda_N/(\hat\sigma+\varepsilon_L) > 0$,
$d\ln(W/R)/d\ln K = (1+\varepsilon_L)/(\hat\sigma+\varepsilon_L) > 0$; cost-minimising
case: $\sigma_{free} = \hat\sigma + \Lambda_I/\varepsilon_\gamma > \hat\sigma$.

**Lean interface statement.** `paper_prop2_lambda_positiveSpec`,
`paper_prop2_signs_constrainedSpec`, `paper_prop2_sigma_freeSpec`.

**Status.** formalized for the signs; the derivatives are displays (boundary).

### Proposition 3 (impact of technology on productivity, wages, factor prices)
**Paper statement.** Constrained case: productivity effect positive; $d\ln W$ and
$d\ln R$ decompositions; a higher $I$ always raises $R$ and may reduce $W$; new
tasks always raise $W$.

**Lean interface statement.** `paper_prop3_productivity_effect_positiveSpec`,
`paper_prop3_rental_rate_risesSpec`, `paper_prop3_wage_decompositionSpec`,
`paper_prop3_new_tasks_raise_wageSpec`.

**Status.** formalized in algebraic form; the $\bar K$ sentence is not
formalized and its printed direction is disputed (Section 10).

### Corollary 1
**Paper statement.** $Y = \frac{B}{1-\eta}K^{1-N+I^*}L^{N-I^*}$ when $\sigma = \zeta = 1$, $\gamma \equiv 1$.

**Lean interface statement.** `paper_corollary_1_cobb_douglas_sharesSpec`.

**Status.** formalized as the production function's marginal products and
labor share; the derivation from (12) is a boundary.

## 20. Paper-Facing Statement Validator Ledger
| Lean declaration | Source item | Status |
| --- | --- | --- |
| `paper_cost_thresholdSpec` | equations (5)-(6), page 10 | proved |
| `paper_equilibrium_thresholdSpec` | $I^* = \min\{I,\tilde I\}$, page 10 | proved |
| `paper_prop2_lambda_positiveSpec` | Proposition 2, page 13 | proved |
| `paper_prop2_signs_constrainedSpec` | Proposition 2, page 13 | proved |
| `paper_prop2_sigma_freeSpec` | Proposition 2, page 13 | proved |
| `paper_prop3_productivity_effect_positiveSpec` | Proposition 3, page 15 | proved |
| `paper_prop3_rental_rate_risesSpec` | Proposition 3, page 15 | proved |
| `paper_prop3_wage_decompositionSpec` | Proposition 3, page 15 | proved |
| `paper_prop3_new_tasks_raise_wageSpec` | Proposition 3, page 15 | proved |
| `paper_corollary_1_cobb_douglas_sharesSpec` | Corollary 1, page 13 | proved |

## 21. Source-Coverage Audit Ledger
Not run. Named results not covered: Proposition 1, Propositions 4-9, Lemmas
of the appendices, the $\bar K$ existence claim of Proposition 3.
