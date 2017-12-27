sample_num = 1000000;

% Preallocation for Bit error rate
Pe_sc = zeros(5, 4, 2); % selective combining
Pe_mrc = zeros(5,4, 2); % maximal ratio combining
Pe_egc = zeros(5,4, 2); % equal gain combining
Pe_dc = zeros(5,4, 2); % direct combining
tic

for R = 0:1 % Rayleigh:0 ; Ricean:1
    % Different fading channel has different variance
    if R == 0  
        sigma = 1/sqrt(2);
    else
        sigma = 1/2;
    end
    for enr_index = 1:5
        enr_dB = (enr_index-1)*2+1; % energy-to-noise ratio:1, 3, 5, 7, 9 dB
        enr = 10^(enr_dB/10); 

        % generate QPSK data (2 bits)
        data = rand(2,sample_num); % 2*sample_num matrix
        data = 2*(data > 0.5)-1; % map to -1, 1

        Edata = sqrt(2); % symbol energy
        En = Edata/enr; % noise energy

        for L = 1:4
            % generate noise
            n = normrnd(0,sqrt(En/2),2,sample_num,L) + 1i*normrnd(0,sqrt(En/2),2,sample_num,L);

            % generate fading gain (R=0: Rayleigh; R=1: Riciean)
            g = normrnd(R/2,sigma,1,sample_num,L) + 1i*normrnd(R/sqrt(2),1/2,1,sample_num,L);
            g_tmp = repmat(g,2,1,1); % replicate for 2 bits (QPSK)

            tx_data = repmat(data,1,1,L); % replicate for L branches
            % received signal
            r = g_tmp.*tx_data + n; 

            %%% Selective combining %%%
            [Pe_sc(enr_index, L, R+1), result_sc] = selective_combining(g, g_tmp, r, sample_num, data);

            %%% Maximal Ratio Combining %%%
            [Pe_mrc(enr_index, L, R+1), result_mrc] = maximal_ratio_combining(g_tmp, r, sample_num, data);

            %%% Equal Gain Combining %%%
            [Pe_egc(enr_index, L, R+1), result_egc] = equal_gain_combining(g_tmp, r, sample_num, data);

            %%% Direct Combining %%%
            [Pe_dc(enr_index, L, R+1), result_dc] = direct_combining(r, sample_num, data);
        end
    end
end
toc

% Plot Rayleigh
figure,plot([1 3 5 7 9], Pe_sc(:,:,1),'-*')
set(gca, 'YScale', 'log')
title('BER of Selective Combining (Rayleigh)');
legend('L=1','L=2','L=3','L=4');
xlabel('SNR (dB)');
ylabel('Bit error rate');

figure,plot([1 3 5 7 9], Pe_mrc(:,:,1),'-*')
set(gca, 'YScale', 'log')
title('BER of Maximal Ratio Combining (Rayleigh)');
legend('L=1','L=2','L=3','L=4');
xlabel('SNR (dB)');
ylabel('Bit error rate');

figure,plot([1 3 5 7 9], Pe_egc(:,:,1),'-*')
set(gca, 'YScale', 'log')
title('BER of Equal Gain Combining (Rayleigh)');
legend('L=1','L=2','L=3','L=4');
xlabel('SNR (dB)');
ylabel('Bit error rate');

figure,plot([1 3 5 7 9], Pe_dc(:,:,1),'-*')
set(gca, 'YScale', 'log')
title('BER of Direct Combining (Rayleigh)');
legend('L=1','L=2','L=3','L=4');
xlabel('SNR (dB)');
ylabel('Bit error rate');

% Plot Riciean
figure,plot([1 3 5 7 9], Pe_sc(:,:,2),'-*')
set(gca, 'YScale', 'log')
title('BER of Selective Combining (Ricean)');
legend('L=1','L=2','L=3','L=4');
xlabel('SNR (dB)');
ylabel('Bit error rate');

figure,plot([1 3 5 7 9], Pe_mrc(:,:,2),'-*')
set(gca, 'YScale', 'log')
title('BER of Maximal Ratio Combining (Ricean)');
legend('L=1','L=2','L=3','L=4');
xlabel('SNR (dB)');
ylabel('Bit error rate');

figure,plot([1 3 5 7 9], Pe_egc(:,:,2),'-*')
set(gca, 'YScale', 'log')
title('BER of Equal Gain Combining (Ricean)');
legend('L=1','L=2','L=3','L=4');
xlabel('SNR (dB)');
ylabel('Bit error rate');

figure,plot([1 3 5 7 9], Pe_dc(:,:,2),'-*')
set(gca, 'YScale', 'log')
title('BER of Direct Combining (Ricean)');
legend('L=1','L=2','L=3','L=4');
xlabel('SNR (dB)');
ylabel('Bit error rate');

% Comparison among all combining strategies
% Rayleigh
figure,plot([1 3 5 7 9], Pe_dc(:,4,1),'-*',[1 3 5 7 9], Pe_sc(:,4,1),'-+',[1 3 5 7 9], Pe_egc(:,4,1),'-*',[1 3 5 7 9], Pe_mrc(:,4,1),'-+')
set(gca, 'YScale', 'log')
title('BER of SC & MRC & EGC & DC (Rayleigh)');
legend('Direct Combining','Selective Combining','Equal Gain Combinig','Maximal Ratio Combining');
xlabel('SNR (dB)');
ylabel('Bit error rate');

% Ricean
figure,plot([1 3 5 7 9], Pe_dc(:,4,2),'-*',[1 3 5 7 9], Pe_sc(:,4,2),'-+',[1 3 5 7 9], Pe_egc(:,4,2),'-*',[1 3 5 7 9], Pe_mrc(:,4,2),'-+')
set(gca, 'YScale', 'log')
title('BER of SC & MRC & EGC & DC (Ricean)');
legend('Direct Combining','Selective Combining','Equal Gain Combinig','Maximal Ratio Combining');
xlabel('SNR (dB)');
ylabel('Bit error rate');

% Comparison between Rayleigh and Ricean
figure,plot([1 3 5 7 9], Pe_egc(:,4,1),'-*',[1 3 5 7 9], Pe_egc(:,4,2),'-+')
set(gca, 'YScale', 'log')
title('BER of Rayleigh and Ricean');
legend('Rayleigh','Ricean');
xlabel('SNR (dB)');
ylabel('Bit error rate');
