% l2m2 l4m2

f_peaks = [0.795, 0.795, 0.788, 0.7812, 0.7743, 0.7674, 0.7674, 0.7605, 0.7536, 0.7466];
le_f = Le(11:20);

le_matr = horzcat(le_f, ones(size(le_f))); 

x = le_matr\f_peaks'

(mean((le_matr*x - f_peaks').^2))^0.5
