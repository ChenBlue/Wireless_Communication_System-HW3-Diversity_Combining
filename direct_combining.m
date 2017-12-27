function [BER, result] = direct_combining(r, sample_num, data)
% Direct combining

%r_dc = real(exp(-1i*angle(sum(r,3))).*sum(r,3));
r_dc = real(sum(r,3)); % Sum up directly
result = (r_dc > 0)*2 -1; % Detection
BER = get_BER(result, data, sample_num);