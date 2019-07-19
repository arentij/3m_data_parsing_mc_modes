% main peaks at IW

f_peaks = [0.76, 0.7765, 0.7917, 0.8228, 0.8538, 0.885, 0.87, 0.9159, 0.947, 0.9625];
ro_f = ro(1:length(f_peaks));

ro_matr = horzcat(ro_f, ones(size(ro_f))); 

x = ro_matr\f_peaks'


line_ro = -40*ones(D,L);

spectrum_m2 = squeeze(spectrum_sp_harm(7,:,:));
for i=1:L
    fi = ro(i)*x(1)+x(2);
    spectrum_m2(fix(fi/f(D)*D),i)=1;
end

figure(3)
s = pcolor(ro,f(1:D),spectrum_m2);
set(s, 'EdgeColor', 'none');
% caxis([-40 29]);
xlabel('Rossby number','FontSize',18)
ylabel('\omega/\Omega_{out}','FontSize',18)
colorbar
