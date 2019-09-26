% folder = '032516';
load('unique_days.mat')

for day_ind = 1:length(exp_days_list)
    
    folder = char(exp_days_list(day_ind));
%     importing log files

    if folder(6) == "5" & folder(1) == "1"

        [data_control, data_magnet] = import_control_magnet_logs(folder);

        % torque_data = importdata(['/data/3m/' folder '/torque.dat' ]);
        % 
        % 
        % tt = torque_data(:,1);
        % t_d = torque_data(:,2);

        % setting time arrays
        tc = data_control(:,1);
        tm = data_magnet(:,1);

        % setting variables
        angle = data_control(:,3);   
        fi =  data_control(:,14);   % inner freq
        fo =  data_control(:,20);   % oiter freq
        fo_r=data_control(:,19)/8.297;   % outer freq real
        fi_r=data_control(:,13);   % inner freq real

        tq = data_control(:,21);   % torque
        T1 = data_control(:,2);   % temp 1
        T2 = data_control(:,3);   % temp 2
        THi = data_control(:,6);   % temp heater in
        THo = data_control(:,9);   % temp heater in
        P_heat=data_control(:,5);   % temp heater in

        ro_r = (fi_r-fo_r)./fo_r;   % rossby real
        ro = (fi-fo)./fo;            % requested rossby
        mg = data_magnet(:,3);      % magnetic field


        figure(14)
        plot(tc,ro_r,'b',tm,mg/10,'r',tc,fo_r,'g',tc,fi_r,'c',tc,fo-fo_r,'k')
        % plot(tc,ro,'b',tm,mg/10,'r',tc,fo_r,'g',tc,fi,'c',tt, t_d/50000,'k')
        title(['Rossby, f_o, f_i, and Mag field on ' folder])
        legend('Ro, 1','B, ~A','f_o, Hz','f_i, Hz','Location','northwest')
        xlabel('Time in seconds since midnight')

        % saveas(gcf,[save_folder '102115_log.png'])

        % Ek = 7e-7/2/3.14/3.95/1.03^2
        figure(5)
        plot(tc,THi, tc,THo, tc,P_heat,tc,T1,tc,T2)
        % % 
    end
end
    
%% Ruben annalisys (annalysis?) please comment if I forgot to do so. I love you all if you're reading
% figure(2);scatter(ro1,bdip)
% hold on
% scatter(ro1,brad);
% scatter(ro1,bphi);scatter(ro1,bcua);hold off;
% figure(3);scatter(re,bdip)
% hold on
% scatter(re,brad);
% scatter(re,bphi);scatter(re,bcua);hold off;figure(4);scatter(ro1,gginf);hold off;
% figure(6);scatter(tim,bdip)
% hold on
% scatter(tim,brad);
% scatter(tim,bphi);scatter(tim,bcua);hold off;
