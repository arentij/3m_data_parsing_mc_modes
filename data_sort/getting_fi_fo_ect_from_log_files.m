fldr = '050914';
way = ['/data/3m/' fldr];
files = dir(way);


% Going to directories
% setting up the name of control.log file with location
filename_control = [way  '/control.log'];
% setting up the name of magnet.log file with location
filename_magnet  = [way  '/magnet.log'];

% if there are logs
if exist(filename_control, 'file') == 2 && exist(filename_magnet, 'file') == 2

    % Write there is something interesting
     [ fldr ' yes']
    % importing data 
    data_control = importdata(filename_control);
    data_magnet  = importdata(filename_magnet);

    % setting time arrays
    tc = data_control(:,1);
    tm = data_magnet(:,1);

    % setting variables
    fi =  data_control(:,14);   % inner freq
    fo =  data_control(:,20);   % oiter freq
    fo_r=data_control(:,19);   % outer freq real
    fi_r=data_control(:,14);   % inner freq real
    
    tq = data_control(:,21);   % torque
    T1 = data_control(:,2);   % temp 1
    T2 = data_control(:,3);   % temp 2
    
    ro = (fi-fo)./fo;           % rossby
    mg = data_magnet(:,3);      % magnetic field
    
end

figure(1)
plot(tc,ro,'b',tm,mg/10,'r',tc,fo_r/3.4*0.41,'g',tc,fi,'c')
title(['Rossby, f_o, f_i, and Mag field on ' fldr])
legend('Ro','B','f_o','f_i','Location','northwest')

figure(2)
plot(tc,fo,'b',tc,fo_r/3.4*0.41,'r')
title('Requested and observed f out')

figure(3)
plot(tc,T1,'r',tc,T2,'b')
title('Temperature')



