# Run log for `papers/AR18RaceManMachine` (student run, 2026-09-24)

This note records how this paper folder was produced.

## Agent and tools

**Claude Code (Claude Fable 5.1, Anthropic)**, driven by the student from
Windows, in a WSL2 Ubuntu 26.04 clone of `nikhgarg/EconCSLib` — now
**AppliedModelingLib** — at commit `2db7d108` (2026-09-15); Lean `v4.30.0-rc2`,
Lake 5.0.0. **Not Codex.** The course issue for Repository 6 asks for
`gpt-5.6-sol` with reasoning effort `xhigh`; the student decided, as in
Repository 5, not to spend those tokens and asked Claude Code to execute the
same AppliedModelingLib workflow on the student's own clone, with the deadline
four hours away. The student's prompts are reproduced in the course
repository's `prompts.md`.

Steps, in order (all on 2026-09-24, between 18:00 and 19:00 local time):

1. Pinned the source: NBER Working Paper 22252 as revised in June 2017
   (87 pp., the course PDF; `~/econcslib-review/AR18RaceManMachine/paper.pdf`,
   SHA-256 `441d01202afd56ef8002fc24ffc2beb51191741c0b5accb11d2534620dd616b7`).
   Read Section 2 (static model) in full; rendered pages 10, 13 and 15 to
   check the bars on `K` in Assumption 3 and Proposition 3.
2. `python3 scripts/paper_contribution.py init-spec paper.pdf --version "NBER
   Working Paper 22252, revised June 2017 (published as AER 108(6), 2018,
   1488-1542)"` and filled the statement spec with 10 targets (page-level
   locators, literal source statements, transparent Lean propositions over
   the primitives), first checked in a scratch file with `lake env lean` under
   `import Mathlib.Tactic`, `Mathlib.Data.Real.Basic` and
   `Mathlib.Analysis.SpecialFunctions.Pow.Deriv`.
3. `python3 scripts/paper_contribution.py new <NBER PDF URL> --folder
   AR18RaceManMachine --title "The Race between Man and Machine: ..." --authors
   "Daron Acemoglu and Pascual Restrepo" --version "..." --official-url
   https://www.nber.org/papers/w22252 --statement-spec ...` (exit 0; the
   scaffold Lean-validated every Spec with its `#assert_scaffold_spec` check).
   **Deviation, stated exactly.** The library root `AppliedModelingLib.olean`
   does not exist on this machine: the rebuild started for Repository 5 never
   finished (about 300 of the library's own modules were still pending after
   12 hours, disk-bound: 5.6 GB of Mathlib `.olean` files against a 4-5 GB
   WSL page cache). The scaffold's validation hard-codes `import
   AppliedModelingLib`; for this one run the line `validation_import = "import
   AppliedModelingLib\n\n" ...` in `scripts/new_paper.py` was changed to the
   three Mathlib imports above, `new` was run, and the script was restored with
   `git checkout` (the clone shows no diff). Also needed: `PYTHONPATH=<clone
   root>` because `new_paper.py` imports `scripts.formalization_protocol`.
4. Wrote the 10 proof endpoints in `ProofInterface.lean` and the Cobb-Douglas
   extension (two theorems) in `MainTheorems.lean`. The scaffold-generated
   `MainTheorems.lean` opens with `import Mathlib`; the installed file imports
   the three Mathlib modules above instead (loading all of Mathlib per module
   is as slow as the library root on this machine); the reason is stated in
   the file's header.
5. `lake build AR18RaceManMachine`: Build completed successfully (3313 jobs;
   the four paper modules in 21 s, 7.2 s, 2.4 s, 3.2 s).
   `python3 scripts/paper_contribution.py check AR18RaceManMachine --fast`:
   exit code 0. Both recorded in `docs/CHECK_FAST_OUTPUT.txt`.
6. Set `status.json` to `partially formalized`; regenerated `README.md` with
   `sync_paper_status.py --paper AR18RaceManMachine`; wrote
   `FINAL_VALIDATION_REPORT.md`, `docs/FORMALIZATION_PLAN.md`,
   `docs/DependencyDAG.tex` (rendered with MiKTeX on Windows) and this file.

What Lean verifies and what it does not. The ten Specs are the sign and
threshold content of the static model once the paper's displayed formulas are
taken as hypotheses: the cost threshold of equation (6) and `I* = min{I, Ĩ}`,
the positivity of `Λ_I`, `Λ_N`, the signs of Proposition 2 in both cases,
`σ_free > σ̂`, the positivity of the productivity effect of Proposition 3 for
`σ̂ ≠ 1`, the rental-rate and new-tasks sign results, the wage decomposition as
an equivalence, and Corollary 1's marginal products and labor share `N - I*`
as real derivatives of `c K^(1-s) L^s`. Not derived: the equilibrium of
Proposition 1 (existence, uniqueness, equation (13)), the derivatives of
Proposition 2 themselves (they are the paper's differentiation of (13), taken
as displays), the existence of the capital threshold `K̄` of Proposition 3,
and everything from Section 3 on (balanced growth, endogenous technology).

Iteration record (errors seen and fixed): one, in the extension —
`rw [← Real.log_exp]` rewrote the inner `exp` as well; replaced by
`Real.lt_log_iff_exp_lt`. Three unused hypotheses were dropped from the
extension's derivative lemma. Everything else compiled at the first pass.

The audit sidecars under `audit/` are the scaffold-generated stubs; the
LLM-as-judge lanes that populate them were not run.
