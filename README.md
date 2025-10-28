# Optimization Techniques Assignments 2024-2025

This repository contains the assignments for the "Optimization Techniques" course at ECE AUTH for the academic year 2024-2025. 
The work covers fundamental optimization concepts, including unconstrained, constrained, and non-linear optimization techniques.

## Assignment 1: 1D Function Minimization
**Goal:** Minimize convex functions within a predefined interval.

**Methods Studied:**
- Derivative-Free Methods: Bisection Method, Golden Section Search, Fibonacci Search.
- Derivative-Based Method: Bisection Method using derivatives.

**Key Findings:**
- Bisection Method with derivatives was the most efficient overall.
- Among derivative-free methods, Fibonacci Search was the most computationally efficient.

## Assignment 2: Unconstrained Minimization
**Goal:** Perform unconstrained minimization of a given objective function.

**Methods Studied:**
- Steepest Descent
- Newton Method
- Levenberg-Marquardt Method

**Key Findings:**
- Step size selection significantly affects performance. Adaptive selection accelerates convergence.
- Levenberg-Marquardt combines the speed of Newton's method near the solution with the stability of Steepest Descent for points far from optimum or when the Hessian is not positive definite.

## Assignment 3: Constrained Minimization
**Goal:** Minimize a non-linear function subject to linear box constraints.

**Method Studied:** Projected Gradient Descent

**Key Findings:**
- Suitable for constrained problems, ensuring that successive points remain feasible.
- Convergence depends on step size selection. Improper selection can cause oscillations around the optimum but remains within the feasible set.
- Can start from non-feasible initial points successfully.

## Project: Traffic Flow Optimization using Genetic Algorithm (project-report.pdf)
**Goal:** Minimize total network traversal time per vehicle in a directed road network, subject to flow conservation and capacity constraints.

**Method Studied:** Genetic Algorithm

**Constraints Handled:**
- Flow conservation at nodes.
- Traffic capacity constraints.

**Key Findings:**
- Compared parent selection methods: Tournament, Roulette, Random.
- Tournament selection converges faster but risks premature local convergence; Roulette maintains higher diversity.
- Including the incoming vehicle rate as a gene allowed the Genetic Algorithm to outperform MATLAB's `fmincon`, showing robustness and adaptability.
