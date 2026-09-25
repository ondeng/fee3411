---
title: "Tutorial 3 — Transfer functions; inverse Laplace; poles, zeros and response shape"
---

# Tutorial 3 — Transfer functions; inverse Laplace; poles, zeros and response shape
**QUESTION SHEET**

This tutorial covers the following: full transfer-function derivations, from physical law to $G(s)$, for an electrical system (Question 1) and a mechanical system (Question 2); and more practice with inverse Laplace transforms by partial fractions, extending the notes to the two cases they describe but do not fully work through with numbers — a repeated pole (Question 3) and a right-half-plane zero (Question 4) — plus a second, distinct complex-pole example (Question 5). Question 6 then uses the pole–zero map itself as a calculating device, which is how every graphical method later in the unit works.

*Preparation:* Week 3 lecture notes, §1–§4, and §7 for Question 6.

/// admonition | Reading
    type: quote

**Quick reference**

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

## Question 1 — Series *RLC* circuit: full derivation { #question-1-series-rlc-circuit-full-derivation }

A series $RLC$ circuit is driven by a voltage source $v(t)$, and the output is taken as the voltage across the capacitor, $v_C(t)$. The component values are $R=7\,\Omega$, $L=1\,\mathrm{H}$, $C=0.1\,\mathrm{F}$.

1.  Write Kirchhoff’s voltage law around the loop in terms of the loop current $i(t)$, and the defining relation $i(t)=C\,\dot v_C(t)$. Combine the two into a single second-order differential equation in $v_C(t)$ and $v(t)$.

2.  Take the Laplace transform of your equation with zero initial conditions and hence write down $G(s)=V_C(s)/V(s)$.

3.  Factor the denominator to find the two poles. Which is dominant, and what is its time constant?

4.  Find the d.c. gain $G(0)$ two ways: (i) directly from your transfer function, and (ii) by reasoning physically about the circuit once all transients have died away. Confirm the two agree.

## Question 2 — Mass–spring–damper: full derivation { #question-2-massspringdamper-full-derivation }

A mass $M=1\,\mathrm{kg}$ slides on a damped surface and is connected to a wall by a spring, with damping coefficient $B=7\,\mathrm{N}\,\mathrm{s}\,\mathrm{m}^{-1}$ and spring constant $K=12\,\mathrm{N}\,\mathrm{m}^{-1}$. A force $f(t)$ is applied to the mass, and the output is its displacement $x(t)$ from equilibrium.

1.  Apply Newton’s second law to write the equation of motion in $x(t)$ and $f(t)$.

2.  Take the Laplace transform with zero initial conditions and find $G(s)=X(s)/F(s)$.

3.  Factor the denominator to find the two poles, and state which is dominant.

4.  Recall the force–voltage analogy from Week 2 ($M\!\leftrightarrow\! L$, $B\!\leftrightarrow\! R$, $K\!\leftrightarrow\! 1/C$). What values of $R$, $L$, $C$ would give an electrical circuit with exactly this transfer function shape? Compare the resulting $C$ with Question 1’s — are the two systems’ pole locations the same? Should they be?

/// admonition | Common pitfall
    type: warning

Questions 1 and 2 both reduce to $G(s)=K'/(s^2+7s+K')$ with the *same* $R/L$ (or $B/M$) ratio of $7$, purely because these examples were chosen that way. Do not read anything physical into that coincidence beyond “both systems happen to have the same relative damping term.” The poles, the d.c. gain, and the time constants are all set by the actual numbers in *each* system, and Question 1’s poles ($-2,-5$) are not interchangeable with Question 2’s ($-3,-4$) just because the equations look alike.

///

## Question 3 — Partial fractions with a repeated pole { #question-3-partial-fractions-with-a-repeated-pole }

A system has transfer function 

$$G(s)=\frac{8}{(s+2)^2}.$$

1.  Find the d.c. gain $G(0)$, and hence predict the final value of the unit-step response *before* doing any partial-fraction work.

2.  Form $Y(s)=G(s)/s$ and expand it in partial fractions of the form $A/s+B/(s+2)+C/(s+2)^2$. Find $A$, $B$, $C$.

3.  Use the repeated-pole template from the quick-reference box to invert $Y(s)$ to $y(t)$. Which term is new compared with the distinct-pole case, and where does it come from mathematically (what did the second power in $(s+2)^2$ demand)?

4.  Confirm $\lim_{t\to\infty}y(t)$ matches your prediction from (a).

/// admonition | Key idea
    type: info

A repeated real pole at $s=-a$ is the borderline case between two distinct real poles and a complex-conjugate pair: it is what you get from $s^2+2as+a^2=(s+a)^2$, the exact boundary of $\zeta=1$ (critical damping) in the standard second-order form $s^2+2\zeta\omega_{n}s+\omega_{n}^2$. That is why it needs its own template ($te^{-at}$, not a second, distinct exponential): the two roots have merged, and the system has “used up” its independence between modes. You will meet this same boundary again when second-order response specifications (overshoot, settling time) are built from $\zeta$ and $\omega_{n}$.

///

## Question 4 — A right-half-plane zero { #question-4-a-right-half-plane-zero }

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

## Question 5 — Partial fractions with a complex-conjugate pair { #question-5-partial-fractions-with-a-complex-conjugate-pair }

A system has transfer function 

$$G(s)=\frac{20}{s^2+4s+20}.$$

1.  Complete the square in the denominator to write it as $(s+a)^2+\omega^2$, and hence identify the poles, $\omega_{n}$, and $\zeta$.

2.  Find the d.c. gain $G(0)$.

3.  Form $Y(s)=G(s)/s$ and expand it as $A/s+(Bs+C)/(s^2+4s+20)$. Find $A$, $B$, $C$.

4.  Rewrite the second term using the same completed-square denominator from (a), split it into a $\cos$-generating part and a $\sin$-generating part (matching the templates in the quick-reference box), and hence write $y(t)$ in closed form.

5.  Check: does your $y(t)$ give $y(0)=0$ and $y(\infty)=G(0)$?

## Question 6 — Reading $G(s)$ off the pole–zero map { #question-6-reading-gs-off-the-polezero-map }

Section 7 of the notes draws the pole–zero map and says the poles set the natural modes. This question does the other thing a map is for: evaluating $G(s)$ at a point straight off the diagram, without substituting anything into the algebra. It is the question that pays off most later — the graphical construction in part (b) is the whole basis of root-locus sketching in Week 8 and of Bode and Nyquist plots in Weeks 10–12.

Consider 

$$G(s)=\frac{4(s+2)}{s(s+4)} .$$

1.  Mark the poles ($\times$) and zeros ($\circ$) of $G$ on an $s$-plane diagram.

2.  Evaluate $G(s)$ at the point $s=-1+j$ **graphically**: draw the vector from each pole and each zero to that point, measure (or compute) its length and angle, and combine them. Confirm your answer algebraically.
