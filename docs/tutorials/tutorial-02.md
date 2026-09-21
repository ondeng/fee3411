---
title: "Tutorial 2 — Electromechanical modelling; linear approximation"
---

# Tutorial 2 — Electromechanical modelling; linear approximation
**QUESTION SHEET**

This tutorial has two purposes: turning the servomotor derivation from the lecture into working fluency with numbers, and extending gearing and linearization slightly beyond what the notes worked through, so you meet the ideas in a second setting before Assignment 1 asks you to use them in a third.

*Preparation:* Week 2 lecture notes, §6–§7.

## Question 1 — The servomotor: derive, reduce, and check the reduction { #question-1-the-servomotor-derive-reduce-and-check-the-reduction }

An armature-controlled d.c. servomotor has $R_a=4\,\Omega$, $L_a=0.05\,\mathrm{H}$, $K_t=0.8\,\mathrm{N}\,\mathrm{m}\,\mathrm{A}^{-1}$, $K_b=0.8\,\mathrm{V}\,\mathrm{s}\,\mathrm{rad}^{-1}$, $J_m=0.05\,\mathrm{kg}\,\mathrm{m}^{2}$ and $b=0.06\,\mathrm{N}\,\mathrm{m}\,\mathrm{s}\,\mathrm{rad}^{-1}$. The field is separately excited and held constant.

1.  Write down the armature circuit equation and the torque-balance equation, and state the transfer function $\theta_m(s)/V_a(s)$ that follows from eliminating the armature current.

2.  Setting $L_a\to0$, show that the reduced transfer function is given by $K_m/[s(\tau_ms+1)]$, then find its value numerically.

3.  Without discarding $L_a$, find the two roots of the characteristic equation of the transfer function. Identify the *dominant* pole (the one closest to the origin) and its time constant.

4.  Compare the time constant from (c) with $\tau_m$ from (b). By what percentage do they differ? Was neglecting $L_a$ reasonable here?

/// admonition | Reading
    type: warning

A $4$–$5\%$ shift in the dominant time constant is the kind of number you should expect to see and accept, not a sign of an arithmetic mistake. If the same calculation ever gives you a discrepancy of, say, $50\%$, that is telling you $L_a$ is *not* negligible for that motor, and the reduced formula should not be used — check by comparing the electrical time constant $L_a/R_a$ against the mechanical one, $\tau_m$; the approximation is only good when the first is much smaller than the second.

///

## Question 2 — A two-stage gear train { #question-2-a-two-stage-gear-train }

The servomotor of Question 1 drives a load of inertia $J_L=3\,\mathrm{kg}\,\mathrm{m}^{2}$ through *two* meshed gear pairs in series: the first stage has ratio $n_1=\theta_1/\theta_m=1/2$ (an intermediate shaft at angle $\theta_1$), and the second has ratio $n_2=\theta_L/\theta_1=1/4$. Neglect the inertia of the intermediate shaft and all load-side friction.

1.  Find the overall ratio $n=\theta_L/\theta_m$.

2.  Find the equivalent inertia $J_{\text{eq}}$ at the motor shaft.

3.  Recompute $\tau_m$ for the loaded, geared motor, and compare it with the *unloaded* motor’s $\tau_m$ from Question 1(b). By what factor has the motor slowed down?

## Question 3 — Linearizing a liquid-level tank { #question-3-linearizing-a-liquid-level-tank }

A tank of constant cross-sectional area $A=2\,\mathrm{m}^{2}$ has inflow rate $q_{in}(t)$ (the control input) and an outflow through a valve at the base obeying Torricelli’s law, so the level $h(t)$ obeys 

$$A\,\dot h(t) = q_{in}(t) - k\sqrt{h(t)}, \qquad k=0.5\,\mathrm{m}\,\mathrm{^{1.5}}\,\mathrm{s}^{-1}.$$

 This is nonlinear because of the $\sqrt{h}$ term.

1.  Find the equilibrium inflow $q_{in,0}$ that holds the level at $h_0=4\,\mathrm{m}$.

2.  Writing $\dot h=f(h,q_{in})$, find $\partial f/\partial h$ and $\partial f/\partial q_{in}$ at the operating point, and hence the linearized equation in $\Delta h$ and $\Delta q_{in}$.

3.  Identify the time constant of the linearized tank, and state in words what it means physically for the tank to respond *faster* or *slower* than this.

4.  The valve is replaced by a narrower one with the same $\sqrt{h}$ law but a smaller $k$. Without recomputing anything, say whether the tank’s linearized time constant gets longer or shorter, and why.

/// admonition | Common pitfall
    type: info

The tank is the same kind of exercise as the pendulum in the lecture notes, but with a control input as well as a state: linearizing $\dot x=f(x,u)$ needs *two* partial derivatives, one for each variable, evaluated together at the single operating point $(x_0,u_0)$ where $f(x_0,u_0)=0$. Every entry in the “s-domain relations” table you will build up over the unit is, underneath, one of these two partial derivatives.

///

## Question 4 — Gearing with load friction retained { #question-4-gearing-with-load-friction-retained }

Redo the gear-reflection idea of Question 2, but for a single gear stage where the load’s own friction is *not* negligible. A motor with $J_m=0.05\,\mathrm{kg}\,\mathrm{m}^{2}$ and $b=0.06\,\mathrm{N}\,\mathrm{m}\,\mathrm{s}\,\mathrm{rad}^{-1}$ (the same motor as Question 1) drives, through a single gear pair of ratio $n=\theta_L/\theta_m=1/5$, a load of inertia $J_L=2.5\,\mathrm{kg}\,\mathrm{m}^{2}$ and *load-side* viscous friction $b_L=0.4\,\mathrm{N}\,\mathrm{m}\,\mathrm{s}\,\mathrm{rad}^{-1}$.

1.  Find the equivalent inertia $J_{\text{eq}}=J_m+n^2J_L$ and the equivalent damping $b_{\text{eq}}=b+n^2b_L$ at the motor shaft.

2.  Using the purely mechanical (no electrical circuit) transfer function 

$$\frac{\theta_m(s)}{T_m(s)}=\frac{1}{s(J_{\text{eq}}s+b_{\text{eq}})},$$

 find the time constant $J_{\text{eq}}/b_{\text{eq}}$.

3.  By what percentage does ignoring $b_L$ entirely (as Question 2 did) change this time constant? Is it a bigger or smaller effect than ignoring $L_a$ was in Question 1?

## Question 5 — Linearizing quadratic (turbulent) drag { #question-5-linearizing-quadratic-turbulent-drag }

A rotational load of inertia $J=0.8\,\mathrm{kg}\,\mathrm{m}^{2}$ is driven by torque $T(t)$ against turbulent aerodynamic drag, which for this load is proportional to the *square* of the speed rather than to the speed itself: 

$$J\dot\omega(t) = T(t) - c\,\omega(t)\,|\omega(t)|,
  \qquad \omega=\dot\theta,\quad c=0.02\,\mathrm{N}\,\mathrm{m}\,\mathrm{s}^{2}\,\mathrm{{}^{-1}\,\mathrm{rad}^{2}\,\mathrm{}}.$$

 (The $|\omega|$ keeps the drag opposing the motion whichever way the load turns; for $\omega>0$ it is simply $c\omega^2$.)

1.  Suppose the load is to be held at a constant speed $\omega_0=10\,\mathrm{rad}\,\mathrm{s}^{-1}$ ($\omega_0>0$). Find the torque $T_0$ needed at this operating point.

2.  Linearize the drag torque about $\omega_0$ to find an *effective linear* damping coefficient $b_{\text{eff}}$, defined by $\Delta T_{\text{drag}}\approx b_{\text{eff}}\Delta\omega$.

3.  Hence write the linearized equation for $\Delta\omega$ in terms of $\Delta T$, and find its time constant.

4.  A common mistake is to linearize by simply evaluating the *drag itself* at $\omega_0$, i.e. to treat $b_{\text{eff}}=c\omega_0$ rather than using the derivative. Compute that (wrong) value and compare it with your answer to (b). Which is bigger, and by what factor?

/// admonition | Key idea
    type: warning

Linearization is differentiation, not substitution. Evaluating the nonlinear function *at* the operating point gives you the value $T_0$ there (useful for part (a)); it does not give you the *slope*, which is what governs the response to a small deviation and is what you actually need for the linear model. This is the single most common error in linearization problems, and Question 5(d) is designed to make it show up numerically rather than staying a rule you forget under pressure.

///
