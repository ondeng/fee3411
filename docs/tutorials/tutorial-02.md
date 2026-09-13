---
title: "Tutorial 2 — Electromechanical modelling; linear approximation"
---

# Tutorial 2 — Electromechanical modelling; linear approximation
**QUESTIONS AND SOLUTIONS**<br>
*Instructor copy — do not circulate before the tutorial.*

This hour has two purposes: turning the servomotor derivation from the lecture into working fluency with numbers, and extending gearing and linearization slightly beyond what the notes worked through, so you meet the ideas in a second setting before Assignment 1 asks you to use them in a third.

Questions marked **\[in the hour\]** are the ones we work through together. Those marked **\[homework\]** you do in your own time — they are not collected, but the material is assumed from here on, including in Assignment 1 (Questions 3–4, due Week 3).

*Preparation:* Week 2 lecture notes, §6–§7.

/// admonition | Reading
    type: quote

**Quick reference — carry these into every question below.**

**Armature-controlled d.c. servomotor**<br>

$$\frac{\theta_m(s)}{V_a(s)}=\frac{K_t}{s\big[(R_a+L_as)(J_ms+b)+K_tK_b\big]}$$

 

$$L_a\to0:\quad \frac{\theta_m(s)}{V_a(s)}=\frac{K_m}{s(\tau_ms+1)},$$

 

$$K_m=\frac{K_t}{R_ab+K_tK_b},\qquad \tau_m=\frac{J_mR_a}{R_ab+K_tK_b}$$

**Gear reflection to the motor shaft**<br>

$$n=\frac{\theta_L}{\theta_m},\qquad
  J_{\text{eq}}=J_m+n^2J_L,\qquad
  b_{\text{eq}}=b+n^2b_L$$

**Linearization about $(x_0,u_0)$** 

$$\Delta\dot x \approx
  \left.\frac{\partial f}{\partial x}\right|_{0}\!\Delta x
  +\left.\frac{\partial f}{\partial u}\right|_{0}\!\Delta u,
  \qquad f(x_0,u_0)=0$$

///

## Question 1 — The servomotor: derive, reduce, and check the reduction *\[in the hour\]* { #question-1-the-servomotor-derive-reduce-and-check-the-reduction-in-the-hour }

An armature-controlled d.c. servomotor has $R_a=4\,\Omega$, $L_a=0.05\,\mathrm{H}$, $K_t=0.8\,\mathrm{N}\,\mathrm{m}\,\mathrm{A}^{-1}$, $K_b=0.8\,\mathrm{V}\,\mathrm{s}\,\mathrm{rad}^{-1}$, $J_m=0.05\,\mathrm{kg}\,\mathrm{m}^{2}$ and $b=0.06\,\mathrm{N}\,\mathrm{m}\,\mathrm{s}\,\mathrm{rad}^{-1}$. The field is separately excited and held constant.

1.  Write down the armature circuit equation and the torque-balance equation, and state the transfer function $\theta_m(s)/V_a(s)$ that follows from eliminating the armature current. (This is bookwork from the lecture — quote the result, but be ready to reproduce the elimination step if asked.)

2.  Setting $L_a\to0$, find the reduced transfer function $K_m/[s(\tau_ms+1)]$ numerically.

3.  Without discarding $L_a$, find the two roots of the quadratic factor $(R_a+L_as)(J_ms+b)+K_tK_b=0$. Identify the *dominant* pole (the one closest to the origin) and its time constant.

4.  Compare the time constant from (c) with $\tau_m$ from (b). By what percentage do they differ? Was neglecting $L_a$ reasonable here?

/// details | Solution
    type: note

**(a)** Exactly as derived in the lecture (notes §6.1–6.2): 

$$v_a=R_ai_a+L_a\frac{di_a}{dt}+K_b\dot\theta_m,
  \qquad
  K_ti_a=J_m\ddot\theta_m+b\dot\theta_m,$$

 

$$\frac{\theta_m(s)}{V_a(s)}=\frac{K_t}{s\big[(R_a+L_as)(J_ms+b)+K_tK_b\big]}.$$

**(b)** $R_ab+K_tK_b=(4)(0.06)+(0.8)(0.8)=0.24+0.64=0.88$. 

$$K_m=\frac{0.8}{0.88}=0.909\,\mathrm{rad}\,\mathrm{V}^{-1}\,\mathrm{s}^{-1},
  \qquad
  \tau_m=\frac{(0.05)(4)}{0.88}=0.227\,\mathrm{s}.$$

**(c)** Expanding $(R_a+L_as)(J_ms+b)+K_tK_b$ with the numbers above, 

$$0.0025\,s^2+0.203\,s+0.88=0
  \qquad\Longleftrightarrow\qquad
  s^2+81.2s+352=0,$$

 with roots 

$$s=-4.595 \quad\text{and}\quad s=-76.60 .$$

 The dominant pole is $s=-4.595$ (closest to the origin, so it decays slowest and dominates the response), giving time constant $\tau_{\text{dominant}}=1/4.595=0.218\,\mathrm{s}$.

**(d)** $\tau_m=0.227\,\mathrm{s}$ against $\tau_{\text{dominant}}=0.218\,\mathrm{s}$ is a difference of about 

$$\frac{0.227-0.218}{0.218}\times100\%\approx4.4\%.$$

 That is a small error for an introductory model, so neglecting $L_a$ was reasonable here — but notice it is not *zero*. The fast pole at $s=-76.6$ (time constant 0.013 s) is the one thrown away entirely; it is legitimate to discard only because it is roughly seventeen times faster than the dominant pole it leaves behind.

///

/// admonition | Common pitfall
    type: warning

A $4$–$5\%$ shift in the dominant time constant is the kind of number you should expect to see and accept, not a sign of an arithmetic mistake. If the same calculation ever gives you a discrepancy of, say, $50\%$, that is telling you $L_a$ is *not* negligible for that motor, and the reduced formula should not be used — check by comparing the electrical time constant $L_a/R_a$ against the mechanical one, $\tau_m$; the approximation is only good when the first is much smaller than the second.

///

## Question 2 — A two-stage gear train *\[in the hour\]* { #question-2-a-two-stage-gear-train-in-the-hour }

The servomotor of Question 1 drives a load of inertia $J_L=3\,\mathrm{kg}\,\mathrm{m}^{2}$ through *two* meshed gear pairs in series: the first stage has ratio $n_1=\theta_1/\theta_m=1/2$ (an intermediate shaft at angle $\theta_1$), and the second has ratio $n_2=\theta_L/\theta_1=1/4$. Neglect the inertia of the intermediate shaft and all load-side friction.

1.  Find the overall ratio $n=\theta_L/\theta_m$.

2.  Find the equivalent inertia $J_{\text{eq}}$ at the motor shaft.

3.  Recompute $\tau_m$ for the loaded, geared motor, and compare it with the *unloaded* motor’s $\tau_m$ from Question 1(b). By what factor has the motor slowed down?

/// details | Solution
    type: note

**(a)** Ratios of gear pairs in series multiply: 

$$n=n_1n_2=\left(\frac{1}{2}\right)\left(\frac{1}{4}\right)=\frac{1}{8}.$$

 This is the same idea as combining several transfer functions in a series connection — each stage’s ratio is applied in turn.

**(b)** Using $J_{\text{eq}}=J_m+n^2J_L$ with the *overall* ratio (the intermediate shaft’s own inertia is neglected, so it never enters the formula): 

$$J_{\text{eq}}=0.05+\left(\frac{1}{8}\right)^2(3)=0.05+\frac{3}{64}
   =0.05+0.046875=0.096875\,\mathrm{kg}\,\mathrm{m}^{2}.$$

**(c)** 

$$\tau_m'=\frac{J_{\text{eq}}R_a}{R_ab+K_tK_b}=\frac{(0.096875)(4)}{0.88}
   =0.440\,\mathrm{s}.$$

 Compared with the unloaded $\tau_m=0.227\,\mathrm{s}$, the ratio is 

$$\frac{0.440}{0.227}\approx1.94,$$

 so the geared, loaded motor is just under twice as sluggish as the bare motor — a modest penalty for driving a load $3/0.05=60$ times the motor’s own inertia, precisely because the $n^2=1/64$ scaling in the reflected inertia does almost all of the work.

///

## Question 3 — Linearizing a liquid-level tank *\[in the hour\]* { #question-3-linearizing-a-liquid-level-tank-in-the-hour }

A tank of constant cross-sectional area $A=2\,\mathrm{m}^{2}$ has inflow rate $q_{in}(t)$ (the control input) and an outflow through a valve at the base obeying Torricelli’s law, so the level $h(t)$ obeys 

$$A\,\dot h(t) = q_{in}(t) - k\sqrt{h(t)}, \qquad k=0.5\,\mathrm{m}\,\mathrm{^{1.5}}\,\mathrm{s}^{-1}.$$

 This is nonlinear because of the $\sqrt{h}$ term.

1.  Find the equilibrium inflow $q_{in,0}$ that holds the level at $h_0=4\,\mathrm{m}$.

2.  Writing $\dot h=f(h,q_{in})$, find $\partial f/\partial h$ and $\partial f/\partial q_{in}$ at the operating point, and hence the linearized equation in $\Delta h$ and $\Delta q_{in}$.

3.  Identify the time constant of the linearized tank, and state in words what it means physically for the tank to respond *faster* or *slower* than this.

4.  The valve is replaced by a narrower one with the same $\sqrt{h}$ law but a smaller $k$. Without recomputing anything, say whether the tank’s linearized time constant gets longer or shorter, and why.

/// details | Solution
    type: note

**(a)** At equilibrium $\dot h=0$, so $q_{in,0}=k\sqrt{h_0}=0.5\sqrt4=1$, i.e. $q_{in,0}=1\,\mathrm{m}^{3}\,\mathrm{s}^{-1}$.

**(b)** With $f(h,q_{in})=(q_{in}-k\sqrt h)/A$, 

$$\frac{\partial f}{\partial h}=-\frac{k}{2A\sqrt h},
  \qquad
  \frac{\partial f}{\partial q_{in}}=\frac{1}{A}.$$

 At $h_0=4$: $\partial f/\partial h=-0.5/(2\cdot2\cdot2)=-1/16=-0.0625$, and $\partial f/\partial q_{in}=1/2=0.5$. So 

$$\boxed{\;\Delta\dot h = 0.5\,\Delta q_{in} - 0.0625\,\Delta h\;} .$$

**(c)** Writing the linearized equation as $\Delta\dot h+0.0625\,\Delta h=0.5\,\Delta q_{in}$, the time constant is $\tau=1/0.0625=16\,\mathrm{s}$. A tank with a *shorter* time constant would settle to a new level faster after a change in inflow; one with a *longer* time constant responds more sluggishly — exactly the same sense in which $\tau_m$ described the servomotor’s speed of response.

**(d)** A smaller $k$ makes $|\partial f/\partial h|=k/(2A\sqrt{h_0})$ *smaller* in magnitude, so the time constant $\tau=2A\sqrt{h_0}/k$ *increases* — the tank becomes slower. Physically, a narrower valve drains more slowly for a given head, so a disturbed level takes longer to recover; this needs no recalculation because the sign and shape of the dependence on $k$ are already visible in the linearized coefficient.

///

/// admonition | Key idea
    type: info

The tank is the same kind of exercise as the pendulum in the lecture notes, but with a control input as well as a state: linearizing $\dot x=f(x,u)$ needs *two* partial derivatives, one for each variable, evaluated together at the single operating point $(x_0,u_0)$ where $f(x_0,u_0)=0$. Every entry in the “s-domain relations” table you will build up over the unit is, underneath, one of these two partial derivatives.

///

## Question 4 — Gearing with load friction retained *\[homework\]* { #question-4-gearing-with-load-friction-retained-homework }

Redo the gear-reflection idea of Question 2, but for a single gear stage where the load’s own friction is *not* negligible. A motor with $J_m=0.05\,\mathrm{kg}\,\mathrm{m}^{2}$ and $b=0.06\,\mathrm{N}\,\mathrm{m}\,\mathrm{s}\,\mathrm{rad}^{-1}$ (the same motor as Question 1) drives, through a single gear pair of ratio $n=\theta_L/\theta_m=1/5$, a load of inertia $J_L=2.5\,\mathrm{kg}\,\mathrm{m}^{2}$ and *load-side* viscous friction $b_L=0.4\,\mathrm{N}\,\mathrm{m}\,\mathrm{s}\,\mathrm{rad}^{-1}$.

1.  Find the equivalent inertia $J_{\text{eq}}=J_m+n^2J_L$ and the equivalent damping $b_{\text{eq}}=b+n^2b_L$ at the motor shaft.

2.  Using the purely mechanical (no electrical circuit) transfer function 

$$\frac{\theta_m(s)}{T_m(s)}=\frac{1}{s(J_{\text{eq}}s+b_{\text{eq}})},$$

 find the time constant $J_{\text{eq}}/b_{\text{eq}}$.

3.  By what percentage does ignoring $b_L$ entirely (as Question 2 did) change this time constant? Is it a bigger or smaller effect than ignoring $L_a$ was in Question 1?

/// details | Solution
    type: note

**(a)** With $n^2=1/25=0.04$: 

$$J_{\text{eq}}=0.05+0.04(2.5)=0.05+0.1=0.15\,\mathrm{kg}\,\mathrm{m}^{2},$$

 

$$b_{\text{eq}}=0.06+0.04(0.4)=0.06+0.016=0.076\,\mathrm{N}\,\mathrm{m}\,\mathrm{s}\,\mathrm{rad}^{-1}.$$

**(b)** 

$$\tau=\frac{J_{\text{eq}}}{b_{\text{eq}}}=\frac{0.15}{0.076}=1.974\,\mathrm{s}.$$

**(c)** Ignoring $b_L$ means using $b_{\text{eq}}\to b=0.06$ instead of $0.076$, giving $\tau\to0.15/0.06=2.5\,\mathrm{s}$ — a change of 

$$\frac{2.5-1.974}{1.974}\times100\%\approx27\%,$$

 substantially bigger than the $4.4\%$ effect of ignoring $L_a$ in Question 1. Load friction reflected through even a modest reduction gear is not automatically negligible, and should be checked rather than assumed away by habit.

///

## Question 5 — Linearizing quadratic (turbulent) drag *\[homework\]* { #question-5-linearizing-quadratic-turbulent-drag-homework }

A rotational load of inertia $J=0.8\,\mathrm{kg}\,\mathrm{m}^{2}$ is driven by torque $T(t)$ against turbulent aerodynamic drag, which for this load is proportional to the *square* of the speed rather than to the speed itself: 

$$J\dot\omega(t) = T(t) - c\,\omega(t)\,|\omega(t)|,
  \qquad \omega=\dot\theta,\quad c=0.02\,\mathrm{N}\,\mathrm{m}\,\mathrm{s}^{2}\,\mathrm{rad}^{-1}^{2}.$$

 (The $|\omega|$ keeps the drag opposing the motion whichever way the load turns; for $\omega>0$ it is simply $c\omega^2$.)

1.  Suppose the load is to be held at a constant speed $\omega_0=10\,\mathrm{rad}\,\mathrm{s}^{-1}$ ($\omega_0>0$). Find the torque $T_0$ needed at this operating point.

2.  Linearize the drag torque about $\omega_0$ to find an *effective linear* damping coefficient $b_{\text{eff}}$, defined by $\Delta T_{\text{drag}}\approx b_{\text{eff}}\Delta\omega$.

3.  Hence write the linearized equation for $\Delta\omega$ in terms of $\Delta T$, and find its time constant.

4.  A common mistake is to linearize by simply evaluating the *drag itself* at $\omega_0$, i.e. to treat $b_{\text{eff}}=c\omega_0$ rather than using the derivative. Compute that (wrong) value and compare it with your answer to (b). Which is bigger, and by what factor?

/// details | Solution
    type: note

**(a)** At equilibrium $\dot\omega=0$, so $T_0=c\omega_0^2=(0.02)(10)^2=2\,\mathrm{N}\,\mathrm{m}$.

**(b)** For $\omega>0$ the drag is $c\omega^2$, so 

$$b_{\text{eff}}=\left.\frac{d}{d\omega}\big(c\omega^2\big)\right|_{\omega_0}
  =2c\omega_0=2(0.02)(10)=0.4\,\mathrm{N}\,\mathrm{m}\,\mathrm{s}\,\mathrm{rad}^{-1}.$$

**(c)** $J\Delta\dot\omega=\Delta T-b_{\text{eff}}\Delta\omega$, i.e. 

$$\boxed{\;0.8\,\Delta\dot\omega+0.4\,\Delta\omega=\Delta T\;},
  \qquad \tau=\frac{J}{b_{\text{eff}}}=\frac{0.8}{0.4}=2\,\mathrm{s}.$$

**(d)** The naive value is $c\omega_0=(0.02)(10)=0.2\,\mathrm{N}\,\mathrm{m}\,\mathrm{s}\,\mathrm{rad}^{-1}$ — exactly *half* of the correct $b_{\text{eff}}=0.4$ found by differentiating. This is not a coincidence: for any power-law drag $c\omega^{p}$, the correct linearized coefficient is $pc\omega_0^{p-1}$, which for $p=2$ is $2c\omega_0$, twice the naive $c\omega_0$.

///

/// admonition | Common pitfall
    type: warning

Linearization is differentiation, not substitution. Evaluating the nonlinear function *at* the operating point gives you the value $T_0$ there (useful for part (a)); it does not give you the *slope*, which is what governs the response to a small deviation and is what you actually need for the linear model. This is the single most common error in linearization problems, and Question 5(d) is designed to make it show up numerically rather than staying a rule you forget under pressure.

///

------------------------------------------------------------------------

<br>

End of solutions. Week 3: transfer functions and the $s$-plane.
