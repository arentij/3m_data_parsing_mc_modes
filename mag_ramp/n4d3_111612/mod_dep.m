% l2m2 l4m2

f_peaks = [9955, 9748, 9540, 9333, 9126, 8503]*0.0001;
le_f = Le(7:12);

f_peaks = [2696, 3526, 4355, 5185, 5392, 6015]*0.0001;
le_f = Le(3:8);

le_matr = horzcat(le_f.^0.6, ones(size(le_f))); 

x = le_matr\f_peaks'

(mean((le_matr*x - f_peaks').^2))^0.5
