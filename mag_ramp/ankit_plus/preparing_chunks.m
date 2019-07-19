%% need just to set up times, folder and daq file name
% exp_time1  exp_time2  - time of the whole run while rossby is fixed
% tb1  tb2              - time of mag bias ( rossby should be zero, or not?)

%% importing data
% ___________ADJUST HERE ___________
folder = '050914';
% ___________ADJUST HERE ___________

if 0
    % ___________ADJUST HERE ___________
    [data, time, abstime] = daqread(['/data/3m/' folder '/050914_3']);
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
exp_time1 = 57840; exp_time2 = 61740;
% ___________ADJUST HERE ___________

i_expt1 = find(data_control(:,1) > exp_time1, 1, 'first');
i_expt2 = find(data_control(:,1) > exp_time2, 1, 'first');

fi = mean(nonzeros(data_control(i_expt1:i_expt2,13)))
std(nonzeros(data_control(i_expt1:i_expt2,13)))
fo = mean(nonzeros(data_control(i_expt1:i_expt2,19))/8.297);  % 8.297 is the gear ratio (I hope)
ro = (fi-fo)/fo;

% saving rossby and rotation rates
record{1,2} = [ro, fo, fi];

%% organizing bias part
% defiing location of the bias part
% ___________ADJUST HERE ___________
tb1 = 61850; tb2 = 62100;
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

% clearvars L l1 l2 bias_srt bias_x

%% setting starting and ending times for chunks
% ___________ADJUST HERE ___________
t_list = [58100, 58700, 59600, 60300, 61000, 61700];
L = length(t_list);
figure; plot(t_list(2:L) - t_list(1:L-1),'.');
t1_list = t_list(2:L)-550;
t2_list = t_list(2:L);
% ___________ADJUST HERE ___________



% %%
% clearvars B_ext bias data12 data_control data_m12 data_m12 data_magnet data_p12
% clearvars exp_time1 exp_time2 fi fo folder i_expt1 i_expt2 ib1 ib2 imag1 imag2 k ro t1 t1_list
% clearvars t2 t2_list tb1 tb2 time_12
