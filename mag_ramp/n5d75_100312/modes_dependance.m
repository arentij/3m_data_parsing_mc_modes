f_peaks = [0.18, 0.31, 0.435, 0.497, 0.559, 0.59, 0.652];
f_peaks = [2018, 3105, 4347, 4968, 5589, 5899, 6365]/10000;
le_f = Le(3:9);

le_matr = horzcat(le_f.^1, ones(size(le_f))); 

x = le_matr\f_peaks'

(mean((le_matr*x - f_peaks').^2))^0.5
