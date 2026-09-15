---
title: "Tutorial 1 — Mathematical toolkit: Laplace, partial fractions, the s-plane"
---

# Tutorial 1 — Mathematical toolkit: Laplace, partial fractions, the s-plane
**QUESTION SHEET**

This tutorial is a **review**, not new material. Everything here you have met in FEE 222 or FEE 372; the purpose is to get it back into working order, because from Week 2 onwards it is assumed silently in every derivation.

Questions marked **\[in the hour\]** are the ones we work through together, if time allows. Those marked **\[homework\]** you do in your own time. Week 2 assumes you have done them.

*Preparation:* Khalil Appendix A (p. 438) or Nise §2.2 (p. 35).

/// admonition | Reading
    type: quote

**The toolkit you should be able to use without looking anything up.**

**Pairs**<br>

|                       |                                 |
|:----------------------|:--------------------------------|
| $\delta(t)$           | $1$                             |
| $u(t)$                | $1/s$                           |
| $t$                   | $1/s^{2}$                       |
| $t^{n}/n!$            | $1/s^{n+1}$                     |
| $e^{-at}$             | $1/(s+a)$                       |
| $t e^{-at}$           | $1/(s+a)^{2}$                   |
| $\sin\omega t$        | $\omega/(s^{2}+\omega^{2})$     |
| $\cos\omega t$        | $s/(s^{2}+\omega^{2})$          |
| $e^{-at}\sin\omega t$ | $\omega/[(s+a)^{2}+\omega^{2}]$ |
| $e^{-at}\cos\omega t$ | $(s+a)/[(s+a)^{2}+\omega^{2}]$  |

///

**Properties**<br>

|  |  |
|:---|:---|
| Linearity | $\mathcal{L}\{af+bg\}=aF+bG$ |
| Differentiation | $\mathcal{L}\{\dot f\}=sF(s)-f(0^{-})$ |
|  | $\mathcal{L}\{\ddot f\}=s^{2}F(s)-s f(0^{-})-\dot f(0^{-})$ |
| Integration | $\mathcal{L}\left\{\int_{0}^{t}\!f\right\}=F(s)/s$ |
| Frequency shift | $\mathcal{L}\{e^{-at}f(t)\}=F(s+a)$ |
| Time shift | $\mathcal{L}\{f(t-T)u(t-T)\}=e^{-sT}F(s)$ |
| Initial value | $f(0^{+})=\lim_{s\to\infty}sF(s)$ |
| Final value | $f(\infty)=\lim_{s\to 0}sF(s)$ |
|  | *only if all poles of $sF(s)$* |
|  | *have negative real parts* |

## Question 1 — Standard test signals *\[in the hour\]* { #question-1-standard-test-signals-in-the-hour }

1.  Sketch, on the same time axis, the unit impulse $\delta(t)$, unit step $u(t)$, unit ramp $r(t)=t\,u(t)$ and unit parabola $p(t)=\tfrac{1}{2}t^{2}u(t)$. Write down the Laplace transform of each.

2.  Show that each signal in the list is the time integral of the one before it. Using the integration property only, deduce the transforms $1/s$, $1/s^{2}$, $1/s^{3}$ from $\mathcal{L}\{\delta\}=1$.

3.  Why does a control engineer test with *these* signals rather than, say, a sine wave or a recorded real input?

## Question 2 — Transforms and properties *\[in the hour\]* { #question-2-transforms-and-properties-in-the-hour }

1.  From the definition $F(s)=\int_{0^{-}}^{\infty}f(t)e^{-st}\,dt$, derive $\mathcal{L}\{e^{-at}\}$. For which values of $s$ does the integral converge?

2.  Using the properties in the box, and *without* integrating, find 

$$\text{(i) } \mathcal{L}\{t\,e^{-3t}\}\qquad
            \text{(ii) } \mathcal{L}\{e^{-2t}\sin 4t\}\qquad
            \text{(iii) } \mathcal{L}\{e^{-(t-2)}u(t-2)\}$$

3.  Find $F(s)$ for $f(t)=5-3e^{-2t}\cos 4t$.

4.  For $\displaystyle F(s)=\frac{10(s+2)}{s(s^{2}+4s+13)}$, find $f(0^{+})$ and $f(\infty)$ without inverting.

5.  A student applies the final value theorem to $\displaystyle G(s)=\frac{5}{s^{2}+9}$ and reports $g(\infty)=0$. What has gone wrong?

## Question 3 — Partial fractions *\[in the hour\]* { #question-3-partial-fractions-in-the-hour }

Expand each of the following and hence find $f(t)$. In each case check your answer against the initial and final value theorems.

1.  $\displaystyle F(s)=\frac{s+3}{s(s+1)(s+2)}$ (distinct real poles)

2.  $\displaystyle F(s)=\frac{s+4}{s(s+2)^{2}}$ (a repeated pole)

3.  $\displaystyle F(s)=\frac{10}{s(s^{2}+2s+5)}$ (a complex pair)

## Question 4 — Solving a differential equation *\[homework\]* { #question-4-solving-a-differential-equation-homework }

The position servomechanism of this week’s lecture (Figure 5 of the notes), with a particular choice of amplifier gain, obeys 

$$\ddot{c}+4\dot{c}+8c=8r(t),$$

 where $r$ is the reference shaft angle and $c$ the load shaft angle.

1.  With the load initially at rest at the origin, $c(0)=\dot c(0)=0$, find $c(t)$ for a unit step reference $r(t)=u(t)$.

2.  Now set $r(t)=0$ but start the load displaced: $c(0)=1$, $\dot c(0)=0$. Find $c(t)$.

3.  Comment on what is the same and what is different between (a) and (c), and say which part of the answer is a property of the *system* rather than of the input.

## Question 5 — Time delay, and a warning about $s\to\infty$ *\[homework\]* { #question-5-time-delay-and-a-warning-about-stoinfty-homework }

1.  A sensor introduces a pure time delay of $T$ seconds: its output is the input, unchanged in shape, but arriving $T$ seconds late. Show from the time-shift property that its transfer function is $e^{-sT}$.

2.  A step of height $5$ is applied at $t=0$ to such a sensor with $T=0.4\,\mathrm{s}$. Write down the transform of the output, and sketch the output against time.

3.  Apply the initial value theorem to $\displaystyle F(s)=\frac{s+1}{s+2}$. Then find $f(t)$ properly and explain the discrepancy.
