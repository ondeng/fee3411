---
title: "Week 4 — Block Diagrams and Signal Flow Graphs"
---

# Week 4 — Block Diagrams and Signal Flow Graphs
## What this week covers { #what-this-week-covers }

/// admonition | By the end of this week you should be able to
    type: abstract

- Draw the block diagram of an interconnected system, using the three elements — block, summing junction and pick-off point — and state the no-loading assumption that the cascade rule depends on.

- Reduce the three basic connections (cascade, parallel, feedback) to a single block, deriving the closed-loop formula rather than quoting it.

- Identify, for a system in canonical feedback form, the forward-path, open-loop, closed-loop and error transfer functions, and write down the characteristic equation.

- Apply the rules of block-diagram algebra — including moving a summing junction or a pick-off point past a block — to reduce a multi-loop diagram to one transfer function.

- Convert a block diagram to a signal flow graph, and identify its forward paths, loops, loop gains and non-touching loops.

- Evaluate a transfer function with Mason’s gain formula, including the non-touching-loop terms of $\Delta$ and the cofactors $\Delta_k$, and check the result against block-diagram reduction.

- Find the response of a system with more than one input by superposition, computing one transfer function per input.

///

/// admonition | Reading
    type: quote

**Primary** — Khalil, §2-3 Block Diagrams (pp. 40–49).<br>
**Secondary** — Nise (6th ed.), §5.2 Block Diagrams (p. 236); §5.3 Analysis and Design of Feedback Systems (p. 245); §5.4 Signal-Flow Graphs (p. 248); §5.5 Mason’s Rule (p. 251). *Khalil does not cover signal flow graphs — for §[6](#sec:sfg)–§[7](#sec:mason) Nise is the primary text.*<br>
**Further** — Nagrath & Gopal (2nd ed.), §2.4 Block Diagram Algebra (p. 38), §2.5 Signal Flow Graphs (p. 45); Sundararajan, §5.1, §5.2, §5.2.1.

///

*Syllabus items addressed:* “Block diagrams and canonical feedback. Derivation of transfer functions from the reduction of elementary block diagrams. Construction of signal flow diagrams. Block diagram reduction using signal flow diagrams.” (Transfer Functions); “Block diagrams” (Time Domain Linear Systems Analysis).<br>
*Expected learning outcomes:* ELO 2 — *analyse a control system solution in the time- and frequency-domains*; ELO 1 — *describe the working principles of a given control system* (the block diagram is how a control system’s working principle is described on paper).

## Part A — Block diagrams { #partmarker-part-a-block-diagrams }

### 1. From one block to many { #sec:elements }

Week 3 produced transfer functions for single components: a network, a motor, a mass on a spring. A real control system is several of these wired together — a reference input compared against a measurement, the difference amplified, the amplifier driving a motor, the motor’s shaft position measured by a sensor that closes the loop. To get the transfer function of the whole thing we need a notation for the wiring, and rules for collapsing it.

A **block diagram** is that notation. It has exactly three elements, shown in Figure [1](#fig:elements).

<figure id="fig:elements" data-latex-placement="htbp">
<img src="../svg/week-04-notes/fig01.svg" />
<figcaption><strong>Figure 1.</strong> The three elements of a block diagram. A block multiplies its input by a transfer function; a summing junction adds signals with the signs marked beside it; a pick-off point sends the <em>same</em> signal down two branches.</figcaption>
</figure>

Two things about this notation matter more than they first appear.

First, **a pick-off point does not divide the signal.** Both branches carry $X$ in full. This is the opposite of a wire junction in a circuit, where current divides; the block diagram is a diagram of *signals*, not of power flow, and taking a copy of a signal costs nothing.

Second, and more consequentially: writing two blocks in cascade and multiplying their transfer functions assumes the second does not *load* the first.

/// admonition | Common pitfall
    type: warning

Cascading $G_1$ and $G_2$ to get $G_1G_2$ assumes that connecting $G_2$ does not change $G_1$’s output — that is, that $G_2$ draws no current (or torque, or flow) from $G_1$. Two $RC$ networks in series are the standard trap: each alone has transfer function $1/(RCs+1)$, but wired directly together their combined transfer function is *not* $1/(RCs+1)^2$, because the second network’s input impedance loads the first. Cascade blocks only where a buffer amplifier separates the stages, or where the impedances make loading negligible — and if a question gives you a circuit rather than a diagram, go back to the impedance method of Week 3 and derive the whole thing at once.

///

/// admonition | Key idea
    type: info

A block diagram is a picture of a set of simultaneous algebraic equations in $s$ — one equation per block and per summing junction. Every reduction rule in this week’s work is nothing more than eliminating an internal variable between those equations. If a diagram ever defeats you, write its equations out and solve them; you will always get the right answer, just more slowly.

///

### 2. The three basic connections { #sec:connections }

Every block diagram, however tangled, is built from three connections: cascade, parallel and feedback. Figure [2](#fig:three) shows each with its single-block equivalent.

<figure id="fig:three" data-latex-placement="htbp">
<img src="../svg/week-04-notes/fig02.svg" />
<figcaption><strong>Figure 2.</strong> The three basic connections and their single-block equivalents: (a) cascade, (b) parallel, (c) negative feedback.</figcaption>
</figure>

###### Cascade.

With $X=G_1U$ and $Y=G_2X$, substitution gives $Y=G_2G_1U$, so the equivalent transfer function is the *product* $G_1G_2$. Order does not matter algebraically, because transfer functions are scalar rational functions and multiplication commutes — which is worth noticing, because the physical systems certainly do not commute. Swapping a real amplifier and a real motor would matter; swapping their transfer functions does not.

###### Parallel.

With both blocks fed the same $U$ from a pick-off point and their outputs summed, $Y=G_1U\pm G_2U$, so the equivalent is $G_1\pm G_2$ — a *sum*, with whatever signs the summing junction carries.

###### Feedback.

This one deserves the full derivation, because it is the formula the rest of the unit runs on. Let the summing junction subtract the feedback signal, so that with $E$ the signal at the junction’s output, 

$$E = U - HY, \qquad Y = GE .$$

 Eliminating $E$ between the two, 

$$Y = G\left(U - HY\right)
  \quad\Longrightarrow\quad
  Y\left(1 + GH\right) = GU
  \quad\Longrightarrow\quad
  \boxed{\;\frac{Y}{U} = \frac{G}{1+GH}\;}.$$

 If the junction *adds* the feedback signal instead — positive feedback — the same two lines give $G/(1-GH)$. The sign in the denominator is therefore the opposite of the sign at the summing junction, which is the single most common place to lose a minus sign in this entire unit.

/// admonition | Common pitfall
    type: warning

Read the sign off the *diagram*, not off memory. The formula $G/(1+GH)$ is for negative feedback, where the junction subtracts. A diagram with a $+$ at the feedback input needs $G/(1-GH)$, and that system is a completely different animal: its denominator can vanish, which is exactly what instability looks like. When a question’s answer comes out with a suspicious sign, check the summing junction first.

///

### 3. The canonical feedback form { #sec:canonical }

Almost every control system in this unit is drawn, eventually, in the form of Figure [3](#fig:canonical): a reference in, a comparison, a forward path, a measurement path back. It is worth having names for its parts, because examination questions and textbooks both use them freely.

<figure id="fig:canonical" data-latex-placement="htbp">
<img src="../svg/week-04-notes/fig03.svg" />
<figcaption><strong>Figure 3.</strong> The canonical negative-feedback form, with the three equations it encodes. <span class="arithmatex">\(R\)</span> is the reference, <span class="arithmatex">\(C\)</span> the controlled output, <span class="arithmatex">\(B\)</span> the feedback signal and <span class="arithmatex">\(E\)</span> the actuating error signal.</figcaption>
</figure>

Eliminating $E$ and $B$ from the three equations beside the figure gives the four transfer functions that get quoted by name: 

<a id="eq:closedloop"></a>

$$\begin{align}
  \text{forward-path (or plant) transfer function:}\quad & G(s) \nonumber\\
  \text{open-loop transfer function (loop gain):}\quad & G(s)H(s) \nonumber\\
  \text{closed-loop transfer function:}\quad & T(s)=\frac{C(s)}{R(s)}
    = \frac{G(s)}{1+G(s)H(s)} \tag{1}\\
  \text{error transfer function:}\quad & \frac{E(s)}{R(s)}
    = \frac{1}{1+G(s)H(s)} \tag{2}
\end{align}$$

 When $H(s)=1$ the system is called **unity feedback**, the measurement is taken as perfect, and $E$ becomes the true error $R-C$.

/// admonition | Key idea
    type: info

The denominator of the closed-loop transfer function is $1+G(s)H(s)$, so the closed-loop poles are the roots of 

$$1 + G(s)H(s) = 0 ,$$

 the **characteristic equation** of the closed-loop system. This single equation is the object of Weeks 7, 8, 11 and 12: Routh–Hurwitz tests whether its roots are in the left half plane, the root locus tracks where they move as a gain varies, and the Nyquist criterion counts them from a frequency-response plot. Everything downstream of this week is about the roots of $1+GH=0$.

///

/// admonition | Common pitfall
    type: warning

The open-loop transfer function is $G(s)H(s)$, the gain around the whole loop — not the forward path $G(s)$ alone, and not the closed-loop $T(s)$ with the loop cut. The three are equal only in the trivial case $H=1$ and no feedback at all. When a question says “for the open-loop transfer function $G(s)H(s)=K/[s(s+2)]$”, it is handing you the *product*, and the characteristic equation is $1+K/[s(s+2)]=0$ directly.

///

/// admonition | Worked example 4.1 — what feedback does to the poles
    type: example

A unity-feedback system has forward path 

$$G(s)=\frac{8}{s(s+6)},\qquad H(s)=1 .$$

 Find the closed-loop transfer function, its poles, its d.c. gain, and the error transfer function. Compare the closed-loop poles with the open-loop poles.

**Closed-loop transfer function.** From [(1)](#eq:closedloop), 

$$T(s)=\frac{G}{1+GH}
   =\frac{\dfrac{8}{s(s+6)}}{1+\dfrac{8}{s(s+6)}}
   =\frac{8}{s(s+6)+8}
   =\frac{8}{s^{2}+6s+8}
   =\frac{8}{(s+2)(s+4)} .$$

 The middle step — multiplying numerator and denominator by $s(s+6)$ — is the one worth doing carefully; it is where the $1$ in $1+GH$ turns into the open-loop denominator.

**Poles.** Open loop, $G$ has poles at $s=0$ and $s=-6$: one of them is at the origin, so the open-loop system is only marginally stable and its step response would ramp away without bound. Closed loop, the poles are at $s=-2$ and $s=-4$ — both strictly in the left half plane. Closing the loop has moved both poles and made the system stable.

**d.c. gain.** $T(0)=8/8=1$. The closed-loop system follows a constant reference exactly, which is what the free integrator in $G$ buys us — a result Week 6 will make precise as “a type-1 system has zero steady-state error to a step”.

**Error transfer function.** From [(2)](#eq:errortf), 

$$\frac{E(s)}{R(s)}=\frac{1}{1+GH}=\frac{s(s+6)}{s^{2}+6s+8} ,$$

 whose d.c. gain is $0$ — the same statement as $T(0)=1$, read from the other side.

**What it means.** Feedback did not add or remove any modes: the closed-loop system still has two poles, because $1+GH=0$ still has degree two. What it did was *relocate* them, from $\{0,-6\}$ to $\{-2,-4\}$. That relocation is the whole point of feedback, and choosing where to put the poles is what FEE3412 calls design.

///

### 4. Block-diagram algebra { #sec:algebra }

The three basic connections handle diagrams whose loops are neatly nested. Real diagrams need a few more moves, collected in Table [1](#tab:rules). Each is proved the same way: write the equations for the signals before and after, and check they agree.

<a id="tab:rules"></a>

| **Rule** | **Original** | **Equivalent** |
|:---|:--:|:--:|
| Combine blocks in cascade | ![image](svg/week-04-notes/fig04.svg) | ![image](svg/week-04-notes/fig05.svg) |
| Combine blocks in parallel | ![image](svg/week-04-notes/fig06.svg) | ![image](svg/week-04-notes/fig07.svg) |
| Eliminate a feedback loop | ![image](svg/week-04-notes/fig08.svg) | ![image](svg/week-04-notes/fig09.svg) |
| Move a summing junction back through a block | ![image](svg/week-04-notes/fig10.svg) | ![image](svg/week-04-notes/fig11.svg) |
| Move a pick-off point forward through a block | ![image](svg/week-04-notes/fig12.svg) | ![image](svg/week-04-notes/fig13.svg) |
| Interchange adjacent summing junctions | ![image](svg/week-04-notes/fig14.svg) | ![image](svg/week-04-notes/fig15.svg) |

**Table 1.** The rules of block-diagram algebra. Each row’s two diagrams are equivalent.

The two *moving* rules are the ones that need thought, and both follow the same logic: a signal must be worth the same after the move as before.

###### Moving a summing junction.

In the original, the added signal $W$ enters *after* the block, so the output is $GU+W$. To move the junction to the block’s input and keep the output the same, whatever we add there gets multiplied by $G$ on the way through — so we must add $W/G$, giving $G(U+W/G)=GU+W$ as required. Moving a junction *against* the signal flow divides by the block; moving it *with* the flow multiplies by it.

###### Moving a pick-off point.

In the original, the branch taps $X$ before the block. Moved to after the block, the branch would carry $GX$, which is wrong by a factor $G$ — so the moved branch needs a $1/G$ block to undo it. Same principle, opposite direction: the rule always *compensates* for what the block does to the signal on the moved path.

/// admonition | Common pitfall
    type: warning

A $1/G$ block introduced by one of these moves is a bookkeeping device, not a physical component — and it is not necessarily a proper transfer function. If $G=1/(s+2)$ then $1/G=s+2$, a pure differentiator plus a gain, which no hardware realises exactly. That is fine: the $1/G$ block will cancel before the reduction finishes. It is only a problem if you stop halfway and try to interpret the intermediate diagram as a real system.

///

/// admonition | Worked example 4.2 — a servo with tachometer feedback
    type: example

A position servo consists of an amplifier of gain $G_1=4$ driving a motor with transfer function 

$$G_2(s)=\frac{1}{s(s+2)}
  \qquad\text{(shaft angle per volt)},$$

 which is the reduced servomotor model of Week 2. A tachometer on the motor shaft measures shaft *speed* and feeds it back to a summing junction at the *motor’s* input, between the amplifier and the motor; since speed is $s$ times position, the tachometer path has transfer function $H_1(s)=s$. The shaft position is then measured by a potentiometer of unit gain and fed back to the outer summing junction. Find $C(s)/R(s)$, and identify $\omega_{n}$ and $\zeta$ of the result.

**Step 1 — collapse the inner loop.** The inner loop is a plain negative-feedback connection of $G_2$ with $H_1$: 

$$\frac{G_2}{1+G_2H_1}
  = \frac{\dfrac{1}{s(s+2)}}{1+\dfrac{s}{s(s+2)}}
  = \frac{1}{s(s+2)+s}
  = \frac{1}{s^{2}+3s}
  = \frac{1}{s(s+3)} .$$

 Look carefully at what happened: the motor’s pole at $s=-2$ has moved to $s=-3$. Tachometer feedback has made the motor faster — or, in the language of Week 5, it has added damping. This is why tachometer feedback is fitted to real servos, and it is the reason the inner loop exists at all.

**Step 2 — cascade the amplifier.** The forward path of the remaining single loop is 

$$G_1\cdot\frac{1}{s(s+3)} = \frac{4}{s(s+3)} .$$

**Step 3 — collapse the outer loop** (unity feedback): 

$$T(s)=\frac{\dfrac{4}{s(s+3)}}{1+\dfrac{4}{s(s+3)}}
   =\frac{4}{s(s+3)+4}
   =\frac{4}{s^{2}+3s+4} .$$

**Reading the answer.** Comparing $s^{2}+3s+4$ with the standard second-order denominator $s^{2}+2\zeta\omega_{n}s+\omega_{n}^{2}$, 

$$\omega_{n}=\sqrt{4}=2\,\mathrm{rad}\,\mathrm{s}^{-1},
  \qquad
  2\zeta\omega_{n}=3 \;\Longrightarrow\; \zeta=\frac{3}{4}=0.75 .$$

 The poles are at $s=-1.5\pm\mathrm{j}1.32$: a stable, underdamped system with d.c. gain $T(0)=4/4=1$. Week 5 turns $\omega_{n}=2$ and $\zeta=0.75$ directly into an overshoot and a settling time; this week’s job is only to get the transfer function they are read from.

///

<figure id="fig:servo-reduce" data-latex-placement="htbp">
<img src="../svg/week-04-notes/fig16.svg" />
<figcaption><strong>Figure 4.</strong> Worked example 4.2 reduced in stages: (a) the servo with tachometer and position feedback, (b) after the inner loop is collapsed — note the motor pole moving from <span class="arithmatex">\(-2\)</span> to <span class="arithmatex">\(-3\)</span>, (c) the single closed-loop block.</figcaption>
</figure>

### 5. When reduction gets awkward: overlapping loops { #sec:overlap }

Worked example 4.2 was easy because its loops were **nested**: the inner loop sat entirely inside the outer one, so collapsing it left a diagram of the same shape. Loops can also **overlap** — each containing part, but not all, of the other — and then no amount of collapsing helps, because there is no innermost loop to start from. Figure [5](#fig:overlap)(a) is the smallest example, and it is the standard one in every textbook.

<figure id="fig:overlap" data-latex-placement="htbp">
<img src="../svg/week-04-notes/fig17.svg" />
<figcaption><strong>Figure 5.</strong> Overlapping loops. In (a) neither loop contains the other, so there is no inner loop to collapse first. In (b) the pick-off point of loop 1 has been moved forward through <span class="arithmatex">\(G_3\)</span> — its gain picking up a factor <span class="arithmatex">\(s+1\)</span> in compensation — which makes the two loops nested and the reduction routine.</figcaption>
</figure>

/// admonition | Worked example 4.3 — overlapping loops by block-diagram algebra
    type: example

For Figure [5](#fig:overlap)(a), with 

$$G_1=5,\qquad G_2=\frac{1}{s+2},\qquad G_3=\frac{1}{s+1},
  \qquad H_1=1,\qquad H_2=8,$$

 find $T(s)=C(s)/R(s)$.

**Step 1 — move the pick-off point.** Loop 1 is fed from the output of $G_2$. Move that pick-off forward through $G_3$, compensating the branch with $1/G_3=s+1$, as in Figure [5](#fig:overlap)(b). Loop 1 now taps the same node as loop 2, and loop 2 sits inside it: the loops are nested.

**Step 2 — collapse the inner loop** ($G_2G_3$ with $H_2$): 

$$\frac{G_2G_3}{1+G_2G_3H_2}
  = \frac{\dfrac{1}{(s+1)(s+2)}}{1+\dfrac{8}{(s+1)(s+2)}}
  = \frac{1}{(s+1)(s+2)+8}
  = \frac{1}{s^{2}+3s+10} .$$

**Step 3 — collapse the outer loop.** Its forward path is $G_1$ times the result of step 2, and its feedback path is $H_1(s+1)=s+1$: 

$$T(s)=\frac{\dfrac{5}{s^{2}+3s+10}}
            {1+\dfrac{5(s+1)}{s^{2}+3s+10}}
   =\frac{5}{s^{2}+3s+10+5s+5}
   =\frac{5}{s^{2}+8s+15}
   =\frac{5}{(s+3)(s+5)} .$$

**Check.** The d.c. gain is $T(0)=5/15=1/3$, and the closed-loop poles are at $-3$ and $-5$: real, distinct and stable. Notice that the two open-loop poles were at $-1$ and $-2$; feedback has again relocated them, this time further into the left half plane.

**The cost.** Getting here took a junction move, two loop collapses and a redrawn diagram, and every one of those steps is a place to lose a factor. The answer is right, but the method does not scale — a diagram with three overlapping loops would need several moves, and each redrawing invites error. That is the problem §[7](#sec:mason) solves.

///

## Part B — Signal flow graphs and Mason’s gain formula { #partmarker-part-b-signal-flow-graphs-and-masons-gain-formula }

### 6. Signal flow graphs { #sec:sfg }

A **signal flow graph** (SFG) carries exactly the same information as a block diagram in a leaner notation, invented by S. J. Mason precisely so that the reduction could be replaced by a formula.

- A **node** is a signal. It is drawn as a small dot and labelled with the signal’s name.

- A **branch** is a directed line from one node to another, labelled with its gain. Travelling along it multiplies the signal by that gain.

- The signal at any node is the *sum* of everything arriving on the branches that end there.

That last rule is what removes the need for summing junctions: addition is built into the meaning of a node, and a subtraction is carried by a branch of gain $-H$ rather than a $-$ sign on a circle. Table [2](#tab:dictionary) is the translation, and Figure [6](#fig:bd2sfg) shows it applied to the canonical feedback form.

<a id="tab:dictionary"></a>

| **Block diagram** | **Signal flow graph** | **Note** |
|:---|:---|:---|
| Block with transfer function $G$ | Branch of gain $G$ | The gain sits on the line, not in a box |
| Signal on a connecting line | Node | Named signals become dots |
| Summing junction | Node (addition is implied) | Signs move onto the branch gains |
| Pick-off point | Node with two or more outgoing branches | Each branch carries the node’s full value |
| Input (reference) | **Source node** — only outgoing branches | Also called an input node |
| Output (controlled variable) | **Sink node** — only incoming branches | Add a unit branch if the output node also feeds a loop |

**Table 2.** Block diagram and signal flow graph: the same content, two notations.

<figure id="fig:bd2sfg" data-latex-placement="htbp">
<img src="../svg/week-04-notes/fig18.svg" />
<figcaption><strong>Figure 6.</strong> The canonical feedback form in both notations. The summing junction becomes the node <span class="arithmatex">\(E\)</span>, and its minus sign is absorbed into the feedback branch gain <span class="arithmatex">\(-H\)</span>.</figcaption>
</figure>

The vocabulary Mason’s formula needs is all about routes through the graph. Figure [7](#fig:sfgterms) is a graph carrying one of each.

- A **path** is any route along branches, following the arrows, that passes through no node twice.

- A **forward path** is a path from the source node to the sink node. Its **forward-path gain** is the product of the gains along it.

- A **loop** is a closed path that starts and ends at the same node, visiting no other node twice. Its **loop gain** is the product of the gains around it — including the minus signs.

- Two loops are **non-touching** if they share *no node at all*.

<figure id="fig:sfgterms" data-latex-placement="htbp">
<img src="../svg/week-04-notes/fig19.svg" />
<figcaption><strong>Figure 7.</strong> Signal flow graph vocabulary. Loop 1 touches nodes <span class="arithmatex">\(x_1,x_2\)</span> and loop 2 touches <span class="arithmatex">\(x_3,C\)</span>; because those sets are disjoint, the two loops are non-touching, and Mason’s formula will carry a product term for the pair.</figcaption>
</figure>

/// admonition | Common pitfall
    type: warning

“Non-touching” means *no shared node* — not “drawn without crossing”, and not “no shared branch”. Two loops that meet at a single node are touching, and contribute no product term. Getting this wrong is the most common source of a wrong $\Delta$, and because the error is in a term you simply failed to write, nothing in the algebra flags it. Check every pair of loops explicitly: list each loop’s nodes, then compare the lists.

///

### 7. Mason’s gain formula { #sec:mason }

Mason’s gain formula reads the transfer function between a source node and a sink node straight off the graph, with no redrawing at all: 

<a id="eq:errortf"></a>

$$\begin{equation}
  T(s) = \frac{\displaystyle\sum_{k} P_k\,\Delta_k}{\Delta} ,
  \tag{3}
\end{equation}$$

 where

- $P_k$ is the gain of the $k$-th forward path, summed over *all* forward paths;

- $\Delta$ is the **determinant** of the graph, built from the loop gains as in [(4)](#eq:delta) below;

- $\Delta_k$ is the **cofactor** of path $k$: the determinant $\Delta$ recomputed with every loop that *touches* path $k$ deleted from the graph.

The determinant is an alternating sum over the loops, taken one at a time, then in non-touching pairs, then in non-touching triples: 

<a id="eq:mason"></a>

$$\begin{equation}
  \Delta = 1
    - \sum_{i} L_i
    + \sum_{\substack{\text{pairs }i,j\\ \text{non-touching}}} L_iL_j
    - \sum_{\substack{\text{triples }i,j,k\\ \text{non-touching}}} L_iL_jL_k
    + \cdots
  \tag{4}
\end{equation}$$

 where $L_i$ is the gain of the $i$-th loop, signs included. In this unit the sum almost always stops at the pairs; triples need three loops that mutually share no node, which takes a larger graph than any examination question here will set.

Two special cases are worth noting before we use it. If every loop touches every forward path — which is true of most single-input single-output control diagrams — then every $\Delta_k=1$ and [(3)](#eq:mason) collapses to $\left(\sum_k P_k\right)/\Delta$. And for the canonical feedback form of Figure [6](#fig:bd2sfg), there is one forward path $P_1=G$ and one loop $-GH$, so $\Delta=1+GH$, $\Delta_1=1$, and Mason gives $T=G/(1+GH)$ — the formula of §[2](#sec:connections), recovered as the simplest possible case.

/// admonition | Key idea
    type: info

Block-diagram reduction and Mason’s formula are two routes to the same transfer function, and the choice between them is practical, not mathematical. Reduction is clearer for a diagram with two or three nested loops and tells a story about the physics as you go. Mason wins the moment loops overlap or forward paths multiply, because it never requires the diagram to be redrawn — and a diagram that is never redrawn cannot be redrawn wrongly.

///

/// admonition | Worked example 4.4 — the overlapping-loop system again
    type: example

Take the system of Worked example 4.3 — Figure [5](#fig:overlap)(a), with $G_1=5$, $G_2=1/(s+2)$, $G_3=1/(s+1)$, $H_1=1$, $H_2=8$ — and apply Mason’s formula to it directly.

**Forward paths.** There is one: 

$$P_1 = G_1G_2G_3 = \frac{5}{(s+1)(s+2)} .$$

**Loops.** There are two. Loop 1 runs forward through $G_1$ and $G_2$ and back through $H_1$; loop 2 runs forward through $G_2$ and $G_3$ and back through $H_2$: 

$$L_1 = -G_1G_2H_1 = -\frac{5}{s+2},
  \qquad
  L_2 = -G_2G_3H_2 = -\frac{8}{(s+1)(s+2)} .$$

 They both pass through the node at the output of $G_2$, so they *touch*: there is no non-touching pair, and $\Delta$ stops after the loop-gain sum.

**Determinant and cofactor.** 

$$\Delta = 1-(L_1+L_2) = 1+\frac{5}{s+2}+\frac{8}{(s+1)(s+2)} ,
  \qquad \Delta_1 = 1$$

 ($\Delta_1=1$ because the single forward path passes through both loops).

**Result.** Multiplying numerator and denominator of [(3)](#eq:mason) by $(s+1)(s+2)$, 

$$T(s)=\frac{P_1\Delta_1}{\Delta}
   =\frac{5}{(s+1)(s+2)+5(s+1)+8}
   =\frac{5}{s^{2}+8s+15}
   =\frac{5}{(s+3)(s+5)} ,$$

 which is exactly the answer Worked example 4.3 obtained — with no pick-off move, no redrawn diagram and no intermediate transfer functions to mislay.

///

/// admonition | Worked example 4.5 — two forward paths and a non-touching pair
    type: example

Figure [8](#fig:mason-ex) shows a graph with a feedforward branch and two loops that do not touch. Take 

$$G_1=1,\quad G_2=\frac{2}{s+1},\quad G_3=\frac{1}{s+2},\quad G_4=4,
  \quad G_5=2,\quad H_1=3,\quad H_2=2 .$$

 Find $T(s)=C(s)/R(s)$.

**Forward paths.** Two: 

$$P_1 = G_1G_2G_3G_4 = \frac{8}{(s+1)(s+2)}
  \qquad\text{(through the whole chain)},$$

 

$$P_2 = G_5 = 2
  \qquad\text{(the feedforward branch $x_1\to C$)} .$$

**Loops.** Two: $L_1=-G_1H_1=-3$ around $x_1,x_2$, and $L_2=-G_3H_2=-2/(s+2)$ around $x_3,x_4$. Their node sets $\{x_1,x_2\}$ and $\{x_3,x_4\}$ are disjoint, so this pair *is* non-touching and contributes a product term: 

$$\Delta = 1-(L_1+L_2)+L_1L_2
   = 1+3+\frac{2}{s+2}+\frac{6}{s+2}
   = 4+\frac{8}{s+2}
   = \frac{4(s+4)}{s+2} .$$

**Cofactors.** Path $P_1$ runs through every node of both loops, so $\Delta_1=1$. Path $P_2$ leaves the chain at $x_1$, so it touches loop 1 but *not* loop 2 — loop 2 survives in its cofactor: 

$$\Delta_2 = 1 - L_2 = 1+\frac{2}{s+2}=\frac{s+4}{s+2} .$$

**Result.** 

$$T(s)=\frac{P_1\Delta_1+P_2\Delta_2}{\Delta}
   =\frac{\dfrac{8}{(s+1)(s+2)}+\dfrac{2(s+4)}{s+2}}
         {\dfrac{4(s+4)}{s+2}} ,$$

 and multiplying numerator and denominator by $(s+1)(s+2)$, 

$$T(s)=\frac{8+2(s+4)(s+1)}{4(s+4)(s+1)}
   =\frac{2s^{2}+10s+16}{4(s+1)(s+4)}
   =\frac{s^{2}+5s+8}{2(s+1)(s+4)} .$$

**Reading the answer.** The closed-loop poles are at $-1$ and $-4$, and the d.c. gain is $T(0)=8/8=1$. The interesting part is the numerator: the feedforward path has given the system a pair of *zeros*, at $s=-2.5\pm\mathrm{j}1.32$, where the chain alone had none. This is Week 3’s lesson arriving from a new direction — a parallel route through a system puts zeros in its transfer function, and those zeros reshape the transient without changing a single pole.

///

<figure id="fig:mason-ex" data-latex-placement="htbp">
<img src="../svg/week-04-notes/fig20.svg" />
<figcaption><strong>Figure 8.</strong> Worked example 4.5: a graph with two forward paths (the chain, and the feedforward branch <span class="arithmatex">\(G_5\)</span>) and a non-touching pair of loops.</figcaption>
</figure>

### 8. Systems with more than one input { #sec:twoinput }

An LTI system’s response to several inputs acting at once is the sum of its responses to each acting alone — superposition, which holds precisely because the system is linear. In block-diagram terms: to find the transfer function from one input, set all the other inputs to zero and reduce the diagram as usual; then add the contributions.

<figure id="fig:twoinput" data-latex-placement="htbp">
<img src="../svg/week-04-notes/fig21.svg" />
<figcaption><strong>Figure 9.</strong> A system with a second input <span class="arithmatex">\(U\)</span> entering between the two forward blocks. Its response is found by superposition: one reduction with <span class="arithmatex">\(U=0\)</span>, a second with <span class="arithmatex">\(R=0\)</span>.</figcaption>
</figure>

Take Figure [9](#fig:twoinput) with $G_1=2$, $G_2=3/(s+1)$ and unity feedback. Setting $U=0$ leaves the canonical form with forward path $G_1G_2=6/(s+1)$: 

$$\frac{C(s)}{R(s)} = \frac{G_1G_2}{1+G_1G_2}
   = \frac{\dfrac{6}{s+1}}{1+\dfrac{6}{s+1}}
   = \frac{6}{s+7} .$$

 Setting $R=0$ instead, $U$ sees only $G_2$ on the way out, but the same loop on the way round: 

$$\frac{C(s)}{U(s)} = \frac{G_2}{1+G_1G_2}
   = \frac{\dfrac{3}{s+1}}{1+\dfrac{6}{s+1}}
   = \frac{3}{s+7} ,$$

 and the total response is 

$$C(s) = \frac{6}{s+7}R(s) + \frac{3}{s+7}U(s) .$$

 The two transfer functions share a denominator — necessarily, since both are governed by the same characteristic equation $1+G_1G_2=0$ — and differ only in numerator, because $U$ enters the loop further downstream and so is amplified less. Here a unit step at $U$ produces half the steady-state output of a unit step at $R$.

/// admonition | Key idea
    type: info

Superposition means one characteristic equation, several numerators. Extra inputs change *what* the system responds to; they cannot change *how* it responds, because the poles belong to the loop, not to the input.

///

*Where this stops in FEE3411.* When the second input is something unwanted — a load torque, a supply fluctuation, sensor noise — it is called a disturbance, and the interesting question becomes how to design a loop that rejects it. Computing the response, as above, is analysis and belongs here. Designing for disturbance rejection, and dealing with plant uncertainty and measurement noise, is FEE3412’s work; Khalil §4-4 to §4-8 and Nise §7.5 and §7.7 are worth reading for interest, but are not examinable in this unit.

## Summary { #summary }

- A block diagram has three elements — block, summing junction, pick-off point — and encodes one algebraic equation in $s$ per block and per junction. A pick-off point copies a signal; it does not divide it.

- Cascade gives $G_1G_2$, parallel gives $G_1\pm G_2$, negative feedback gives $G/(1+GH)$. The cascade rule assumes no loading between stages.

- In canonical form, $G$ is the forward path, $GH$ the open-loop transfer function, $T=G/(1+GH)$ the closed-loop transfer function and $1/(1+GH)$ the error transfer function. The closed-loop poles are the roots of the characteristic equation $1+GH=0$.

- Feedback does not change the number of poles; it relocates them. That relocation is the whole purpose of closing a loop.

- Block-diagram algebra adds two moving rules: a summing junction moved against the flow divides by the block, and a pick-off point moved with the flow needs a compensating $1/G$ on the moved branch.

- Nested loops reduce from the inside out. *Overlapping* loops do not — they need a junction move first, which is where hand reduction becomes error-prone.

- A signal flow graph replaces blocks with branch gains and summing junctions with nodes, absorbing feedback signs into the branch gains.

- Mason’s gain formula, $T=\sum_kP_k\Delta_k/\Delta$, reads the transfer function off the graph with no redrawing. $\Delta$ alternates signs over loop gains, then products of non-touching pairs, then triples; $\Delta_k$ deletes the loops that touch path $k$. “Non-touching” means sharing no node.

- Several inputs are handled by superposition: one transfer function per input, all sharing the same denominator.

## Before the tutorial { #before-the-tutorial }

1.  A unity-feedback system has $G(s)=12/[s(s+8)]$. Write down its open-loop transfer function, its characteristic equation, and its closed-loop transfer function. Are the closed-loop poles real or complex?

2.  In the canonical form, which of $G$, $GH$ and $G/(1+GH)$ would a question mean by “the loop gain”? Which sets the closed-loop poles?

3.  A pick-off point sits before a block $G(s)=4/(s+3)$ and feeds a branch of gain $2$. Redraw it with the pick-off taken *after* the block, and state the new branch gain.

4.  Draw the signal flow graph of a unity-feedback system whose forward path is a cascade of $G_1$ and $G_2$, then use Mason’s formula to confirm you get $G_1G_2/(1+G_1G_2)$. How many forward paths and loops did you find?

## Looking ahead { #looking-ahead }

This week finished the modelling half of FEE3411. From Week 2’s differential equations, through Week 3’s transfer functions, to this week’s interconnection rules, we can now write down a single $T(s)$ for a complete control system — and every remaining week of the unit is about interrogating that one function. Week 5 starts immediately: it takes the $\omega_{n}$ and $\zeta$ read off denominators like $s^{2}+3s+4$ in Worked example 4.2 and turns them into overshoot, rise time, peak time and settling time. Week 6 asks what steady-state error the response settles to, and Week 7 asks the question this week quietly set up — whether the roots of $1+G(s)H(s)=0$ are all in the left half plane at all. Assignment 2 covers Weeks 3 and 4 together: transfer functions, block-diagram reduction, signal flow graphs and Mason’s rule. The boundary holds as always — locating a closed-loop pole is *analysis* and belongs here; choosing $G(s)$ to put it somewhere better is *design*, and belongs to FEE3412.
