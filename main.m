sample_num = 1000000;

% Preallocation for error of probability
Pe_sc = zeros(5, 4, 2);
Pe_mrc = zeros(5,4, 2);
Pe_egc = zeros(5,4, 2);
Pe_dc = zeros(5,4, 2);
tic

for R = 0:1
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
            g_tmp = repmat(g,2,1,1); % replicate for 2 bits

            tx_data = repmat(data,1,1,L); % replicate for L branches
            % received signal
            r = g_tmp.*tx_data + n; 

            %%% Selective combining %%%
            g_abs = abs(g); % energy of fading gain
            [g_max, I] = max(g_abs,[],3); % find index of fading gain
            r_sc_tmp = zeros(2,sample_num); 
            g_sc = zeros(2,sample_num);

            % Select corresponding fading gain and received signal from indices
            for i = 1:sample_num
               r_sc_tmp(:,i) = r(:,i,I(i)); 
               g_sc(:,i) = g_tmp(:,i,I(i));
            end
            r_sc = real(exp(-1i*angle(g_sc)).*r_sc_tmp); % remove the phase shift
            result_sc = (r_sc > 0)*2 -1; % map to +1, -1

            % Calculate error of probability
            Pe_sc(enr_index, L, R+1) = get_error_prob(result_sc, data, sample_num);

            %%% Maximal Ratio Combining %%%
            r_mrc = real(sum(conj(g_tmp).*r,3)); 
            result_mrc = (r_mrc > 0)*2 -1;
            Pe_mrc(enr_index, L, R+1) = get_error_prob(result_mrc, data, sample_num);

            %%% Equal Gain Combining %%%
            r_egc = real(sum(exp(-1i*angle(g_tmp)).*r,3));
            result_egc = (r_egc > 0)*2 -1;
            Pe_egc(enr_index, L, R+1) = get_error_prob(result_egc, data, sample_num);

            %%% Direct Combining %%%
            %r_dc = real(exp(-1i*angle(sum(r,3))).*sum(r,3));
            r_dc = real(sum(r,3));
            result_dc = (r_dc > 0)*2 -1;
            Pe_dc(enr_index, L, R+1) = get_error_prob(result_dc, data, sample_num);
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
