
%% importing data
% ___________ADJUST HERE ___________
folder = '100912';
daq_file = '/mr_Ro_n170_OS_225';
exp_time1 = 64170; 
exp_time2 = 68700;
tb1 = 64160; 
tb2 = 64430;
t_list = [64170, 64453, 64643, 64826, 65021, 65219, 65452, 65634, 65830, 66020, 66280, 66480, 66682, 66870, 67070, 67283, 67478, 67669, 67867, 68055, 68257];
chunk_l = 175;

if 0
    % ___________ADJUST HERE ___________
    [data, time, abstime] = daqread(['/data/3m/' folder daq_file]);
    % ___________ADJUST HERE ___________

    dossm();
    time = time + ssm;
    ['T1= ' num2str(fix(time(1))) '  T2= ' num2str(fix(time(end)))]
end

record = prep_chunks(data, time, exp_time1, exp_time2, tb1, tb2, t_list, chunk_l, folder);

clearvars folder daq_file exp_time1 exp_time2 tb1 tb2 t_list chunk_l flg abstime ssm