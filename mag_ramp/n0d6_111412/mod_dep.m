% l2m2 l4m2

f_peaks = [5220, 5220, 5185, 5185, 5151, 5151, 5116]*0.0001;
le_f = Le(2:8);

f_peaks = [5047, 5012, 4978]*0.0001;
le_f = Le(9:11);

le_matr = horzcat(le_f.^0.6, ones(size(le_f))); 

x = le_matr\f_peaks'

(mean((le_matr*x - f_peaks').^2))^0.5
