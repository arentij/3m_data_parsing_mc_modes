% l2m2 l4m2

f_peaks = [8433, 8121, 8121, 7809, 7809, 7809, 7809, 7809, 7809, 7496]*0.0001;
le_f = Le(3:12);


le_matr = horzcat(le_f.^0.6, ones(size(le_f))); 

x = le_matr\f_peaks'

(mean((le_matr*x - f_peaks').^2))^0.5
