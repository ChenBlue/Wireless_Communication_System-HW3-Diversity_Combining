sample_num = 100000;
gI = normrnd(0,sqrt(var(i)),1,sample_num);

enr_dB = 1;
Pe_sc = zeros(4,5);
Pe_mrc = zeros(4,5);
tic
for enr_index = 1:5
    enr_dB = (enr_index-1)*2+1;
    enr = 10^(enr_dB/10);

    % generate QPSK data
    data = rand(2,sample_num); 
    data = 2*(data > 0.5)-1;

    Edata = sqrt(2); % symbol energy
    En = Edata/enr; % noise energy

    
    for L = 1:4
        ni = normrnd(0,sqrt(En/2),2,sample_num,L);
        nq = normrnd(0,sqrt(En/2),2,sample_num,L);
        n = ni + 1i*nq;

        % generate fading gain
        gi = normrnd(0,1,1,sample_num,L);
        gq = normrnd(0,1,1,sample_num,L);
        g = gi + 1i*gq;
        g_tmp = repmat(g,2,1,1);

        tx_data = repmat(data,1,1,L);
        % received signal
        r = g_tmp.*tx_data + n;

        % Selective combining
        g_abs = abs(g);
        [g_max, I] = max(g_abs,[],3);
        r_sc = zeros(2,sample_num);
        result_sc = zeros(2, sample_num);
        error_count = 0;
        for i = 1:sample_num
           r_sc(:,i) = r(:,i,I(i));
           loss1 = sum(abs(r_sc(:,i) - g_tmp(:,i,I(i)).*[1;1]));
           loss2 = sum(abs(r_sc(:,i) - g_tmp(:,i,I(i)).*[1;-1]));
           loss3 = sum(abs(r_sc(:,i) - g_tmp(:,i,I(i)).*[-1;1]));
           loss4 = sum(abs(r_sc(:,i) - g_tmp(:,i,I(i)).*[-1;-1]));
           [~,index] = min([loss1 loss2 loss3 loss4]);
           size(index);
           if index==1
               result_sc(:,i) = [1;1];
           elseif index == 2
               result_sc(:,i) = [1;-1];
           elseif index == 3
               result_sc(:,i) = [-1;1];
           else
               result_sc(:,i) = [-1;-1];
           end

        end
        
        % Calculate error of probability
        wrong = result_sc~= data;
        error_count = sum(sum(wrong));
        Pe_sc(enr_index, L) = error_count/sample_num/2;
        
        % Maximal Ratio Combining
        r_mrc = real(sum(conj(g_tmp).*r,3));
        result_mrc = (r_mrc > 0)*2 -1;
        wrong = result_mrc~= data;
        error_count = sum(sum(wrong));
        Pe_mrc(enr_index, L) = error_count/sample_num/2;
        
        % Equal Gain Combining
        
    end
end
toc
%error_count
%figure,plot(Pe_sc)
%set(gca, 'YScale', 'log')
figure,plot(Pe_sc)
set(gca, 'YScale', 'log')

