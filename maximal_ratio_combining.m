function [BER, result] = maximal_ratio_combining(g_2, r, sample_num, data)
% Maximal ratio combining

r_mrc = real(sum(conj(g_2).*r,3)); % weighted by fading gain and combine
result = (r_mrc > 0)*2 -1; % Detection
BER = get_BER(result, data, sample_num);