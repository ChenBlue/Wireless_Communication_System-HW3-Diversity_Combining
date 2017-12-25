function Pe = get_error_prob(A,B,sample_num)
wrong = A~= B;
error_count = sum(sum(wrong));
Pe = error_count/sample_num/2;