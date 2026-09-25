# Repository 6 — Acemoglu & Restrepo (2018)

*The Race between Man and Machine: Implications of Technology for Growth,
Factor Shares, and Employment.* American Economic Review 108(6), 1488–1542,
https://doi.org/10.1257/aer.20160696. **Version read and pinned:** the NBER
working paper 22252 **as revised in June 2017** (87 pp., SHA-256
`441d0120…16b7`), which is the course PDF; it carries the earlier title *The
Race Between Machine and Man*. Page numbers below are the PDF's (printed page
= PDF page − 2). The author's ChatGPT study session (Session 1 of
`prompts.md`) worked from the AER pagination (pp. 1493–1498); the equations
and propositions cited there carry the same numbers. `paper/README.md` has
the pointers.

> **Tools, stated up front.** The Lean folder, the numerics, the deck and the
> file structure were produced with **Claude Code (Claude Fable 5.1)** in the
> session recorded in `prompts.md`; the written analysis and the hand
> derivation are the author's, worked out with ChatGPT (also in `prompts.md`).
> The issue asks for the Lean run to be done with Codex `gpt-5.6-sol`/`xhigh`;
> with the deadline four hours away the author chose Claude Code, which ran the
> same AppliedModelingLib workflow on the author's own clone (`init-spec` →
> `new --statement-spec` → proofs → `lake build` → `check --fast`). The
> substitution and one import deviation are recorded in `lean/docs/RUN_LOG.md`
> and `lean/status.json`.

---

## What question the paper answers

Technology reaches the economy in two ways: **automation** (machines take over
tasks labor used to perform) and **new tasks** (labor gets things to do that
did not exist). What does each do to output, wages, the labor share and
employment, and what keeps the labor share from collapsing when both run at
once? This is the only paper of the term whose unit of analysis is the
aggregate economy rather than an individual agent: there is no one choosing an
AI tool, there is a task space and competitive firms choosing factors.

## The agent's problem (the economy's equilibrium)

A unit measure of tasks $i \in [N-1, N]$ produces the final good with
elasticity $\sigma$ (eq. 1). Tasks $i \le I$ are technologically automated:
capital and labor are perfect substitutes there, $k(i) + \gamma(i)l(i)$; tasks
$i > I$ need labor with productivity $\gamma(i)$. **Assumption 1:** $\gamma$ is
strictly increasing (labor's comparative advantage rises with the task index).
A representative household supplies labor along an increasing schedule
$L = L^s(\omega)$, $\omega = W/(RK)$ (eq. 11). **Assumption 2** (homothetic
demand: $\eta \to 0$ or $\zeta = 1$) makes $\hat\sigma = \sigma(1-\eta) + \zeta\eta$
the elasticity between capital and labor. **Assumption 3:** $K < \underline K$,
i.e. $R > W/\gamma(N)$, so new tasks are adopted at once.

Tasks are priced at minimum unit cost, $p(i) = \min\{R, W/\gamma(i)\}^{1-\eta}$
for $i \le I$ (eq. 5). Since $\gamma$ increases there is a unique $\tilde I$
with $W/R = \gamma(\tilde I)$ (eq. 6): capital is cheaper below it, labor above
it. The equilibrium threshold is

$$I^* = \min\{I, \tilde I\},$$

tasks below $I^*$ done by capital, above by labor. Two regimes:
**technology-constrained** ($I^* = I < \tilde I$: firms would automate more if
they could) and **cost-minimising** ($I^* = \tilde I < I$: the frontier is
slack). **Proposition 1** (p. 12): the equilibrium exists and is unique, and
output is a CES aggregate of $K$ and $L$ with shares that depend on $I^*$ and
$N$ (eq. 12); $\omega$ solves the relative demand (13). **Corollary 1:** with
$\sigma = \zeta = 1$ and $\gamma \equiv 1$, $Y = \tfrac{B}{1-\eta}K^{1-N+I^*}L^{N-I^*}$,
so the labor share *is* $N - I^*$.

## The main result, with all its conditions

Write $\varepsilon_L > 0$ for the labor-supply elasticity and
$\Lambda_I = \gamma(I^*)^{\hat\sigma-1}/\!\int_{I^*}^N\gamma^{\hat\sigma-1} + 1/(I^*-N+1) > 0$,
$\Lambda_N$ likewise with $\gamma(N)$.

**Proposition 2 (p. 13), comparative statics.** In the technology-constrained
case,

$$\frac{d\ln(W/R)}{dI} = -\frac{\Lambda_I}{\hat\sigma+\varepsilon_L} < 0,\qquad
\frac{d\ln(W/R)}{dN} = \frac{\Lambda_N}{\hat\sigma+\varepsilon_L} > 0,\qquad
\frac{d\ln(W/R)}{d\ln K} = \frac{1+\varepsilon_L}{\hat\sigma+\varepsilon_L} > 0;$$

in the cost-minimising case $d\ln(W/R)/dI = 0$ and
$d\ln(W/R)/dN = \Lambda_N/(\sigma_{free}+\varepsilon_L) > 0$ with
$\sigma_{free} = \hat\sigma + \Lambda_I/\varepsilon_\gamma > \hat\sigma$. In all cases
the labor share and employment move with $\omega$: automation is always
capital-biased, new tasks always labor-biased. *Displacement* against
*reinstatement*.

**Proposition 3 (p. 15), factor prices.** In the constrained case, with
$W/\gamma(I^*) > R > W/\gamma(N)$,

$$d\ln Y|_{K,L} = \frac{B^{\hat\sigma-1}}{1-\hat\sigma}\Big(\big(\tfrac{W}{\gamma(I^*)}\big)^{1-\hat\sigma} - R^{1-\hat\sigma}\Big)dI + \frac{B^{\hat\sigma-1}}{1-\hat\sigma}\Big(R^{1-\hat\sigma} - \big(\tfrac{W}{\gamma(N)}\big)^{1-\hat\sigma}\Big)dN > 0,$$

$$d\ln W = d\ln Y|_{K,L} + (1-s_L)\Big(\frac{\Lambda_N\,dN}{\hat\sigma+\varepsilon_L} - \frac{\Lambda_I\,dI}{\hat\sigma+\varepsilon_L}\Big),\qquad
d\ln R = d\ln Y|_{K,L} - s_L\Big(\frac{\Lambda_N\,dN}{\hat\sigma+\varepsilon_L} - \frac{\Lambda_I\,dI}{\hat\sigma+\varepsilon_L}\Big).$$

New tasks always raise the wage (and may lower $R$); automation always raises
$R$ and **raises the wage iff its productivity effect (the cost saving
$W/\gamma(I^*) - R$ on the marginal automated task) exceeds the displacement
effect $(1-s_L)\Lambda_I/(\hat\sigma+\varepsilon_L)$**. In the cost-minimising
case automation does nothing to factor prices.

Conditions the statements rest on, spelled out:

1. Assumptions 1–3 (increasing $\gamma$; homothetic demand; $K < \underline K$).
2. Static model: $K$ fixed; labor supply along (11); competitive firms, zero
   profits, the final good as numeraire.
3. $\hat\sigma \neq 1$ in the displayed productivity term (Cobb-Douglas is the
   limit); the case $I^* = I = \tilde I$ is left out (footnote 15).
4. The wage sign depends on $K$: see the trap below.

## This week's trap

**Does automation necessarily reduce wages and the labour share?** The labor
share and employment, yes, whenever technology binds (Proposition 2). The
wage, no: it falls or rises depending on which of two forces dominates, and
with a slack frontier it does not move at all. The condition for automation
to *raise* the wage is a large enough cost saving on the marginal task, which
requires abundant capital. In the Cobb-Douglas case this is a closed form
(derived by hand and proved in `lean/MainTheorems.lean`): with
$\ln W = \ln c + \ln s + (1-s)\ln K + (s-1)\ln L$, $s = N - I^*$,

$$\frac{d\ln W}{dI^*} = \ln\frac{K}{L} - \frac{1}{N-I^*} > 0 \iff \frac{K}{L} > e^{1/(N-I^*)} =: \frac{\bar K}{L}.$$

Since $\underline K/L = (1-s)/s < e^{1/s}$, inside Assumption 3 ($K < \underline K$)
the wage always falls with automation. **Proposition 3 prints the opposite
direction** ("there exists $\bar K > \underline K$ such that an increase in $I$
increases the equilibrium wage when $K < \bar K$ and reduces it when
$K > \bar K$", p. 15) — which would make automation always raise the wage under
Assumption 3, against the same proposition's "may reduce the equilibrium
wage". The Cobb-Douglas closed form, the numerics for $\hat\sigma = 0.6$
($\underline K = 4.73$, $\bar K = 5.73$ at $I = 0.5$, $d\ln W/dI < 0$ throughout
the window), and the paper's own intuition ("the productivity gains depend on
the cost savings $W/\gamma(I^*) - R$", p. 16) all point the same way: the two
inequalities appear reversed. I could not check the AER text.

## What is in this repository

| File | What it is |
|---|---|
| `README.md` | This page |
| `prompts.md` | Raw prompts and answers: the author's ChatGPT session and the Claude Code session |
| `hand/hand-derivation.pdf` | Hand derivation (one long page; `*-part1..3.png` are crops for the deck): the static model from scratch — the task CES and Assumption 1, the unit-cost minimisation behind $p(i)$ in (5), the threshold $W/R = \gamma(\tilde I)$ and $I^* = \min\{I, \tilde I\}$, the two regimes, Assumption 3, and the task demand (7) |
| `presentation.tex` / `.pdf` | The 20-minute deck: paper and problem, Propositions 2–3 with conditions, the trap, what I did, three Lean slides (with the required equation → Spec → proof → interpretation slide), where I did not believe the AI and the paper, backup |
| `lean/` | The AppliedModelingLib paper folder `papers/AR18RaceManMachine/` exactly as generated by the run: statement spec pinned to the June-2017 PDF, `PaperInterface.lean` with ten source-facing Specs, `ProofInterface.lean` with their proofs, `MainTheorems.lean` with the Cobb-Douglas extension, reports, DAG, audit stubs, `docs/RUN_LOG.md`, `docs/CHECK_FAST_OUTPUT.txt` |
| `analysis/` | `task_model.py`: the static equilibrium solved from eq. (13) with both regimes; the numerical $d\ln W/dI$ equals Proposition 3's formula to four decimals; the Assumption-3 window and $\bar K$; new tasks; the Cobb-Douglas closed forms. Figures in `analysis/figures/`, numbers in `results.json` |
| `paper/README.md` | Pointers to the versions of the article (PDFs not committed) |

## The Lean component in one paragraph

Ten source-facing statements of Section 2 of the June-2017 NBER paper were
pinned in an AppliedModelingLib statement spec, scaffolded with
`paper_contribution.py new` and proved with no `sorry`: the cost threshold of
equations (5)–(6) with $\gamma$ strictly increasing (capital cheaper below
$\tilde I$, labor above); $I^* = \min\{I,\tilde I\}$; $\Lambda_I, \Lambda_N > 0$;
Proposition 2's three signs in the constrained case and
$\sigma_{free} > \hat\sigma$; Proposition 3's productivity effect of automation
positive on both sides of $\hat\sigma = 1$, automation raising the rental rate,
the wage decomposition as an equivalence, new tasks raising the wage; and
Corollary 1's marginal products as real derivatives with labor share $N - I^*$.
`MainTheorems.lean` adds the Cobb-Douglas wage response and its sign
condition. Results: `lake build AR18RaceManMachine` — Build completed
successfully (3313 jobs); `check AR18RaceManMachine --fast` — exit code 0
(`lean/docs/CHECK_FAST_OUTPUT.txt`). Status **partially formalized**: the
equilibrium map (13) and the derivatives of Proposition 2 are taken as the
paper's displays, and the general $\bar K$ is not derived. One deviation,
stated exactly: the library root would not rebuild on this laptop (disk-bound,
12 hours last week), so the paper modules import three Mathlib modules instead
of the scaffold's `import Mathlib`, and the scaffold's statement-spec
validation ran under those imports instead of `import AppliedModelingLib`; no
library declaration is used by any Spec or proof (`lean/docs/RUN_LOG.md`).
