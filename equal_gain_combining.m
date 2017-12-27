function [BER, result] = equal_gain_combining(g_2, r, sample_num, data)
% Equal gain combining

r_egc = real(sum(exp(-1i*angle(g_2)).*r,3)); % Cancel phase shift and combine
result = (r_egc > 0)*2 -1; % Detection
BER = get_BER(result, data, sample_num);