% main peaks at IW

f_peaks = [0.73, 0.75, 0.776, 0.807, 0.82, 0.846, 0.87, 0.88, 0.893, 0.91, 0.92];
ro_f = ro(1:length(f_peaks));

ro_matr = horzcat(ro_f, ones(size(ro_f))); 

x = ro_matr\f_peaks';


line_ro = -40*ones(D,L);

spectrum_m2 = spectrum_m;
for i=1:L
    fi = ro(i)*x(1)+x(2);
    spectrum_m2(i,fix(fi/f(D)*D))=30;
end

figure(4)
s = pcolor(ro,f(1:D),spectrum_m2');
set(s, 'EdgeColor', 'none');
caxis([-40 29]);
xlabel('Rossby number','FontSize',18)
ylabel('\omega/\Omega_{out}','FontSize',18)
colorbar
