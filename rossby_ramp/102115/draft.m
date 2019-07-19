% main peaks at IW

f_peaks = [0.6117, 0.6186, 0.6255, 0.6324, 0.6403, 0.6472];
ro_f = ro(2:1+length(f_peaks));

ro_matr = horzcat(ro_f, ones(size(ro_f))); 

x = ro_matr\f_peaks'


line_ro = -40*ones(D,L);

spectrum_m2 = squeeze(spectrum_sp_harm(2,:,:));
for i=1:L
    fi = ro(i)*x(1)+x(2);
    spectrum_m2(fix(fi/f(D)*D),i)=1;
end

figure()
s = pcolor(ro,f(1:D),spectrum_m2);
set(s, 'EdgeColor', 'none');
caxis([-70 0]);
xlabel('Rossby number','FontSize',18)
ylabel('\omega/\Omega_{out}','FontSize',18)
colorbar
