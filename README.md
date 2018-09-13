# Wireless_Communication_System-HW3-Diversity_Combining
This is the homework from COM5170 **Wireless Communication** in National Tsing Hua University. We are going to implement several diversity combining strategies. The requirements are shown as following. </br>
There are L (L = 1, 2, 3, 4) diversity branches of uncorrelated Rayleigh/Ricean fading signals. The average symbol energy-to-noise power ratio Es/N0 of each branch is 1, 3, 5, 7, and 9 dB. Simulate the **QPSK** bit error rate for
1. Selective Combining
2. Maximal Ratio Combining
3. Equal Gain Combining
4. Direct Combining

## Algorithm
### Selective Combining (SC)
Select the branch with highest signal-to-noise from received signal. 
SNR of received signal: </br>
$$ SNR=\frac{|g_k |^2 E_s}{E[n^2 ]}, k=1-L $$
Because $\frac{E_s }{E[n^2 ]}$ is fixed, we only have to find largest $|g_k |^2$ among all branches. </br>
Next, compensate the phase shift $\phi _m $, where $g_k=\alpha _k e^{j\phi _k }$
$$ r(t)=\tilde{r}_m (t)\times e^{-j\phi _m } $$

### Maximal Ratio Combining (MRC)
The diversity branches are weighted by their complex fading gains and then combined.
$$ r(t)=\sum \_{k=1} ^L g_k ^* \tilde{r}(t)=\sum \_{k=1} ^L g_k ^* g_k \tilde{s}(t)+\sum \_{k=1} ^L g_k ^* \tilde{n}(t)=\sum \_{k=1} ^L |α_k |^2 \tilde{s}(t)+noise $$

### Equal Gain Combining (EGC)
Since QPSK has equal energy symbols, EGC is useful. The diversity branches are not weighted. We compensate the phase shift and combine all branches.
$$ r(t)=\sum \_{k=1} ^L e^{-j\phi _k } \tilde{r} _k (t)=\sum \_{k=1} ^L e^{-j\phi _k } g_k \tilde{s}(t)+\sum \_{k=1}^L e^{-j\phi _k } \tilde{n}_k (t)=\sum \_{k=1} ^L \alpha _k \tilde{s}(t)+noise $$

### Direct Combining
Combine all signals of branches directly and then compensates the overall phase shift.
$$ r(t)=e^{-j\phi } \sum \_{k=1} ^L \tilde{r} _k (t),    φ=∡(\sum \_{k=1} ^L \tilde{r} _k(t)) $$

## Result
### Rayleigh fading channel
1. Selective Combining </br>
![ray_sc](https://github.com/ChenBlue/Wireless_Communication_System-HW3-Diversity_Combining/blob/master/FIG/rayleigh_SC.jpg)
2. Maxmial Ratio Combining </br>
![ray_mrc](https://github.com/ChenBlue/Wireless_Communication_System-HW3-Diversity_Combining/blob/master/FIG/rayleigh_MRC.jpg)
3. Equal Gain Combining </br>
![ray_egc](https://github.com/ChenBlue/Wireless_Communication_System-HW3-Diversity_Combining/blob/master/FIG/rayleigh_EGC.jpg)
4. Direct Combining </br>
![ray_dc](https://github.com/ChenBlue/Wireless_Communication_System-HW3-Diversity_Combining/blob/master/FIG/rayleigh_DC.jpg)

### Ricean fading channel
1. Selective Combining </br>
![ric_sc](https://github.com/ChenBlue/Wireless_Communication_System-HW3-Diversity_Combining/blob/master/FIG/ricean_SC.jpg)
2. Maxmial Ratio Combining </br>
![ric_mrc](https://github.com/ChenBlue/Wireless_Communication_System-HW3-Diversity_Combining/blob/master/FIG/ricean_MRC.jpg)
3. Equal Gain Combining </br>
![ric_egc](https://github.com/ChenBlue/Wireless_Communication_System-HW3-Diversity_Combining/blob/master/FIG/ricean_EGC.jpg)
4. Direct Combining </br>
![ric_dc](https://github.com/ChenBlue/Wireless_Communication_System-HW3-Diversity_Combining/blob/master/FIG/ricean_DC.jpg)

### Comparison among all combining strategies
The following 2 figures are both use 4 branches.
1. Rayleigh </br>
![ray_all](https://github.com/ChenBlue/Wireless_Communication_System-HW3-Diversity_Combining/blob/master/FIG/Rayleigh_all.jpg)
2. Ricean </br>
![ric_all](https://github.com/ChenBlue/Wireless_Communication_System-HW3-Diversity_Combining/blob/master/FIG/Ricean_all.jpg)

* **Performance**: MRC > EGC > SC > DC

### Comparison between Rayleigh & Ricean channel
The following figure use Equal gain combining with 4 branches. </br>
![ray_ric](https://github.com/ChenBlue/Wireless_Communication_System-HW3-Diversity_Combining/blob/master/FIG/Ray%26Ric.jpg)

* **Performance**: Ricean > Rayleigh
