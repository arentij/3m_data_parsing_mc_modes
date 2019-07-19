folder = '091815';
% day_ind = 71;
% folder = char(days_unique(day_ind));
% importing log files
[data_control, data_magnet] = import_control_magnet_logs(folder);

torque_data = importdata(['/data/3m/' folder '/torque.dat' ]);

tt = torque_data(:,1);
t_d = torque_data(:,2);

% setting time arrays
tc = data_control(:,1);
tm = data_magnet(:,1);

% setting variables
fi =  data_control(:,14);   % inner freq
fo =  data_control(:,20);   % oiter freq
fo_r=data_control(:,19)/8.297;   % outer freq real
fi_r=data_control(:,13);   % inner freq real

tq = data_control(:,21);   % torque
T1 = data_control(:,2);   % temp 1
T2 = data_control(:,3);   % temp 2

ro = (fi-fo)./fo;           % rossby
mg = data_magnet(:,3);      % magnetic field


figure(1)
plot(tc,ro,'b',tm,mg/10,'r',tc,fo_r,'g',tc,fi,'c',tt, t_d/50000,'k')
title(['Rossby, f_o, f_i, and Mag field on ' folder])
legend('Ro, 1','B, ~A','f_o, Hz','f_i, Hz','Location','northwest')
xlabel('Time in seconds since midnight')

% saveas(gcf,[save_folder '102115_log.png'])

% Ek = 7e-7/2/3.14/3.95/1.03^2

