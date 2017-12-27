function Pe = get_BER(A,B,sample_num)
% Calculate bit error rate by counting how many elements in two matrices A
% and B are different. Next, divided the size the matrix to derive BER.
wrong = A~= B;
error_count = sum(sum(wrong));
Pe = error_count/sample_num/2;