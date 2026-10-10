---
title: "Assignment 2 — Transfer Functions, Block Diagrams and Mason’s Rule"
---

# Assignment 2 — Transfer Functions, Block Diagrams and Mason’s Rule
**ASSIGNMENT 2**

/// admonition | Reading
    type: quote

**Issued** Week 4. **Due** after 2 weeks. **Weight** 2.5% of the unit. **Total** 40 marks.

**Covers** Week 3 (the Laplace transform, transfer functions, poles and zeros, partial fractions, the final value theorem) and Week 4 (block-diagram representation and reduction, signal flow graphs and Mason’s gain formula). Question 1 needs only Week 3; Questions 2–4 need Week 4 as well.

**Submit** your own handwritten or typed solutions. This is individual work: you may discuss the questions with others, but what you hand in must be written by you.

///

## Question 1 — A transfer function, and the response it predicts **\[10 marks\]** { #question-1-a-transfer-function-and-the-response-it-predicts-10-marks }

In the series $RLC$ network of Figure [1](#fig:a2q1) the input is the source voltage $v_i(t)$ and the output is the voltage $v_o(t)$ across the *resistor*. Take $R=11\,\Omega$, $L=1\,\mathrm{H}$, $C=0.1\,\mathrm{F}$ and zero initial conditions.

<figure id="fig:a2q1" data-latex-placement="htbp">
<img src="../svg/assignment-2/fig01.svg" />
<figcaption><strong>Figure 1.</strong> Question 1: a series <span class="arithmatex">\(RLC\)</span> network with the output taken across the resistor.</figcaption>
</figure>

1.  Using the impedance method (no differential equation needed), derive $G(s)=V_o(s)/V_i(s)$ in terms of $R$, $L$ and $C$, then substitute the given values. **\[3 marks\]**

2.  State the poles, the zeros and the relative degree of $G(s)$, sketch its pole–zero map, and say what kind of filter this network is. **\[2 marks\]**

3.  Write down the d.c. gain of $G(s)$. Confirm it with the final value theorem applied to the unit-step response, and explain *physically* why the answer must come out as it does. **\[2 marks\]**

4.  Find $v_o(t)$ for a unit step input, $v_i(t)=u(t)$, by partial fractions. Which of the two natural modes governs the shape of the response after the first few tenths of a second, and why? **\[3 marks\]**

## Question 2 — Block-diagram reduction with overlapping loops **\[10 marks\]** { #question-2-block-diagram-reduction-with-overlapping-loops-10-marks }

Figure [2](#fig:a2q2) shows a servo with three feedback paths: a minor loop through $H_1$, a second minor loop through $H_2$, and unity feedback round the whole system. The blocks are 

$$G_1=4,\qquad
  G_2(s)=\frac{1}{s+4},\qquad
  G_3(s)=\frac{5}{s},\qquad
  H_1=0.5,\qquad
  H_2=1 .$$

<figure id="fig:a2q2" data-latex-placement="htbp">
<img src="../svg/assignment-2/fig02.svg" />
<figcaption><strong>Figure 2.</strong> Question 2: minor loop 1 spans <span class="arithmatex">\(G_1,G_2\)</span> and minor loop 2 spans <span class="arithmatex">\(G_2,G_3\)</span>. Neither contains the other.</figcaption>
</figure>

1.  Explain, in one or two sentences, why neither minor loop can be collapsed first by the standard closed-loop formula. **\[2 marks\]**

2.  Move the $H_2$ branch’s summing junction back through $G_1$, and move the $H_1$ branch’s pick-off point forward through $G_3$. State the gain each moved branch must now carry, and sketch the resulting diagram, in which all three feedback branches start at $C$ and return to one junction. **\[3 marks\]**

3.  Hence reduce the diagram to a single transfer function $T(s)=C(s)/R(s)$, and write down the characteristic equation. **\[3 marks\]**

4.  Give $\omega_{n}$, $\zeta$ and the closed-loop poles, and find the steady-state error for a unit step input. The forward path contains a free integrator ($G_3$), which ordinarily forces the steady-state error to zero — why does it not do so here? **\[2 marks\]**

## Question 3 — Signal flow graph and Mason’s gain formula **\[10 marks\]** { #question-3-signal-flow-graph-and-masons-gain-formula-10-marks }

Figure [3](#fig:a2q3) is the signal flow graph of a system with a feedforward branch from the input directly to node $x_3$. The branch gains are $G_1=2$, $G_2(s)=6/(s+3)$, $G_3=4$, $G_4=1$, $H_1=1$, $H_2=0.25$ and $H_3=1$.

<figure id="fig:a2q3" data-latex-placement="htbp">
<img src="../svg/assignment-2/fig03.svg" />
<figcaption><strong>Figure 3.</strong> Question 3: a signal flow graph with two forward paths and three loops.</figcaption>
</figure>

1.  List both forward paths and all three loops, giving the gain of each and the nodes it touches. **\[3 marks\]**

2.  Exactly one pair of loops is non-touching. Identify it, and hence write down the determinant $\Delta$ and simplify it to a single rational function of $s$. **\[2 marks\]**

3.  Find the cofactors $\Delta_1$ and $\Delta_2$, explaining in each case which loops survive, and hence obtain $T(s)=C(s)/R(s)$ by Mason’s gain formula. **\[3 marks\]**

4.  State the pole, the zero and the d.c. gain of $T(s)$. Recompute $T(s)$ with the feedforward branch removed ($G_4=0$) and say precisely what the branch contributed — and what it did *not*. **\[2 marks\]**

## Question 4 — Two inputs, and what the loop gain buys **\[10 marks\]** { #question-4-two-inputs-and-what-the-loop-gain-buys-10-marks }

A position servo is modelled as in Figure [4](#fig:a2q4): an adjustable amplifier of gain $K>0$ drives a plant $G_p(s)=4/[s(s+8)]$, and a disturbance $D(s)$ — a load torque — enters at the plant input. The feedback is unity.

<figure id="fig:a2q4" data-latex-placement="htbp">
<img src="../svg/assignment-2/fig04.svg" />
<figcaption><strong>Figure 4.</strong> Question 4: a unity-feedback servo with an adjustable gain <span class="arithmatex">\(K\)</span> and a disturbance entering at the plant input.</figcaption>
</figure>

1.  Using superposition, derive $C(s)/R(s)$ (with $D=0$) and $C(s)/D(s)$ (with $R=0$). **\[3 marks\]**

2.  Write down the characteristic equation. Why is it the same for both inputs, even though the two transfer functions are different? **\[2 marks\]**

3.  Find the value of $K$ that gives a damping ratio $\zeta=0.5$, and state $\omega_{n}$ and the closed-loop poles for that $K$. What value of $K$ would make the servo critically damped instead? **\[2 marks\]**

4.  With $K$ as found in (c), use the final value theorem to find (i) the steady-state error for a unit step reference with $D=0$, and (ii) the steady-state output produced by a unit step disturbance with $R=0$. Show that $\zeta=2/\sqrt{K}$, and comment on the design trade-off this exposes. **\[3 marks\]**

------------------------------------------------------------------------

<br>

End of Assignment 2. Total 40 marks.
