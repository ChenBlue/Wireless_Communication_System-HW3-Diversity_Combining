# Wireless_Communication_System-HW3-Diversity_Combining
This is the homework from COM5170 **Wireless Communication** in National Tsing Hua University. We are going to implement several diversity combining strategies. The requirements are shown as following. </br>
There are L (L = 1, 2, 3, 4) diversity branches of uncorrelated Rayleigh/Ricean fading signals. The average symbol energy-to-noise power ratio Es/N0 of each branch is 1, 3, 5, 7, and 9 dB. Simulate the QPSK bit error rate for
1. Selective Combining
2. Maximal Ratio Combining
3. Equal Gain Combining
4. Direct Combining

## Implementation
### Selective Combining
Select the branch with highest signal-to-noise from received signal. 
SNR of received signal: </br>
$$ SNR=\frac{|g_k |^2 E_s}{E[n^2 ]}, k=1~L $$
Because $E_s /(E[n^2 ])$ is fixed, we only have to find largest $|g_k |^2$ among all branches.
Next, compensate the phase shift $\phi _m $, where $g_k=\alpha _k e^(j\phi _k )$
$$ r(t)=\tilde{r}_m (t)\times e^{-j\phi _m } $$

