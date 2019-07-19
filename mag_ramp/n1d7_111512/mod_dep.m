% l2m2 l4m2

f_peaks = [7882, 7830, 7571, 7674, 7674, 7623, 7623, 7519, 7467, 7415]*0.0001;
le_f = Le(3:12);

%l1m1
f_peaks = [5030, 4978, 4874, 4771, 4615, 4356]*0.0001;
le_f = Le(3:8);

le_matr = horzcat(le_f, ones(size(le_f))); 

x = le_matr\f_peaks'

(mean((le_matr*x - f_peaks').^2))^0.5
