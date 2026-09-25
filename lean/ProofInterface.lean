import AR18RaceManMachine.PaperInterface

/-!
# Proof Interface: The Race between Man and Machine

This file contains exact-type proof endpoints for the transparent propositions
in `PaperInterface.lean`. It is not a human semantic-review surface: one source
claim is reviewed once, against its expanded `...Spec : Prop` declaration.
-/

namespace AR18RaceManMachine

/--
Lean proof endpoint for `paper_cost_thresholdSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_cost_threshold :
  paper_cost_thresholdSpec := by
  intro W R γ i It hW hR hmono hpos hIt
  have hγi : 0 < γ i := hpos i
  have hγIt : 0 < γ It := hpos It
  constructor
  · intro hi
    have h1 : γ i < γ It := hmono hi
    rw [hIt] at h1
    -- γ i < W / R  ⇒  R < W / γ i
    rw [lt_div_iff₀ hR] at h1
    rw [lt_div_iff₀ hγi]
    linarith [mul_comm R (γ i)]
  · intro hi
    have h1 : γ It < γ i := hmono hi
    rw [hIt] at h1
    rw [div_lt_iff₀ hR] at h1
    rw [div_lt_iff₀ hγi]
    linarith [mul_comm R (γ i)]

/--
Lean proof endpoint for `paper_equilibrium_thresholdSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_equilibrium_threshold :
  paper_equilibrium_thresholdSpec := by
  intro I It i
  exact ⟨lt_min_iff, min_lt_iff⟩

/--
Lean proof endpoint for `paper_prop2_lambda_positiveSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_prop2_lambda_positive :
  paper_prop2_lambda_positiveSpec := by
  intro γI γN J Istar N σh hγI hγN hJ hI
  have hden : 0 < Istar - N + 1 := by linarith
  have h2 : 0 < 1 / (Istar - N + 1) := one_div_pos.mpr hden
  constructor
  · have h1 : 0 < γI ^ (σh - 1) / J := div_pos (Real.rpow_pos_of_pos hγI _) hJ
    linarith
  · have h1 : 0 < γN ^ (σh - 1) / J := div_pos (Real.rpow_pos_of_pos hγN _) hJ
    linarith

/--
Lean proof endpoint for `paper_prop2_signs_constrainedSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_prop2_signs_constrained :
  paper_prop2_signs_constrainedSpec := by
  intro σh εL ΛI ΛN hσ hε hΛI hΛN
  have hsum : 0 < σh + εL := by linarith
  have hinv : 0 < 1 / (σh + εL) := one_div_pos.mpr hsum
  refine ⟨?_, mul_pos hinv hΛN, div_pos (by linarith) hsum⟩
  have : 0 < (1 / (σh + εL)) * ΛI := mul_pos hinv hΛI
  linarith

/--
Lean proof endpoint for `paper_prop2_sigma_freeSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_prop2_sigma_free :
  paper_prop2_sigma_freeSpec := by
  intro σh εγ ΛI hε hΛ
  have : 0 < (1 / εγ) * ΛI := mul_pos (one_div_pos.mpr hε) hΛ
  linarith

/--
Lean proof endpoint for `paper_prop3_productivity_effect_positiveSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_prop3_productivity_effect_positive :
  paper_prop3_productivity_effect_positiveSpec := by
  intro Wg R σh hR hlt hne
  rcases lt_or_gt_of_ne hne with hlt1 | hgt1
  · -- σ̂ < 1: exponent 1 - σ̂ > 0, rpow increasing
    have hexp : 0 < 1 - σh := by linarith
    have h : R ^ (1 - σh) < Wg ^ (1 - σh) := Real.rpow_lt_rpow hR.le hlt hexp
    exact div_pos (by linarith) hexp
  · -- σ̂ > 1: exponent 1 - σ̂ < 0, rpow decreasing
    have hexp : 1 - σh < 0 := by linarith
    have h : Wg ^ (1 - σh) < R ^ (1 - σh) := Real.rpow_lt_rpow_of_neg hR hlt hexp
    exact div_pos_of_neg_of_neg (by linarith) hexp

/--
Lean proof endpoint for `paper_prop3_rental_rate_risesSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_prop3_rental_rate_rises :
  paper_prop3_rental_rate_risesSpec := by
  intro P sL ΛI σh εL dI hP hs hΛ hσ hε hd
  have hsum : 0 < σh + εL := by linarith
  have : 0 < sL * ((1 / (σh + εL)) * ΛI * dI) :=
    mul_pos hs (mul_pos (mul_pos (one_div_pos.mpr hsum) hΛ) hd)
  linarith

/--
Lean proof endpoint for `paper_prop3_wage_decompositionSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_prop3_wage_decomposition :
  paper_prop3_wage_decompositionSpec := by
  intro P sL ΛI σh εL dI
  constructor <;> intro h <;> linarith

/--
Lean proof endpoint for `paper_prop3_new_tasks_raise_wageSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_prop3_new_tasks_raise_wage :
  paper_prop3_new_tasks_raise_wageSpec := by
  intro P sL ΛN σf εL dN hP hs hΛ hσ hε hd
  have hsum : 0 < σf + εL := by linarith
  have : 0 < (1 - sL) * ((1 / (σf + εL)) * ΛN * dN) :=
    mul_pos (by linarith) (mul_pos (mul_pos (one_div_pos.mpr hsum) hΛ) hd)
  linarith

/--
Lean proof endpoint for `paper_corollary_1_cobb_douglas_sharesSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_corollary_1_cobb_douglas_shares :
  paper_corollary_1_cobb_douglas_sharesSpec := by
  intro c K L N Istar hc hK hL hs hs1
  set s := N - Istar with hs_def
  have hKs : 0 < K ^ (1 - s) := Real.rpow_pos_of_pos hK _
  have hLs : 0 < L ^ s := Real.rpow_pos_of_pos hL _
  have hY : 0 < c * K ^ (1 - s) * L ^ s := mul_pos (mul_pos hc hKs) hLs
  refine ⟨?_, ?_, ?_⟩
  · -- derivative in L
    have h := (Real.hasDerivAt_rpow_const (x := L) (p := s) (Or.inl hL.ne')).const_mul
      (c * K ^ (1 - s))
    refine h.congr_deriv ?_
    have : L ^ (s - 1) = L ^ s / L := by
      rw [Real.rpow_sub_one hL.ne']
    rw [this]
    field_simp
  · -- derivative in K
    have h := ((Real.hasDerivAt_rpow_const (x := K) (p := 1 - s) (Or.inl hK.ne')).const_mul c).mul_const
      (L ^ s)
    refine h.congr_deriv ?_
    have : K ^ (1 - s - 1) = K ^ (1 - s) / K := by
      rw [Real.rpow_sub_one hK.ne']
    rw [this]
    field_simp
  · -- labor share
    have hL' : L ≠ 0 := hL.ne'
    have hK' : K ≠ 0 := hK.ne'
    have hY' : c * K ^ (1 - s) * L ^ s ≠ 0 := hY.ne'
    field_simp
    ring

end AR18RaceManMachine
