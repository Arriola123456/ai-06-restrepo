"""Acemoglu & Restrepo (2018), static task model (Section 2 of NBER w22252, rev. June 2017).

Numerics for the static equilibrium under Assumption 2 (homothetic case), with
  gamma(i) = g0 * exp(a i)        comparative-advantage schedule (Assumption 1: increasing)
  L^s(omega) = L0 * omega^epsL    labor supply as a function of omega = W/(R K)   (eq. 11)
  sigma_hat                       elasticity between capital and labor in (12)
Tasks i in [N-1, N]; tasks i <= I are technologically automated; I* = min{I, I_tilde}
with W/R = gamma(I_tilde) (eq. 6); Assumption 3 (K < K_lower) is R > W/gamma(N).

Equilibrium (eq. 13): ln omega + (1/sigma_hat) ln L^s(omega)
                      = (1/sigma_hat - 1) ln K + (1/sigma_hat) ln( Gamma(I*) / (I* - N + 1) )
where Gamma(I*) = int_{I*}^N gamma(i)^(sigma_hat - 1) di.  Then W/R = omega K, factor prices
follow from the price index (10), and Y = R K + W L (zero profits).

Checks: the total derivative d ln W / dI computed numerically equals Proposition 3's formula
d ln Y|_{K,L} - (1 - s_L) Lambda_I/(sigma_hat + eps_L) to 4 decimals (see results.txt).

Outputs (analysis/figures/*.pdf, analysis/results.json):
  * automation_sweep.pdf : W, s_L, L against I for a capital stock inside the Assumption-3 window
                           and one beyond K-bar (Propositions 2-3)
  * wage_response_vs_K.pdf : d ln W / dI against K, with K_lower (Assumption 3) and K-bar marked
  * decomposition.pdf : productivity effect vs displacement effect at the two capital stocks
  * new_tasks_sweep.pdf : W and s_L against N (reinstatement)
  * the Cobb-Douglas corollary: closed forms, d ln W / d I* = ln(K/L) - 1/(N - I*)
"""
from __future__ import annotations

import json
import os

import numpy as np
from scipy.optimize import brentq

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
FIG = os.path.join(HERE, "figures")
os.makedirs(FIG, exist_ok=True)


class StaticModel:
    def __init__(self, N=1.0, a=3.0, sigma_hat=0.6, epsL=0.3, L0=1.0, B=1.0, g0=0.3):
        self.N, self.a, self.sh, self.epsL, self.L0, self.B, self.g0 = N, a, sigma_hat, epsL, L0, B, g0

    def gamma(self, i):
        return self.g0 * np.exp(self.a * i)

    def Gamma(self, Istar):
        """int_{I*}^N gamma(i)^(sigma_hat-1) di."""
        e = self.a * (self.sh - 1.0)
        c = self.g0 ** (self.sh - 1.0)
        if abs(e) < 1e-12:
            return c * (self.N - Istar)
        return c * (np.exp(e * self.N) - np.exp(e * Istar)) / e

    def Ls(self, omega):
        return self.L0 * omega ** self.epsL

    def omega_demand(self, Istar, K):
        rhs = (1 / self.sh - 1) * np.log(K) + (1 / self.sh) * np.log(self.Gamma(Istar) / (Istar - self.N + 1))
        f = lambda lw: lw + (1 / self.sh) * np.log(self.Ls(np.exp(lw))) - rhs
        return np.exp(brentq(f, -40, 40))

    def solve(self, I, K):
        omega = self.omega_demand(I, K)
        WR = omega * K                         # W/R = omega K  (omega = W/(RK), eq. 11)
        if WR >= self.gamma(I):                # I_tilde >= I: technology-constrained, I* = I
            Istar, constrained = I, True
        else:                                  # cost-minimising: I* = I_tilde solves W/R = gamma(I*)
            g = lambda Is: self.omega_demand(Is, K) * K - self.gamma(Is)
            Istar = brentq(g, self.N - 1 + 1e-9, I)
            omega = self.omega_demand(Istar, K)
            WR = omega * K
            constrained = False
        L = self.Ls(omega)
        R = (self.B ** (1 - self.sh) / ((Istar - self.N + 1) + WR ** (1 - self.sh) * self.Gamma(Istar))) ** (1 / (1 - self.sh))
        W = WR * R
        Y = R * K + W * L
        return dict(I=I, K=K, Istar=Istar, Itilde=np.log(WR / self.g0) / self.a, omega=omega, W=W, R=R, L=L, Y=Y,
                    sL=W * L / Y, constrained=constrained, assumption3=bool(WR < self.gamma(self.N)))

    def dlnW_dI(self, I, K, h=1e-3):
        e1, e2 = self.solve(I - h, K), self.solve(I + h, K)
        return (np.log(e2["W"]) - np.log(e1["W"])) / (2 * h)

    def decomposition(self, I, K):
        """Proposition 3 (constrained case): productivity effect and displacement effect per unit dI."""
        e = self.solve(I, K)
        prod = self.B ** (self.sh - 1) / (1 - self.sh) * ((e["W"] / self.gamma(e["Istar"])) ** (1 - self.sh) - e["R"] ** (1 - self.sh))
        LamI = self.gamma(e["Istar"]) ** (self.sh - 1) / self.Gamma(e["Istar"]) + 1 / (e["Istar"] - self.N + 1)
        disp = (1 - e["sL"]) * LamI / (self.sh + self.epsL)
        return dict(productivity=prod, displacement=disp, formula=prod - disp, numerical=self.dlnW_dI(I, K),
                    W_over_gamma=e["W"] / self.gamma(e["Istar"]), R=e["R"], sL=e["sL"], LambdaI=LamI,
                    constrained=e["constrained"], assumption3=e["assumption3"])


m = StaticModel()
I0 = 0.5
results = {"model": {"N": m.N, "gamma": f"{m.g0} exp({m.a} i)", "sigma_hat": m.sh, "epsL": m.epsL, "I0": I0}}

# --- the capital window of the main text at I0: constrained (I_tilde > I) and Assumption 3 (W/R < gamma(N))
lnWR = lambda lk: np.log(m.omega_demand(I0, np.exp(lk)) * np.exp(lk))
K_constr = np.exp(brentq(lambda lk: lnWR(lk) - np.log(m.gamma(I0)), -15, 15))   # below: cost-minimising case
K_lower = np.exp(brentq(lambda lk: lnWR(lk) - np.log(m.gamma(m.N)), -15, 15))   # Assumption 3: K < K_lower
# K-bar: sign change of d ln W / dI in the constrained region
Ks = np.exp(np.linspace(np.log(K_constr * 1.02), np.log(K_lower * 300), 90))
d = np.array([m.dlnW_dI(I0, K) for K in Ks])
Kbar = None
for j in range(1, len(Ks)):
    if d[j - 1] < 0 <= d[j]:
        Kbar = float(brentq(lambda K: m.dlnW_dI(I0, K), Ks[j - 1], Ks[j]))
        break
results["capital_thresholds_at_I0"] = {"K_constrained_from": K_constr, "K_lower_assumption3": K_lower, "K_bar_wage_sign_change": Kbar,
                                        "dlnW_dI_at_K_lower": float(m.dlnW_dI(I0, K_lower * 0.999)),
                                        "all_negative_inside_assumption3": bool(np.all(d[Ks < K_lower] < 0))}
K_in = float(np.exp(0.5 * (np.log(K_constr) + np.log(K_lower))))   # inside the window
K_out = float(2.0 * Kbar) if Kbar else float(K_lower * 20)          # beyond K-bar

fig, ax = plt.subplots(figsize=(6.6, 4.1))
ax.axhline(0, color="k", lw=0.8)
ax.axvspan(K_constr, K_lower, color="C2", alpha=0.12, label="Assumption 3 window: $I^*=I<\\tilde I$ and $R>W/\\gamma(N)$")
ax.semilogx(Ks, d, lw=2.2, color="C0", label="$d\\ln W/dI$ at $I=0.5$ (equilibrium, numerical)")
ax.axvline(K_lower, color="C2", ls=":", lw=1)
ax.text(K_lower * 1.05, ax.get_ylim()[0] * 0.9, "$K_{A3}$", color="C2")
if Kbar:
    ax.axvline(Kbar, color="C3", ls=":", lw=1)
    ax.text(Kbar * 1.05, ax.get_ylim()[0] * 0.9, "$\\bar K$", color="C3")
ax.set_xlabel("capital stock $K$ (log scale)")
ax.set_ylabel("$d\\ln W/dI$")
ax.set_title("Automation lowers the wage for scarce capital, raises it beyond $\\bar K$ ($>K_{A3}$)")
ax.legend(frameon=False, fontsize=8, loc="upper left")
fig.tight_layout()
fig.savefig(os.path.join(FIG, "wage_response_vs_K.pdf"))
plt.close(fig)

# --- automation sweep at K_in (inside the window) and K_out (beyond K-bar)
Is = np.linspace(0.05, 0.95, 46)
fig, axs = plt.subplots(1, 3, figsize=(11.5, 3.6))
for K, col, lab in ((K_in, "C0", f"$K={K_in:.2f}$ (inside window)"), (K_out, "C3", f"$K={K_out:.1f}$ (beyond $\\bar K$)")):
    s = {k: np.array([m.solve(I, K)[k] for I in Is]) for k in ("W", "R", "L", "Y", "sL", "constrained", "assumption3")}
    axs[0].plot(Is, s["W"] / s["W"][0], color=col, lw=2, label=lab)
    axs[1].plot(Is, s["sL"], color=col, lw=2, label=lab)
    axs[2].plot(Is, s["L"] / s["L"][0], color=col, lw=2, label=lab)
    results[f"automation_sweep_K{K:.3f}"] = {"I": Is.tolist(), "W": s["W"].tolist(), "R": s["R"].tolist(), "sL": s["sL"].tolist(),
                                              "L": s["L"].tolist(), "Y": s["Y"].tolist(),
                                              "constrained_all": bool(np.all(s["constrained"])),
                                              "assumption3_all": bool(np.all(s["assumption3"]))}
axs[0].set_title("wage $W$ (normalised at $I=0.05$)")
axs[1].set_title("labor share $s_L$")
axs[2].set_title("employment $L$ (normalised)")
for ax in axs:
    ax.set_xlabel("automation technology $I$")
    ax.legend(frameon=False, fontsize=7)
fig.suptitle(f"Automation: $s_L$ and $L$ always fall; $W$ falls inside the window, rises beyond $\\bar K$  ($\\hat\\sigma$={m.sh}, $\\varepsilon_L$={m.epsL})", fontsize=10)
fig.tight_layout(rect=(0, 0, 1, 0.92))
fig.savefig(os.path.join(FIG, "automation_sweep.pdf"))
plt.close(fig)

# --- decomposition at I0 for the two capital stocks
dec = {f"{K:.3f}": m.decomposition(I0, K) for K in (K_in, K_out)}
results["decomposition_at_I0"] = dec
fig, ax = plt.subplots(figsize=(6.4, 4.0))
labels = [f"$K={K_in:.2f}$\n(inside window)", f"$K={K_out:.1f}$\n(beyond $\\bar K$)"]
x = np.arange(2)
p = [dec[f"{K:.3f}"]["productivity"] for K in (K_in, K_out)]
q = [-dec[f"{K:.3f}"]["displacement"] for K in (K_in, K_out)]
t = [dec[f"{K:.3f}"]["formula"] for K in (K_in, K_out)]
ax.bar(x - 0.25, p, 0.25, color="C2", label="productivity effect $d\\ln Y|_{K,L}$")
ax.bar(x, q, 0.25, color="C3", label="displacement $-(1-s_L)\\Lambda_I/(\\hat\\sigma+\\varepsilon_L)$")
ax.bar(x + 0.25, t, 0.25, color="C0", label="total $d\\ln W/dI$")
ax.axhline(0, color="k", lw=0.8)
ax.set_xticks(x)
ax.set_xticklabels(labels)
ax.set_title("Proposition 3: the two forces on the wage at $I=0.5$")
ax.legend(frameon=False, fontsize=8)
fig.tight_layout()
fig.savefig(os.path.join(FIG, "decomposition.pdf"))
plt.close(fig)

# --- new tasks sweep at K_in (reinstatement)
Ns = np.linspace(0.9, 1.4, 26)
sN = {k: [] for k in ("W", "sL", "L", "Y")}
for N in Ns:
    mm = StaticModel(N=N, a=m.a, sigma_hat=m.sh, epsL=m.epsL, g0=m.g0)
    e = mm.solve(I0, K_in)
    for k in sN:
        sN[k].append(float(e[k]))
results["new_tasks_sweep"] = {"N": Ns.tolist(), **sN, "K": K_in}
fig, axs = plt.subplots(1, 2, figsize=(8.6, 3.6))
axs[0].plot(Ns, np.array(sN["W"]) / sN["W"][0], lw=2, color="C2")
axs[0].set_title("wage $W$ (normalised)")
axs[1].plot(Ns, sN["sL"], lw=2, color="C2")
axs[1].set_title("labor share $s_L$")
for ax in axs:
    ax.set_xlabel(f"new tasks $N$ ($I=0.5$, $K={K_in:.2f}$)")
fig.suptitle("New tasks (reinstatement): wage and labor share always rise (Propositions 2-3)", fontsize=10)
fig.tight_layout(rect=(0, 0, 1, 0.92))
fig.savefig(os.path.join(FIG, "new_tasks_sweep.pdf"))
plt.close(fig)

# --- Cobb-Douglas corollary: Y = c K^(1-s) L^s, s = N - I*
def cobb_douglas(K, L, s, c=1.0):
    Y = c * K ** (1 - s) * L ** s
    W, R = s * Y / L, (1 - s) * Y / K
    return Y, W, R, W * L / (R * K + W * L)

cd = {}
for K in (0.5, 2.0, 8.0):
    cd[str(K)] = [{"s=N-I*": s, "Y": Y, "W": W, "R": R, "sL": sL, "dlnW_dIstar": float(np.log(K) - 1 / s),
                   "K_lower(=L(1-s)/s)": (1 - s) / s, "K_bar(=L e^(1/s))": float(np.exp(1 / s))}
                  for s in (0.7, 0.6, 0.5, 0.4) for (Y, W, R, sL) in [cobb_douglas(K, 1.0, s)]]
results["cobb_douglas"] = {"note": "L = 1. d ln W / d I* = ln(K/L) - 1/(N-I*): positive iff K/L > e^(1/(N-I*)) = K_bar; Assumption 3 is K < K_lower = L(1-s)/s < K_bar",
                           "rows": cd}

with open(os.path.join(HERE, "results.json"), "w", encoding="utf-8") as f:
    json.dump(results, f, indent=2, default=float)

lines = [f"model: N={m.N}, gamma={m.g0} exp({m.a} i), sigma_hat={m.sh}, epsL={m.epsL}, I0={I0}",
         f"capital thresholds at I0: constrained from K={K_constr:.4f}; Assumption 3 up to K_lower={K_lower:.4f}; wage sign change K_bar={Kbar}; all negative inside window: {results['capital_thresholds_at_I0']['all_negative_inside_assumption3']}"]
for K in (K_in, K_out):
    s = results[f"automation_sweep_K{K:.3f}"]; dd = dec[f"{K:.3f}"]
    lines.append(f"K={K:.3f}: W {s['W'][0]:.4f}->{s['W'][-1]:.4f}, sL {s['sL'][0]:.4f}->{s['sL'][-1]:.4f}, L {s['L'][0]:.4f}->{s['L'][-1]:.4f}; constrained all {s['constrained_all']}, Assumption3 all {s['assumption3_all']}")
    lines.append(f"   decomposition at I0: productivity {dd['productivity']:.4f} - displacement {dd['displacement']:.4f} = {dd['formula']:.4f}; numerical {dd['numerical']:.4f}; W/gamma(I*)={dd['W_over_gamma']:.4f} R={dd['R']:.4f} sL={dd['sL']:.4f}")
lines.append(f"new tasks at K_in: W {sN['W'][0]:.4f}->{sN['W'][-1]:.4f}, sL {sN['sL'][0]:.4f}->{sN['sL'][-1]:.4f}")
for K, rows in cd.items():
    lines.append(f"CD K={K}: " + "; ".join(f"s={r['s=N-I*']}: dlnW/dI*={r['dlnW_dIstar']:.3f} (K_lower {r['K_lower(=L(1-s)/s)']:.2f}, K_bar {r['K_bar(=L e^(1/s))']:.2f})" for r in rows))
with open(os.path.join(HERE, "results.txt"), "w", encoding="utf-8") as f:
    f.write("\n".join(lines) + "\n")
print("\n".join(lines))
