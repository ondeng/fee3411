---
title: "Tutorial 3 — Transfer functions; inverse Laplace; poles, zeros and response shape"
---

# Tutorial 3 — Transfer functions; inverse Laplace; poles, zeros and response shape
**QUESTIONS AND SOLUTIONS**<br>
*Instructor copy — do not circulate before the tutorial.*

This hour delivers on the two promises made at the end of the Week 3 lecture: full transfer-function derivations, from physical law to $G(s)$, for an electrical system (Question 1) and a mechanical system (Question 2); and more practice with inverse Laplace transforms by partial fractions, extending the notes to the two cases they describe but do not fully work through with numbers — a repeated pole (Question 3) and a right-half-plane zero (Question 4) — plus a second, distinct complex-pole example (Question 5).

Questions marked **\[in the hour\]** are the ones we work through together. Those marked **\[homework\]** you do in your own time — they are not collected, but the technique is assumed from here on, including in Assignment 2 (issued Week 4).

*Preparation:* Week 3 lecture notes, §1–§4.

/// admonition | Reading
    type: quote

**Quick reference — carry these into every question below.**

**Transfer function, zero initial conditions**<br>

$$G(s) = \frac{Y(s)}{U(s)}\bigg|_{\text{zero i.c.}}$$

 

$$\dot y \leftrightarrow sY(s),\qquad
  \ddot y \leftrightarrow s^2Y(s)$$

 **Impedance shortcut (zero i.c. only)** 

$$Z_R=R,\qquad Z_L=Ls,\qquad Z_C=\frac{1}{Cs}$$

 **d.c. gain (final value, unit step input)** 

$$y(\infty)=\lim_{s\to0}sY(s)=G(0)$$

 (poles of $sY(s)$ all in the open left half plane)

///

**Partial-fraction templates**<br>
*Distinct real pole:* 

$$\frac{A}{s+a} \leftrightarrow Ae^{-at}$$

 *Repeated pole, order 2:* 

$$\frac{B}{s+a}+\frac{C}{(s+a)^2}
  \leftrightarrow
  Be^{-at}+Cte^{-at}$$

 *Complex-conjugate pair, $(s+a)^2+\omega^2$:* 

$$\frac{s+a}{(s+a)^2+\omega^2}\leftrightarrow e^{-at}\cos\omega t$$

 

$$\frac{\omega}{(s+a)^2+\omega^2}\leftrightarrow e^{-at}\sin\omega t$$

## Question 1 — Series *RLC* circuit: full derivation *\[in the hour\]* { #question-1-series-rlc-circuit-full-derivation-in-the-hour }

A series $RLC$ circuit is driven by a voltage source $v(t)$, and the output is taken as the voltage across the capacitor, $v_C(t)$. The component values are $R=7\,\Omega$, $L=1\,\mathrm{H}$, $C=0.1\,\mathrm{F}$.

1.  Write Kirchhoff’s voltage law around the loop in terms of the loop current $i(t)$, and the defining relation $i(t)=C\,\dot v_C(t)$. Combine the two into a single second-order differential equation in $v_C(t)$ and $v(t)$.

2.  Take the Laplace transform of your equation with zero initial conditions and hence write down $G(s)=V_C(s)/V(s)$.

3.  Factor the denominator to find the two poles. Which is dominant, and what is its time constant?

4.  Find the d.c. gain $G(0)$ two ways: (i) directly from your transfer function, and (ii) by reasoning physically about the circuit once all transients have died away. Confirm the two agree.

/// details | Solution
    type: note

**(a)** KVL around the loop: $v = Ri + L\dot i + v_C$, with $i=C\dot v_C$. Substituting, 

$$v = RC\dot v_C + LC\ddot v_C + v_C
  \quad\Longleftrightarrow\quad
  LC\,\ddot v_C + RC\,\dot v_C + v_C = v .$$

**(b)** With zero initial conditions, $\ddot v_C\to s^2V_C(s)$, $\dot v_C\to sV_C(s)$: 

$$(LCs^2+RCs+1)V_C(s) = V(s)
  \quad\Longrightarrow\quad
  G(s)=\frac{V_C(s)}{V(s)}=\frac{1}{LCs^2+RCs+1}.$$

 Substituting $L=1$, $C=0.1$, $R=7$: $LC=0.1$, $RC=0.7$, so 

$$G(s)=\frac{1}{0.1s^2+0.7s+1}=\frac{10}{s^2+7s+10}.$$

**(c)** Factoring, $s^2+7s+10=(s+2)(s+5)$, so the poles are $s=-2$ and $s=-5$. The pole at $s=-2$ is dominant (closest to the origin, decays slowest), with time constant $\tau=1/2=0.5\,\mathrm{s}$; the pole at $s=-5$ decays two and a half times faster ($\tau=0.2\,\mathrm{s}$) and its transient is essentially gone before the dominant one is.

**(d)** (i) $G(0)=10/10=1$. (ii) Once transients die away with a constant (d.c.) source, no current flows into the capacitor ($i=C\dot v_C=0$ at steady state), so there is no drop across $R$ or $L$ and $v_C=v$: the d.c. gain is exactly $1$, confirming (i).

///

## Question 2 — Mass–spring–damper: full derivation *\[in the hour\]* { #question-2-massspringdamper-full-derivation-in-the-hour }

A mass $M=1\,\mathrm{kg}$ slides on a damped surface and is connected to a wall by a spring, with damping coefficient $B=7\,\mathrm{N}\,\mathrm{s}\,\mathrm{m}^{-1}$ and spring constant $K=12\,\mathrm{N}\,\mathrm{m}^{-1}$. A force $f(t)$ is applied to the mass, and the output is its displacement $x(t)$ from equilibrium.

1.  Apply Newton’s second law to write the equation of motion in $x(t)$ and $f(t)$.

2.  Take the Laplace transform with zero initial conditions and find $G(s)=X(s)/F(s)$.

3.  Factor the denominator to find the two poles, and state which is dominant.

4.  Recall the force–voltage analogy from Week 2 ($M\!\leftrightarrow\! L$, $B\!\leftrightarrow\! R$, $K\!\leftrightarrow\! 1/C$). What values of $R$, $L$, $C$ would give an electrical circuit with exactly this transfer function shape? Compare the resulting $C$ with Question 1’s — are the two systems’ pole locations the same? Should they be?

/// details | Solution
    type: note

**(a)** Newton’s second law, with spring and damper forces opposing the motion: $M\ddot x = f - B\dot x - Kx$, i.e. 

$$M\ddot x + B\dot x + Kx = f .$$

**(b)** With zero initial conditions, 

$$(Ms^2+Bs+K)X(s)=F(s)
  \quad\Longrightarrow\quad
  G(s)=\frac{X(s)}{F(s)}=\frac{1}{Ms^2+Bs+K}
  =\frac{1}{s^2+7s+12}.$$

**(c)** Factoring, $s^2+7s+12=(s+3)(s+4)$: poles at $s=-3$ and $s=-4$. The pole at $s=-3$ is dominant, time constant $\tau=1/3=0.333\,\mathrm{s}$.

**(d)** Matching $M\leftrightarrow L=1\,\mathrm{H}$, $B\leftrightarrow R=7\,\Omega$, $K\leftrightarrow 1/C\Rightarrow
C=1/12=0.0833\,\mathrm{F}$. This is close to, but not the same as, Question 1’s $C=0.1\,\mathrm{F}$ — and correspondingly the pole locations differ ($-3,-4$ here against $-2,-5$ there), even though both transfer functions have the identical form $1/(s^2+7s+K')$ with the same middle coefficient. The two systems are analogous in structure, not identical in behaviour: the analogy carries over the *equation*, not the specific numbers, and a small change in the third coefficient is enough to move both poles.

///

/// admonition | Common pitfall
    type: warning

Questions 1 and 2 both reduce to $G(s)=K'/(s^2+7s+K')$ with the *same* $R/L$ (or $B/M$) ratio of $7$, purely because these examples were chosen that way. Do not read anything physical into that coincidence beyond “both systems happen to have the same relative damping term.” The poles, the d.c. gain, and the time constants are all set by the actual numbers in *each* system, and Question 1’s poles ($-2,-5$) are not interchangeable with Question 2’s ($-3,-4$) just because the equations look alike.

///

## Question 3 — Partial fractions with a repeated pole *\[in the hour\]* { #question-3-partial-fractions-with-a-repeated-pole-in-the-hour }

A system has transfer function 

$$G(s)=\frac{8}{(s+2)^2}.$$

1.  Find the d.c. gain $G(0)$, and hence predict the final value of the unit-step response *before* doing any partial-fraction work.

2.  Form $Y(s)=G(s)/s$ and expand it in partial fractions of the form $A/s+B/(s+2)+C/(s+2)^2$. Find $A$, $B$, $C$.

3.  Use the repeated-pole template from the quick-reference box to invert $Y(s)$ to $y(t)$. Which term is new compared with the distinct-pole case, and where does it come from mathematically (what did the second power in $(s+2)^2$ demand)?

4.  Confirm $\lim_{t\to\infty}y(t)$ matches your prediction from (a).

/// details | Solution
    type: note

**(a)** $G(0)=8/4=2$, so we expect $y(\infty)=2$ (the poles of $sY(s)$, namely $s=0$ and the double pole $s=-2$, are all in the closed left half plane with only a simple pole at the origin, so the final value theorem applies).

**(b)** 

$$Y(s)=\frac{8}{s(s+2)^2}=\frac{A}{s}+\frac{B}{s+2}+\frac{C}{(s+2)^2}.$$

 Cover-up for $A$ and $C$: $A=\left.\dfrac{8}{(s+2)^2}\right|_{s=0}=\dfrac{8}{4}=2$; $C=\left.\dfrac{8}{s}\right|_{s=-2}=\dfrac{8}{-2}=-4$. For $B$, multiply through by $s(s+2)^2$ and match the $s^2$ coefficient: $0=A+B\Rightarrow
B=-A=-2$. So 

$$Y(s)=\frac{2}{s}-\frac{2}{s+2}-\frac{4}{(s+2)^2}.$$

**(c)** Using $B/(s+a)\leftrightarrow Be^{-at}$ and $C/(s+a)^2\leftrightarrow Cte^{-at}$ with $a=2$: 

$$y(t)=2-2e^{-2t}-4te^{-2t},\qquad t\ge0.$$

 The new term is $-4te^{-2t}$: it did not appear in Question 1 or 2, where every pole was simple. A *repeated* pole at $s=-2$ needs a second, independent basis function alongside $e^{-2t}$ to match the extra degree of freedom in the partial fraction, and $te^{-2t}$ is that function — it is still decaying at the same rate $e^{-2t}$, but it starts at zero and rises before falling, so it briefly reinforces the decay rather than opposing it.

**(d)** As $t\to\infty$, both $e^{-2t}\to0$ and $te^{-2t}\to0$ (the exponential always beats the polynomial), leaving $y(\infty)=2$, exactly matching (a).

///

/// admonition | Key idea
    type: info

A repeated real pole at $s=-a$ is the borderline case between two distinct real poles and a complex-conjugate pair: it is what you get from $s^2+2as+a^2=(s+a)^2$, the exact boundary of $\zeta=1$ (critical damping) in the standard second-order form $s^2+2\zeta\omega_{n}s+\omega_{n}^2$. That is why it needs its own template ($te^{-at}$, not a second, distinct exponential): the two roots have merged, and the system has “used up” its independence between modes. You will meet this same boundary again when second-order response specifications (overshoot, settling time) are built from $\zeta$ and $\omega_{n}$.

///

## Question 4 — A right-half-plane zero *\[homework\]* { #question-4-a-right-half-plane-zero-homework }

Two systems share the same two poles, $s=-2$ and $s=-6$, and the same d.c. gain of $1$, but differ in their zero: 

$$G_A(s)=\frac{12}{(s+2)(s+6)}
  \qquad\text{(no zero)},$$

 

$$G_B(s)=\frac{K(s-4)}{(s+2)(s+6)}
  \qquad\text{(zero at }s=+4\text{, right half plane)}.$$

1.  Find the value of $K$ that gives $G_B(0)=1$, matching $G_A$’s d.c. gain. (Be careful with the sign.)

2.  Expand $Y_A(s)=G_A(s)/s$ in partial fractions and invert it to find $y_A(t)$.

3.  Do the same for $Y_B(s)=G_B(s)/s$ to find $y_B(t)$.

4.  Compute $\dot y_A(0)$ and $\dot y_B(0)$ directly from your time-domain expressions. What is qualitatively different about the two responses in the first instant, and which feature of $G_B$ is responsible?

5.  Using your expression for $y_B(t)$ (or a calculator/plot), estimate how far below zero $y_B(t)$ dips, and roughly when. Does $y_B(t)$ ever become unstable?

/// details | Solution
    type: note

**(a)** $G_B(0)=K(-4)/[(2)(6)]=-K/3$. Setting this to $1$ gives $K=-3$, so 

$$G_B(s)=\frac{-3(s-4)}{(s+2)(s+6)}=\frac{3(4-s)}{(s+2)(s+6)}.$$

 The sign matters: a right-half-plane zero at $+4$ needs a *negative* leading coefficient to keep the d.c. gain positive — it is easy to guess $K=3$ by pattern-matching the numerator to $(4-s)$ without checking, and get the wrong answer.

**(b)** $Y_A(s)=\dfrac{12}{s(s+2)(s+6)}=\dfrac{A}{s}+\dfrac{B}{s+2}+\dfrac{C}{s+6}$. Cover-up: $A=12/12=1$; $B=12/[(-2)(4)]=-1.5$; $C=12/[(-6)(-4)]=0.5$. So 

$$y_A(t)=1-1.5e^{-2t}+0.5e^{-6t}.$$

**(c)** $Y_B(s)=\dfrac{3(4-s)}{s(s+2)(s+6)}=\dfrac{A}{s}+\dfrac{B}{s+2}+\dfrac{C}{s+6}$. $A=G_B(0)=1$; $B=\left.\dfrac{3(4-s)}{s(s+6)}\right|_{s=-2}=\dfrac{3(6)}{(-2)(4)}=-2.25$; $C=\left.\dfrac{3(4-s)}{s(s+2)}\right|_{s=-6}=\dfrac{3(10)}{(-6)(-4)}=1.25$. So 

$$y_B(t)=1-2.25e^{-2t}+1.25e^{-6t}.$$

**(d)** $\dot y_A(t)=3e^{-2t}-3e^{-6t}\Rightarrow\dot y_A(0)=0$. $\dot y_B(t)=4.5e^{-2t}-7.5e^{-6t}\Rightarrow\dot y_B(0)=4.5-7.5=-3$. System $A$ leaves the origin with zero slope (it has relative degree 2, like Question 3); system $B$ leaves with a *negative* slope even though it is heading towards $+1$ — it initially moves the wrong way. This is exactly the right-half-plane zero at work: it is the only structural difference between $G_A$ and $G_B$, and it is what forces the initial dip.

**(e)** Evaluating $y_B(t)$ numerically, the minimum is $y_B\approx-0.162$ at $t\approx0.13\,\mathrm{s}$ — an undershoot of about $16\%$ of the final value, arriving quickly and then recovering. $y_B(t)$ is not unstable: both poles ($-2,-6$) are in the left half plane, so $y_B(t)\to1$ as $t\to\infty$ exactly as $y_A(t)$ does. The zero changes the *shape* of the transient, never whether the system settles.

///

## Question 5 — Partial fractions with a complex-conjugate pair *\[homework\]* { #question-5-partial-fractions-with-a-complex-conjugate-pair-homework }

A system has transfer function 

$$G(s)=\frac{20}{s^2+4s+20}.$$

1.  Complete the square in the denominator to write it as $(s+a)^2+\omega^2$, and hence identify the poles, $\omega_{n}$, and $\zeta$.

2.  Find the d.c. gain $G(0)$.

3.  Form $Y(s)=G(s)/s$ and expand it as $A/s+(Bs+C)/(s^2+4s+20)$. Find $A$, $B$, $C$.

4.  Rewrite the second term using the same completed-square denominator from (a), split it into a $\cos$-generating part and a $\sin$-generating part (matching the templates in the quick-reference box), and hence write $y(t)$ in closed form.

5.  Check: does your $y(t)$ give $y(0)=0$ and $y(\infty)=G(0)$?

/// details | Solution
    type: note

**(a)** $s^2+4s+20=(s+2)^2+16$, so the poles are $s=-2\pm\mathrm{j}4$. Matching $(s+2)^2+16$ to the standard form $(s+\zeta\omega_{n})^2+\omega_{n}^2(1-\zeta^2)$ gives $\omega_{n}^2=20\Rightarrow\omega_{n}=\sqrt{20}=2\sqrt5\approx4.47\,\mathrm{rad}\,\mathrm{s}^{-1}$, and $\zeta\omega_{n}=2\Rightarrow\zeta=2/4.47\approx0.447$.

**(b)** $G(0)=20/20=1$.

**(c)** 

$$Y(s)=\frac{20}{s(s^2+4s+20)}=\frac{A}{s}+\frac{Bs+C}{s^2+4s+20}.$$

 At $s=0$: $20=20A\Rightarrow A=1$. Matching the $s^2$ coefficient: $0=A+B\Rightarrow B=-1$. Matching the $s^1$ coefficient: $0=4A+C\Rightarrow C=-4$. So 

$$Y(s)=\frac{1}{s}-\frac{s+4}{s^2+4s+20}=\frac{1}{s}-\frac{s+4}{(s+2)^2+16}.$$

**(d)** Split $s+4=(s+2)+2$: 

$$\frac{s+4}{(s+2)^2+16}=\underbrace{\frac{s+2}{(s+2)^2+16}}_{\to\,e^{-2t}\cos4t}
  +\underbrace{\frac{2}{(s+2)^2+16}}_{=\frac12\cdot\frac{4}{(s+2)^2+16}\,\to\,\frac12e^{-2t}\sin4t}.$$

 Hence 

$$\boxed{\;y(t)=1-e^{-2t}\left(\cos4t+\tfrac12\sin4t\right)\;},\qquad t\ge0.$$

**(e)** At $t=0$: $y(0)=1-(1)(1+0)=0$, confirming the step response starts from rest. As $t\to\infty$, $e^{-2t}\to0$ (the oscillation is damped by the same real part $-2$ that appears in both poles), leaving $y(\infty)=1$, matching $G(0)$ from (b).

///

------------------------------------------------------------------------

<br>

End of solutions. Week 4: block diagrams and signal-flow graphs.
