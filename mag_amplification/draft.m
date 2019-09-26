folder = '060314';
[data_control, data_magnet] = import_control_magnet_logs(folder);

% figure; plot(data_magnet(:,1),data_magnet(:,3))

% setting time arrays
tc = data_control(:,1);
tm = data_magnet(:,1);

% setting variables
fi =  data_control(:,14);   % inner freq
fo =  data_control(:,19)/8.33;   % oiter freq

tb1_vec = zeros(1,length(t1));
tb2_vec = zeros(1,length(t1));

for ind_t = 1:length(t1)
    
    ind_middle = find(tc > (t1(ind_t)+t2(ind_t))/2, 1, 'first');
    
    goal_f0 = fo(ind_middle);
    
    [tb1, tb2] = find_x_hz_bias(folder,goal_f0,tc(1),tc(end));
    tb1_vec(1,ind_t) = tb1;
    tb2_vec(1,ind_t) = tb2;
end