
%l2m2
f_peaks = [9732, 9654, 9576, 9576, 9342]*0.0001;
le_f = Le(18:22);

f_peaks = [2647, 3192, 3503, 3893, 4048, 4282, 4360, 4515, 4593]*0.0001;
le_f = Le(7:15);

le_matr = horzcat(le_f.^0.6, ones(size(le_f))); 

x = le_matr\f_peaks'

(mean((le_matr*x - f_peaks').^2))^0.5
