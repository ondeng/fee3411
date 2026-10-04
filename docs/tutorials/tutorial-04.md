---
title: "Tutorial 4 — Block Diagrams, Signal Flow Graphs and Mason’s Rule"
---

# Tutorial 4 — Block Diagrams, Signal Flow Graphs and Mason’s Rule
**QUESTION SHEET**

This tutorial is reduction practice, and then the same diagram taken the other way. Question 1 is a nested two-loop reduction; Question 2 is an *overlapping*-loop diagram that needs a pick-off point moved before it will collapse; Question 3 converts that same diagram to a signal flow graph and evaluates it with Mason’s rule, so you finish the tutorial having done one system by both routes and seen the answers agree. The tutorial also extends Mason to a graph with a non-touching pair of loops, and revisits the canonical form with an unknown gain.

*Preparation:* Week 4 lecture notes, §1–§7.

/// admonition | Reading
    type: quote

**Quick reference**

**The three connections**<br>

$$\text{cascade: } G_1G_2,
  \qquad
  \text{parallel: } G_1\pm G_2$$

 

$$\text{negative feedback: } \frac{G}{1+GH}$$

 **Canonical form** 

$$T=\frac{C}{R}=\frac{G}{1+GH},
  \qquad
  \frac{E}{R}=\frac{1}{1+GH}$$

 

$$\text{characteristic equation: } 1+GH=0$$

 **Moving a junction past a block $G$** 

$$\text{summing junction, against the flow: } \div G$$

 

$$\text{pick-off point, with the flow: } \times\tfrac{1}{G}$$

**Mason’s gain formula**<br>

$$T = \frac{\sum_k P_k\Delta_k}{\Delta}$$

 

$$\Delta = 1-\sum_i L_i
    + \!\!\sum_{\substack{\text{non-touching}\\ \text{pairs}}}\!\! L_iL_j
    - \cdots$$

 $P_k$: gain of the $k$-th forward path.<br>
$L_i$: gain of the $i$-th loop, signs included.<br>
$\Delta_k$: $\Delta$ with every loop touching path $k$ deleted.<br>
Non-touching $=$ sharing *no node*.

**Second-order denominator** 

$$s^{2}+2\zeta\omega_{n}s+\omega_{n}^{2}$$

///

## Question 1 — Nested loops: reduce from the inside out { #question-1-nested-loops-reduce-from-the-inside-out }

Figure [1](#fig:q1) shows a position servo with an inner rate loop. The amplifier has gain $G_1=10$, the power stage is $G_2(s)=1/(s+5)$, the shaft integrates its input so $G_3(s)=1/s$, the rate sensor has gain $H_1=3$, and the position sensor is a unit-gain potentiometer.

<figure id="fig:q1" data-latex-placement="htbp">
<img src="../svg/week-04-tutorial/fig01.svg" />
<figcaption><strong>Figure 1.</strong> Question 1: a position servo with an inner rate loop.</figcaption>
</figure>

1.  Collapse the inner loop to a single block, and say what feedback has done to the pole of $G_3$.

2.  Cascade the amplifier and power stage with your result, then collapse the outer loop to find $T(s)=C(s)/R(s)$.

3.  Identify $\omega_{n}$ and $\zeta$, and give the closed-loop poles.

4.  What is the d.c. gain of the closed loop? Why is it not $1$, given that the forward path contains an integrator?

/// admonition | Common pitfall
    type: warning

It is tempting to write “the forward path has an integrator, so the d.c. gain is $1$”. That rule belongs to the *outer* loop’s forward path, and in this diagram the integrator is inside the inner loop, where feedback has already relocated its pole. Always check which loop a block ends up inside after the first collapse.

///

## Question 2 — Overlapping loops: move a pick-off point { #question-2-overlapping-loops-move-a-pick-off-point }

Figure [2](#fig:q2) has two loops that overlap: loop 1 (through $H_1$) spans $G_1$ and $G_2$, and loop 2 (through $H_2$) spans $G_2$ and $G_3$. The values are 

$$G_1=2,\qquad G_2(s)=\frac{1}{s+1},\qquad G_3(s)=\frac{4}{s+6},
  \qquad H_1=1,\qquad H_2=0.5 .$$

<figure id="fig:q2" data-latex-placement="htbp">
<img src="../svg/week-04-tutorial/fig02.svg" />
<figcaption><strong>Figure 2.</strong> Question 2: overlapping loops. Loop 1 spans <span class="arithmatex">\(G_1,G_2\)</span> and loop 2 spans <span class="arithmatex">\(G_2,G_3\)</span> — neither contains the other.</figcaption>
</figure>

1.  Explain in one sentence why this diagram cannot be reduced by collapsing an inner loop first.

2.  Move loop 1’s pick-off point forward through $G_3$, stating the gain the moved branch must now carry.

3.  Reduce the resulting nested diagram to find $T(s)=C(s)/R(s)$, in factored form.

4.  State the closed-loop poles and the d.c. gain.

## Question 3 — The same system, by SFG and Mason { #question-3-the-same-system-by-sfg-and-mason }

Now take the *original* diagram of Figure [2](#fig:q2) — before any junction was moved — and evaluate it the other way.

1.  Draw the signal flow graph. Use nodes $R$, $E_1$ (the output of the first summing junction), $E_2$ (the output of the second), $X$ (the output of $G_2$) and $C$.

2.  List every forward path with its gain, and every loop with its loop gain. Are the two loops touching or non-touching? Justify your answer by listing each loop’s nodes.

3.  Write down $\Delta$ and the cofactor $\Delta_1$, and evaluate Mason’s formula.

4.  Compare with your answer to Question 2(c). What have you gained, and what have you lost, by using Mason’s rule instead of reduction?

/// admonition | Key idea
    type: info

Doing one system both ways, as Questions 2 and 3 just did, is the best available check on a reduction. If the two routes disagree, the error is almost always a lost sign at a summing junction or a forgotten compensating factor on a moved branch — look there first, not at the arithmetic.

///

## Question 4 — Mason with a non-touching pair { #question-4-mason-with-a-non-touching-pair }

Figure [3](#fig:q4) is a signal flow graph with a feedforward branch. Take 

$$a_1=2,\quad a_2(s)=\frac{1}{s+1},\quad a_3(s)=\frac{4}{s+2},\quad a_4=1,
  \quad a_5=0.5,\quad b_1=1,\quad b_2=1 .$$

<figure id="fig:q4" data-latex-placement="htbp">
<img src="../svg/week-04-tutorial/fig03.svg" />
<figcaption><strong>Figure 3.</strong> Question 4: a graph with two forward paths and two loops.</figcaption>
</figure>

1.  Identify both forward paths and both loops, with their gains.

2.  Show that the two loops are non-touching, and hence write down $\Delta$.

3.  Show that your $\Delta$ factors as $(1-L_1)(1-L_2)$. Explain why this factorisation is guaranteed whenever the graph’s only two loops are non-touching.

4.  Find both cofactors $\Delta_1$ and $\Delta_2$, and hence $T(s)=C/R$.

5.  State the closed-loop poles and the d.c. gain. Where did the numerator’s zeros come from — and would they be there if $a_5$ were removed?

/// admonition | Common pitfall
    type: warning

The commonest error in this question is writing $\Delta_2=1$ out of habit. A cofactor is $1$ only when the path touches *every* loop. Before writing $\Delta_k$, list the nodes on path $k$ and strike out only the loops that share one — here that is loop 1 alone, which is why loop 2 stays in $\Delta_2$.

///

## Question 5 — The canonical form with an unknown gain { #question-5-the-canonical-form-with-an-unknown-gain }

A unity-feedback system has forward path 

$$G(s)=\frac{K}{s(s+5)},\qquad K>0 .$$

1.  Write down the open-loop transfer function, the characteristic equation and the closed-loop transfer function $T(s)$ in terms of $K$.

2.  Find the value of $K$ that gives a natural frequency $\omega_{n}=4\,\mathrm{rad}\,\mathrm{s}^{-1}$, and the damping ratio $\zeta$ that comes with it.

3.  Give the closed-loop poles for that $K$.

4.  Find the steady-state error to a unit step, using $E(s)/R(s)$. Explain the answer in one sentence.

5.  If $K$ is raised to $64$, what happens to $\omega_{n}$ and $\zeta$? State the general relationship between $K$ and $\zeta$ for this system, and say what it implies about raising gain to make a system faster.

## Question 6 — Two inputs, one characteristic equation { #question-6-two-inputs-one-characteristic-equation }

In Figure [4](#fig:q6) the reference is $R$, and $U$ is a second input entering between the two forward blocks. Take $G_a=5$, $G_b(s)=1/(s+3)$ and unity feedback.

<figure id="fig:q6" data-latex-placement="htbp">
<img src="../svg/week-04-tutorial/fig04.svg" />
<figcaption><strong>Figure 4.</strong> Question 6: a system with a second input entering after <span class="arithmatex">\(G_a\)</span>.</figcaption>
</figure>

1.  Find $C(s)/R(s)$ with $U=0$, and $C(s)/U(s)$ with $R=0$.

2.  Write the total response $C(s)$ in terms of both inputs.

3.  Why do the two transfer functions have the same denominator?

4.  $R$ is a unit step and $U$ is a constant $-2$ (a steady load pulling the output down). Find the steady-state value of $c(t)$.

5.  What constant value of $U$ would hold the output at zero in the steady state while the unit step at $R$ is still applied?
