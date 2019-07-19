%% need just to set up times, folder and daq file name
% exp_time1  exp_time2  - time of the whole run while rossby is fixed
% tb1  tb2              - time of mag bias ( rossby should be zero, or not?)

%% importing data
% ___________ADJUST HERE ___________
folder = '111612';
% ___________ADJUST HERE ___________

if 0
    % ___________ADJUST HERE ___________
    [data, time, abstime] = daqread(['/data/3m/' folder '/mr_Ro_n430']);
    % ___________ADJUST HERE ___________

    dossm();
    time = time + ssm;
    ['T1= ' num2str(fix(time(1))) '  T2= ' num2str(fix(time(end)))]
end


%% importing magnet and control logs
[data_control, data_magnet] = import_control_magnet_logs(folder);
% control.log  % data_control(,);
% 1-time, 2:3 - Tna, 4-12 oil, 
% IS 13-f_rep, 14-f_req, 15-torque, 16-power, 17-current, 18-status
% OS 19-f_rep, 20-f_req, 21-torque, 22-power, 23-current, 24-status

% magnet.log
% 1-time, 2-?, 3-magnet data

%% Creating the record

record = {};
% saving the day =)
record{1,1} = folder;
% ___________ADJUST HERE ___________
exp_time1 = 60940; exp_time2 = 65111;
% ___________ADJUST HERE ___________

i_expt1 = find(data_control(:,1) > exp_time1, 1, 'first');
i_expt2 = find(data_control(:,1) > exp_time2, 1, 'first');

fi = mean(data_control(i_expt1:i_expt2,13));
fo = mean(data_control(i_expt1:i_expt2,19))/8.297;  % 8.297 is the gear ratio (I hope)
ro = (fi-fo)/fo;

% saving rossby and rotation rates
record{1,2} = [ro, fo, fi];

%% organizing bias part
% defiing location of the bias part
% ___________ADJUST HERE ___________
tb1 = 60300; 
tb2 = 60450;
% ___________ADJUST HERE ___________

% taking only second half of the bias time (why? for the glory of satan of course)
ib1 = find(time > (tb1+tb2)/2, 1, 'first'); ib2 = find(time > tb2, 1, 'first');

% cropping mag bias data from all data assuming it is already stored in data variable and time variable
bias_x = data(ib1:ib2,12:44);  %12:44 is due to mag probes index
L = size(bias_x,1); 
l1 = fix(0.05*L); l2 = fix(0.95*L);
bias_srt = sort(bias_x(:,:),1);
% defining bias without top and low 5% of values
bias = mean(bias_srt(l1:l2,:));

clearvars L l1 l2 bias_srt bias_x

%% setting starting and ending times for chunks
% ___________ADJUST HERE ___________
t_list = [61080, 61380, 61690, 62057, 62377, 62700, 63010, 63340, 63650, 63974, 64295, 64536, 64912];
L = length(t_list);
t1_list = t_list(2:L)-230;
t2_list = t_list(2:L);
% ___________ADJUST HERE ___________

%% cropping times of magnetic data 
record{1,3} = {};
for k = 1:size(t1_list,2)

    t1 = t1_list(k);
    t2 = t2_list(k);
    % giving some margin for at least 60 seconds (20 dipole timescales) or 10% of the time whatever is less
    t1 = t1+min(30,(t2-t2)*0.1);

    % getting the data from daq file assuming it is already stored in data variable and time variable
    [time_12, data_p12, data_m12, data12] = data_chunk_tpmd(data,time,t1,t2,bias);
    
    imag1 = find(data_magnet(:,1) > t1, 1, 'first');
    imag2 = find(data_magnet(:,1) > t2, 1, 'first');
    
    B_ext = mean(data_magnet(imag1:imag2,3));
    B_ext_std=std(data_magnet(imag1:imag2,3));
    
    record{1,3}{k,1} = [B_ext, t1, t2, B_ext_std];
    record{1,3}{k,2} = time_12;
	record{1,3}{k,3} = data_p12;
    record{1,3}{k,4} = data_m12;
    record{1,3}{k,5} = data12;
end

%% adding data from bias file (just to keep it there

t1 = tb1; t2 = tb2;
[time_12, data_p12, data_m12, data12] = data_chunk_tpmd(data,time,t1,t2,0*bias);
k = k+1;
imag1 = find(data_magnet(:,1) > t1, 1, 'first');
imag2 = find(data_magnet(:,1) > t2, 1, 'first');

B_ext = mean(data_magnet(imag1:imag2,3));

record{1,3}{k,1} = [B_ext, t1, t2];
record{1,3}{k,2} = time_12;
record{1,3}{k,3} = data_p12;
record{1,3}{k,4} = data_m12;
record{1,3}{k,5} = data12;


%%
clearvars B_ext bias data12 data_control data_m12 data_m12 data_magnet data_p12
clearvars exp_time1 exp_time2 fi fo folder i_expt1 i_expt2 ib1 ib2 imag1 imag2 k ro t1 t1_list
clearvars t2 t2_list tb1 tb2 time_12
