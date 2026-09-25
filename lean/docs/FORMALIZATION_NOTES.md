# Formalization Notes

This file preserves the previous hand-written paper-folder README content.
The paper-folder `README.md` is now a generated status overview.

# The Race between Man and Machine: Implications of Technology for Growth, Factor Shares, and Employment

## Source Version

- Paper: *The Race between Man and Machine: Implications of Technology for Growth, Factor Shares, and Employment*
- Authors: Daron Acemoglu and Pascual Restrepo
- Version formalized: NBER Working Paper 22252, revised June 2017 (published as AER 108(6), 2018, 1488-1542)
- Official URL: https://www.nber.org/papers/w22252
- Public PDF: https://www.nber.org/system/files/working_papers/w22252/w22252.pdf

Without a statement spec, a downloaded PDF is cached as `source.pdf` and ignored
by Git. A statement spec's SHA-256-verified source bytes are copied to a stable
paper-local `source-audited.*` path recorded in `audit/paper_statement_map.json`.
These artifacts are ignored by default. Unignore one only after an explicit
redistribution-rights review; machines without the private bytes must leave the
source-evidence gate unresolved rather than accepting the digest alone.
The extracted text cache is `source.txt` when `pdftotext` succeeds, and is also
ignored by Git in public workspaces unless redistribution rights have been
checked separately.

## Paper-Facing Ledger

- Implementation theorem file: `AR18RaceManMachine/MainTheorems.lean`
- Source-semantic interface: `AR18RaceManMachine/PaperInterface.lean`
- Proof-endpoint interface: `AR18RaceManMachine/ProofInterface.lean`
- Machine-readable status source: `AR18RaceManMachine/status.json`
- Private outside-Lean proof plan: `AR18RaceManMachine/docs/FORMALIZATION_PLAN.md`
- Final validation report: `AR18RaceManMachine/FINAL_VALIDATION_REPORT.md`
- Dependency DAG: `AR18RaceManMachine/docs/DependencyDAG.tex`
- Rendered DAG: `AR18RaceManMachine/docs/DependencyDAG.pdf`
- LLM/source audit sidecars: `AR18RaceManMachine/audit/*.json`

`PaperInterface.lean` should be readable on its own: expose actual source
definitions/models and one transparent statement specification for each
selected source claim. Put each distinct theorem/lemma proof endpoint in
`ProofInterface.lean`, with a short closed proof that calls into
`MainTheorems.lean`. Do not duplicate the proof endpoint in the semantic
interface. Do not mark a row `formalized` unless the endpoint is closed and the
remaining assumptions cell is `None`.
Keep the dashboard surface curated but complete for source-labelled formal
material: definitions, formulas, propositions, theorems/corollaries, named
claims, and main-text lemmas that a reviewer or LLM-as-judge should inspect.
Do not omit source-visible named material merely to keep the dashboard compact.
Inventory every named appendix theorem, corollary, lemma, and definition under
the paper's single `closeout_review_policy`. The prospective default gives all
named theory an initial source-to-Lean review and repeats terminal adversarial
review for main-text material plus any explicitly promoted appendix item that
governs it. Record one complete content-pinned `source_region_partition`; do not
infer a tier from a Lean name, helper name, or proof location. Catalog
unnumbered prose assertions separately. They are claim-bearing but are not
independent theorem targets under named-theory scope unless the chosen policy
explicitly selects all prose.

Use the controlled status vocabulary from `../../docs/STATUS.md`. Public-facing
rows should use `partially formalized` for results that still depend on an
external theorem, certificate, or proof boundary, and should name that boundary
in the final column rather than using `conditional` as a separate status label.
Keep theorem/status content synchronized with the current Lean graph before
marking a row `formalized`. The planner creates the final Dependency DAG later,
from that stable graph. Keep `status.json` as the source of truth for review
rows, artifact paths, and the paper's top-level public status.

## Current Workflow

1. Byte-pin the exact source version and complete the source-only inventory,
   formula sanity pass, scope decisions, shared-library search, and
   `docs/FORMALIZATION_WORKING_MEMO.md`.
2. Put actual source models/definitions and one complete transparent
   `<name>Spec : Prop` per selected source claim in `PaperInterface.lean`.
   Put its distinct theorem/lemma endpoint in `ProofInterface.lean`; use
   `by sorry` only as a temporary private proof body.
3. Run the one non-certifying architecture pre-pass, repair role confusion or
   hidden result packages, and materialize the reviewed source map from
   `audit/v11_source_map_preparation_config.json`.
4. Prove the fixed Specs with targeted Lean builds. Record possible source
   clarifications, genuine additional assumptions, and proof deviations in the
   working memo; it is a lead log, not evidence.
5. Begin or resume audit and closeout with
   `python3 scripts/closeout_reuse_plan.py --paper AR18RaceManMachine` and execute only
   its `next_action`.

The current semantic judge compares the ordered byte-pinned source-anchor
bundle directly with the fully expanded transparent Spec emitted by Lean. A
Lean-to-TeX translation, curator paraphrase, theorem name, wrapper theorem,
source-map summary, or code location is never semantic evidence. The same
standard applies to material paper-local and reusable-library prerequisites;
Lean's graph owns recursive declarations, premises, proof routes, instances,
and axiom closure.

Do not generate legacy `lean_to_tex_llm.json`,
`statement_match_llm.json`, `review_surface_llm.json`,
`paper_coverage_llm.json`, `source_record_audit.json`, or
`source_record_match_llm.json` for this current-protocol paper. The planner
schedules current graph acquisition, semantic-review deltas, complete
tracked-module elaboration, theorem realization, final holistic source review,
terminal report/DAG/status work, and the one issuer-protected strict
transaction.

The dashboard and PDF packet are optional human-review presentations generated
from the current graph after the source map and interfaces are stable. Human
annotations may not be fabricated or auto-closed, but missing annotations do
not block Lean closeout.

## Theorem Status

| Paper item | Lean declaration | Status | File | Remaining assumptions / notes |
|---|---|---|---|---|
| Equations (5)-(6): unit costs and the cost-minimising threshold Ĩ (Section 2.2) (Section 2.2, PDF page 10 (printed page 8): equation (5) p(i) = min{R, W/γ(i)}^(1-η) for i ≤ I, equation (6) W/R = γ(Ĩ), and the sentence 'For all tasks i < Ĩ, we have R < W/γ(i)'; Assumption 1 (γ strictly increasing) on PDF page 9) | `paper_cost_thresholdSpec` -> `paper_cost_threshold` | statement specification + proof stub | `PaperInterface.lean` | The transparent `...Spec : Prop` is the statement-audit target; the proof body is `by sorry`; raw-source-to-expanded-Spec judgment and premise provenance pending |
| The equilibrium threshold task I* = min{I, Ĩ} (Section 2.2) (Section 2.2, PDF page 10 (printed page 8): 'there exists a unique equilibrium threshold task I* = min{I, Ĩ} such that all tasks i < I* will be produced with capital, while all tasks i > I* will be produced with labor') | `paper_equilibrium_thresholdSpec` -> `paper_equilibrium_threshold` | statement specification + proof stub | `PaperInterface.lean` | The transparent `...Spec : Prop` is the statement-audit target; the proof body is `by sorry`; raw-source-to-expanded-Spec judgment and premise provenance pending |
| Proposition 2: the terms Λ_I and Λ_N are positive (Proposition 2, PDF page 13 (printed page 11): definitions Λ_I = γ(I*)^(σ̂-1)/∫_{I*}^N γ(i)^(σ̂-1) di + 1/(I*-N+1) and Λ_N = γ(N)^(σ̂-1)/∫_{I*}^N γ(i)^(σ̂-1) di + 1/(I*-N+1); tasks run over [N-1, N] (PDF page 8), so I* - N + 1 > 0) | `paper_prop2_lambda_positiveSpec` -> `paper_prop2_lambda_positive` | statement specification + proof stub | `PaperInterface.lean` | The transparent `...Spec : Prop` is the statement-audit target; the proof body is `by sorry`; raw-source-to-expanded-Spec judgment and premise provenance pending |
| Proposition 2 (technology-constrained case): signs of the comparative statics of W/R (Proposition 2, PDF page 13 (printed page 11), first bullet: d ln(W/R)/dI = d ln ω/dI = -Λ_I/(σ̂+ε_L) < 0, d ln(W/R)/dN = Λ_N/(σ̂+ε_L) > 0, d ln(W/R)/d ln K = (1+ε_L)/(σ̂+ε_L) > 0) | `paper_prop2_signs_constrainedSpec` -> `paper_prop2_signs_constrained` | statement specification + proof stub | `PaperInterface.lean` | The transparent `...Spec : Prop` is the statement-audit target; the proof body is `by sorry`; raw-source-to-expanded-Spec judgment and premise provenance pending |
| Proposition 2 (cost-minimising case): σ_free = σ̂ + Λ_I/ε_γ > σ̂ (Proposition 2, PDF page 13 (printed page 11), second bullet: 'where σ_free = σ̂ + (1/ε_γ) Λ_I > σ̂') | `paper_prop2_sigma_freeSpec` -> `paper_prop2_sigma_free` | statement specification + proof stub | `PaperInterface.lean` | The transparent `...Spec : Prop` is the statement-audit target; the proof body is `by sorry`; raw-source-to-expanded-Spec judgment and premise provenance pending |
| Proposition 3 (technology-constrained case): the productivity effect of automation is positive (Proposition 3, PDF page 15 (printed page 13), first bullet: W/γ(I*) > R > W/γ(N) and d ln Y|_{K,L} = B^(σ̂-1)/(1-σ̂) ((W/γ(I*))^(1-σ̂) - R^(1-σ̂)) dI + ... ; 'That is, both technologies increase productivity') | `paper_prop3_productivity_effect_positiveSpec` -> `paper_prop3_productivity_effect_positive` | statement specification + proof stub | `PaperInterface.lean` | The transparent `...Spec : Prop` is the statement-audit target; the proof body is `by sorry`; raw-source-to-expanded-Spec judgment and premise provenance pending |
| Proposition 3 (technology-constrained case): a higher I always increases the rental rate (Proposition 3, PDF page 15 (printed page 13): d ln R = d ln Y|_{K,L} - s_L (Λ_N dN/(σ̂+ε_L) - Λ_I dI/(σ̂+ε_L)); 'a higher I always increases the rental rate') | `paper_prop3_rental_rate_risesSpec` -> `paper_prop3_rental_rate_rises` | statement specification + proof stub | `PaperInterface.lean` | The transparent `...Spec : Prop` is the statement-audit target; the proof body is `by sorry`; raw-source-to-expanded-Spec judgment and premise provenance pending |
| Proposition 3 (technology-constrained case): the wage rises with automation iff the productivity effect exceeds the displacement effect (Proposition 3, PDF page 15 (printed page 13): d ln W = d ln Y|_{K,L} + (1-s_L)(Λ_N dN/(σ̂+ε_L) - Λ_I dI/(σ̂+ε_L)); the discussion on PDF pages 15-16 names the two terms the productivity effect and the displacement effect) | `paper_prop3_wage_decompositionSpec` -> `paper_prop3_wage_decomposition` | statement specification + proof stub | `PaperInterface.lean` | The transparent `...Spec : Prop` is the statement-audit target; the proof body is `by sorry`; raw-source-to-expanded-Spec judgment and premise provenance pending |
| Proposition 3 (cost-minimising case): new tasks always increase the equilibrium wage (Proposition 3, PDF page 15 (printed page 13), second bullet: d ln W = d ln Y|_{K,L} + (1-s_L) Λ_N dN/(σ_free+ε_L) with d ln Y|_{K,L} = B^(σ̂-1)/(1-σ̂)(R^(1-σ̂) - (W/γ(N))^(1-σ̂)) dN > 0 under R > W/γ(N); 'an increase in N (more new tasks) always increases the equilibrium wage') | `paper_prop3_new_tasks_raise_wageSpec` -> `paper_prop3_new_tasks_raise_wage` | statement specification + proof stub | `PaperInterface.lean` | The transparent `...Spec : Prop` is the statement-audit target; the proof body is `by sorry`; raw-source-to-expanded-Spec judgment and premise provenance pending |
| Corollary 1: the Cobb-Douglas case and its factor shares (Corollary 1, PDF page 13 (printed page 11): Y = (B/(1-η)) K^(1-N+I*) L^(N-I*); the text below Proposition 1 (PDF page 12): 'An increase in I* — which corresponds to greater equilibrium automation — increases the share of capital and reduces the share of labor'; competitive factor prices are marginal products (page 10)) | `paper_corollary_1_cobb_douglas_sharesSpec` -> `paper_corollary_1_cobb_douglas_shares` | statement specification + proof stub | `PaperInterface.lean` | The transparent `...Spec : Prop` is the statement-audit target; the proof body is `by sorry`; raw-source-to-expanded-Spec judgment and premise provenance pending |

## Intake Checklist

- [ ] Pin the exact source bytes and version.
- [ ] Complete the source-only selected-presentation and material-atom inventory.
- [ ] Complete the outside-Lean formula/dependency sanity pass and working memo.
- [ ] Search Mathlib, Cslib, Optlib, AppliedModelingLib, and relevant upstream
      Lean sources before introducing paper-local abstractions.
- [ ] Create actual source definitions/models and one transparent Spec per
      selected claim in `PaperInterface.lean`.
- [ ] Create each distinct proof endpoint in `ProofInterface.lean`.
- [ ] Run the architecture pre-pass and repair role confusion before freezing
      the source map and beginning expensive proof work.
- [ ] Keep final validation reports and Dependency DAGs absent until the
      planner schedules terminal closeout documents.

## Closeout Checklist

- [ ] Start with `python3 scripts/closeout_reuse_plan.py --paper AR18RaceManMachine` and
      execute only its current `next_action`.
- [ ] Resolve every raw-source-to-expanded-Spec, material-prerequisite,
      assumption, proof-route, axiom, realization, and source-coverage finding.
- [ ] Let the complete tracked-module checkpoint use the Git-owned module
      inventory and one dependency-aware `lake --rehash build` transaction.
- [ ] When `complete_terminal_closeout_documents` is scheduled, write the
      final report and paper-facing DAG from the current graph, compile and
      visually inspect the DAG, update paper-local status, and replan.
- [ ] Complete the independent holistic source audit only after the final
      source/interface/proof surface is fixed. Record each required distinct
      reviewer and exact audit-document hash in
      `docs/FINAL_ADVERSARIAL_REVIEW_PANEL.json`; a later count increase keeps
      valid prior entries for unchanged comparison material and adds only the
      missing review.
- [ ] Run only the exact strict worker command printed for the frozen plan.
      Acceptance exists only when that in-process transaction publishes the
      accepted obligation graph.
- [ ] Generate the packet/dashboard from the accepted current graph for optional
      human review; never manufacture reviewer annotations.
