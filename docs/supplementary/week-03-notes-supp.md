---
title: "Discrete-Time LTI Systems"
---

# Discrete-Time LTI Systems
**SUPPLEMENTARY MATERIAL**<br>
*Difference equations, the $z$-transform, the $z$-plane and stability*

/// admonition | Reading
    type: quote

**What this is.** Section 11 of the Week 3 notes states the discrete-time counterparts of the transfer function and of the stability region, which is what the syllabus asks for and what you are examined on. This supplement is the longer version of that section: where the samples come from, how to read any $z$-plane pole, one worked example carried out three independent ways, the frequency response on the unit circle, and how the sampling period is chosen.

**How to use it.** This is supplementary material. Read it if you want the discrete-time picture to be more than a table of correspondences. This material is especially useful for *Digital Signal Processing (DSP)*.

**Reading** — Khalil, Appendix C, Laplace and $z$-Transform Tables (p. 444). Nise (6th ed.), §13.2 Modeling the Digital Computer (p. 727); §13.3 The $z$-Transform (p. 730); §13.6 Stability (p. 742).

///

### 1. From continuous time to discrete time

A continuous-time signal $u(t)$ is defined at every instant. A discrete-time signal is a *sequence*, 

$$u[k], \qquad k=\ldots,-2,-1,0,1,2,\ldots$$

 in which the integer $k$ is a **sample index**, not a time. If a continuous signal is sampled every $T$ seconds then 

$$\boxed{\;u[k]=u(kT)\;}$$

 so $k=3$ means “the third sample”, and the physical instant it was taken at is $t=3T$. Everything that follows is the continuous theory of Weeks 2 and 3 with derivatives replaced by delays.

/// admonition | Key idea
    type: info

$$\begin{array}{c@{\qquad\longleftrightarrow\qquad}c}
    \text{continuous time } t & \text{sample index } k\\[2mm]
    \text{derivatives} & \text{differences and delays}\\[1mm]
    \text{differential equations} & \text{difference equations}\\[1mm]
    \text{the Laplace transform} & \text{the } z\text{-transform}\\[1mm]
    \text{the } s\text{-plane} & \text{the } z\text{-plane}
  \end{array}$$

///

###### Where the samples come from.

A digital controller sees the plant only at the instants it chooses to look. An analogue-to-digital converter samples the measured output every $T$ seconds, the processor computes a command from those numbers, and a digital-to-analogue converter with a **zero-order hold** turns the command back into a voltage, holding each value constant until the next one is ready.

<figure id="fig:supp-loop" data-latex-placement="htbp">
<img src="../svg/week-03-notes-supp/fig01.svg" />
<figcaption><strong>Figure 1.</strong> A sampled-data loop. Only the dashed interior is discrete: the plant <span class="arithmatex">\(G(s)\)</span> is exactly the continuous system modelled in Week 2, and the converters are the boundary between the two worlds.</figcaption>
</figure>

Two consequences are worth naming at once. First, *between* samples the loop is open: whatever happens to the plant in the interval, the controller cannot react to it until the next sample. Second, the signal the plant actually receives is a staircase, not a smooth curve — the hold reconstructs $u(t)$ from $u[k]$ by the crudest possible rule, repeating the last value.

### 2. Difference equations

A broad class of discrete-time LTI systems is described by 

<a id="eq:supp-diffeq"></a>

$$\begin{equation}
  y[k]+\alpha_1 y[k-1]+\cdots+\alpha_n y[k-n]
  = \beta_0 u[k]+\beta_1 u[k-1]+\cdots+\beta_m u[k-m] .
  \tag{1}
\end{equation}$$

 The *order* is the largest output delay, $n$. Stored values such as $y[-1]$ and $y[-2]$ play the role that initial conditions play in a differential equation. Two shapes are worth distinguishing:

- **Nonrecursive** — the right-hand side uses input samples only, as in the two-sample moving average $y[k]=\tfrac12 u[k]+\tfrac12 u[k-1]$. Such a system has no memory of its own output.

- **Recursive** — previous *output* samples appear as well, as in $y[k]=0.6\,y[k-1]+u[k]$. The system feeds part of its past output back into the present calculation, which is what gives it dynamics.

###### A difference equation is executable.

This is the practical difference from a differential equation, and it is why digital control is easy to build. Rearranging [(1)](#eq:supp-diffeq) for $y[k]$ gives a rule for computing the next output from numbers already stored: the equation and the program that implements it are the same object. A controller of any order is a handful of multiplications and additions per sample, and changing the controller means changing coefficients in a table rather than changing hardware.

/// admonition | Natural response of a first-order system
    type: example

Take $y[k]-0.6\,y[k-1]=u[k]$ and set the input to zero. Then $y[k]=0.6\,y[k-1]$, and repeated substitution from a stored $y[0]$ gives 

$$y[1]=0.6\,y[0],\qquad y[2]=0.6^{2}y[0],\qquad\ldots,\qquad
  \boxed{\;y[k]=0.6^{k}\,y[0]\;}$$

 Because $|0.6|<1$ the sequence decays: this is the discrete-time version of a stable natural mode, and it is a *geometric* sequence where the continuous case gave an exponential. The general discrete mode is 

$$\boxed{\;z_0^{\,k}\;}$$

 and its fate depends on the modulus alone — decaying for $|z_0|<1$, constant in magnitude for $|z_0|=1$, growing for $|z_0|>1$. If $z_0$ is complex, its angle supplies oscillation while its modulus still controls growth or decay.

///

### 3. The *z*-transform and the pulse transfer function

The Laplace transform makes differential equations algebraic; the $z$-transform does the same for delays. For a sequence starting at $k=0$, 

$$U(z) = \sum_{k=0}^{\infty}u[k]\,z^{-k},
  \qquad z\in\mathbb{C},$$

 which is the one-sided transform, the one used throughout control work. (The bilateral transform sums from $k=-\infty$ and is the one to reach for in signal processing; the distinction matters only for the convergence question raised in §[6](#sec:supp-stability).) The property that does all the work is the delay rule: with zero initial conditions, 

$$\boxed{\;u[k-m]\;\longleftrightarrow\;z^{-m}U(z)\;}$$

/// admonition | Key idea
    type: info

Read $z^{-1}$ as the operator “wait one sample”: 

$$u[k]\ \xrightarrow{\;z^{-1}\;}\ u[k-1]
       \ \xrightarrow{\;z^{-1}\;}\ u[k-2].$$

 Every block diagram of a digital filter is built from gains, adders and $z^{-1}$ blocks, and nothing else — just as continuous diagrams are built from gains, adders and integrators.

///

Transforming [(1)](#eq:supp-diffeq) term by term therefore turns it into an algebraic equation, and the ratio of the transforms is the **pulse transfer function** $G(z)=Y(z)/U(z)$. For the recursive example above, 

$$Y(z)-0.6z^{-1}Y(z)=U(z)
  \qquad\Longrightarrow\qquad
  \boxed{\;G(z)=\frac{1}{1-0.6z^{-1}}=\frac{z}{z-0.6}\;}$$

 Written as a ratio of polynomials in $z$, the roots of the numerator are the **zeros** and the roots of the denominator the **poles** — here a zero at $z=0$ and a pole at $z=0.6$. Both forms are useful: the $z^{-1}$ form mirrors the difference equation and the code, the polynomial form shows the poles.

### 4. One system, three routes to its step response

Everything above can be seen at once in a single example — the same system used as Worked example 3.5 in the notes. The three routes agree, and each teaches something the others do not.

/// admonition | Worked Example 3.5
    type: example

$y[k]=0.5\,y[k-1]+u[k]$, unit step, $y[-1]=0$

**(a) The transfer function.** With zero initial conditions, $Y(z)=0.5z^{-1}Y(z)+U(z)$, so 

$$G(z)=\frac{1}{1-0.5z^{-1}}=\frac{z}{z-0.5},$$

 one pole, at $z=0.5$. Since $|0.5|<1$ the mode $(0.5)^{k}$ decays and the causal system is stable.

**(b) Direct recursion.** This is the route a processor takes. From $y[-1]=0$ with $u[k]=1$ for $k\ge0$: 

$$\begin{aligned}
  y[0]&=0.5(0)+1=1, &\qquad y[1]&=0.5(1)+1=1.5,\\
  y[2]&=0.5(1.5)+1=1.75, &\qquad y[3]&=0.5(1.75)+1=1.875,
\end{aligned}$$

and so on, evidently climbing towards $2$.

**(c) Closed form, by separating steady state from transient.** At steady state $y[k]=y[k-1]=y_{ss}$, so $y_{ss}=0.5y_{ss}+1$ and $y_{ss}=2$. Define the deviation $e[k]=y[k]-2$; substituting into the difference equation leaves $e[k]=0.5\,e[k-1]$, a pure natural mode. With $y[0]=1$ we have $e[0]=-1$, hence $e[k]=-(0.5)^{k}$ and 

$$\boxed{\;y[k]=2-(0.5)^{k},\qquad k\ge0\;}$$

 “Steady state plus decaying transient” — exactly the decomposition a first-order continuous system gives.

**(d) By the $z$-transform.** The unit step transforms as a geometric series, 

$$U(z)=\sum_{k=0}^{\infty}z^{-k}=1+z^{-1}+z^{-2}+\cdots
       =\frac{1}{1-z^{-1}}=\frac{z}{z-1},
  \qquad |z|>1,$$

 the condition $|z|>1$ being what makes the series converge. Then 

$$Y(z)=G(z)U(z)=\frac{z^{2}}{(z-0.5)(z-1)}
       =\frac{2}{1-z^{-1}}-\frac{1}{1-0.5z^{-1}}$$

 by partial fractions. Expanding each term with $1/(1-az^{-1})=1+az^{-1}+a^{2}z^{-2}+\cdots$, 

$$Y(z)=2\left(1+z^{-1}+z^{-2}+\cdots\right)
       -\left(1+0.5z^{-1}+0.25z^{-2}+\cdots\right)$$

 

$$\phantom{Y(z)}=1+1.5z^{-1}+1.75z^{-2}+1.875z^{-3}+\cdots$$

 But by the definition of the transform, $Y(z)=y[0]+y[1]z^{-1}+y[2]z^{-2}+\cdots$, so *the coefficients are the samples*: $1,\ 1.5,\ 1.75,\ 1.875,\dots$, agreeing with (b) and with (c). Inverting a $z$-transform by long division is not a trick; it reads the samples off one at a time, in order.

**(e) D.c. gain and final value.** Zero frequency means $z=1$, so the d.c. gain is $G(1)=1/(1-0.5)=2$: a unit d.c. input settles to an output of $2$. The final value theorem carries over as 

$$y[\infty]=\lim_{z\to1}\bigl(1-z^{-1}\bigr)Y(z) = 2,$$

 under the same kind of condition as its continuous cousin — every pole of $(1-z^{-1})Y(z)$ strictly inside the unit circle.

///

### 5. Reading a pole in the *z*-plane { #sec:supp-poles }

The two planes are related by one substitution. A continuous mode $e^{st}$, observed only at $t=kT$, is 

$$e^{s(kT)}=\bigl(e^{sT}\bigr)^{k}=z^{k},
  \qquad\text{so}\qquad
  \boxed{\;z=e^{sT}\;}$$

 — a geometric sequence in $k$ wherever the continuous signal was an exponential in $t$. Writing $s=\sigma+\mathrm{j}\omega$ and separating modulus from argument, 

<a id="eq:supp-zmap"></a>

$$\begin{equation}
  |z|=e^{\sigma T},
  \qquad
  \angle z = \theta = \omega T ,
  \tag{2}
\end{equation}$$

 where $\omega$ is in $\mathrm{rad}\,\mathrm{s}^{-1}$ as everywhere else in this unit and $\theta$ is the discrete frequency in *radians per sample*. This is the whole of how to read a $z$-plane pole: **the modulus carries the decay and the angle carries the oscillation**, both per sample rather than per second.

<a id="tab:supp-zpoles"></a>

| **Pole** | **Mode $y[k]$** | **Continuous counterpart** |
|:---|:---|:---|
| $z=a$, $0<a<1$ | $a^{k}$, decaying, one sign | stable real pole $s<0$ |
| $z=a$, $a>1$ | $a^{k}$, growing | unstable real pole $s>0$ |
| $z=1$ | constant | pole at the origin, an integrator |
| $z=0$ | zero after one step | no analogue: a pure delay |
| $z=-a$, $0<a<1$ | $(-a)^{k}$, sign alternating | no analogue: oscillation at $\pi/T$ |
| $|z|=1$ | constant amplitude | pole on the imaginary axis |
| $z=r\,e^{\pm\mathrm{j}\theta}$ | $r^{k}\cos(k\theta+\phi)$ | complex pair $\sigma\pm\mathrm{j}\omega$ |

**Table 1.** What a pole at $z$ does, for a real sequence. Each mode is the discrete counterpart of the continuous mode named in the last column.

Take $T=0.1\,\mathrm{s}$ for the three modes of Figure [2](#fig:supp-modes).

- A pole at $z=0.8$ gives $0.8^{k}$: decay with no oscillation. Its continuous equivalent is $s=\ln(0.8)/T=-2.23\,\mathrm{s}^{-1}$, a time constant $\tau=-T/\ln 0.8=0.448\,\mathrm{s}$, and the sequence is inside $2\%$ after about 18 samples.

- A pole at $z=-0.6$ gives $1,\,-0.6,\,0.36,\,-0.216,\dots$ — a mode that changes sign at *every* sample. By [(2)](#eq:supp-zmap) its angle is $\pi$, so $\omega=\pi/T=31.4\,\mathrm{rad}\,\mathrm{s}^{-1}$: it oscillates at exactly the fastest frequency the sampling can represent. No continuous first-order system does this; it is an artefact of sampling, and seeing it in a controller’s output is a sign that $T$ is wrong.

- A conjugate pair at $r=0.85$, $\theta=\pi/6$ gives $0.85^{k}\cos(k\pi/6)$: a decaying oscillation with $2\pi/\theta=12$ samples per cycle. In continuous terms $s=(\ln r+\mathrm{j}\theta)/T=-1.63\pm\mathrm{j}5.24$, a period of $1.2\,\mathrm{s}$ — which is those 12 samples.

<figure id="fig:supp-modes" data-latex-placement="htbp">
<img src="../svg/week-03-notes-supp/fig02.svg" />
<figcaption><strong>Figure 2.</strong> Three modes, all with <span class="arithmatex">\(T=0.1\,\mathrm{s}\)</span>: a positive real pole decays smoothly; a negative real pole alternates sign every sample; a complex pair oscillates with <span class="arithmatex">\(2\pi/\theta=12\)</span> samples to the cycle. The modulus sets how fast each envelope falls, the angle how fast it oscillates.</figcaption>
</figure>

### 6. Stability { #sec:supp-stability }

Equation [(2)](#eq:supp-zmap) settles where the stable region is. A mode decays when $|z|<1$, and $|z|=e^{\sigma T}<1$ exactly when $\sigma<0$. So the map $z=e^{sT}$ carries the left half plane onto the interior of the unit circle, the imaginary axis onto the circle itself, and the right half plane outside it.

/// admonition | Key idea
    type: info

A continuous system is stable when every pole satisfies $\mathrm{Re}(s)<0$; a causal discrete system is stable when every pole satisfies $|z|<1$. Same idea, different picture: the imaginary axis becomes the unit circle (Nise §13.6, p. 742).

///

<figure id="fig:supp-s-vs-z" data-latex-placement="htbp">
<img src="../svg/week-03-notes-supp/fig03.svg" />
<figcaption><strong>Figure 3.</strong> Stability regions compared. The shaded left half plane maps onto the shaded interior of the unit circle, the imaginary axis onto the circle.</figcaption>
</figure>

/// admonition | Common pitfall
    type: warning

The rule “all poles inside the unit circle” is stated here for a *causal* rational system, and the qualification is not decoration. In its general form a $z$-transform comes with a **region of convergence**: the set of $z$ for which the defining sum converges — which is why the unit step above carried the condition $|z|>1$. Stability means the region of convergence contains the unit circle. For a causal system that region is everything outside the outermost pole, and the two statements coincide, which is why the simple rule works. It stops working for a non-causal system, which is the province of signal processing rather than of this unit.

///

/// admonition | A second-order system
    type: example

Consider 

$$y[k]-1.2\,y[k-1]+0.32\,y[k-2]=u[k].$$

 Transforming, $Y(z)\bigl(1-1.2z^{-1}+0.32z^{-2}\bigr)=U(z)$, so 

$$G(z)=\frac{1}{1-1.2z^{-1}+0.32z^{-2}}=\frac{z^{2}}{z^{2}-1.2z+0.32},
  \qquad
  z^{2}-1.2z+0.32=(z-0.8)(z-0.4).$$

 The poles are at $z=0.8$ and $z=0.4$, both inside the unit circle, so the causal system is stable. Its modes are $0.8^{k}$ and $0.4^{k}$: both decay, but the first needs about 18 samples to fall inside $2\%$ and the second only about 4, so after a handful of samples the response is essentially $0.8^{k}$ alone. **The pole at $0.8$ is dominant** — and dominance means in the $z$-plane exactly what it meant in the $s$-plane in §8 of the notes, with “closest to the imaginary axis” replaced by “closest to the unit circle”: 

$$\begin{array}{c@{\qquad\longleftrightarrow\qquad}c}
    \text{pole } s=-0.2 & \text{slow mode } e^{-0.2t}\\[1mm]
    \text{pole } z=0.8  & \text{slow mode } 0.8^{k}
  \end{array}$$

///

### 7. Frequency response on the unit circle

In continuous time the frequency response is the transfer function evaluated along the imaginary axis, $G(\mathrm{j}\omega)$ — the object Weeks 10 to 12 are built on. In discrete time the corresponding path is the unit circle: 

$$\boxed{\;G\bigl(e^{\mathrm{j}\theta}\bigr)\;}$$

 because a discrete sinusoid contains $e^{\mathrm{j}\theta k}$, which is $z^{k}$ with $z=e^{\mathrm{j}\theta}$ and hence $|z|=1$. If the sequence came from sampling a continuous sinusoid of $\omega$ $\mathrm{rad}\,\mathrm{s}^{-1}$ every $T$ seconds then, as in [(2)](#eq:supp-zmap), $\theta=\omega T$ radians per sample.

One property has no continuous analogue at all: discrete frequency is **periodic**. Since $e^{\mathrm{j}(\theta+2\pi)k}=e^{\mathrm{j}\theta k}$, the frequencies $\theta$ and $\theta+2\pi$ describe the same sampled sequence and cannot be told apart after sampling. That is aliasing, stated exactly, and it is why the useful range of $\theta$ is $[-\pi,\pi]$ — equivalently, $|\omega|\le\pi/T$.

/// admonition | Common pitfall
    type: warning

$T$ is chosen, and choosing it badly cannot be repaired later in the design. Sample too slowly and two things go wrong at once. Information is lost irrecoverably — a component above $\pi/T$ comes back disguised as a lower frequency, and no filtering afterwards can separate the two. And the hold’s own lag destabilises the loop: holding each value for a whole period delays the signal the plant sees by half a sample on average, so a sampled-data loop carries roughly $T/2$ of extra dead time that no tuning removes. That is a pure time delay of the kind §12 of the notes describes, with the destabilising phase lag Week 10 quantifies. A workable starting rule is **ten to twenty samples per rise time** of the closed-loop response you are aiming for.

///

### 8. The correspondence, and a procedure

<a id="tab:supp-correspondence"></a>

| **Concept** | **Continuous time** | **Discrete time** |
|:---|:---|:---|
| Signal | $u(t)$ | $u[k]=u(kT)$ |
| Dynamic model | differential equation | difference equation |
| Memory | integration | sample delay |
| Transform | Laplace | $z$ |
| Transfer function | $G(s)=Y(s)/U(s)$ | $G(z)=Y(z)/U(z)$ |
| Natural mode | $e^{st}$ | $z_0^{\,k}$ |
| Stability boundary | the imaginary axis | the unit circle |
| Stable region (causal) | $\mathrm{Re}(s)<0$ | $|z|<1$ |
| D.c. gain | $G(0)$ | $G(1)$ |
| Frequency response | $G(\mathrm{j}\omega)$ | $G(e^{\mathrm{j}\theta})$, $\theta=\omega T$ |
| Pole mapping under sampling | $z=e^{sT}$ |  |

**Table 2.** Continuous and discrete counterparts. Nothing in the left column is abandoned; each row is the same idea written in the other language.

Given a linear constant-coefficient difference equation, then:

1.  Take the $z$-transform, assuming zero initial conditions for transfer-function work.

2.  Use $u[k-m]\leftrightarrow z^{-m}U(z)$, and the same for $y[k-m]$.

3.  Rearrange into $G(z)=Y(z)/U(z)$.

4.  Rewrite as a ratio of polynomials in $z$ when you want the poles.

5.  Find the poles from the denominator.

6.  For a causal system, check that every pole satisfies $|p_i|<1$.

7.  For the steady-state sinusoidal response, evaluate $G(z)$ on $z=e^{\mathrm{j}\theta}$; for the d.c. gain, at $z=1$.

## Self-check { #self-check }

1.  For $y[k]-1.1\,y[k-1]=u[k]$, where is the pole, and is the causal system stable?

2.  A pole sits at $z=0.95e^{\mathrm{j}0.3}$. Does its oscillation grow or decay, and what sets how fast it oscillates?

3.  Under $z=e^{sT}$, where does the imaginary axis of the $s$-plane map to?

4.  Why is $z^{-1}$ naturally read as a one-sample delay?

5.  A system sampled at $T=0.05\,\mathrm{s}$ has a single pole at $z=-0.9$. Is it stable? Describe its natural response in words, and give the frequency in $\mathrm{rad}\,\mathrm{s}^{-1}$ at which it oscillates.

6.  A continuous plant has its dominant pole at $s=-5$. Roughly what sampling period would the rule of thumb in §7 suggest, and where would that put the corresponding $z$-plane pole?

/// admonition | Answers
    type: info

**1.** Pole at $z=1.1$, outside the unit circle: unstable, and the mode $1.1^{k}$ grows by $10\%$ every sample. **2.** It decays, because $|z|=0.95<1$; the angle $\theta=0.3\,\mathrm{rad}$ per sample sets the oscillation, giving $2\pi/0.3\approx21$ samples per cycle. **3.** Onto the unit circle itself. **4.** Because the delay rule sends $u[k-1]$ to $z^{-1}U(z)$, so multiplying a transform by $z^{-1}$ is precisely shifting its sequence one sample later. **5.** Stable, since $|z|=0.9<1$: the response alternates in sign at every sample inside a decaying envelope $0.9^{k}$. Its angle is $\pi$, so $\omega=\pi/T=62.8\,\mathrm{rad}\,\mathrm{s}^{-1}$. **6.** A pole at $s=-5$ has $\tau=0.2\,\mathrm{s}$ and a rise time of roughly $2.2\tau\approx0.44\,\mathrm{s}$; ten to twenty samples across that gives $T$ of the order of $0.02\,\mathrm{s}$ to $0.04\,\mathrm{s}$. At $T=0.03\,\mathrm{s}$ the pole maps to $z=e^{-5(0.03)}=0.86$ — comfortably inside the unit circle, and close enough to it to be the dominant mode, as it should be.

///
