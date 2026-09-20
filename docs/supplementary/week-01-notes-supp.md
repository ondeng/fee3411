---
title: "Control System Components"
---

# Control System Components
/// admonition | Reading
    type: quote

**Set text:** Nagrath & Gopal, *Control Systems Engineering*, 2nd ed., §4.3–4.6, pp. 84–119. Nagrath states the results this document derives.

///

/// admonition | By the end of this week you should be able to
    type: abstract

- Derive the governing equation of these representative components — error detectors, actuators, sensors, and hydraulic and pneumatic power elements — from a physical law, rather than quoting it.

- Recognise the transfer function $K/[s(\tau s+1)]$ wherever it appears (d.c. and a.c. servomotors, hydraulic pump–motor and cylinder), and say in each case *why* the free integrator is there.

- Explain three recurring reasons a manufacturer builds a component the way it does: high rotor resistance in an a.c. servomotor, a spring in a pneumatic actuator but not a hydraulic one, and rate feedback added purely to change damping.

- Quantify, rather than merely state, the approximations behind a model — a linearisation error, a neglected leakage term — and know when each stops being safe to make.

///

### 1. Error detectors

The error detector is the physical realisation of the summing junction $\otimes$ you draw in a block diagram. Its job is to form the difference $r-c$ between a reference and a measured output *as a real signal*, using hardware, before any amplifier sees it. Two standard devices do this for angular position, and the whole of this section is about them.

#### 1.1. The potentiometer pair

Two identical potentiometers are fed from the same d.c. supply. One is turned by the reference shaft, through angle $r$; the other by the load shaft, through angle $c$. Each wiper sits at a voltage proportional to its own shaft angle, so the voltage measured *between the two wipers* is

<a id="eq:pot"></a>

$$\begin{equation}
  v_{e}=K_{p}\,(r-c),\qquad [K_{p}]=\mathrm{V}\,\mathrm{rad}^{-1}.
  \tag{1}
\end{equation}$$

The subtraction is done by the wiring, not by a circuit: connect the two wipers to the two inputs of the amplifier and the difference appears of its own accord. Equation [(1)](#eq:pot) is a **pure gain** — no derivative, no time constant, no dynamics of any kind — which is why the potentiometer pair is the easiest error detector to model.

**For:** cheap; d.c. in and d.c. out; a pure gain. **Against:** the wiper is a sliding contact, so there is friction, wear, electrical noise from the contact, and a resolution limited by the pitch of the winding — the wiper cannot sit *between* two turns.

#### 1.2. The synchro pair { #sec:synchro }

Every objection to the potentiometer comes from the same source: the sliding contact. Where a shaft must turn continuously, or through many revolutions, or sit in dust, damp or vibration, that contact is unacceptable. The **synchro** (sold under the trade names *selsyn* and *autosyn*) removes it, and does the subtraction magnetically instead.

The argument runs in five steps, and each has its own subsection:

1.  One coil facing a rotor gives a voltage proportional to $\cos$ of the angle between them. *(§[1.2.1](#sss:cosine))*

2.  Three coils $120^\circ$ apart therefore encode the rotor angle as three voltages. *(§[1.2.2](#sss:three))*

3.  Fed into a second, identical stator, those three voltages rebuild a flux pointing in the *same direction* as the first rotor. *(§[1.2.3](#sss:rebuild))*

4.  A rotor sitting in that flux gives a voltage proportional to $\cos$ of the angle between it and the flux — step 1 again, run backwards. *(§[1.2.4](#sss:output))*

5.  Mount that second rotor $90^\circ$ out and the cosine becomes a sine, which for small angles is the error itself. *(§[1.2.5](#sss:linear))*

Only step 3 is genuinely new physics. Steps 1 and 4 are the same piece of transformer theory used twice, and step 5 is trigonometry.

##### Step 1 — where the cosine comes from { #sss:cosine }

Consider the rotor first. It carries a single coil, fed with alternating current through slip rings. The coil is *concentric* (or *sinusoidally distributed*): its turns are not bunched in one slot but spread around the rotor so that the magnetomotive force it produces, and hence the flux density it drives across the air gap, varies smoothly around the stator bore rather than in steps.

Let $\psi$ measure position around the stator bore, and let the rotor coil axis lie at angle $\theta$. Then the air-gap flux density is

<a id="eq:airgap"></a>

$$\begin{equation}
  B(\psi,t)=B_{m}(t)\,\cos(\psi-\theta),
  \tag{2}
\end{equation}$$

which is maximum where the bore faces the rotor coil axis ($\psi=\theta$), zero a quarter-turn away, and reversed on the far side. The time variation $B_{m}(t)$ follows the rotor current: the flux *pulsates* in time along a *fixed* direction. It does not rotate. That distinction matters, and we come back to it.

Now put a stator coil in the bore with its own axis at angle $\psi_{s}$. A full-pitch coil spans half the bore, so its two sides sit at $\psi_{s}-90^\circ$ and $\psi_{s}+90^\circ$, and the flux it links is the integral of [(2)](#eq:airgap) across that span:

<a id="eq:fluxlink"></a>

$$\begin{equation}
  \Phi_{s}\;\propto\;\int_{\psi_{s}-\pi/2}^{\psi_{s}+\pi/2}
     B_{m}(t)\cos(\psi-\theta)\,\mathrm{d}\psi
   = B_{m}(t)\Big[\sin(\psi-\theta)\Big]_{\psi_{s}-\pi/2}^{\psi_{s}+\pi/2}
   = 2B_{m}(t)\,\cos(\psi_{s}-\theta).
  \tag{3}
\end{equation}$$

There is the cosine. It is not an assumption and not an approximation: it is what you get when you integrate a sinusoidally distributed field over a half-turn window. Move the window and the enclosed net flux traces out a cosine.

<figure id="fig:cosine" data-latex-placement="H">
<p><img src="../svg/week-01-notes-supp/fig01.svg" alt="image" /> <img src="../svg/week-01-notes-supp/fig02.svg" alt="image" /></p>
<figcaption><strong>Figure 1.</strong> Where the cosine in <a href="#eq:fluxlink">(3)</a> comes from. The rotor drives a flux density that varies sinusoidally around the bore, <a href="#eq:airgap">(2)</a>. The stator coil links whatever lies between its two sides — the shaded window in (b). Flux entering the coil (blue) counts positively and flux leaving it (orange) counts negatively, so the net linkage is the <em>signed</em> area, <span class="math inline arithmatex">\(2B_{m}\cos(\psi_{s}-\theta)\)</span>. Slide the window around the bore and that signed area traces out a cosine.</figcaption>
</figure>

To turn flux linkage into a voltage, use the transformer relation rather than differentiating [(3)](#eq:fluxlink) directly — it is shorter and it gets the phase right. Neglecting the resistance and leakage of the rotor winding, the applied rotor voltage is absorbed entirely by the rate of change of its own flux linkage: 

$$v(t)\;\approx\;N_{r}\frac{\mathrm{d}\Phi}{\mathrm{d}t},
  \qquad\text{while}\qquad
  e_{s}(t)=N_{s}\frac{\mathrm{d}\Phi_{s}}{\mathrm{d}t}
          =N_{s}\cos(\psi_{s}-\theta)\frac{\mathrm{d}\Phi}{\mathrm{d}t}.$$

 Dividing one by the other kills the derivative and leaves an algebraic relation between the two voltages:

<a id="eq:onecoil"></a>

$$\begin{equation}
  \boxed{\;e_{s}(t)=\frac{N_{s}}{N_{r}}\cos(\psi_{s}-\theta)\;v(t)
        =K V_{r}\cos(\psi_{s}-\theta)\sin\omega_{c}t\;}
  \tag{4}
\end{equation}$$

for a rotor excitation $v(t)=V_{r}\sin\omega_{c}t$, with $K=N_{s}/N_{r}$ the effective turns ratio. Two things are worth noticing before moving on:

- The *time* behaviour, $\sin\omega_{c}t$, is fixed by the supply and is the same in every coil. The coils are in time phase with one another.

- The *amplitude*, $KV_{r}\cos(\psi_{s}-\theta)$, is the only place the shaft angle appears. All the information is in the amplitudes.

/// admonition | Key idea
    type: info

A synchro is a **transformer whose coupling depends on shaft angle**. The rotor coil is the primary, each stator coil a secondary, and the turns ratio of each secondary is modulated by $\cos(\psi_{s}-\theta)$. Nothing rotates electrically and nothing slides in the signal path — only the coupling changes.

///

##### Step 2 — three coils, and what appears on the wires { #sss:three }

The stator carries three identical Y-connected coils with their axes $120^\circ$ apart. Take the axis of $S_{2}$ as the reference, $\psi_{2}=0$, and place $S_{1}$ at $\psi_{1}=-120^\circ$ and $S_{3}$ at $\psi_{3}=+120^\circ$. Substituting each $\psi_{k}$ into [(4)](#eq:onecoil), and using $\cos(-x)=\cos x$ throughout, gives the three coil-to-neutral voltages:

<a id="eq:v1"></a>

$$\begin{align}
  v_{s_{1}n}&=KV_{r}\sin\omega_{c}t\,\cos(\theta+120^\circ), \tag{5}\<br>
  v_{s_{2}n}&=KV_{r}\sin\omega_{c}t\,\cos\theta,             \tag{6}\<br>
  v_{s_{3}n}&=KV_{r}\sin\omega_{c}t\,\cos(\theta+240^\circ). \tag{7}
\end{align}$$

(The last one may look odd: $\psi_{3}=+120^\circ$ gives $\cos(\theta-120^\circ)$, and $\cos(\theta-120^\circ)=\cos(\theta+240^\circ)$ because cosine repeats every $360^\circ$. Nagrath writes it the second way; it is the same voltage.)

<figure id="fig:transmitter" data-latex-placement="H">
<img src="../svg/week-01-notes-supp/fig03.svg" />
<figcaption><strong>Figure 2.</strong> The synchro transmitter. (a) Mechanically, three coil axes <span class="math inline arithmatex">\(120^\circ\)</span> apart and a rotor at angle <span class="math inline arithmatex">\(\theta\)</span>, measured from the <span class="math inline arithmatex">\(S_{2}\)</span> axis. (b) Electrically, three Y-connected secondaries and one rotating primary <span class="math inline arithmatex">\(R_{1}\)</span>–<span class="math inline arithmatex">\(R_{2}\)</span> fed through slip rings. Cf. Nagrath &amp; Gopal Figs. 4.10–4.11, pp. 92–93. Note that only three wires leave the stator: the neutral <span class="math inline arithmatex">\(n\)</span> is internal and is not brought out.</figcaption>
</figure>

###### What is actually measurable.

The neutral $n$ is buried inside the machine. Only three wires leave it, so the voltages you can measure are the three *line-to-line* voltages, and these are differences of [(5)](#eq:v1)–[(7)](#eq:v3). Take the first, and use the identity $\cos A-\cos B=-2\sin\frac{A+B}{2}\sin\frac{A-B}{2}$: 

$$\begin{align*}
  v_{s_{1}s_{2}}&=v_{s_{1}n}-v_{s_{2}n}
   =KV_{r}\sin\omega_{c}t\big[\cos(\theta+120^\circ)-\cos\theta\big]\<br>
  &=KV_{r}\sin\omega_{c}t\big[-2\sin(\theta+60^\circ)\sin 60^\circ\big]
   =-\sqrt{3}\,KV_{r}\sin(\theta+60^\circ)\sin\omega_{c}t,
\end{align*}$$

 and since $-\sin x=\sin(x+180^\circ)$, this is the form Nagrath quotes. Doing the same for the other two pairs:

<a id="eq:v2"></a>

$$\begin{align}
  v_{s_{1}s_{2}}&=\sqrt{3}\,KV_{r}\sin(\theta+240^\circ)\sin\omega_{c}t, \tag{8}\<br>
  v_{s_{2}s_{3}}&=\sqrt{3}\,KV_{r}\sin(\theta+120^\circ)\sin\omega_{c}t, \tag{9}\<br>
  v_{s_{3}s_{1}}&=\sqrt{3}\,KV_{r}\sin\theta\,\sin\omega_{c}t.           \tag{10}
\end{align}$$

Two checks are worth making on [(5)](#eq:v1)–[(7)](#eq:v3) before going on.

**Check 1: the three coil voltages sum to zero.** Adding [(5)](#eq:v1)–[(7)](#eq:v3), 

$$\cos(\theta+120^\circ)+\cos\theta+\cos(\theta+240^\circ)=0
  \qquad\text{for every }\theta,$$

 which is the standard result that three equal phasors $120^\circ$ apart cancel. That is why the Y point needs no return wire: whatever currents these voltages drive, Kirchhoff’s current law at $n$ is satisfied without one.

**Check 2: the electrical zero.** Put $\theta=0$. Then $S_{2}$ carries its maximum voltage (its axis faces the rotor squarely) and, from [(10)](#eq:l3), the line voltage $v_{s_{3}s_{1}}$ is exactly zero. This position is the **electrical zero** of the transmitter, and it is the reference against which shaft angle is quoted. It is easy to find in practice: turn the shaft until $v_{s_{3}s_{1}}$ nulls.

<figure id="fig:linev" data-latex-placement="H">
<img src="../svg/week-01-notes-supp/fig04.svg" />
<figcaption><strong>Figure 3.</strong> The three line voltages of <a href="#eq:l1">(8)</a>–<a href="#eq:l3">(10)</a> as the transmitter shaft turns. No two shaft angles in a full revolution give the same set of three amplitudes-with-signs, so the three wires carry an unambiguous code for <span class="math inline arithmatex">\(\theta\)</span>. This is why a synchro can also be used on its own as a position <em>transmitter</em>, not only inside an error detector.</figcaption>
</figure>

##### Step 3 — rebuilding the flux in the second machine { #sss:rebuild }

Now wire those three stator terminals to the three stator terminals of a second machine, the **synchro control transformer**. It is built like the transmitter except for its rotor, which is cylindrical — more on that below.

Currents circulate in the two sets of stator windings. If the resistances and leakage reactances are small, the current in each phase of the control transformer is very nearly proportional to the voltage impressed on it, so phase $k$ of the control transformer carries a current $i_{k}\propto\cos(\theta-\psi_{k})$ — the same pattern of amplitudes the transmitter had. Each of those currents drives a magnetomotive force *along its own coil axis*, and the three add.

This is where the machine actually works, so it is worth doing properly rather than asserting. Write the m.m.f. of phase $k$ as a vector of length $\cos(\theta-\psi_{k})$ pointing along $\hat{u}(\psi_{k})
=(\cos\psi_{k},\,\sin\psi_{k})$, and sum over the three phases $\psi_{k}\in\{-120^\circ,\,0,\,+120^\circ\}$. Take the horizontal component first, using $\cos A\cos B=\tfrac{1}{2}[\cos(A-B)+\cos(A+B)]$: 

$$\sum_{k}\cos(\theta-\psi_{k})\cos\psi_{k}
  =\frac{1}{2}\sum_{k}\cos\theta+\frac{1}{2}\sum_{k}\cos(\theta-2\psi_{k})
  =\frac{3}{2}\cos\theta+0 .$$

 The second sum vanishes because doubling three angles $120^\circ$ apart gives three angles that are again $120^\circ$ apart, and those cancel as in Check 1. The vertical component goes the same way and yields $\tfrac{3}{2}\sin\theta$. So

<a id="eq:v3"></a>

$$\begin{equation}
  \mathbf{F}_{\text{total}}
  =\sum_{k}\cos(\theta-\psi_{k})\,\hat{u}(\psi_{k})
  =\frac{3}{2}\,\hat{u}(\theta).
  \tag{11}
\end{equation}$$

/// admonition | Key idea
    type: info

Equation [(11)](#eq:mmf) is the synchro. Three stationary coils, carrying currents in the ratio $\cos(\theta-\psi_{k})$, produce between them a single resultant field pointing along the direction $\theta$ — *whatever* $\theta$ is, and with a magnitude $\tfrac{3}{2}$ that does not depend on $\theta$ either. The control transformer therefore contains a copy of the transmitter’s flux, pointing the same way, with no moving part having carried it there.

///

<figure id="fig:mmf" data-latex-placement="H">
<img src="../svg/week-01-notes-supp/fig05.svg" />
<figcaption><strong>Figure 4.</strong> Equation <a href="#eq:mmf">(11)</a> drawn, for <span class="math inline arithmatex">\(\theta=50^\circ\)</span>. In (a), <span class="math inline arithmatex">\(F_{1}=\cos170^\circ\)</span> is negative, so it points <em>opposite</em> to the <span class="math inline arithmatex">\(S_{1}\)</span> axis. Adding the three head to tail in (b) gives a resultant of length <span class="math inline arithmatex">\(\tfrac{3}{2}\)</span> lying exactly along <span class="math inline arithmatex">\(\theta\)</span>. Repeat the construction for any other <span class="math inline arithmatex">\(\theta\)</span> and the same two facts hold — that constancy of length and fidelity of direction is what makes the device useful.</figcaption>
</figure>

/// admonition | Common pitfall
    type: warning

The resultant in [(11)](#eq:mmf) is a *stationary* field whose magnitude pulsates at the carrier frequency; it is not a rotating field. Do not carry over the rotating-field picture from three-phase induction machines. There, the three currents are $120^\circ$ apart *in time* and the resultant sweeps round the bore. Here the three currents are in time phase with one another — all of them follow the same $\sin\omega_{c}t$ — and only their *amplitudes* differ, so the resultant stands still and pulsates. The direction it stands in is set by the shaft, not by time.

///

###### Two construction details, and why they are there.

The control transformer differs from the transmitter in two respects, both deliberate.

- **Its rotor is cylindrical**, giving a uniform air gap. The rotor of the transmitter is dumb-bell shaped, which is fine because nothing is connected to it but the supply. The control transformer rotor, however, feeds an amplifier, and if the air gap changed as the shaft turned then so would the rotor’s output impedance — and with it the gain of the amplifier stage. A uniform gap keeps the source impedance seen by the amplifier constant at every shaft angle.

- **Its stator has a higher impedance per phase**, so it draws less current from the transmitter. That allows several control transformers to be driven from one transmitter — one shaft angle distributed to several loops.

##### Step 4 — the output voltage, and the $90^\circ$ offset { #sss:output }

Inside the control transformer there is now a pulsating flux lying along the direction $\theta$. Its rotor is a coil sitting in that flux, so step 1 applies again, unchanged. If $\phi$ is the angle between the control transformer’s rotor axis and the flux axis, then by [(4)](#eq:onecoil)

<a id="eq:l1"></a>

$$\begin{equation}
  e(t)=K'V_{r}\cos\phi\,\sin\omega_{c}t.
  \tag{12}
\end{equation}$$

All that remains is to express $\phi$ in terms of the two shaft angles we care about. Let $\theta$ be the transmitter shaft angle from *its* electrical zero, and $\alpha$ the control transformer shaft angle from *its* zero, both measured in the same sense. The flux inside the control transformer lies at $\theta$ from its $S_{2}$ axis. The control transformer’s rotor is mounted so that at $\alpha=0$ it sits at $90^\circ$ to that axis, and turning its shaft by $\alpha$ carries it to $90^\circ+\alpha$. The angle between rotor and flux is therefore

<a id="eq:l2"></a>

$$\begin{equation}
  \phi=(90^\circ+\alpha)-\theta=90^\circ-(\theta-\alpha),
  \tag{13}
\end{equation}$$

and substituting [(13)](#eq:phi) into [(12)](#eq:ct), with $\cos(90^\circ-x)=\sin x$:

<a id="eq:l3"></a>

$$\begin{equation}
  \boxed{\;e(t)=K'V_{r}\,\sin(\theta-\alpha)\,\sin\omega_{c}t\;}
  \tag{14}
\end{equation}$$

<figure id="fig:pair" data-latex-placement="H">
<img src="../svg/week-01-notes-supp/fig06.svg" />
<figcaption><strong>Figure 5.</strong> The geometry behind <a href="#eq:phi">(13)</a>, drawn for <span class="math inline arithmatex">\(\theta=25^\circ\)</span> and <span class="math inline arithmatex">\(\alpha=15^\circ\)</span>, so <span class="math inline arithmatex">\(\phi=80^\circ\)</span>. The transmitter’s rotor angle is reproduced as the direction of the flux inside the control transformer; the control transformer’s own rotor is mounted a further <span class="math inline arithmatex">\(90^\circ\)</span> round. Cf. Nagrath &amp; Gopal Fig. 4.12, p. 94.</figcaption>
</figure>

###### Why mount the rotor at $90^\circ$?

It looks like an odd choice until you ask what an error detector must do. Two properties are wanted, and $\phi=90^\circ$ delivers both at once.

- **It must read zero when the error is zero.** A summing junction that outputs something when $r=c$ is not a summing junction. From [(12)](#eq:ct), $\cos\phi=0$ exactly at $\phi=90^\circ$, so the offset puts the null where the shafts agree.

- **It must be most sensitive there.** Differentiating [(12)](#eq:ct), the change in output per unit change in angle is $|\mathrm{d}e/\mathrm{d}\phi|\propto|\sin\phi|$, which is *largest* at $\phi=90^\circ$. The null and the point of maximum slope coincide.

Had the rotor been aligned with the flux instead, at $\phi=0$, the output would sit at its maximum, the slope would be zero, and small shaft errors would produce almost no change in output — and no sign information at all, since $\cos$ is even. The device would be useless as an error detector. A sensor for a feedback loop should always be arranged to work about a null, and this is a clean example of why.

##### Step 5 — linearising, and what it costs { #sss:linear }

Equation [(14)](#eq:synchro) is exact, but $\sin(\theta-\alpha)$ is not a gain. For small shaft differences, $\sin x\approx x$, and

<a id="eq:mmf"></a>

$$\begin{equation}
  e(t)\;\approx\;K_{s}\,(\theta-\alpha)\,\sin\omega_{c}t,
  \qquad K_{s}=K'V_{r},\qquad [K_{s}]=\mathrm{V}\,\mathrm{rad}^{-1},
  \tag{15}
\end{equation}$$

where $K_{s}$ is the **sensitivity of the error detector**. Now the pair is a pure gain from shaft-angle difference to signal amplitude — exactly the $\otimes$ of the block diagram, followed by a constant.

<figure id="fig:sine" data-latex-placement="H">
<img src="../svg/week-01-notes-supp/fig07.svg" />
<figcaption><strong>Figure 6.</strong> The exact characteristic <a href="#eq:synchro">(14)</a> against the linear model <a href="#eq:linear">(15)</a>. Inside the shaded band the two are indistinguishable at the accuracy of any real measurement; a servo drives the error into that band and keeps it there, so the linear model is not a compromise so much as a description of where the device actually lives.</figcaption>
</figure>

###### How small is small?

The relative error of $\sin x\approx x$ is worth knowing as a number rather than a feeling:

| $\theta-\alpha$ | $5^\circ$ | $10^\circ$ | $14^\circ$ | $15^\circ$ | $20^\circ$ | $30^\circ$ |
|:---|:--:|:--:|:--:|:--:|:--:|:--:|
| error in $e$ | 0.13% | 0.51% | 1.0% | 1.15% | 2.1% | 4.7% |

So the linear model is good to about 1% out to $\pm14^\circ$ and to about 5% out to $\pm30^\circ$. In a position servo, whose whole purpose is to hold $\theta-\alpha$ near zero, the steady-state error is a small fraction of a degree and the approximation is far better than any other in the loop.

/// admonition | Common pitfall
    type: warning

$\sin(\theta-\alpha)$ is also zero at $\theta-\alpha=180^\circ$. That is a *false null*: the pair produces no output there even though the shafts are as far apart as they can be. It is not, however, a place the servo can settle. Just past it, at $\theta-\alpha=180^\circ+\delta$, the exact output is $\sin(180^\circ+\delta)=-\sin\delta$ — the *opposite* sign to what the linear model predicts. The feedback that should pull the shaft back instead pushes it away, so the $180^\circ$ point is an unstable equilibrium and the loop runs off it towards the true null. A synchro pair therefore cannot tell you absolute position over a whole revolution, but as an error detector inside a loop it does not need to.

///

/// admonition | Common pitfall
    type: warning

Watch the units in which $K_{s}$ is quoted. Nagrath gives it in volts (rms) per radian, so read $V_{r}$ as the *rms* rotor voltage and treat $\sin\omega_{c}t$ as a marker of the carrier’s frequency and phase rather than as a literal peak-value multiplier. Take $V_{r}$ to be the peak value instead and $K_{s}$ comes out $\sqrt{2}$ times larger. Both conventions appear on datasheets; settle which one you are in before putting a number into a loop gain, because a stray $\sqrt{2}$ in the forward path is a real error in the damping you predict.

///

/// admonition | Worked example 1.1 — sizing a synchro error detector
    type: example

A control transformer is quoted as producing 22.5 V rms at its rotor terminals at maximum coupling, from a 26 V, 400 Hz carrier supply.

**(a) What is its sensitivity?** Maximum coupling is $\phi=0$ — rotor aligned with the flux — which by [(13)](#eq:phi) means the shafts differ by $90^\circ$, so $\sin(\theta-\alpha)=1$ and the whole of $K'V_{r}$ appears: 

$$K_{s}=22.5\,\mathrm{V}\,\mathrm{rad}^{-1}
       =\frac{22.5\times\pi}{180}=0.393\,\mathrm{V}\ \text{per degree}.$$

**(b) What comes out at a 2 ° shaft error?** Exactly, from [(14)](#eq:synchro), 

$$e_{\text{rms}}=22.5\sin 2^\circ=22.5\times0.034899=0.785\,\mathrm{V}.$$

 From the linear model [(15)](#eq:linear), with $2^\circ=0.034907\,\mathrm{rad}$, 

$$e_{\text{rms}}\approx22.5\times0.034907=0.785\,\mathrm{V}.$$

 The two agree to four figures; the error of linearisation here is 0.02%, which is two orders of magnitude below the tolerance of the components around it.

**(c) What does the amplifier have to cope with?** If the loop can be disturbed by as much as $30^\circ$ before the servo catches it, the detector will momentarily put out $22.5\sin30^\circ=11.3\,\mathrm{V}$ rms. An amplifier sized on the linear model alone would have predicted $22.5\times0.5236=11.8\,\mathrm{V}$ — close enough for sizing, but note that the *exact* value is the smaller one. Linearisation always over-estimates the signal, never under-estimates it, because $\sin x<x$.

///

##### Reading the output: a modulated carrier { #sss:carrier }

Equation [(15)](#eq:linear) has an unfamiliar shape. It is not a voltage proportional to the error; it is a *carrier* $\sin\omega_{c}t$ whose amplitude is proportional to the error. Let the shafts move, so that $\theta-\alpha$ becomes a slowly varying function of time. Then 

$$e(t)=\underbrace{K_{s}\big[\theta(t)-\alpha(t)\big]}_{\text{modulating signal, slow}}
       \times\underbrace{\sin\omega_{c}t}_{\text{carrier, fast}} .$$

 This is **suppressed-carrier modulation**, and it has two properties that matter for reading an oscilloscope and for designing the rest of the loop.

- **No error, no signal.** When $\theta=\alpha$ the output is identically zero — the carrier itself is absent. Compare ordinary amplitude modulation, in which the carrier is still there at full strength when the modulating signal is zero. Here the carrier is *suppressed*, hence the name.

- **The sign lives in the phase.** When $\theta-\alpha$ changes sign, the amplitude factor changes sign, and multiplying $\sin\omega_{c}t$ by a negative number is the same as shifting it by $180^\circ$. The envelope of $e(t)$ is $|\,K_{s}(\theta-\alpha)|$ and carries no sign; the sign is carried entirely by whether $e(t)$ is in phase or antiphase with the supply.

<figure id="fig:carrier" data-latex-placement="H">
<img src="../svg/week-01-notes-supp/fig08.svg" />
<figcaption><strong>Figure 7.</strong> Suppressed-carrier modulation at the output of the synchro pair. Cf. Nagrath &amp; Gopal Fig. 4.13, p. 95. Where the shaft difference passes through zero (dashed lines) the output vanishes and then comes back <em>inverted</em> relative to the carrier. The envelope alone (orange) is the same on both sides of that crossing: it gives the size of the error but not its direction.</figcaption>
</figure>

/// admonition | Common pitfall
    type: warning

In a carrier system the information is in the **envelope and its phase**, never in the instantaneous value. A student who reads the error straight off an oscilloscope trace of $e(t)$ will conclude that the error is swinging violently at 400 Hz while the shaft stands perfectly still. Trigger the scope on the carrier supply and look at the envelope instead — and note which way up the trace is, because that is the sign of the error.

///

###### Two consequences for the rest of the loop.

First, since the sign lives in the phase, whatever comes next must be *phase-sensitive* — a simple rectifier would deliver $|\theta-\alpha|$ and the loop would drive the shaft the wrong way half the time. In the a.c. position control systems of §[1.2](#sec:synchro) this is arranged elegantly: the a.c. servomotor’s reference phase is fed from the same carrier supply as the synchro rotor, so the motor itself compares the two phases and turns in the direction the sign demands. The demodulator is the actuator.

Second, the description [(15)](#eq:linear) treats the amplitude as though it were constant over each carrier cycle, which is only true if the shafts move slowly compared with the carrier. Nagrath states the condition as the speed voltages induced by rotation being negligible; in design terms it means the closed-loop bandwidth must be well below $\omega_{c}$. With a 400 Hz carrier, a loop bandwidth of a few tens of hertz is comfortable and a few hundred is not. If that separation holds, the loop can be analysed on the modulating signal alone and the carrier ignored — which is exactly what we do for the rest of this unit.

##### Summary of the derivation

/// admonition | Key idea
    type: info

Each equation and where it came from:

clP6.9cm Eq. & Result & Origin<br>
[(2)](#eq:airgap) & $B=B_{m}\cos(\psi-\theta)$ & the rotor winding is sinusoidally distributed<br>
[(3)](#eq:fluxlink)& $\Phi_{s}\propto2B_{m}\cos(\psi_{s}-\theta)$ & integrating the above over a $180^\circ$ coil span<br>
[(4)](#eq:onecoil) & $e_{s}=KV_{r}\cos(\psi_{s}-\theta)\sin\omega_{c}t$ & transformer relation between primary and secondary<br>
[(8)](#eq:l1)–[(10)](#eq:l3) & $\sqrt{3}KV_{r}\sin(\theta+\cdot)$ & differences of the three coil voltages<br>
[(11)](#eq:mmf) & $\mathbf{F}=\tfrac{3}{2}\hat{u}(\theta)$ & summing three m.m.f. vectors $120^\circ$ apart<br>
[(12)](#eq:ct) & $e=K'V_{r}\cos\phi\sin\omega_{c}t$ & [(4)](#eq:onecoil) applied a second time<br>
[(13)](#eq:phi) & $\phi=90^\circ-(\theta-\alpha)$ & the deliberate $90^\circ$ mounting offset<br>
[(14)](#eq:synchro) & $e=K'V_{r}\sin(\theta-\alpha)\sin\omega_{c}t$ & $\cos(90^\circ-x)=\sin x$<br>
[(15)](#eq:linear) & $e\approx K_{s}(\theta-\alpha)\sin\omega_{c}t$ & $\sin x\approx x$, good to 1% out to $14^\circ$<br>

///

##### Check yourself { #check-yourself }

1.  Without looking back: why is the flux linked by a stator coil proportional to $\cos$ of the angle, and not to the angle itself?

2.  The three coil-to-neutral voltages sum to zero for every $\theta$. What practical consequence does that have for the wiring?

3.  Sketch the m.m.f. construction of Figure [4](#fig:mmf) for $\theta=0$. Which of the three components is largest, and which two are equal?

4.  A colleague proposes mounting the control transformer rotor in line with the flux instead of $90^\circ$ from it, “so that the output is as large as possible”. Give two reasons why the resulting device would not work as an error detector.

5.  A synchro pair has $K_{s}=18\,\mathrm{V}\,\mathrm{rad}^{-1}$. What shaft error gives 1 V rms out, exactly and on the linear model? By how much do the two disagree?

6.  Why does the fact that $e(t)$ is a suppressed-carrier signal make a diode rectifier unsuitable as the next stage?

### 2. Actuators { #sec:actuators }

The actuator is the muscle of the loop: it takes the amplified error signal and does physical work on the plant. Three of them carry almost all of the positional control done with electricity, and each answers a different question.

- The **d.c. servomotor** — the workhorse. Question: where do its two constants $K_{t}$ and $K_{b}$ come from, and why are they the same number?

- The **a.c. two-phase servomotor** — used where the signals are already a.c. Question: why must its rotor be deliberately built with a *high* resistance, when every other motor designer works to keep rotor resistance low?

- The **stepper motor** — the digital actuator. Question: where does the step angle come from, and why can it be run open loop when almost nothing else can?

One theme runs through the first two and is worth naming in advance: in both machines, the thing that makes the motor *controllable* also supplies most of its *damping*. That is not a coincidence, and §[2.2.4](#sss:samething) says why.

#### 2.1. The d.c. servomotor

A d.c. motor becomes a *servo*motor by construction rather than by principle: low rotor inertia, so it accelerates quickly, and a design that tolerates constant reversal. The physics is the physics of any d.c. machine. Two ways of controlling it:

- **Armature control** — field current held constant, armature voltage varied. Almost universal, and the case treated below.

- **Field control** — armature current held constant, field voltage varied. Cheaper amplifier, but slower, for a reason derived in §[2.1.6](#sss:field).

##### Step 1 — where $T_{m}=K_{t}i_{a}$ comes from { #sss:torqueconst }

A conductor of length $\ell$ carrying current $i$ across a magnetic field of flux density $B$ feels a force 

$$F=B\,\ell\,i .$$

 In a d.c. machine the armature conductors lie along the shaft, at radius $r$ from it, in the gap between the pole faces — and the field there is *radial*, so the force on each conductor comes out *tangential*, which is exactly what produces torque. With $z$ conductors carrying current, each contributing a moment $Fr$, 

<a id="eq:ct"></a>

$$\begin{equation}
  T_{m}=z\,B\ell r\,i_{a}=K_{t}\,i_{a},
  \qquad K_{t}=z B\ell r,\qquad [K_{t}]=\mathrm{N}\,\mathrm{m}\,\mathrm{A}^{-1}.
  \tag{16}
\end{equation}$$

 Everything in $K_{t}$ is a fixed feature of the machine *except* $B$, and $B$ is set by the field current. This is the whole reason armature control gives a linear model: hold the field constant and $K_{t}$ is a constant, so torque is proportional to armature current with no product of two varying quantities. Vary the field instead and you are multiplying two signals together, which is not linear — see §[2.1.6](#sss:field).

##### Step 2 — where $e_{b}=K_{b}\dot\theta$ comes from { #sss:emfconst }

The same conductors, now considered as generators. A conductor of length $\ell$ moving with velocity $v$ across a field $B$ has an e.m.f. induced along it, 

$$e=B\,\ell\,v .$$

 A conductor at radius $r$ on a shaft turning at $\dot\theta$ moves at $v=r\dot\theta$, so summing over the same $z$ conductors, 

<a id="eq:phi"></a>

$$\begin{equation}
  e_{b}=z B\ell r\,\dot\theta=K_{b}\,\dot\theta,
  \qquad K_{b}=z B\ell r,
  \qquad [K_{b}]=\mathrm{V}\,\mathrm{s}\,\mathrm{rad}^{-1}.
  \tag{17}
\end{equation}$$

 This is the **back e.m.f.**: it appears the moment the shaft moves, and by Lenz’s law it opposes the current that is driving the motion.

<figure id="fig:dcmotor" data-latex-placement="H">
<img src="../svg/week-01-notes-supp/fig09.svg" />
<figcaption><strong>Figure 8.</strong> The same conductors, the same field, the same geometry — read two ways. Because <span class="math inline arithmatex">\(zB\ell r\)</span> appears in both <a href="#eq:torqueconst">(16)</a> and <a href="#eq:emfconst">(17)</a>, <span class="math inline arithmatex">\(K_{t}\)</span> and <span class="math inline arithmatex">\(K_{b}\)</span> are not merely similar: in a consistent set of units they are the <em>same number</em>.</figcaption>
</figure>

##### Step 3 — why $K_{t}$ and $K_{b}$ are the same number

Comparing [(16)](#eq:torqueconst) and [(17)](#eq:emfconst), both constants equal $zB\ell r$. That is suggestive but it depends on an idealised geometry. The argument that does not is **conservation of energy**, and it takes two lines.

The electrical power that disappears from the armature circuit into electromechanical conversion is the power absorbed by the back e.m.f., $P_{\text{elec}}=e_{b}i_{a}$. The mechanical power delivered to the shaft is $P_{\text{mech}}=T_{m}\dot\theta$. Nothing else happens in between — copper loss is already accounted for by $R_{a}i_{a}^{2}$, and stored magnetic energy does not change in steady state — so the two are equal: 

$$e_{b}i_{a}=T_{m}\dot\theta
  \quad\Longrightarrow\quad
  (K_{b}\dot\theta)\,i_{a}=(K_{t}i_{a})\,\dot\theta
  \quad\Longrightarrow\quad
  \boxed{\;K_{t}=K_{b}\;}$$

 after cancelling $i_{a}\dot\theta$, which is legitimate for every operating point except the trivial one where the motor is doing nothing.

/// admonition | Key idea
    type: info

$K_{t}=K_{b}$ is a statement about *units*, not a coincidence. Check them: $\mathrm{N}\,\mathrm{m}\,\mathrm{A}^{-1}=\mathrm{J}\,\mathrm{A}^{-1}$ and $\mathrm{V}\,\mathrm{s}\,\mathrm{rad}^{-1}=\mathrm{J}\,\mathrm{C}^{-1}\cdot\mathrm{s}
=\mathrm{J}\,\mathrm{A}^{-1}$ (the radian being dimensionless). The two constants carry the same dimensions because they describe the same energy conversion seen from opposite ends. This is why a datasheet quoting $K_{t}=0.6\,\mathrm{N}\,\mathrm{m}\,\mathrm{A}^{-1}$ is also telling you $K_{b}=0.6\,\mathrm{V}\,\mathrm{s}\,\mathrm{rad}^{-1}$, and why a question that gives you one has given you both.

///

/// admonition | Common pitfall
    type: warning

The equality holds in **SI**. Datasheets often quote $K_{b}$ in volts per 1000 rpm and $K_{t}$ in ounce-inches per ampere, and in those units the two numbers are wildly different — which leads students to conclude the equality is false. Convert to N m A^−1^ and V s rad^−1^ first, then compare.

///

##### Step 4 — the back e.m.f. *is* the motor’s damping { #sss:dcdamping }

This is the step that makes the d.c. and a.c. servomotors one story rather than two, and it needs no transfer function at all.

Let the shaft turn steadily at $\dot\theta$, so the armature current has settled and the inductance has nothing to do. Kirchhoff round the armature circuit gives $v_{a}=R_{a}i_{a}+e_{b}$, hence $i_{a}=(v_{a}-K_{b}\dot\theta)/R_{a}$, and multiplying by $K_{t}$:

<a id="eq:synchro"></a>

$$\begin{equation}
  T_{m}=\underbrace{\frac{K_{t}}{R_{a}}\,v_{a}}_{\text{set by the input}}
       \;-\;\underbrace{\frac{K_{t}K_{b}}{R_{a}}\,\dot\theta}_{\text{opposes motion}} .
  \tag{18}
\end{equation}$$

Read [(18)](#eq:dctorquespeed) as a family of straight lines: torque against speed, one line per armature voltage, all with the *same* negative slope $K_{t}K_{b}/R_{a}$. A torque that grows more negative in proportion to speed is precisely what viscous friction does. So the back e.m.f. contributes an effective viscous damping coefficient $K_{t}K_{b}/R_{a}$, in parallel with whatever mechanical friction $b$ the bearings supply.

<figure id="fig:dcslope" data-latex-placement="H">
<img src="../svg/week-01-notes-supp/fig10.svg" />
<figcaption><strong>Figure 9.</strong> The armature-controlled d.c. motor’s torque–speed characteristic, <a href="#eq:dctorquespeed">(18)</a>. Raising the armature voltage lifts the line without tilting it. The negative slope is the back e.m.f. acting as viscous friction; compare Figure <a href="#fig:acslope">11</a>, where an a.c. servomotor achieves the same negative slope by a completely different mechanism.</figcaption>
</figure>

Two things follow immediately, without doing any more algebra.

- **A d.c. motor is self-damping.** Lower $R_{a}$ and the slope steepens: a low-resistance armature is a heavily damped one. Drive the same motor from a high-impedance (current) source instead and that damping disappears, because the current — and hence the torque — no longer responds to the back e.m.f. at all.

- **Stall torque and no-load speed follow from one line.** Setting $\dot\theta=0$ gives the stall torque $K_{t}v_{a}/R_{a}$; setting $T_{m}=0$ gives the no-load speed $v_{a}/K_{b}$. Those are the two numbers a catalogue quotes, and they fix the whole characteristic.

##### The transfer function, and where it is derived

Add the mechanical equation $T_{m}=J_{m}\ddot\theta_{m}+b\dot\theta_{m}$ and the armature inductance $L_{a}$, take Laplace transforms and eliminate $I_{a}(s)$, and the result is 

<a id="eq:linear"></a>

$$\begin{equation}
  \frac{\theta_{m}(s)}{V_{a}(s)}
     =\frac{K_{t}}{s\big[(R_{a}+L_{a}s)(J_{m}s+b)+K_{t}K_{b}\big]}
     \;\xrightarrow[\;L_{a}\to0\;]{}\;
     \frac{K_{m}}{s(\tau_{m}s+1)},
  \tag{19}
\end{equation}$$

 

$$K_{m}=\frac{K_{t}}{R_{a}b+K_{t}K_{b}},
  \qquad
  \tau_{m}=\frac{J_{m}R_{a}}{R_{a}b+K_{t}K_{b}} .$$

 Notice the denominator: $R_{a}b$ is the mechanical friction’s contribution and $K_{t}K_{b}$ is the electromechanical damping of §[2.1.4](#sss:dcdamping), appearing exactly where [(18)](#eq:dctorquespeed) says it should. In most servomotors $K_{t}K_{b}$ is the larger of the two, so the motor’s own back e.m.f. supplies most of its damping.

##### Field control, and why it is slower { #sss:field }

Hold the armature current constant at $I_{a}$ and vary the field instead. Now $B$ in [(16)](#eq:torqueconst) is proportional to the field current $i_{f}$, so 

$$T_{m}=K_{f}\,i_{f},\qquad
  v_{f}=R_{f}i_{f}+L_{f}\frac{\mathrm{d}i_{f}}{\mathrm{d}t},$$

 and combining these with $T_{m}=J\ddot\theta+b\dot\theta$ gives 

<a id="eq:torqueconst"></a>

$$\begin{equation}
  \frac{\theta(s)}{V_{f}(s)}
   =\frac{K_{f}}{s\,(R_{f}+L_{f}s)(Js+b)}
   =\frac{K}{s(\tau_{f}s+1)(\tau_{m}s+1)},
  \qquad \tau_{f}=\frac{L_{f}}{R_{f}},\ \ \tau_{m}=\frac{J}{b}.
  \tag{20}
\end{equation}$$

 Compare this with [(19)](#eq:dcm) and two differences stand out, both of them disadvantages.

- **There is no $K_{t}K_{b}$ term.** With the armature current forced constant, the back e.m.f. can no longer alter it, so the electromechanical damping of §[2.1.4](#sss:dcdamping) is gone and the motor is left with only its bearing friction $b$. The field-controlled motor is the more lightly damped machine.

- **There is an extra lag $\tau_{f}$.** The field winding is built for many turns and low current, so $L_{f}$ is large and $\tau_{f}$ is long. The armature circuit it replaced was fast enough that [(19)](#eq:dcm) routinely throws it away; the field circuit is not.

Its one advantage is power: the field carries a small current, so the amplifier driving it is cheap. Field control survives where that matters more than speed of response.

###### The amplidyne.

Before solid-state amplifiers, large d.c. systems were driven by an **amplidyne** — a cross-field d.c. machine with two brush sets $90^\circ$ apart, the quadrature pair short-circuited so that the machine amplifies twice within one frame (power gains of roughly $200$ then $50$, so about $10^{4}$ overall). It is obsolete, displaced by thyristor and IGBT drives, but it is all over older textbook problems and worth recognising. Nagrath & Gopal §4.3, p. 90.

#### 2.2. The a.c. (two-phase) servomotor

Preferred at low power, and the natural partner of a synchro error detector because the signals are already carrier-modulated a.c. It is rugged, light and brushless. Nagrath & Gopal §4.3, pp. 84–88.

##### The rotating field — and how it differs from the synchro’s { #sss:rotating }

Structurally it is a two-phase induction motor: two stator windings $90^\circ$ apart *in space*, excited by voltages $90^\circ$ apart *in time*. Sum the two m.m.f. vectors exactly as in §[1.2.3](#sss:rebuild), putting winding 1 along $\hat{u}(0)$ and winding 2 along $\hat{u}(90^\circ)$: 

<a id="eq:emfconst"></a>

$$\begin{equation}
  \mathbf{F}(t)=F_{m}\cos\omega t\;\hat{u}(0)
              + F_{m}\cos(\omega t-90^\circ)\;\hat{u}(90^\circ)
              = F_{m}\big(\cos\omega t,\;\sin\omega t\big).
  \tag{21}
\end{equation}$$

 The magnitude is $F_{m}$ at every instant, and the direction advances at $\omega$ radians per second. This is a **rotating field of constant magnitude**, turning at synchronous speed. It sweeps past the short-circuited rotor, induces currents in it, and drags it round — ordinary induction-motor action.

/// admonition | Key idea
    type: info

The synchro of §[1.2](#sec:synchro) and the two-phase motor use the *same* vector sum over stator coils. The only difference is how the coil currents are phased in time, and it changes everything:

|            | synchro stator           | two-phase motor                |
|:-----------|:-------------------------|:-------------------------------|
| coils      | three, $120^\circ$ apart | two, $90^\circ$ apart          |
| amplitudes | unequal, set by $\theta$ | equal                          |
| time phase | all identical            | $90^\circ$ apart               |
| resultant  | *stationary*, pulsating  | *rotating*, constant magnitude |
| tip traces | a straight line          | a circle                       |

///

Getting these two confused is the single most common error in this material.

<figure id="fig:loci" data-latex-placement="H">
<img src="../svg/week-01-notes-supp/fig11.svg" />
<figcaption><strong>Figure 10.</strong> The same vector sum, two different time phasings. In (a) the coil currents are in time quadrature and the resultant sweeps round at constant length; in (b) — the synchro of §<a href="#sec:synchro">1.2</a> — they are in time phase, and the resultant stands still along the direction <span class="math inline arithmatex">\(\theta\)</span> while its length pulsates through zero and reverses.</figcaption>
</figure>

###### Reversing it.

Feed the control phase at $+90^\circ$ instead of $-90^\circ$ and [(21)](#eq:rotfield) becomes 

$$\mathbf{F}(t)=F_{m}\big(\cos\omega t,\;-\sin\omega t\big):$$

 same constant magnitude, opposite direction of rotation. That is the entire steering mechanism of the machine. The *reference phase* is held at a fixed voltage, the *control phase* is driven by the servo amplifier, and the *sign* of the control signal — carried, as §[1.2.6](#sss:carrier) showed, in the phase of the carrier — decides which way the shaft turns. The error detector’s phase information is consumed here, by the motor itself.

##### Why the rotor must have a *high* resistance { #sss:highR }

Every ordinary induction motor is designed with rotor resistance as low as practicable, to keep the rotor copper loss down. The servomotor deliberately does the opposite. The reason is visible in the torque–slip relation.

For an induction machine with rotor resistance $R$ and standstill rotor reactance $X$, running at slip $s$, the standard approximate torque (neglecting stator impedance) is 

<a id="eq:dctorquespeed"></a>

$$\begin{equation}
  T\;\propto\;\frac{s\,R}{R^{2}+s^{2}X^{2}} .
  \tag{22}
\end{equation}$$

 Differentiate and set to zero: the maximum occurs at 

<a id="eq:dcm"></a>

$$\begin{equation}
  s_{\max}=\frac{R}{X},
  \qquad\text{and there}\qquad
  T_{\max}\propto\frac{1}{2X}
  \quad\text{--- independent of }R.
  \tag{23}
\end{equation}$$

 Raising the rotor resistance does not change how much torque the machine can produce; it changes *where* that maximum sits. And since slip runs from $s=1$ at standstill down to $s=0$ at synchronous speed, everything turns on whether $s_{\max}$ falls inside that interval:

- **Ordinary motor, $X/R$ large.** Then $s_{\max}=R/X$ is small — typically a few per cent — so the peak sits close to synchronous speed. Over the whole range from standstill up to $s_{\max}$, torque *rises* as the motor speeds up. That is a **positive** torque–speed slope.

- **Servomotor, $R\ge X$.** Then $s_{\max}\ge1$, so the peak lies at or beyond standstill and is never reached in normal running. Over the entire operating range torque falls monotonically as speed rises: the slope is **negative everywhere**.

There is a bonus. When $R\gg sX$ the denominator of [(22)](#eq:torqueslip) is dominated by $R^{2}$ and $T\propto s/R$ — torque becomes very nearly *linear* in slip, and therefore linear in speed. So the one design change buys both properties the control engineer needs: a negative slope, and a straight enough line to linearise about.

<figure id="fig:acslope" data-latex-placement="H">
<img src="../svg/week-01-notes-supp/fig12.svg" />
<figcaption><strong>Figure 11.</strong> Equation <a href="#eq:torqueslip">(22)</a> plotted for the two designs. The ordinary motor’s peak sits at <span class="math inline arithmatex">\(s_{\max}=R/X=0.2\)</span>, i.e. at 80% of synchronous speed, leaving the shaded region below it with a positive torque–speed slope. The servomotor’s peak is pushed out to <span class="math inline arithmatex">\(s_{\max}=3\)</span>, beyond standstill, so its whole characteristic falls — and it hugs the dashed straight line to within about 8%. Cf. Nagrath &amp; Gopal Fig. 4.4, p. 85.</figcaption>
</figure>

/// admonition | Common pitfall
    type: warning

A positive torque–speed slope is not merely inconvenient, it is *destabilising*. As [(25)](#eq:acm) below shows, the slope enters the model as a viscous friction $f$ added to the load’s own $f_{0}$. A positive slope makes $f$ negative, and if it outweighs $f_{0}$ the total damping goes negative — the $s$ coefficient of a second-order denominator changes sign, and the closed loop is unstable. The choice of rotor resistance, apparently a machine-design detail, reaches all the way into the stability of the control system.

///

##### Linearising the characteristic

The curves of Figure [11](#fig:acslope) are still not exactly straight, and their spacing with control voltage is not exactly uniform. But a servomotor in a position loop spends its life near zero speed and near zero control voltage, so linearise there. Torque depends on two variables, speed and the rms control voltage: $T_{m}=f(\dot\theta,E)$. Expand in a Taylor series about the operating point $(\dot\theta_{0},E_{0})$ and keep first-order terms: 

$$T_{m}=T_{m0}
    +\left.\frac{\partial T_{m}}{\partial E}\right|_{0}(E-E_{0})
    +\left.\frac{\partial T_{m}}{\partial\dot\theta}\right|_{0}
      (\dot\theta-\dot\theta_{0}),$$

 which in incremental notation is 

<a id="eq:fieldctl"></a>

$$\begin{equation}
  \Delta T_{m}=K\,\Delta E-f\,\Delta\dot\theta,
  \qquad
  K=\left.\frac{\partial T_{m}}{\partial E}\right|_{0},
  \qquad
  f=-\left.\frac{\partial T_{m}}{\partial\dot\theta}\right|_{0}.
  \tag{24}
\end{equation}$$

 The minus sign in the definition of $f$ is deliberate: the slope $\partial T_{m}/\partial\dot\theta$ is negative, so defining $f$ as its negative makes $f$ a positive number, and [(24)](#eq:aclin) then reads as “driving torque minus a friction torque”.

With a load of inertia $J$ and friction $f_{0}$, the torque balance is $\Delta T_{m}=J\Delta\ddot\theta+f_{0}\Delta\dot\theta$. Substituting [(24)](#eq:aclin), taking Laplace transforms and rearranging: 

<a id="eq:rotfield"></a>

$$\begin{equation}
  G_{m}(s)=\frac{\Delta\theta(s)}{\Delta E(s)}
   =\frac{K}{Js^{2}+(f_{0}+f)s}
   =\frac{K_{m}}{s(\tau_{m}s+1)},
  \qquad
  K_{m}=\frac{K}{f_{0}+f},\quad
  \tau_{m}=\frac{J}{f_{0}+f} .
  \tag{25}
\end{equation}$$

 In a position control system the operating point is $(\dot\theta_{0}=0,
E_{0}=0)$, so the increments are the quantities themselves and the $\Delta$s can be dropped.

###### Getting *K* and *f* from two tests.

The characteristic is fixed by two standard measurements at rated control voltage: the **stall torque** (rotor clamped, $\dot\theta=0$) and the **no-load speed** ($T_{m}=0$). The straight line joining them is the working approximation, so 

$$K\approx\frac{\text{stall torque at rated voltage}}
               {\text{rated control-phase voltage}},$$

 

$$f\approx\frac{\text{stall torque at rated voltage}}
               {\text{no-load speed at rated voltage}} .$$

 Nagrath adds a practical correction (§4.3, eq. 4.7, p. 88): in real servomotors the slope at low speed is nearer *half* the slope of that joining line, so for position-control work take $f\approx\tfrac{1}{2}\times(\text{stall torque}/\text{no-load speed})$.

##### The two motors are the same story { #sss:samething }

/// admonition | Key idea
    type: info

Compare [(18)](#eq:dctorquespeed) with [(24)](#eq:aclin). Both say *developed torque $=$ (a constant) $\times$ (the input) $-$ (a constant) $\times$ (speed)*, and in both the second constant is a viscous damping that the machine supplies to itself:

|  | d.c. servomotor | a.c. servomotor |
|:---|:---|:---|
| input | armature voltage $v_{a}$ | control-phase voltage $E$ |
| drive constant | $K_{t}/R_{a}$ | $K=\partial T_{m}/\partial E$ |
| damping | $K_{t}K_{b}/R_{a}$ | $f=-\partial T_{m}/\partial\dot\theta$ |
| its origin | back e.m.f. | negative torque–speed slope |
| result | $K_{m}/[s(\tau_{m}s+1)]$ | $K_{m}/[s(\tau_{m}s+1)]$ |

///

Two quite different machines arrive at the same transfer function because both are governed by the same balance: a driving torque proportional to the input, opposed by a resisting torque proportional to speed, working against inertia. The integrator comes from the fact that we want *position* out of a device that naturally produces *speed*. This is the shape the last section of the Week 1 notes is about.

#### 2.3. The stepper motor

A **stepper motor** converts a train of pulses into a train of discrete angular steps — one step per pulse. It is the actuator of incremental motion control: printers, tape and capstan drives, machine tools, plotters, 3-D printers. The common types are *variable reluctance* and *permanent magnet*; what follows is the variable-reluctance machine. Nagrath & Gopal §4.4, pp. 99–103.

The machine has $n$ stacks of stator and rotor on a common frame and shaft, both toothed with $T$ teeth of the same size. The stators are pulse-excited; the rotors carry no winding at all. Energise a stator stack and the rotor is pulled to the nearest **minimum-reluctance** position — the one where its teeth line up with that stack’s teeth.

##### Where the step angle comes from

The rotor teeth are aligned across every stack, so the rotor by itself has a single tooth pitch 

$$\lambda=\frac{360^\circ}{T} .$$

 If the stator stacks were also aligned with one another, energising any of them would pull the rotor to the same place and the machine could not step at all. So the stacks are built with their stator teeth offset successively by $\lambda/n$ — one $n$-th of a tooth pitch. Energise the next stack in the sequence and the nearest minimum-reluctance position is now one such offset away, so the rotor advances by exactly that much: 

<a id="eq:torqueslip"></a>

$$\begin{equation}
  \alpha=\frac{\lambda}{n}=\frac{360^\circ}{n\,T} .
  \tag{26}
\end{equation}$$

 For $n=3$ stacks and $T=12$ teeth, $\alpha=360/36=10{}^{\circ}$: thirty-six pulses per revolution. Note what [(26)](#eq:step) says about resolution — to make the steps finer you may either add teeth or add stacks, and adding teeth is by far the cheaper of the two.

<figure id="fig:stepper" data-latex-placement="H">
<img src="../svg/week-01-notes-supp/fig13.svg" />
<figcaption><strong>Figure 12.</strong> Developed (rolled-out) view of a three-stack variable-reluctance stepper. The rotor teeth line up across all three stacks; the stator stacks are offset from one another by a third of a tooth pitch. Energising <span class="math inline arithmatex">\(c\)</span>, then <span class="math inline arithmatex">\(a\)</span>, then <span class="math inline arithmatex">\(b\)</span> walks the rotor forward one <span class="math inline arithmatex">\(\alpha\)</span> at a time. Cf. Nagrath &amp; Gopal Figs. 4.18 and 4.20, pp. 100–101.</figcaption>
</figure>

##### Where the torque comes from

The rotor carries no current, so there is no $B\ell i$ force to appeal to. The torque is a **reluctance** torque, and it comes from the fact that the stator winding’s inductance depends on where the rotor is.

Assume the magnetic circuit is linear, so $L$ depends on rotor position only. The energy stored in the field is 

$$W=\tfrac{1}{2}L(\theta)\,i^{2},$$

 and the torque is the rate at which that stored energy changes with position at constant current, 

<a id="eq:smax"></a>

$$\begin{equation}
  T_{m}=\frac{\partial W}{\partial\theta}\bigg|_{i}
       =\tfrac{1}{2}\,i^{2}\,\frac{\mathrm{d}L}{\mathrm{d}\theta} .
  \tag{27}
\end{equation}$$

 Read that: *the rotor moves so as to increase the inductance*, which is the same thing as decreasing the reluctance — the qualitative rule stated above, now with a formula behind it.

For a toothed structure the inductance is a maximum when teeth align, a minimum a half-pitch away, and smooth in between, so it is an even, periodic function of $\theta$ with period $\lambda=360^\circ/T$: 

$$L(\theta)=L_{1}+L_{2}\cos T\theta .$$

 Substituting into [(27)](#eq:reluctorque), 

<a id="eq:aclin"></a>

$$\begin{equation}
  T_{m}=-\tfrac{1}{2}L_{2}T\,i^{2}(t)\,\sin T\theta
       =-K\,i^{2}(t)\,\sin T\theta .
  \tag{28}
\end{equation}$$

<figure id="fig:steptorque" data-latex-placement="H">
<img src="../svg/week-01-notes-supp/fig14.svg" />
<figcaption><strong>Figure 13.</strong> The static torque–angle curve <a href="#eq:steptorque">(28)</a> of one stack, for a fixed excitation current. The aligned position is stable — displace the rotor either way and the torque drives it back. The tooth-faces-slot position a half-pitch away is an equilibrium too, but an unstable one: any disturbance sends the rotor off to one of the neighbouring stable positions. Cf. Nagrath &amp; Gopal Fig. 4.19, p. 101.</figcaption>
</figure>

###### Why three phases are the minimum.

Directional control needs a pulse sequence that is different read forwards and backwards. With three stacks, $abcabc\ldots$ advances the rotor and $bacbac\ldots$ reverses it — two distinct sequences. With two, $ababab\ldots$ read backwards is $bababa\ldots$, which is the same cyclic sequence, so there is nothing to distinguish one direction from the other. *Directional control requires three or more phases.*

##### Why the stepper is not in the analysis weeks

Equation [(28)](#eq:steptorque) contains $i^{2}$ and $\sin T\theta$: it is nonlinear in the current *and* in the position, and no linearisation of it is useful over a whole step. Worse, the stator circuit equation itself carries a speed term, 

$$e(t)=Ri+\frac{\mathrm{d}}{\mathrm{d}t}\big[L(\theta)i\big]
      =\underbrace{Ri+L(\theta)\frac{\mathrm{d}i}{\mathrm{d}t}}_{\text{transformer e.m.f.}}
       +\underbrace{i\frac{\mathrm{d}L}{\mathrm{d}\theta}\dot\theta}_{\text{speed e.m.f.}},$$

 which multiplies two unknowns together. Stepper dynamics are solved numerically, and that is why the machine, useful as it is, does not appear in the analysis weeks of this unit.

Two consequences do matter for control, though.

- **The stepper is a digital actuator.** Shaft position is determined entirely by the pulse count, so an *open-loop* step servo can reach the accuracy of a closed-loop analogue system with no position sensor at all. This is the rare case where open loop is the right engineering answer, and it is worth holding on to as a counterexample to the general argument for feedback.

- **The price is skipped steps.** If pulses arrive faster than the rotor can settle into its lock position, or if it overshoots too far, a step is lost — and because nothing is measured, it is lost silently and permanently, and every subsequent position is wrong by $\alpha$. High-performance systems therefore close the loop after all, gating the pulse train from a position feedback signal.

### 3. Sensors: the tachogenerator { #sec:tacho }

A **tachogenerator** produces a voltage proportional to shaft speed: 

<a id="eq:acm"></a>

$$\begin{equation}
  v_{t}=K_{t}\,\dot\theta,
  \qquad [K_{t}]=\mathrm{V}\,\mathrm{s}\,\mathrm{rad}^{-1}.
  \tag{29}
\end{equation}$$

 It is the only sensor we look at in this survey.

/// admonition | Common pitfall
    type: warning

The symbol $K_{t}$ now means two different things. In §[2](#sec:actuators) it was the d.c. motor’s *torque* constant, in N m A^−1^; here it is the *tachometer* constant, in V s rad^−1^. This clash is in Nagrath and in most of the literature, so it is not worth inventing private notation to avoid — but read the units, not the letter. Confusingly, the tachometer constant has the same units as the motor’s back-e.m.f. constant $K_{b}$, and for good reason: §[3](#sec:tacho) is about to show that it is the same quantity.

///

#### 3.1. The d.c. tachogenerator: an equation we have already derived

A d.c. tachogenerator is a small permanent-magnet d.c. generator on the shaft. Its governing equation is [(17)](#eq:emfconst) — the back-e.m.f. relation of §[2.1.2](#sss:emfconst), with nothing changed but the name: 

$$e_{b}=K_{b}\dot\theta
  \qquad\text{becomes}\qquad
  v_{t}=K_{t}\dot\theta .$$

 There is no new physics here whatever. Every d.c. motor already generates a voltage proportional to its speed; the trouble is that it appears inside the armature circuit, in series with $R_{a}i_{a}$, where it cannot be measured without also measuring the current. A tachogenerator is simply that same conductors-cutting-flux effect given its own machine and its own terminals, so the speed signal comes out where an amplifier can use it. Its polarity follows the direction of rotation, so the sign of the speed survives. Its main limitation is ripple from commutation.

#### 3.2. The a.c. (drag-cup) tachogenerator

Where the loop is a carrier system, the tachometer must produce a carrier-modulated signal like everything else. The drag-cup tachometer does this, and it is worth following through because it is the third device in these notes built out of the same two ideas — coils in space quadrature, and a flux whose coupling depends on motion.

Two stator coils sit at right angles: a **reference** coil, excited from the carrier supply, and a **quadrature** coil, from which the output is taken. The rotor is a thin aluminium cup spinning in the air gap — a short-circuited secondary of very low inertia. With the shaft standing still, the two coils are in space quadrature and there is no coupling between them: the reference flux threads the quadrature coil edge-on and induces nothing. Rotation is what breaks that symmetry.

<figure id="fig:actacho" data-latex-placement="H">
<img src="../svg/week-01-notes-supp/fig15.svg" />
<figcaption><strong>Figure 14.</strong> The a.c. (drag-cup) tachometer. The cup is treated as two imaginary short-circuited conductor pairs. Pair <span class="math inline arithmatex">\((1,1&#39;)\)</span> sits <em>on</em> the reference axis, where the radial field is strongest, so it develops the largest speed voltage — and because a current loop’s magnetic axis is perpendicular to the line joining its two sides, the current it drives produces a flux along the <em>quadrature</em> axis, which is exactly what the output coil sees. Cf. Nagrath &amp; Gopal Fig. 4.7, p. 88.</figcaption>
</figure>

The chain has four links, and each is one line.

1.  **Reference flux.** The reference coil is driven from the carrier supply, $v_{r}=V_{r}\sin\omega_{c}t$. Since its resistance and leakage are small, essentially all of that voltage is absorbed by $N\,\mathrm{d}\phi/\mathrm{d}t$, so the flux *lags the voltage by $90^\circ$*: write it $\phi_{r}\cos\omega_{c}t$, pulsating along the reference axis.

2.  **Speed voltage in the cup.** Treat the cup as two imaginary short-circuited conductor pairs: $(1,1')$ sitting on the reference axis and $(2,2')$ a quarter-turn from it. The field crossing the gap is strongest — and most nearly radial — where it faces the reference axis, so it is pair $(1,1')$ that cuts the most flux as the cup turns. By the same $B\ell v$ law as §[2.1.2](#sss:emfconst), its speed voltage is proportional to the *product* of flux and speed: 

$$e_{1}\;\propto\;\big(\phi_{r}\cos\omega_{c}t\big)\,\dot\theta(t).$$

3.  **Quadrature flux.** The cup is short-circuited, so that voltage drives a current; with the cup’s reactance negligible the current is in phase with it. Now comes the geometric step: a current loop’s magnetic axis is *perpendicular* to the line joining its two sides, so a current in $(1,1')$ — which lie on the reference axis — produces a flux along the **quadrature** axis: 

$$\phi_{q}\;\propto\;\dot\theta(t)\,\cos\omega_{c}t .$$

 This is why the output coil has to be at right angles to the reference coil. At standstill the two are magnetically decoupled and the output is zero; rotation is the only thing that creates a flux along the axis the output coil can see.

4.  **Output.** The quadrature coil sees $\phi_{q}$ and responds to its rate of change: 

$$e_{q}\propto\frac{\mathrm{d}\phi_{q}}{\mathrm{d}t}
            \propto\underbrace{\ddot\theta\,\cos\omega_{c}t}_{\text{small}}
                  -\underbrace{\omega_{c}\,\dot\theta\sin\omega_{c}t}_{\text{dominant}} .$$

 If the shaft speed varies slowly compared with the carrier — the same condition as in §[1.2.6](#sss:carrier) — the first term is negligible against the second, and, absorbing the sign into the sense of the output winding, 

<a id="eq:step"></a>

$$\begin{equation}
            e_{q}(t)=K_{t}\,\dot\theta(t)\,\sin\omega_{c}t .
            \tag{30}
          
    \end{equation}$$

Note what happened to the phase along the way: the reference winding put the flux $90^\circ$ behind its excitation, and the output winding, by differentiating, put that $90^\circ$ straight back. The two cancel, so $e_{q}$ comes out *in phase with the carrier supply* — exactly like the synchro’s output [(15)](#eq:linear). That is not an accident of algebra but the reason the two devices can be summed in the same loop at all: fed from one carrier, their signals are commensurate, and the amplifier can add them without any phase-shifting network between.

So the a.c. tachometer, like the synchro pair, delivers a **suppressed-carrier** signal: amplitude proportional to speed, phase reversing with direction, and nothing at all at the output when the shaft is still. It plugs straight into a carrier loop without a demodulator, which is the point of building it this way. Its very low rotor inertia is the other advantage — a sensor that loads the shaft it is measuring is a poor sensor.

#### 3.3. What a tachometer is *for* { #sss:ratefb }

Tachometers are used in two quite different ways, and it is worth separating them.

1.  As the **sensor of a speed control loop**, where speed is the controlled variable. Unremarkable: it is the feedback element, doing what the potentiometer does in a position loop.

2.  As **rate feedback** inside a *position* loop, where the tachometer signal is fed back through an inner loop that the outer position loop knows nothing about. This is the interesting one, and it is the first compensator you meet in this unit.

Take Nagrath’s a.c. position control system (§4.3, p. 96): synchro pair of sensitivity $K_{s}$, amplifier $K_{a}$, a.c. servomotor $K_{m}/[s(\tau_{m}s+1)]$, gearing $n$, and a tachometer of constant $K_{t}$ feeding back around the motor. Work inwards. The inner loop, from amplifier input $u$ to motor shaft $\theta_{m}$, closes to 

$$\frac{\theta_{m}}{u}
   =\frac{K_{a}K_{m}}{s(\tau_{m}s+1)+K_{a}K_{m}K_{t}s}
   =\frac{K_{a}K_{m}}{s\big(\tau_{m}s+1+K_{a}K_{m}K_{t}\big)} ,$$

 and closing the outer loop around that, with $\theta_{c}=n\theta_{m}$ and $u=K_{s}(\theta_{r}-\theta_{c})$, gives 

<a id="eq:reluctorque"></a>

$$\begin{equation}
  \frac{\theta_{c}(s)}{\theta_{r}(s)}
   =\frac{nK_{a}K_{m}K_{s}}
         {\tau_{m}s^{2}+\big(1+K_{a}K_{m}K_{t}\big)s+nK_{a}K_{m}K_{s}} .
  \tag{31}
\end{equation}$$

/// admonition | Key idea
    type: info

Look at where $K_{t}$ appears in [(31)](#eq:ratefb): in the coefficient of $s$, and *nowhere else*. Comparing with the standard form $\omega_{n}^{2}/(s^{2}+2\zeta\omega_{n}s+\omega_{n}^{2})$, 

$$\omega_{n}=\sqrt{\frac{nK_{a}K_{m}K_{s}}{\tau_{m}}},
  \qquad
  \zeta=\frac{1+K_{a}K_{m}K_{t}}{2\sqrt{\tau_{m}nK_{a}K_{m}K_{s}}} .$$

 The natural frequency does not contain $K_{t}$, and neither does the d.c. gain, which is $1$ whatever $K_{t}$ is. So rate feedback buys damping **and changes nothing else**: same speed of response, same steady-state accuracy, less overshoot. That is an unusually clean trade, and it is why tachometer feedback is the standard first move when a position servo rings.

///

/// admonition | Worked example 3.1 — what rate feedback buys
    type: example

A position servo has $\tau_{m}=0.2\,\mathrm{s}$, $K_{a}K_{m}=20$ and $nK_{s}=1$.

**Without the tachometer** ($K_{t}=0$), [(31)](#eq:ratefb) becomes 

$$\frac{\theta_{c}}{\theta_{r}}=\frac{20}{0.2s^{2}+s+20}
   =\frac{100}{s^{2}+5s+100},$$

 so $\omega_{n}=10\,\mathrm{rad}\,\mathrm{s}^{-1}$ and $2\zeta\omega_{n}=5$, giving $\zeta=0.25$. The step response overshoots by $\exp\!\big(-\pi\zeta/\sqrt{1-\zeta^{2}}\big)=44\%$ and takes about 1.6 s to settle within 2%. Usable, but it rings badly.

**With a tachometer** of $K_{t}=0.1\,\mathrm{V}\,\mathrm{s}\,\mathrm{rad}^{-1}$, the $s$ coefficient becomes $1+K_{a}K_{m}K_{t}=1+20(0.1)=3$: 

$$\frac{\theta_{c}}{\theta_{r}}=\frac{20}{0.2s^{2}+3s+20}
   =\frac{100}{s^{2}+15s+100},$$

 so $\omega_{n}$ is unchanged at 10 rad s^−1^ while $\zeta$ rises to $0.75$. Overshoot falls to $2.8\%$ and the settling time to about 0.53 s.

**Read the numbers carefully.** The response got faster *and* better damped, which sounds like something for nothing — but $\omega_{n}$ did not change. What changed is that the old response wasted its speed on oscillation. And the final value is exactly $1$ in both cases, so the added feedback has cost no steady-state accuracy at all.

///

<figure id="fig:ratefb" data-latex-placement="H">
<img src="../svg/week-01-notes-supp/fig16.svg" />
<img src="../svg/week-01-notes-supp/fig17.svg" />
<figcaption><strong>Figure 15.</strong> Rate feedback in a position servo, and what it does. The tachometer signal never reaches the outer summing junction, so it cannot affect the steady-state error; it acts only on the motor’s effective damping. Both responses have the same natural frequency and the same final value. Cf. Nagrath &amp; Gopal Fig. 4.14, p. 97.</figcaption>
</figure>

You will meet this idea again as a design tool in Week 9, and study it properly in FEE3412. Notice one thing about it now, though: the inner loop feeds back a signal proportional to $s\theta_{m}$ — the *derivative* of the output. Anticipating where the output is heading, rather than only where it is, is what supplies the damping. That is the whole idea behind the derivative term in a PID controller, met here in hardware before it is met as an algorithm.

#### Summary of the derivation { #summary-of-the-derivation-1 }

/// admonition | Key idea
    type: info

Each equation in §§[2](#sec:actuators)–[3](#sec:tacho), and where it came from:

clP6.5cm Eq. & Result & Origin<br>
[(16)](#eq:torqueconst) & $T_{m}=K_{t}i_{a}$, $K_{t}=zB\ell r$ & force $B\ell i$ on $z$ conductors at radius $r$<br>
[(17)](#eq:emfconst) & $e_{b}=K_{b}\dot\theta$, $K_{b}=zB\ell r$ & e.m.f. $B\ell v$ in the same conductors<br>
— & $K_{t}=K_{b}$ & power balance $e_{b}i_{a}=T_{m}\dot\theta$<br>
[(18)](#eq:dctorquespeed) & $T_{m}=\frac{K_{t}}{R_{a}}v_{a}-\frac{K_{t}K_{b}}{R_{a}}\dot\theta$ & KVL at steady speed; the slope is damping<br>
[(20)](#eq:fieldctl) & two lags, no $K_{t}K_{b}$ & fixing $i_{a}$ removes the back-e.m.f. path<br>
[(21)](#eq:rotfield) & $\mathbf{F}=F_{m}(\cos\omega t,\sin\omega t)$ & two coils $90^\circ$ apart in space *and* time<br>
[(23)](#eq:smax) & $s_{\max}=R/X$, $T_{\max}$ independent of $R$ & maximising [(22)](#eq:torqueslip) over slip<br>
[(24)](#eq:aclin) & $\Delta T_{m}=K\Delta E-f\Delta\dot\theta$ & first-order Taylor expansion of $T_{m}(\dot\theta,E)$<br>
[(25)](#eq:acm) & $K_{m}/[s(\tau_{m}s+1)]$ & [(24)](#eq:aclin) against inertia and friction<br>
[(26)](#eq:step) & $\alpha=360^\circ/(nT)$ & stacks offset by one $n$-th of a tooth pitch<br>
[(28)](#eq:steptorque) & $T_{m}=-Ki^{2}\sin T\theta$ & $\tfrac{1}{2}i^{2}\,\mathrm{d}L/\mathrm{d}\theta$ with $L=L_{1}+L_{2}\cos T\theta$<br>
[(30)](#eq:actacho) & $e_{q}=K_{t}\dot\theta\sin\omega_{c}t$ & speed voltage in the cup $\to$ quadrature flux $\to$ output coil<br>
[(31)](#eq:ratefb) & $K_{t}$ only in the $s$ coefficient & closing the inner loop before the outer one<br>

///

#### Check yourself { #check-yourself-1 }

1.  A datasheet gives a motor’s torque constant as 0.45 N m A^−1^ but does not mention the back-e.m.f. constant. What is it, and how do you know?

2.  Why does forcing the armature current constant (field control) destroy the motor’s electromechanical damping? Answer in terms of [(18)](#eq:dctorquespeed), not in terms of the transfer function.

3.  Both the synchro stator and the two-phase servomotor stator produce a resultant field by adding coil m.m.f.s. One field rotates and the other does not. What exactly is different?

4.  Show that increasing the rotor resistance of an induction motor does not increase its maximum torque. Where does the maximum go instead?

5.  A three-stack stepper is required to have a step angle of $2^\circ$. How many rotor teeth does it need? A rival design keeps $T=12$ and reaches the same step angle by adding stacks instead — how many stacks would that take, and why is it not done that way?

6.  In [(31)](#eq:ratefb), what happens to the steady-state output if $K_{t}$ is doubled? Explain your answer without computing anything.

7.  The reference winding of an a.c. tachometer puts the flux $90^\circ$ behind its excitation, yet the output [(30)](#eq:actacho) comes out in phase with that excitation. Where did the $90^\circ$ go, and why does it matter for a loop that also contains a synchro?

### 4. Hydraulic power elements { #sec:hydraulics }

Where the load is large, hydraulics win. A hydraulic motor delivers far more power for its size than an electric motor, and hydraulic components are fast and very stiff under load — push against a hydraulic ram and it does not yield the way a spring does. Set against that: leaks, sealing against contaminated oil, noise, sluggishness when the oil is cold and thick, and lines that are far less flexible than a cable. Typical uses are power steering and brakes, ship steering gear, large machine tools, aircraft flight controls and excavators. Nagrath §4.5, p. 104.

Hydraulic output devices split by the motion they produce: **rotary output** from a *hydraulic motor* (what the syllabus calls a “rotary actuator”), and **translational output** from a *hydraulic linear actuator* — a cylinder or ram. Both stories below end at the same place:

1.  Write a flow balance and a force (or torque) balance for the device (§[4.1.1](#sss:swashplate), §[4.3](#sss:cylinder)).

2.  Eliminate the pressure between them.

3.  Discover, again, the shape $K/[s(\tau s+1)]$ that has now appeared for the d.c. servomotor [(19)](#eq:dcm), the a.c. servomotor [(25)](#eq:acm), and every hydraulic actuator in this section — and see *why* it keeps appearing (the pitfall at the end of §[4.3](#sss:cylinder)).

#### 4.1. Pump–motor transmission { #sec:pumpmotor }

The classical arrangement is a **variable-stroke pump** driving a **fixed-stroke motor**. Both are axial-piston machines: several pistons, arranged in a circle in a rotating cylinder block, bear on a stationary *swash plate* through shoes. Figure [16](#fig:swashplate) shows the idea. With the swash plate perpendicular to the shaft (the dashed “neutral” position) a piston’s distance to the plate does not change as the block turns, so no piston reciprocates and no oil is pumped. Tilt the plate through the **stroke angle** $x$ and that distance now varies once per revolution: as a piston’s bore turns past the plate, it is first pushed in and then drawn back out, once per turn, so it pumps. Reversing the tilt reverses which side pumps and which side returns, and hence reverses the motor. One mechanical variable, the stroke angle $x$, controls everything — flow rate, direction, motor speed.

<figure id="fig:swashplate" data-latex-placement="H">
<img src="../svg/week-01-notes-supp/fig18.svg" />
<figcaption><strong>Figure 16.</strong> Axial-piston pump (schematic, one representative piston pair). As the block rotates, a piston whose bore is on the side where the tilted plate sits <em>closer</em> is pushed in; half a turn later, on the side where the plate is <em>farther</em>, the same piston is drawn back out. That reciprocation is the pumping action, and its amplitude — hence the flow — is set by the stroke angle <span class="math inline arithmatex">\(x\)</span>. A fixed-stroke motor runs the same machine in reverse: fixed <span class="math inline arithmatex">\(x\)</span>, oil in, shaft out. Cf. Nagrath &amp; Gopal §4.5, p. 104.</figcaption>
</figure>

##### From two balances to one transfer function { #sss:swashplate }

Five relations, none of them more than a statement that something is proportional to something else, are all the model needs.

**Flow.** The pump delivers oil at a rate set by the stroke angle; the motor swallows oil at a rate set by its own speed; and real oil is not perfectly contained, so a fraction leaks past the pistons in proportion to the pressure drop across them, and a further fraction goes into compressing the oil itself, in proportion to how fast the pressure is changing: 

$$q_{p}=K_{p}x, \qquad q_{m}=K_{m}\dot\theta, \qquad
  q_{\ell}=K_{\ell}p, \qquad q_{c}=K_{c}\dot p .$$

 Continuity says the pump’s output has to go *somewhere*: 

<a id="eq:steptorque"></a>

$$\begin{equation}
  q_{p}=q_{m}+q_{\ell}+q_{c}.
  \tag{32}
\end{equation}$$

**Torque.** The motor develops a torque in proportion to the pressure across it, and that torque drives the load’s inertia and friction: 

<a id="eq:tacho"></a>

$$\begin{equation}
  T_{m}=K_{T}p=J\ddot\theta+f\dot\theta .
  \tag{33}
\end{equation}$$

Two balances, one unknown pressure $p$ to eliminate between them. Before doing the algebra, drop the compressibility term: $K_{c}\dot p$ is small compared with $K_{m}\dot\theta$ because oil is nearly incompressible, and keeping it would add a third pole to what is about to become a second-order system — correct, but a complication this course does not need. (If it mattered, it would show up as a very fast additional lag; [(32)](#eq:hydcontinuity) shows exactly where to put it back.) With $q_{c}$ dropped, solve [(33)](#eq:hydtorque) for $p=(J\ddot\theta+f\dot\theta)/K_{T}$ and substitute into [(32)](#eq:hydcontinuity): 

$$K_{p}x = K_{m}\dot\theta + \frac{K_{\ell}}{K_{T}}\bigl(J\ddot\theta+f\dot\theta\bigr)
  = \frac{K_{\ell}J}{K_{T}}\ddot\theta + \left(K_{m}+\frac{K_{\ell}f}{K_{T}}\right)\dot\theta .$$

 Take Laplace transforms and divide through by the coefficient of $s\,\Theta$: 

<a id="eq:actacho"></a>

$$\begin{equation}
  G(s)=\frac{\Theta(s)}{X(s)}=\frac{K}{s(\tau s+1)},
  \qquad
  K=\frac{K_{p}}{K_{m}+K_{\ell}f/K_{T}},
  \qquad
  \tau=\frac{K_{\ell}J}{K_{T}K_{m}+K_{\ell}f} .
  \tag{34}
\end{equation}$$

 The same shape as [(19)](#eq:dcm) and [(25)](#eq:acm) — and for the same reason: $x$ commands a *flow*, flow drives a *speed*, and the output of interest is the *position* that speed integrates to.

/// admonition | Key idea
    type: info

$K_{T}$ and $K_{m}$ look like two independent constants, but they are not, and the argument is exactly the one that gave $K_{t}=K_{b}$ for the d.c. motor in §[2.1.1](#sss:torqueconst). An ideal (lossless) hydraulic motor converts flow power to mechanical power with nothing wasted: $p\,q_{m}=T_{m}\dot\theta$. Substitute $q_{m}=K_{m}\dot\theta$ and $T_{m}=K_{T}p$: 

$$p\,K_{m}\dot\theta = K_{T}p\,\dot\theta \quad\Longrightarrow\quad K_{T}=K_{m}.$$

 A hydraulic motor’s torque constant and its volumetric displacement are the same number, for the same reason a d.c. motor’s torque constant and back-e.m.f. constant are the same number: power balance, not coincidence. With $K_{T}=K_{m}$, [(34)](#eq:hyd) simplifies to $K=K_{p}K_{m}/(K_{m}^{2}+K_{\ell}f)$ and $\tau=K_{\ell}J/(K_{m}^{2}+K_{\ell}f)$.

///

#### 4.2. Valve control { #sec:valve }

Instead of varying the pump stroke, hold the supply pressure constant and throttle the flow with a **spool valve**, Figure [17](#fig:spool). The spool is far lighter than a pump’s stroke mechanism, so its time constants are much smaller and the whole system responds much faster — the cost of that speed is that valve flow is genuinely nonlinear: flow through a sharp-edged orifice goes as $\sqrt{\Delta p}$, not as $\Delta p$. Writing 

<a id="eq:ratefb"></a>

$$\begin{equation}
  q = K_{1}x - K_{2}p
  \tag{35}
\end{equation}$$

 is therefore a *linearisation* about the neutral operating point — valid for small spool displacements, invalid for large ones — built by the same first-order Taylor-expansion technique used for the a.c. servomotor’s torque–speed surface in §[2.2.2](#sss:highR).

A **three-way** valve has one supply port, one sump port and one service port; a **four-way** valve has two service ports and can drive a double-acting cylinder in both directions, which is what Figure [17](#fig:spool) shows. At neutral, $x=0$, both service ports are blocked. Move the spool one way and the supply connects to one side of the piston while the other side drains to sump; move it the other way and the connections swap.

<figure id="fig:spool" data-latex-placement="H">
<img src="../svg/week-01-notes-supp/fig19.svg" />
<figcaption><strong>Figure 17.</strong> Four-way spool valve controlling a double-acting power cylinder — a hydraulic linear actuator. Spool displacement <span class="math inline arithmatex">\(x\)</span> admits high-pressure oil to one side of the piston and vents the other to sump; the differential pressure drives the load a distance <span class="math inline arithmatex">\(y\)</span>. Cf. Nagrath &amp; Gopal Fig. 4.27, p. 111.</figcaption>
</figure>

#### 4.3. The linear actuator (cylinder) { #sss:cylinder }

Three equations describe Figure [17](#fig:spool) completely: the linearised valve relation [(35)](#eq:valve); continuity, with the flow into the cylinder equal to the piston’s swept-volume rate, $q=A\dot y$; and the force balance on the load, driven by the pressure difference acting on the piston area $A$, 

$$Ap = M\ddot y + f\dot y .$$

 Eliminate $p$ first (solve the force balance for it) and substitute into the valve relation to eliminate $q$ as well: 

$$A\dot y = K_{1}x - K_{2}\left(\frac{M\ddot y+f\dot y}{A}\right).$$

 Multiply through by $A$, collect the $\ddot y,\dot y$ terms, and take Laplace transforms: 

$$K_{1}Ax = \bigl(A^{2}+K_{2}f\bigr)s\,y + K_{2}M\,s^{2}y
  = s\,y\bigl[K_{2}M s + \bigl(A^{2}+K_{2}f\bigr)\bigr] .$$

 Divide through by $A^{2}+K_{2}f$: 

<a id="eq:hydcontinuity"></a>

$$\begin{equation}
  \frac{Y(s)}{X(s)}=\frac{K}{s(\tau s+1)},
  \qquad
  K=\frac{AK_{1}}{A^{2}+K_{2}f},
  \qquad
  \tau=\frac{MK_{2}}{A^{2}+K_{2}f} .
  \tag{36}
\end{equation}$$

 Again the same shape. Leakage past the piston seal ($K_{2}$) is usually small enough that $K_{2}f\ll A^{2}$, and then [(36)](#eq:cyl) collapses to the tidier $K\approx K_{1}/A$, $\tau\approx MK_{2}/A^{2}$ quoted in the main notes — but “usually small enough” is a claim to check, not to assume, which is exactly what Worked example 4.1 does.

/// admonition | Common pitfall
    type: warning

Note where the $1/s$ comes from. It is *not* an approximation, and it is not the load’s inertia — inertia is what supplies the $(\tau s+1)$ lag, not the integrator. Flow into a cylinder sets the piston’s *velocity*, so position is the integral of that velocity. **Any** actuator whose input commands a rate — valve opening $\to$ velocity, armature voltage $\to$ speed, pump stroke $\to$ motor speed, field current $\to$ (§[2.1.6](#sss:field)) — carries a free integrator whenever the output of interest is position. Once you see it this way, you stop needing to re-derive it for every new actuator: check what the input commands, and the $1/s$ either has to be there or it does not.

///

/// admonition | Worked example 4.1 — how good is $K\approx K_{1}/A$?
    type: example

A cylinder has piston area $A=5e-3\,\mathrm{m}^{2}$, valve gain $K_{1}=0.025\,\mathrm{m}^{2}\,\mathrm{s}^{-1}$, combined leakage and compressibility coefficient $K_{2}=8.33e-9\,\mathrm{m}^{3}\,\mathrm{s}^{-1}\,\mathrm{pascal}^{-1}$, load mass $M=20\,\mathrm{k}\,\mathrm{g}$ and friction $f=150\,\mathrm{N}\,\mathrm{s}\,\mathrm{m}^{-1}$.

*Exact values, from [(36)](#eq:cyl):* 

$$A^{2}=2.5e-5\,\mathrm{m}\,\mathrm{tothe}\,\mathrm{{4}}, \qquad
  K_{2}f=1.25e-6\,\mathrm{m}^{3}\,\mathrm{pascal}^{-1}
  \;\Longrightarrow\; \frac{K_{2}f}{A^{2}}=5.0\%.$$

 

$$K=\frac{AK_{1}}{A^{2}+K_{2}f}=4.76\,\mathrm{s}^{-1},
  \qquad
  \tau=\frac{MK_{2}}{A^{2}+K_{2}f}=6.35\,\mathrm{m}\,\mathrm{s}.$$

 *Approximate value:* $K\approx K_{1}/A=5.00\,\mathrm{s}^{-1}$ — 5.0% high, the same 5.0% by which $K_{2}f$ falls short of $A^{2}$ (the two percentages are the same number: $K/K_{\text{approx}}=A^{2}/(A^{2}+K_{2}f)$). For this seal, the shortcut is good to one part in twenty — fine for a first design pass, worth checking against the exact formula before a report goes out. Note also how fast this actuator is: $\tau\approx6\,\mathrm{m}\,\mathrm{s}$, two orders of magnitude faster than the $\tau_{m}=0.2\,\mathrm{s}$ motor of Worked example 3.1 — exactly the speed advantage valve control was built to buy.

///

### 5. Pneumatic power elements { #sec:pneumatics }

Pneumatic systems use air instead of oil. Air is non-inflammable, intrinsically safe, and its viscosity is negligible and barely changes with temperature the way hydraulic oil’s does. The price is that air is **compressible**, so pneumatic systems carry a substantial compressibility flow and are characterised by **longer time delays** — the reason they dominate in *process* control, where the plant itself is slow, and are rare wherever speed matters. Nagrath §4.6, p. 116.

Four devices make up a pneumatic control chain, each converting one signal into the next: a mechanical input becomes a pressure (bellows or flapper–nozzle), a small pressure signal becomes a large one (the relay), and a pressure becomes a mechanical output again (the diaphragm actuator). Three of the four are pure algebra; only the last needs a differential equation.

#### 5.1. Bellows { #sss:bellows }

A hollow chamber with thin corrugated side walls and flat end faces behaves as a spring. A pressure difference $\Delta P$ across the end faces (area $A$) produces a separating force $(\Delta P)A$; the corrugated walls produce a restoring force $K\Delta x$ proportional to the displacement. At equilibrium these balance, $(\Delta P)A = K\Delta x$, so 

<a id="eq:hydtorque"></a>

$$\begin{equation}
  \frac{\Delta X(s)}{\Delta P(s)}=\frac{A}{K}.
  \tag{37}
\end{equation}$$

 A pure gain, no dynamics at all — pressure in, displacement out, instantly. (A real bellows does have some mass and some air compressibility inside it, which would add a fast second-order lag; at the frequencies this course works with, that lag is negligible next to everything else in the loop, so [(37)](#eq:bellows) is taken as exact.)

#### 5.2. The flapper–nozzle valve { #sss:flappergain }

The key pneumatic *sensing* element, and the pneumatic analogue of the potentiometer or the synchro: it turns a small mechanical displacement into an electrical-strength — here, pneumatic-strength — signal. Air at constant supply pressure $P_{s}$ passes through a fixed *orifice* and out of a *nozzle*. A pivoted *flapper* sits a distance $e$ in front of the nozzle, Figure [18](#fig:flapper). Move the flapper closer and the escape route narrows, so back pressure builds up in the chamber between orifice and nozzle and $P_{b}$ rises towards $P_{s}$; move it away and the restriction eases and $P_{b}$ falls towards ambient.

<figure id="fig:flapper" data-latex-placement="H">
<img src="../svg/week-01-notes-supp/fig20.svg" />
<figcaption><strong>Figure 18.</strong> Flapper–nozzle valve. Small movements of the flapper produce large changes in back pressure — a high-gain displacement-to-pressure transducer. Cf. Nagrath &amp; Gopal Fig. 4.34, p. 117.</figcaption>
</figure>

The lever arms $a$ (pivot to nozzle) and $b$ (pivot to input point) fix the gap in terms of the input displacement, $e=[a/(a+b)]x$: it is the same lever-arm bookkeeping used for any pivoted linkage, nothing pneumatic about it yet. What *is* pneumatic is the characteristic of $P_{b}$ against $e$: it is strongly nonlinear over its full range (as $e\to 0$ the nozzle seals and $P_{b}\to P_{s}$; as $e$ grows large, $P_{b}$ saturates at the value set by the orifice alone), but it has one steep, nearly straight region in between, and that is the region the device is operated in. Writing $K$ for the local slope $\mathrm{d}P_{b}/\mathrm{d}e$ there (negative: closing the gap raises the pressure) and combining it with the lever-arm relation, 

<a id="eq:hyd"></a>

$$\begin{equation}
  \frac{\Delta P_{b}(s)}{\Delta X(s)}=\left(\frac{a}{a+b}\right)K,
  \qquad K<0.
  \tag{38}
\end{equation}$$

 $K$ is large — typically a fraction of a millimetre of flapper travel spans the whole working range of $P_{b}$ — which is exactly what makes the device useful as a sensor: it turns a mechanical signal too small to measure any other way into a pressure signal that is easy to measure and to act on.

#### 5.3. The pneumatic relay { #sss:relaygain }

Keeping the flapper motion inside the linear region of Figure [18](#fig:flapper) also keeps the output pressure swing small, so a pneumatic *power amplifier* — the **relay** — is cascaded after it. Figure [19](#fig:relay) shows the idea: the back pressure $P_{b}$ acts on a small bellows, which positions a ball between two seats. Seated on the *upper* seat, the ball blocks the vent to atmosphere, so supply air fills the output line and the output pressure $P$ rises to $P_{s}$; seated on the *lower* seat, the ball blocks the supply, so the output vents to atmosphere and $P$ falls towards zero. Moving the flapper *away* from the nozzle in Figure [18](#fig:flapper) *drops* $P_{b}$ (less restriction, air escapes more freely); the relay bellows then contracts, the ball rises off the lower seat towards the upper one, the vent path closes, and $P$ *rises*. The relay therefore inverts sign as well as amplifying: raising $x$ lowers $P_{b}$ ([(38)](#eq:flapper), $K<0$) but raises $P$, so overall 

<a id="eq:valve"></a>

$$\begin{equation}
  \frac{\Delta P(s)}{\Delta X(s)}=\left(\frac{a}{a+b}\right)K, \qquad K>0.
  \tag{39}
\end{equation}$$

 Nothing here needs a new constant: the relay’s job is to reproduce $P_{b}$’s *shape* at supply-line power, and the two sign flips — flapper-to-$P_b$ negative, relay negative again — cancel, so [(39)](#eq:relay) uses the same magnitude $|K|$ and lever ratio as [(38)](#eq:flapper).

<figure id="fig:relay" data-latex-placement="H">
<img src="../svg/week-01-notes-supp/fig21.svg" />
<figcaption><strong>Figure 19.</strong> Pneumatic relay (power amplifier), schematic. The flapper’s back pressure <span class="math inline arithmatex">\(P_b\)</span> positions a lightweight ball between a supply seat and a vent seat; whichever seat it leaves open decides whether the output line fills from supply or empties to atmosphere. Output pressure swings over the full supply range for a very small ball travel, and the sign is inverted relative to <span class="math inline arithmatex">\(P_b\)</span>.</figcaption>
</figure>

#### 5.4. The pneumatic (diaphragm) actuator { #sss:diaphragm }

Most pneumatic control systems need a translational output, and this is the device that supplies it. A diaphragm of area $A$, Figure [20](#fig:pneuact), is exposed to the controlled pressure $P$ and moves a stem against a **return spring** of stiffness $K$; the load contributes mass $M$ and friction $f$. Unlike the bellows of §[5.1](#sss:bellows), here the moving mass is large enough, and the motion fast enough, that inertia cannot be dropped from the force balance: 

$$A\,\Delta P = M\Delta\ddot y + f\Delta\dot y + K\Delta y .$$

 

<a id="eq:cyl"></a>

$$\begin{equation}
  \frac{\Delta Y(s)}{\Delta P(s)}=\frac{A}{Ms^{2}+fs+K}.
  \tag{40}
\end{equation}$$

<figure id="fig:pneuact" data-latex-placement="H">
<img src="../svg/week-01-notes-supp/fig22.svg" />
<figcaption><strong>Figure 20.</strong> Pneumatic diaphragm actuator. Unlike the hydraulic cylinder, the spring gives it a definite equilibrium position for each pressure — so its transfer function <a href="#eq:pneuact">(40)</a> is second order with <em>no</em> free integrator. Cf. Nagrath &amp; Gopal Fig. 4.37, p. 119.</figcaption>
</figure>

/// admonition | Common pitfall
    type: warning

Compare [(40)](#eq:pneuact) directly with the hydraulic cylinder, [(36)](#eq:cyl). The cylinder has a free $1/s$; the spring-loaded diaphragm does not. The difference is exactly one part, the spring, but its consequence is not small: with a spring present, a *constant* pressure gives a *constant position* (the spring force balances it at a definite displacement); without one, a constant flow gives a constant *velocity*, and position keeps growing for as long as the pressure is applied. Read the physics, not the picture — both figures show a piston in a cylinder pushed by a fluid, and yet one integrates and the other does not.

///

/// admonition | Worked example 5.1 — sizing a diaphragm actuator's response
    type: example

A diaphragm actuator has area $A=0.01\,\mathrm{m}^{2}$, spring stiffness $K=40000\,\mathrm{N}\,\mathrm{m}^{-1}$, moving mass $M=1\,\mathrm{k}\,\mathrm{g}$ and friction $f=240\,\mathrm{N}\,\mathrm{s}\,\mathrm{m}^{-1}$, driving a pneumatic control valve. Write [(40)](#eq:pneuact) in standard second-order form, 

$$\frac{\Delta Y(s)}{\Delta P(s)}=\frac{A/K}{s^{2}/\omega_{n}^{2}+2\zeta s/\omega_{n}+1},
  \qquad
  \omega_{n}=\sqrt{\frac{K}{M}}, \qquad \zeta=\frac{f}{2\sqrt{KM}}.$$

 Numerically, $\omega_{n}=\sqrt{40000/1}=200\,\mathrm{rad}\,\mathrm{s}^{-1}$ and $\zeta=240/(2\sqrt{40000})=0.60$: underdamped, as a control-valve actuator with some mechanical damping typically is. The steady-state gain is $A/K=2.5e-7\,\mathrm{m}\,\mathrm{pascal}^{-1}$, so a 40 kPa step in controlled pressure — a normal swing for a process instrument — drives the stem $\Delta y_{ss}=A/K\times40000\,\mathrm{pascal}=10\,\mathrm{m}\,\mathrm{m}$ in steady state. From $\zeta=0.6$, the standard second-order formulas (Week 5) give 

$$\%\text{OS}=100\,e^{-\pi\zeta/\sqrt{1-\zeta^{2}}}=9.5\%,
  \qquad
  t_{s}(2\%)\approx\frac{4}{\zeta\omega_{n}}=33\,\mathrm{m}\,\mathrm{s}.$$

 Figure [21](#fig:diaphragmstep) shows the response. The whole transient is over in about 50 ms — consistent with §[4.3](#sss:cylinder)’s observation that the actuator’s own dynamics are usually the fast part of a pneumatic loop; it is the *lines* carrying the pressure signal to and from it, not modelled here, that are pneumatics’ real speed limit.

<figure id="fig:diaphragmstep" data-latex-placement="H">
<img src="../svg/week-01-notes-supp/fig23.svg" />
<figcaption><strong>Figure 21.</strong> Step response of the diaphragm actuator of Worked example 5.1: <span class="math inline arithmatex">\(\omega_{n}=200\,\mathrm{rad/s}\)</span>, <span class="math inline arithmatex">\(\zeta=0.60\)</span>. Compare the shape with Figure <a href="#fig:ratefb">15</a> — same mathematics, a mechanical spring supplying the restoring force instead of a synchro-and-amplifier loop.</figcaption>
</figure>

///

#### 5.5. Comparison: electric, hydraulic, pneumatic { #sss:comparison }

\@P0.185P0.245P0.245P0.245@ & **Electric** & **Hydraulic** & **Pneumatic**<br>
Working medium & electric current & incompressible oil & compressible air<br>
Power/weight & moderate & very high & low<br>
Speed of response & fast & fastest under load & slow (compressibility)<br>
Stiffness under load & moderate & very high & low<br>
Typical use & instruments, servos, drives & machine tools, steering, aircraft controls, presses & process control valves<br>
Main drawback & limited torque density & leaks, sealing, contamination, noise & long time delays, low stiffness<br>
Safety & sparks & fire risk from oil mist & non-inflammable, intrinsically safe<br>

/// admonition | Key idea
    type: info

Do not memorise the table row by row; reason with the three trade-offs behind it. **Power density** pushes a designer towards hydraulics, **safety and cost** towards pneumatics, **precision and convenience** towards electrics. Almost every real actuator selection in practice is one of those three arguments winning over the other two.

///

#### Summary of §§[4](#sec:hydraulics)–[5](#sec:pneumatics) { #summary-of-45 }

/// admonition | Key idea
    type: info

Each equation in §§[4](#sec:hydraulics)–[5](#sec:pneumatics), and where it came from:

clP6.5cm Eq. & Result & Origin<br>
[(34)](#eq:hyd) & $K/[s(\tau s+1)]$ & flow balance and torque balance, $p$ eliminated<br>
— & $K_{T}=K_{m}$ & power balance $p\,q_{m}=T_{m}\dot\theta$, exactly as $K_{t}=K_{b}$<br>
[(35)](#eq:valve) & $q=K_{1}x-K_{2}p$ & linearisation of $q\propto\sqrt{\Delta p}$ about neutral<br>
[(36)](#eq:cyl) & $K/[s(\tau s+1)]$, $K=AK_{1}/(A^{2}+K_{2}f)$ & valve relation, continuity $q=A\dot y$, force balance $Ap=M\ddot y+f\dot y$<br>
[(37)](#eq:bellows) & $A/K$, pure gain & spring balance $(\Delta P)A=K\Delta x$<br>
[(38)](#eq:flapper) & $(a/(a+b))K$, $K<0$ & lever arm $\times$ local slope of the $P_b$–$e$ curve<br>
[(39)](#eq:relay) & $(a/(a+b))K$, $K>0$ & same magnitude, sign flips again in the ball-and-seat linkage<br>
[(40)](#eq:pneuact) & $A/(Ms^{2}+fs+K)$ & force balance with a spring: no free integrator<br>

///

### 6. The shape that keeps recurring { #sec:shape }

| **Device** | **Transfer function** | **Equation** |
|:---|:---|:--:|
| Armature-controlled d.c. motor | $\theta/V_a = K_m/[s(\tau_m s+1)]$ | [(19)](#eq:dcm) |
| Two-phase a.c. servomotor | $\theta/E = K_m/[s(\tau_m s+1)]$ | [(25)](#eq:acm) |
| Hydraulic pump–motor transmission | $\theta/X = K/[s(\tau s+1)]$ | [(34)](#eq:hyd) |
| Hydraulic linear actuator | $Y/X = K/[s(\tau s+1)]$ | [(36)](#eq:cyl) |
| Potentiometer error detector | $V_e/(r-c)=K_p$ | [(1)](#eq:pot) |
| Synchro error detector | $E/(\theta-\alpha)=K_s$ | [(14)](#eq:synchro) |
| Tachogenerator | $V_t/\dot\theta = K_t$ | [(29)](#eq:tacho) |
| Pneumatic bellows | $\Delta X/\Delta P = A/K$ | [(37)](#eq:bellows) |
| Pneumatic diaphragm actuator | $\Delta Y/\Delta P = A/(Ms^2+fs+K)$ | [(40)](#eq:pneuact) |

/// admonition | Key idea
    type: info

Almost every *positional actuator* in control engineering, whatever its physics, has the transfer function 

$$G(s)=\frac{K}{s(\tau s+1)} .$$

 The $1/s$ is there because the input commands a rate and the output of interest is the integral of that rate. The $1/(\tau s+1)$ is there because inertia and friction resist that rate. Sensors and error detectors, by contrast, are usually pure gains.

///

#### Check yourself { #check-yourself-2 }

1.  Why is $K_{T}=K_{m}$ for a hydraulic motor for exactly the same reason $K_{t}=K_{b}$ for a d.c. motor? Name the one physical law both arguments use.

2.  [(34)](#eq:hyd) was derived after dropping the compressibility flow $K_{c}\dot p$. What term would that add back into the model, and what order would the transfer function become?

3.  In Worked example 4.1, the leakage term $K_{2}f$ was 5% of $A^{2}$. Without recomputing anything, say which way $K$ and $\tau$ would move if a worn seal doubled $K_{2}$, and which of the two errors — in $K$ or in $\tau$ — would grow faster.

4.  The hydraulic cylinder [(36)](#eq:cyl) has a free integrator; the pneumatic diaphragm actuator [(40)](#eq:pneuact) does not, even though both are “a fluid pushing a piston”. What single component makes the difference, and why?

5.  The flapper–nozzle gain [(38)](#eq:flapper) is negative and the relay gain [(39)](#eq:relay) is positive, yet the text says both use “the same magnitude $|K|$”. Reconcile these two statements.

6.  In Worked example 5.1, doubling the return spring stiffness $K$ (with $M$ and $f$ unchanged) changes $\omega_{n}$, $\zeta$ and the steady-state gain. State the direction of each change without recomputing the numbers.
