# HW1 - CS754

## 1

1. We know that $\delta_{2s} \propto S$  (also the upperbound: $\delta_{2s} \leq \mu (s-1)$). So, as S increases, $\delta_{2s}$ will increase. Also as m is staying constant, the chances of any 2S columns of measuring matrix being linearly independent decreases as the length of column is fixed and S is increasing. 

   The constant terms ($C_1, C_2$) are increasing functions of $\delta_{2s}$, so they increases as S increases

   So from the above statements:

   - $\delta_{2s}$ increases as S increases
   - $C_1, C_2$ increases as $\delta_{2s}$ increases.

   Overall they increases in such a way that the overall term increases (if S increases and  remains the same). 

2. $m$ might not be present in the error bound but it is hidden in various terms.

   - The second term contains $\epsilon$ which depends on $m$. It depends on m and the distribution of the noise. For eg., 
     - For $\eta_i$ ~ Uniform(-r, r), i.e. uniform random noise which known error r, $\epsilon \geq r^2 m$
     - For $\eta$ ~ N(0,$\sigma^2$) with known $\sigma$, $\epsilon \geq 9m\sigma^2$
   - Theorem 3 holds only when the matrix satisfies RIP of order 2S. Now if we vary m, $\delta_{2s}$ will change and $C_1, C_2$ will change accordingly.
   - As m decreases, since $m > 2S$ is necessary for RIP, chances of matrix satisfying RIP will decrease.
   - For a sensing matrix $\Phi$ constructed, the matrix $A$ will obey the RIP of order S with overwhelming probability provided that the number of rows $m \geq CS \log(n/S)$.

   From the above mentioned points we can conclude that even if the error bound appears to be independent of $m$, terms in the error bound indirectly depends on m.



## 2

- RMSE for T=5 (flames) is 0.033017
- RMSE for T=3 is 0.11745
- RMSE for T=5 is 0.15479
- RMSE for T=7 is 0.19776





### 6

- [Compressed Sensing and Electron Microscopy - Peter Binev, Wolfgang Dahmen, Ronald DeVore, Philipp Lamby, Daniel Savu, and Robert Sharpley ∗](https://www.math.tamu.edu/~rdevore/publications/146.pdf)

  
