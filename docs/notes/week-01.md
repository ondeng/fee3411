---
title: "Week 1 — Introduction and Control System Components"
---

# Week 1 — Introduction and Control System Components
## What this week covers { #what-this-week-covers }

/// admonition | By the end of this week you should be able to
    type: abstract

- Name the six parts of a feedback control system — plant, actuator, sensor, controller, reference and disturbance — on a block diagram of a real system, and say what signal each one carries.

- Classify a given system as open-loop or closed-loop, and justify the classification from what the system does, not from how it is drawn.

- Show quantitatively, on the cruise-control example, why feedback reduces steady-state error and why it reduces sensitivity to an unknown plant parameter.

- Define a servomechanism and identify one in a schematic.

- Describe the working principle of the standard control components: potentiometer and synchro error detectors, d.c. and a.c. servomotors, stepper motors, tachogenerators, hydraulic pumps, motors, valves and cylinders, and pneumatic bellows, flapper valves, relays and actuators.

- Recognise the transfer function $K/[s(\tau s+1)]$ as the shape shared by almost every positional actuator you will meet, and say where the integrator comes from.

///

/// admonition | Reading
    type: quote

**Primary** — Khalil, Ch. 1 (pp. 1–8). Appendix A, Laplace review (p. 438), for the tutorial hour.<br>
**Secondary** — Nise (6th ed.), §1.1–1.4 (pp. 2–14); §1.5 The Design Process (p. 15); §2.2 Laplace review (p. 35).<br>
**Components (essential this week)** — Nagrath & Gopal (2nd ed.), §4.3 Electrical Systems (pp. 84–99): a.c. servomotors p. 84, a.c. tachometer p. 88, amplidyne p. 90, synchros p. 92, a.c. position control system p. 96. §4.4 Stepper Motor (pp. 99–104). §4.5 Hydraulic Systems (pp. 104–116): pumps and motors p. 104, valves p. 108, linear actuator p. 110. §4.6 Pneumatic Systems (pp. 116–121): bellows p. 116, flapper valve p. 117, relay p. 118, actuator p. 119.

///

*Syllabus items addressed:* “Introduction: Examples of control systems. Open and closed-loop classification. Control systems components and devices. Servomechanism, Stepper motors, Hydraulic systems, Pneumatic systems, Valves, cylinders, and rotary actuators.”<br>
*Expected learning outcome:* ELO 1 — *describe the working principles of a given control system.*

## Part A — What control engineering is { #partmarker-part-a-what-control-engineering-is }

### 1. The problem control engineering solves

What do rockets, aircraft, cars, robots, power grids, electric drives, manufacturing lines, disc drives and artificial pancreas systems have in common? Every one of them contains at least one *automatic control system*: an arrangement that makes some variable behave in a desired way *without a human operator intervening moment by moment* (Khalil, p. 2).

Some concrete instances of “behave in a desired way”:

- hold a car at a set speed, or keep it inside a lane;

- hold a room at a set temperature;

- make the position or velocity of a motor follow a prescribed pattern;

- hold the frequency of a power grid at 50 Hz;

- make a rocket follow a desired trajectory.

Each of these has the same skeleton. There is a physical thing whose behaviour we care about. It has variables we can *measure* (outputs) and variables that *drive* it (inputs). Some of the inputs we can set; the rest happen to us.

/// admonition | Key idea
    type: info

A control problem exists whenever you can measure something, you can push on something, and there is a gap between what the thing is doing and what you want it to do.

///

#### 1.1. The vocabulary, fixed now for twelve weeks

The terms below are used in exactly this sense for the rest of FEE3411 and for FEE3412. Learn them this week; after this they are assumed.

| **Term** | **Meaning** |
|:---|:---|
| Plant (or process) | The system whose output is to be controlled. Its inputs are the control signal and the disturbance; its output is the controlled variable. |
| Controlled variable (output) | The variable we want to behave in a desired way, e.g. vehicle speed, antenna angle, tank level. |
| Reference (command, set point, desired output) | The value we want the controlled variable to take. |
| Control input | An input we *can* manipulate: throttle angle, armature voltage, valve opening. |
| Disturbance input | An input that affects the plant but which we *cannot* manipulate: road gradient, wind load, a change in load torque. |
| Actuator | The device that converts the controller’s (usually low-power) command into the physical quantity that acts on the plant: engine, motor, hydraulic ram. |
| Sensor (output transducer) | The device that measures the controlled variable and converts it into the form the controller uses. |
| Measurement (sensor) noise | The difference between what the sensor reports and what is actually there. No sensor is exact. |
| Controller | The device that computes the control input from the reference and the measurement. |
| Error | Reference minus controlled variable. Strictly, this name is only exact when the input and output transducers both have unit gain — see the pitfall in §[2](#sec:oc). |

/// admonition | Common pitfall
    type: warning

“Input” is ambiguous in ordinary speech and precise here. The *input to the system* is the reference $r(t)$ — what you ask for. The *input to the plant* is the control signal $u(t)$ — what the actuator delivers. They are different signals at different points of the diagram, and confusing them is the single most common cause of a wrong block-diagram reduction in Week 4.

///

Throughout this unit we restrict attention to systems with one control input and one measured output — *single-input–single-output* (SISO) systems. Real plants often have several of each; the multivariable case needs the state-space methods that sit outside this syllabus.

### 2. Open-loop and closed-loop control { #sec:oc }

There are exactly two architectures, and the whole of classical control is about the second one.

###### Open-loop control.

A model of the plant is used to work out, in advance, what control input ought to produce the desired output. That input is applied. Nothing is measured, so nothing is corrected (Khalil, p. 2; Nise §1.3, p. 7).

###### Closed-loop (feedback) control.

The output is measured, fed back, and compared with the reference. The control input is then computed from the difference, in a direction that drives the output towards the reference.

<figure id="fig:openclosed" data-latex-placement="htbp">
<img src="../svg/week-01-notes/fig01.svg" />
<img src="../svg/week-01-notes/fig02.svg" />
<figcaption><strong>Figure 1.</strong> The two configurations. In (a) a disturbance <span class="math inline">\(d\)</span> passes straight through to the output and is never corrected. In (b) its effect appears in the measurement, hence in the error <span class="math inline">\(e\)</span>, and the controller acts on it. The price is the sensor, its cost, and its noise <span class="math inline">\(n\)</span>. Cf. Nise Fig. 1.6, p. 8.</figcaption>
</figure>

/// admonition | Key idea
    type: info

The distinguishing feature of an open-loop system is that it cannot compensate for a disturbance. A closed-loop system corrects for disturbances *it can see in the measurement* — and only for those.

///

Nise’s example is a toaster: its output is the colour of the toast, but it measures time, not colour, so it cannot know that the bread is rye rather than white, or thick rather than thin. Anyone who has burnt toast has performed the experiment. A toaster *oven* that measures reflectivity and humidity is closed-loop — and is several times the price. That trade-off is real and is made on every project.

#### 2.1. Worked example: cruise control

This example carries most of the intellectual content of the week. It is worth following every line.

<figure id="fig:car" data-latex-placement="htbp">
<img src="../svg/week-01-notes/fig03.svg" />
<figcaption><strong>Figure 2.</strong> Forces on a vehicle on a road of slope <span class="math inline">\(\theta\)</span>. Cf. Khalil Fig. 1-1, p. 3.</figcaption>
</figure>

/// admonition | Worked example 2.1 — open- versus closed-loop cruise control
    type: example

**Model.** With $T=au$ the thrust from throttle angle $u$ and engine gain $a$, $F=b\upsilon$ the road friction, and $W=mg\sin\theta+D$ a disturbance made of the gradient term and aerodynamic drag, Newton’s second law along the road gives 

$$m\dot{\upsilon}=T-F-W=au-b\upsilon-mg\sin\theta-D .$$

 Here $u$ is the control input, $\upsilon$ is the controlled output. Only the engine gain $a$ is known reliably: the mass $m$ depends on how many passengers are aboard, $b$ on the road surface, and $W$ on gradient and wind.

**Open-loop design.** Design as if there were no disturbance, $W=0$, using nominal values $\hat m$ and $\hat b$: 

$$\hat m \dot\upsilon = au-\hat b \upsilon .$$

 At steady state $\dot\upsilon=0$, so $\upsilon_{ss}=au/\hat b$. To make $\upsilon_{ss}$ equal the desired speed $\upsilon_{des}$, choose the constant throttle 

$$\boxed{\;u=\frac{\hat b\,\upsilon_{des}}{a}\;}$$

 Now apply that fixed $u$ to the *real* car, which has the true $b$, the true $m$, and a real disturbance $W$: 

$$m\dot\upsilon = \hat b \upsilon_{des}-b\upsilon-W
  \quad\Longrightarrow\quad
  \upsilon_{ss}=\frac{\hat b\upsilon_{des}-W}{b},$$

 so the steady-state speed error is 

<a id="eq:ol"></a>

$$\begin{equation}
  \upsilon_{des}-\upsilon_{ss}
  =\left(\frac{b-\hat b}{b}\right)\upsilon_{des}+\frac{1}{b}W .
  \tag{1}
\end{equation}$$

**Closed-loop design.** Measure $\upsilon$ with a speedometer and set 

<a id="eq:cl-law"></a>

$$\begin{equation}
  u=\underbrace{\frac{\hat b\,\upsilon_{des}}{a}}_{\text{feedforward}}
   +\underbrace{K(\upsilon_{des}-\upsilon)}_{\text{feedback}} .
  \tag{2}
\end{equation}$$

 Substituting into the true model, 

$$m\dot\upsilon=\hat b\upsilon_{des}+aK(\upsilon_{des}-\upsilon)-b\upsilon-W
   =-(b+aK)\upsilon+(\hat b+aK)\upsilon_{des}-W,$$

 and the steady-state error becomes 

<a id="eq:cl"></a>

$$\begin{equation}
  \upsilon_{des}-\upsilon_{ss}
  =\left(\frac{b-\hat b}{b+aK}\right)\upsilon_{des}+\frac{1}{b+aK}W .
  \tag{3}
\end{equation}$$

**What it means.** Compare [(1)](#eq:ol) and [(3)](#eq:cl). They are the same expression with $b$ replaced by $b+aK$ in *both* denominators. Making the feedback gain $K$ large therefore shrinks *both* error terms at once: the term caused by not knowing $b$, and the term caused by the disturbance $W$. One knob buys robustness to parameter error and rejection of disturbance together. That is what feedback is for.

///

<figure id="fig:cruise" data-latex-placement="htbp">
<img src="../svg/week-01-notes/fig04.svg" />
<figcaption><strong>Figure 3.</strong> The cruise-control loop of Worked example 2.1, showing the four basic components: plant, actuator, sensor, controller. Cf. Khalil Fig. 1-2, p. 5.</figcaption>
</figure>

#### 2.2. Why not simply make *K* enormous?

Equation [(3)](#eq:cl) suggests taking $K\to\infty$. Three things stop you, and between them they account for most of the remaining eleven weeks (Khalil, p. 5):

1.  **The actuator saturates.** A throttle angle has a maximum. Beyond it, extra commanded control does nothing. *(Control constraints — background only in this unit; examinable in FEE3412.)*

2.  **Transient response degrades.** A large $K$ makes the response faster but more oscillatory, and the design specification usually limits overshoot. *(Weeks 5, 8, 9.)*

3.  **The system can become unstable.** Above some gain the closed loop no longer settles at all. This does not happen in the first-order cruise model above, but it is the norm once the plant has any real dynamics. *(Weeks 7, 8, 10, 11, 12 — this is the largest single theme of the unit.)*

If you have ever heard a public-address system squeal when the volume is turned up, you have heard instability caused by high-gain feedback.

/// admonition | Common pitfall
    type: warning

Feedback is not free and it is not always better. It adds a sensor (cost, noise, one more thing to fail) and it can destabilise a plant that was perfectly well behaved open loop. “Closed loop is better” is not a theorem; it is a trade-off, and the rest of this unit is the machinery for making the trade deliberately.

///

#### 2.3. Error versus actuating signal

In Figure [1](#fig:openclosed)(b) the signal leaving the first summing junction is properly called the *actuating signal*. It equals the true error $r-y$ only when the input and output transducers both have gain 1. A position loop whose feedback potentiometer produces 0.5 V rad^−1^ while the reference potentiometer produces 1 V rad^−1^ has an actuating signal that is *not* proportional to $r-y$, and computing steady-state error as though it were will give the wrong answer. We return to this properly in Week 6 under *non-unity feedback*.

### 3. What a well-designed control system must do { #sec:objectives }

Khalil (p. 6) lists six requirements. They are worth copying out, because they are essentially the syllabus of this unit and FEE3412.

| **Requirement** | **Where it is dealt with** |
|:---|:---|
| The system must be **stable**: a well-behaved input must give a well-behaved output. | Weeks 7 (Routh–Hurwitz), 8 (root locus), 11–12 (Nyquist). |
| The output must **track** the reference with zero or small **steady-state error**. | Week 6 (static error constants, system type). |
| The **transient response** must be acceptable. | Weeks 5 (specifications), 8–9 (shaping it by gain). |
| The effect of **disturbance** and **measurement noise** should be small. | Background reading only in FEE3411 (Khalil §4-4 to §4-8; Nise §7.5, §7.7). Examinable in FEE3412. |
| The design must be **robust** to model uncertainty. | Introduced through gain and phase margins, Weeks 10 and 12. Treated properly in FEE3412. |
| The design must respect **constraints** on the control input. | Background only here; FEE3412. |

/// admonition | Key idea
    type: info

Stability, steady-state accuracy and transient response are the three things FEE3411 teaches you to *analyse*. FEE3412 teaches you to *design* for them. If you can say which of the three a question is about, you can usually say which method it wants.

///

#### 3.1. Where the mathematics comes from

Every method in this unit needs a mathematical model of the plant. Models come from (Khalil, p. 6):

- **first principles** — Kirchhoff’s laws, Newton’s laws, energy balances. This is Week 2.

- **identification experiments** — apply known inputs, measure the outputs, fit a model to the data. Outside this syllabus, but note that fitting a second-order model to a measured step response, which you do in the Week 5 tutorial, is identification in miniature.

- **both** — derive the structure from physics, then measure the parameters.

A model that captures everything is too complicated to design with. A model that captures too little gives a design that fails on the real plant. Choosing what to leave out is the hardest judgement in the subject and it requires understanding the physics, not just the algebra.

#### 3.2. The design process as a map of the course

Nise (§1.5, p. 15, Fig. 1.11) sets out six steps. They are reproduced in Figure [4](#fig:design) with the week of this unit that covers each. Use it as a map: when a topic feels disconnected, find it here.

<figure id="fig:design" data-latex-placement="htbp">
<img src="../svg/week-01-notes/fig05.svg" />
<figcaption><strong>Figure 4.</strong> The design process; cf. Nise Fig. 1.11, p. 15, annotated with the week of FEE3411 in which each step is taught. Steps 1 and 2 are this week.</figcaption>
</figure>

### 4. The servomechanism { #sec:servo }

/// admonition | Key idea
    type: info

A **servomechanism** (servo) is a feedback control system in which the controlled variable is a mechanical position, or one of its derivatives (velocity, acceleration).

///

The servomechanism deserves its own name because it is the archetype: antenna pointing, machine-tool slides, robot joints, radar dishes, aircraft control surfaces, disc-drive head positioning, steering gear on ships. Almost every worked example in this unit is, underneath, a servo.

Figure [5](#fig:servo) shows the standard laboratory form. A pair of potentiometers acts as the error detector: one is turned by the reference shaft, the other by the load shaft, and both are fed from the same d.c. supply. The voltage between the two wipers is 

<a id="eq:pot"></a>

$$\begin{equation}
  v_e = K_p\,(r-c),
  \tag{4}
\end{equation}$$

 where $r$ and $c$ are the reference and output shaft angles in radians and $K_p$ is the potentiometer sensitivity in V rad^−1^. The subtraction is done by the wiring, not by a circuit: this is the physical realisation of the summing junction drawn as $\otimes$ in Figure [1](#fig:openclosed). The error voltage is amplified by $K_a$ and drives the armature of a d.c. motor, which turns the load through a gear train of ratio $n$ in the direction that reduces the error.

<figure id="fig:servo" data-latex-placement="htbp">
<img src="../svg/week-01-notes/fig06.svg" />
<figcaption><strong>Figure 5.</strong> Position servomechanism with a potentiometer-pair error detector. The two wipers are the summing junction: the voltage between them is <span class="math inline">\(K_p(r-c)\)</span>. Cf. Nagrath &amp; Gopal (2nd ed.) §5.4, p. 137, whose Fig. 5.6 (p. 138) is this schematic with its block diagram; we derive that block diagram in Week 4 and its response in Week 5.</figcaption>
</figure>

###### Regulator or tracking system?

Two duties are worth distinguishing, because they lead to different specifications:

- a **regulator** holds the output at a constant reference in the face of disturbances — speed governor, voltage regulator, temperature control;

- a **tracking (follow-up) system** makes the output follow a reference that is itself changing — a radar dish following an aircraft, a machine-tool axis following a profile.

The same hardware often does both. The distinction matters in Week 6, where the steady-state error depends on whether the reference is a step, a ramp or a parabola.

## Part B — Control system components and devices { #partmarker-part-b-control-system-components-and-devices }

This half of the notes is a *survey*. The syllabus outcome is ELO 1, “describe the working principles”. You should be able to say what a device does, how it does it, and roughly what its transfer function looks like. Deriving those transfer functions is Week 2 and, in more detail, FEE3412, which contains a full hardware block.

**For the content of this part, please go to the supplementary reading material for week 1.**

## Summary { #summary }

- A control system makes a variable behave in a desired way without continuous human intervention. Its parts are plant, actuator, sensor, controller; its signals are reference, control input, disturbance, controlled output and measurement noise.

- Open-loop control applies a precomputed input and measures nothing; closed-loop control measures the output and corrects. Only closed-loop control can reject a disturbance.

- In the cruise-control example, feedback with gain $K$ replaces $b$ by $b+aK$ in the steady-state error, reducing both the parameter-error term and the disturbance term. See [(1)](#eq:ol) and [(3)](#eq:cl).

- Gain cannot be raised without limit: actuators saturate, transient response degrades, and the loop may become unstable.

- A servomechanism is a feedback system whose controlled variable is mechanical position or a derivative of it.

- Error detectors: potentiometer pair (d.c., gain $K_p$, sliding contact) and synchro pair (a.c., gain $K_s$, no sliding contact, suppressed-carrier output).

- Actuators: d.c. servomotor (armature or field control), two-phase a.c. servomotor (high rotor resistance for a negatively sloped, near-linear torque–speed curve), stepper motor (digital, step angle $360^\circ/nT$, usable open loop but can skip steps), hydraulic pump–motor and valve-plus-cylinder, pneumatic diaphragm actuator.

- Sensors: tachogenerator, $v_t=K_t\dot\theta$, used both as the sensor of a speed loop and as rate feedback to add damping to a position loop.

- Hydraulics give high power density and stiffness; pneumatics are safe and cheap but slow because air is compressible.

- Positional actuators almost universally have the form $K/[s(\tau s+1)]$; error detectors and sensors are usually pure gains.

## Before the tutorial { #before-the-tutorial }

Use the following to help you prepare for the tutorial. The tutorial itself is a review of the mathematical toolkit — Laplace transform pairs and properties, partial fractions, complex numbers and the $s$-plane, and the standard test signals.

Useful sources: Khalil Appendix A (p. 438) or Nise §2.2 (p. 35) beforehand.

1.  A domestic pressure cooker holds pressure with a weighted valve that lifts when the internal pressure exceeds a set value. Is this open-loop or closed-loop? Identify the plant, the controlled variable, the sensor, the actuator and the reference. What is the disturbance?

2.  In Worked example 2.1, suppose the engine gain is $a=20\,\mathrm{N}/{}^{\circ}$, the true friction coefficient is $b=50\,\mathrm{N}\,\mathrm{s}\,\mathrm{m}^{-1}$ while the nominal value used in design was $\hat b=45\,\mathrm{N}\,\mathrm{s}\,\mathrm{m}^{-1}$, the disturbance is $W=200\,\mathrm{N}$ and the desired speed is $\upsilon_{des}=25\,\mathrm{m}\,\mathrm{s}^{-1}$. Compute the steady-state speed error open loop from [(1)](#eq:ol), and closed loop from [(3)](#eq:cl) with $K=10$. By what factor does feedback improve it?

3.  A three-stack variable-reluctance stepper motor has 20 rotor teeth. What is its step angle? How many pulses are needed for one full revolution of the rotor? If the load must be positioned to 0.5 °, is this motor adequate on its own, and if not, name two ways to fix it.

4.  Write down, without deriving them, the transfer function of (a) an armature-controlled d.c. servomotor driving an inertial load, (b) a hydraulic valve-and-cylinder actuator, and (c) a spring-loaded pneumatic diaphragm actuator. Which one is the odd one out, and why?

5.  Sketch, from memory, the block diagram of Figure [1](#fig:openclosed)(b), labelling every signal and every block. You will draw this diagram more times in the next eleven weeks than any other.

## Looking ahead { #looking-ahead }

This week gave you the vocabulary and the hardware. Everything after it is mathematics applied to that vocabulary. **Week 2** derives models from first principles — electrical networks, translational and rotational mechanical systems — and in the tutorial builds the armature-controlled d.c. servomotor driving a load through a gear train. It also covers linear approximation to nonlinear systems, the technique used informally to linearise the a.c. servomotor’s torque–speed surface and the spool valve’s orifice flow. **Week 3** converts those models into transfer functions and moves into the $s$-plane; **Week 4** connects them into block diagrams and reduces them.

Note that the disturbance $d$ and noise $n$ drawn in Figure [1](#fig:openclosed)(b) will mostly be set to zero for the rest of this unit. They are drawn because they are physically always present, and because their rejection is one of the six objectives in §[3](#sec:objectives). Their quantitative treatment (Khalil §4-4 to §4-8; Nise §7.5, §7.7) is background reading here and examinable in FEE3412.
