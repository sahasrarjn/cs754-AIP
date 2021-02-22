## 2

RMSE : $norm(x'-x)/norm(x)$

- a) RMSE  = 

- b) RMSE = 

- c) RMSE = 

  

- d) RMSE = 0.7-0.9 

  The error is very high for the algorithm to work. The algorithm gives very bad results.



##  4

We Have:

- $\delta_{S}$ = $\max\{1-\lambda_{\min},\lambda_{\max}-1\}$
- $\lambda_{\max}$ = $\max_{\theta_{\tau}\epsilon\R^{S},|\tau|\le S}\frac{||A_{\tau}\theta_{\tau}||^2}{||\theta_{\tau}||^2}$ 
- $\lambda_{\min}$ = $\min_{\theta_{\tau}\epsilon\R^{S},|\tau|\le S}\frac{||A_{\tau}\theta_{\tau}||^2}{||\theta_{\tau}||^2}$

As $S\lt T$ ;
$$
|\tau| \le T \text{ can be divided as } \tau' \text{ and } \tau'' \text{ such that }\\
|\tau'| \le S \text{ and } S \lt |\tau''| \le T
$$

$$
\lambda_{S\max} = \max_{\theta_{\tau}\epsilon\R^{S},|\tau|\le S}\frac{||A_{\tau}\theta_{\tau}||^2}{||\theta_{\tau}||^2} \text{ , }
\lambda_{T\max} = \max_{\theta_{\tau}\epsilon\R^{T},|\tau|\le T}\frac{||A_{\tau}\theta_{\tau}||^2}{||\theta_{\tau}||^2}\\
$$

- 

$$
\max_{\theta_{\tau}\epsilon\R^{T},|\tau|\le T}\frac{||A_{\tau}\theta_{\tau}||^2}{||\theta_{\tau}||^2} = \max(\max_{\theta_{\tau}\epsilon\R^{T},|\tau|\le S}\frac{||A_{\tau}\theta_{\tau}||^2}{||\theta_{\tau}||^2}, \max_{\theta_{\tau}\epsilon\R^{T},S \lt |\tau|\le T}\frac{||A_{\tau}\theta_{\tau}||^2}{||\theta_{\tau}||^2})\\
= \max(\max_{\theta_{\tau}\epsilon\R^{S},|\tau|\le S}\frac{||A_{\tau}\theta_{\tau}||^2}{||\theta_{\tau}||^2}, \max_{\theta_{\tau}\epsilon\R^{T},S \lt |\tau|\le T}\frac{||A_{\tau}\theta_{\tau}||^2}{||\theta_{\tau}||^2})\\
= \max(\lambda_{S \max}, \max_{\theta_{\tau}\epsilon\R^{T},S \lt |\tau|\le T}\frac{||A_{\tau}\theta_{\tau}||^2}{||\theta_{\tau}||^2})\\
\Rightarrow \lambda_{T \max} \ge \lambda_{S \max}\\
\Rightarrow \lambda_{T \max}-1 \ge \lambda_{S \max}-1
$$

- 

$$
\min_{\theta_{\tau}\epsilon\R^{T},|\tau|\le T}\frac{||A_{\tau}\theta_{\tau}||^2}{||\theta_{\tau}||^2} = \min(\min_{\theta_{\tau}\epsilon\R^{S},|\tau|\le S}\frac{||A_{\tau}\theta_{\tau}||^2}{||\theta_{\tau}||^2}, \min_{\theta_{\tau}\epsilon\R^{T},S \lt |\tau|\le T}\frac{||A_{\tau}\theta_{\tau}||^2}{||\theta_{\tau}||^2})\\
= \min(\lambda_{S \min}, \min_{\theta_{\tau}\epsilon\R^{T},S \lt |\tau|\le T}\frac{||A_{\tau}\theta_{\tau}||^2}{||\theta_{\tau}||^2})\\
\Rightarrow \lambda_{T \min} \le \lambda_{S \min}\\
\Rightarrow 1-\lambda_{T \min} \ge 1-\lambda_{S \min}
$$

Case 1  

$\lambda_{T \max}-1\ge 1-\lambda_{T \min}$:

As $\lambda_{T \max}-1 \ge \lambda_{S \max}-1$ and $\lambda_{T \max}-1\ge 1-\lambda_{T \min} \ge 1-\lambda_{S \min}$

 $\max\{\lambda_{T \max}-1,1-\lambda_{T \min}\}\ge\max\{\lambda_{S \max}-1,1-\lambda_{S \min}\}$

$\delta_T\ge\delta_S$



Case 2 

 $1-\lambda_{T \min}\ge\lambda_{T \max}-1$:

As $1-\lambda_{T \min}\ge\lambda_{T \max}-1 \ge \lambda_{S \max}-1$ and $1-\lambda_{T \min} \ge 1-\lambda_{S \min}$

$\max\{\lambda_{T \max}-1,1-\lambda_{T \min}\}\ge\max\{\lambda_{S \max}-1,1-\lambda_{S \min}\}$

$\delta_T\ge\delta_S$



$\therefore \delta_T\ge\delta_S$



## 5

- **[Error Correction Codes for COVID-19 Virus and Antibody Testing: Using Pooled Testing to Increase Test Reliability](https://arxiv.org/pdf/2007.14919.pdf)**

  

- **Key Objective Function:** 

  > ​		minimize $||z||_1 + \lambda||{\bf y-Az-u}||_1,$
  >
  > ​		subject to $||{\bf u}||_2 \le \epsilon,$
  >
  > ​								$z \ge 0,$

   where $||z||_1$ is the sum of absolute value of all the elements of z

  $\lambda \in \R $ is a tuning parameter for controlling the tradeoff between  $||z||_1$ & $||{\bf Az - y-u}||_1$

  $\epsilon \ge 0$ is a parameter controlling the tolerance for noise, $x \ge 0$ means that every element of x is nonnegative

  $||{\bf u}||_2$ is the $l_2$ norm of $\bf u$ 

  

  Assume that we can get $n$ samples for $n$ subjects with one sample for each, and we will perform $m$ tests to determine the quantities of COVID-19 viruses in these samples.

  > ${\bf x} \in [0,\infty)^n$ : The quantity of the DNA that can be generated from the subjects' viral RNAs
  >
  > ${\bf P} \in \{0,1\}^{m\times n}$: matrix to denote participation of $n$ samples in $m$ tests ($P_{ij} = 1$ if $j^{th}$ sample took part in $i^{th}$ test, else $P_{ij}=0$ )
  >
  > ${\bf W} \in [0,1]^{m \times n}$: $W_{ij}$ is the fraction of the $j^{th}$ sample used in the $i^{th}$ test.
  >
  > $\bf A := P \circ W$:  our measurement matrix where $\circ$ represents Hadamard multiplication. 

  

  The corresponding $m$ mixed samples will go through $m$ quantitative PCR to quantify amount of DNAs. Due to potential background noises and gross errors caused by factors such as dilutions, sample and reagent contamination, and operation mistakes, the final measurements ${\bf y} \in \R^m$ from the real-time PCR can be modeled as

  > $\bf y = Ax + e + v$
  >
  > ${\bf Ax} \in \R^m$: True signal
  >
  > ${\bf v} \in \R^m$: Observation noise
  >
  > ${\bf e} \in \R^m$: possible gross error

  Our goal is to recover ${\bf x} \in [0, \infty)^n$ which is what is achieved by our Key Objective Function

  where $\bf z$ is an estimate of $\bf x$, $\bf u$ is an estimate of $\bf v$, and $\bf y-Az-u$ is an estimate of $\bf e$.



- - The main purpose of error correcting pooled testing is to increase test reliability, not to reduce required test numbers as in tapestry pooling.
  - In error detection codes using pooled testing, it doesn't require the involved signal to be sparse as what we consider in tapestry pooling: the signal can be fully dense in the proposed strategy.
  - The intuition behind tapestry is that the current rate of COVID-19 infections in the world population means that most samples tested are not infected, so most tests are wasted on uninfected samples. So tapestry uses this redundancy by group pooling to save on testing resources.
  - The intuition behnd the proposed strategy is that when each individual's sample is part of many pooled sample mixtures, the test results from all of the sample mixtures contain redundant information about each individual's diagnosis, which can be exploited to automatically correct for wrong test results in exactly the same way that error correction codes correct errors introduced in noisy communication channels.
  - Tapestry uses a two-stage approach. In the first stage all the negative pools are identified and the comprising samples are ruled out for the next step. In the second stage compressive sensing is applied to decrease false positives and estimate respective viral loads.
  - The proposed approach uses compressive sensing by assuming the gross error is sparse to estimate viral loads in any regime (undersampled or oversampled) without increasing number of tests required. So it is single stage.



## 6

- P1:  $\min_x||x||_1$ s. t. $||y=\phi x||_2 \le \epsilon$ 

- LASSO: $\min_x (||y-\phi x||_2^2 + \lambda||x||_1)$ 

Let's take $\epsilon = ||y-\phi x||_2$  where x is solution to LASSO problem

Let's suppose $x'$ is the solution to P1 problem.

So,

$||y-\phi x'||_2 \le ||y-\phi x||_2$ 

$||y-\phi x'||_2^2 \le ||y-\phi x||_2^2$                       						(As both are positive)

$||y-\phi x'||_2^2 + \lambda||x'||_1 \ge ||y-\phi x||_2^2 + \lambda||x||_1$ 		   (As x is a minimizer to LASSO)

$ \lambda(||x'||_1 - ||x||_1) \ge ||y-\phi x||_2^2 - ||y-\phi x'||_2^2 $

$ \lambda(||x'||_1 - ||x||_1) \ge 0 $

$||x'||_1\ge||x||_1$ 																   (As $\lambda$ is positive)

$||x'||_1=||x||_1$ 																   (As $x'$ is a minimizer of P1)

This implies $x$ is also a minimizer of the problem P1. ( As  $||y-\phi x||_2 = \epsilon$)

We have proved that for this $\epsilon$ it, indeed, is possible.

Therefore, there exists some value of $\epsilon$ for which minimizer of LASSO is also a minimizer of P1.

