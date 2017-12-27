function [BER, result] = selective_combining(g, g_2, r, sample_num, data)
% Selective Combining:
% First, find the max branch index in g(1*sample_num*branch number) matrix.
% Second, get corresponding gain and received signal and detect its symbol.
% Third, calculate the BER.

g_abs = abs(g); % energy of fading gain
[~, I] = max(g_abs,[],3); % find index of fading gain
r_sc_tmp = zeros(2,sample_num); 
g_sc = zeros(2,sample_num);

% Select corresponding fading gain and received signal from indices
for i = 1:sample_num
   r_sc_tmp(:,i) = r(:,i,I(i)); 
   g_sc(:,i) = g_2(:,i,I(i));
end
r_sc = real(exp(-1i*angle(g_sc)).*r_sc_tmp); % remove the phase shift
result = (r_sc > 0)*2 -1; % map to +1, -1

% Calculate bit error rate
BER = get_BER(result, data, sample_num);