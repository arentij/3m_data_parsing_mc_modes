function [record] = grab_3mdata_chunks(day,t1,t2,tb1,tb2)
% grab_3mdata_chunks should go to folder 'day' find *.daq files and open
% them one by one, crop data from them from t1 to t2: pressure, hall probes data, 
% spherical harmonics and creates structures:
% cell object: record

if ~exist('tb1', 'var')
    tb1 = 0;
    tb2 = 0;
    bias_defined = 0;  % if there is no defined tb1 set bias_defined to zero
else 
    bias_defined = 1;
end

% creating variable that controls if all requested times were delivered
is_done = zeros(1,length(t1));

% way to the foldar with daq files
way = ['/data/3m/' day '/'];

% list of daq files
fileList = dir([way '/*.daq']);

% predefining the output record variable
record = cell(length(t1),3);

%% if the bias was defined lets go and find it
if bias_defined             % 
    for file_i = 1:length(fileList)     % swiping across daq files

        if fileList(file_i).name == "acc.daq" || fileList(file_i).name == "heating.daq"  || fileList(file_i).name ==  "acc0.daq"
            continue        % if it is one of those files than heck it
        end
        warning(['Importing ' fileList(file_i).name ' and looking for bias'])
        
        % import data and time from the current daq file
        [data, time, abstime] = daqread([fileList(file_i).folder '/' fileList(file_i).name]);

        dossm(); % shift time with ssm
        time = time + ssm;
        
        % print times of the file
        [ fileList(file_i).name ' t1= ' num2str(fix(time(1))) '  t2= ' num2str(fix(time(end)))]
        
        % if the bias is in this file than lets evaluate everything for bias
        if tb1 > time(1) && tb1 < time(end)
            
            if tb2 > time(end)
                tb2 = time(end) - 5;
            end
            
            % lets find inexies of the beginning and the end
            i_tb1 = find(time > tb1+1, 1, 'first');
            i_tb2 = find(time > tb2-1, 1, 'first');
            
            % crope the bias data from data
            bias_data = data(i_tb1:i_tb2,12:44);
            
            % evaluate the mean value
            bias = mean(bias_data,1);
            
            % get all the necessary parts of the bias data to write it
            % later in the record variable
            [time_b_12, data_b_p12, data_b_m12, data_b_12] = data_chunk_tpmd(data,time,tb1+1,tb2-1,0*bias);

            warning('Found bias, now working on data')
%             '************' Now lets work on data ************'
            break
        end
    end
    
end

%% Lets swipe all the daq files again and crop the needed times
for file_i = 1:length(fileList)
    
    if fileList(file_i).name == "acc.daq" ||  fileList(file_i).name ==  "acc0.daq" % ||fileList(file_i).name == "heating.daq"  
        continue
    end
    warning(['Importing ' fileList(file_i).name])
    [data, time, abstime] = daqread([fileList(file_i).folder '/' fileList(file_i).name]);

    dossm();
    time = time + ssm;
    [ fileList(file_i).name ' t1= ' num2str(fix(time(1))) '  t2= ' num2str(fix(time(end)))]
    
    % check which of the needed times are in just opened daq file
    is_here = (t2 > time(1)).*(t2 < time(end));
    
    
    % swipe acriss needed times
    for i_t = 1:length(t1)
       if is_here(i_t)   % if the time chunk is in this file
            
           if t1(i_t) < time(1)
               warning(['t1=' num2str(t1(i_t)) ' t_index=' num2str(i_t) 't1 is less than the beginning of the file, so changing it to ' num2str(fix(time(1)))])
               
               t1(i_t) = min(t1(i_t),time(1));
           end
            
            
            % importing log files
            [data_control, data_magnet] = import_control_magnet_logs(day);
            tc = data_control(:,1);             % control lod time vector
            fo_r = data_control(:,19)/8.297;    % outer freq real
            fi_r = data_control(:,14);          % inner freq real
             
            fo = mean((fo_r(tc> t1(i_t) & tc <t2(i_t))));  % evaluate mean values of fi, fo, ro
            fi = mean((fi_r(tc> t1(i_t) & tc <t2(i_t))));
            ro = (fi-fo)/fo;
            
            tf1 = time(1);          % first time
            tf2 = time(end);        % last time
            
            % if bias times were not defined from the outside
            if bias_defined == 0
            % define bias location  (this code has some serious magic mixed
            %                        with terrible ideas)
                if tb1 == 0 || tb1 < time(1) || tb2 > time(end)
                    [tb1, tb2] = find_x_hz_bias(day,fo,tf1,tf2,t2(i_t));

                    if tb1 < time(1) || tb2 > time(end) 
                        [tb1, tb2] = find_x_hz_bias(day,fo,tf1,tf2);
                    end
                end
            
                % define indexies of bias data
                i_tb1 = find(time > tb1+1, 1, 'first');
                i_tb2 = find(time > tb2-1, 1, 'first');
                
                % define bias data nad bias
                bias_data = data(i_tb1:i_tb2,12:44);
                bias = mean(bias_data,1);
            end
            
            %% Writing data in the record
            
            record{i_t,1} = day;
            record{i_t,2} = [ro, fo, fi];
            record{i_t,3} = cell(2,6);      % for daq files data: pressure, mag, spherical...
            record{i_t,4} = cell(1,2);      % for torque data;
            
            % cropping pieces of data
            [time_12, data_p12, data_m12, data12] = data_chunk_tpmd(data,time,t1(i_t),t2(i_t),bias);

            % determining timing in mag data
            imag1 = find(data_magnet(:,1) > t1(i_t), 1, 'first');
            imag2 = find(data_magnet(:,1) > t2(i_t), 1, 'first');
            % evaluating mean current and std of it
            B_ext = mean(data_magnet(imag1:imag2,3));
            B_ext_std=std(data_magnet(imag1:imag2,3));
            
            % adding torque data from the sensor
            try torque_data = importdata(['/data/3m/' day '/torque.dat' ]);
                tt = torque_data(:,1);      % torque times
                t_d = torque_data(:,2);     % torque data
                % index ot t1 and t2 
                itorq1= find(tt > t1(i_t), 1, 'first');
                itorq2= find(tt > t2(i_t), 1, 'first');            
                % saving torque data
                record{i_t,4}{1,1} = tt(itorq1:itorq2);
                record{i_t,4}{1,2} = t_d(itorq1:itorq2);
            catch ME
                record{i_t,4}{1,1} = [];
                record{i_t,4}{1,2} = [];
            end
            % adding control log data
            ind_contr_log1 = find(tc > t1(i_t), 1, 'first');
            ind_contr_log2 = find(tc > t2(i_t), 1, 'first');
            control_log_data = data_control(ind_contr_log1:ind_contr_log2,:);
            
            % evaluating gauss coefficents 
%             data_m12_sph_h = gcoeff33(data_m12,probepos33);  % this one
%             for doing all 33 probes
            data_m12_sph_h = gcoeff3m(data_m12(:,1:31),probepos()); % this one for using only 31 probes
            
            % writing what collected
            record{i_t,3}{1,1} = [B_ext, t1(i_t), t2(i_t), B_ext_std];
            record{i_t,3}{1,2} = time_12;
            record{i_t,3}{1,3} = data_p12;
            record{i_t,3}{1,4} = data_m12;
            record{i_t,3}{1,5} = data12;
            record{i_t,3}{1,6} = data_m12_sph_h;
            record{i_t,3}{1,7} = control_log_data;

            %  now dealing with bias data 
            if bias_defined == 0   % find the bias data part if it was not defined from the outside
                [time_b_12, data_b_p12, data_b_m12, data_b_12] = data_chunk_tpmd(data,time,tb1+1,tb2-1,0*bias);
            end
            
            % finding indexies of bias data in the magnet file
            imag1 = find(data_magnet(:,1) > tb1+1, 1, 'first');
            imag2 = find(data_magnet(:,1) > tb2-1, 1, 'first');
            
            
            % evaluating mean current and std of it
            B_ext = mean(data_magnet(imag1:imag2,3));
            B_ext_std=std(data_magnet(imag1:imag2,3));
            
            
            % adding bias control log data
            ind_bias_contr_log1 = find(tc > tb1, 1, 'first');
            ind_bias_contr_log2 = find(tc > tb2, 1, 'first');
            control_log__bias_data = data_control(ind_bias_contr_log1:ind_bias_contr_log2,:);
            
            
            % writing what was collected about bias
            record{i_t,3}{2,1} = [B_ext, tb1+1, tb2-1, B_ext_std];
            record{i_t,3}{2,2} = time_b_12;
            record{i_t,3}{2,3} = data_b_p12;
            record{i_t,3}{2,4} = data_b_m12;
            record{i_t,3}{2,5} = data_b_12;
            
            record{i_t,3}{2,7} = control_log__bias_data;
            
            %% checking if all records are done
            is_done(i_t) = 1;
            if is_done
               return
            end
       end
    end
    
end

'Not everything was found'
return

end

