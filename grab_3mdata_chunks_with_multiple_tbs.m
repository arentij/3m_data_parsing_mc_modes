function [record] = grab_3mdata_chunks_with_multiple_tbs(day,t1,t2,tb1,tb2)
% grab_3mdata_chunks should go to folder 'day' find *.daq files and open
% them one by one, crop data from them from t1 to t2: pressure, hall probes data, 
% spherical harmonics and creates structures:
% cell object: record

if ~exist('tb1', 'var')
    tb1 = 0;
    tb2 = 0;
end

is_done = zeros(1,length(t1));

% [tb1, tb2] = find_x_hz_bias(day,f_o);
way = ['/data/3m/' day '/'];


fileList = dir([way '/*.daq']);

record = cell(length(t1),3);

for file_i = 1:length(fileList)
    
    if fileList(file_i).name == "acc.daq" || fileList(file_i).name == "heating.daq"  || fileList(file_i).name ==  "acc0.daq"
        continue
    end
    warning(['Importing ' fileList(file_i).name])
    [data, time, abstime] = daqread([fileList(file_i).folder '/' fileList(file_i).name]);

    dossm();
    time = time + ssm;
    [ fileList(file_i).name ' t1= ' num2str(fix(time(1))) '  t2= ' num2str(fix(time(end)))]
    
    is_here = (t1 > time(1)).*(t2 < time(end));
    
    for i_t = 1:length(t1)
       if is_here(i_t)
            
            [data_control, data_magnet] = import_control_magnet_logs(day);
            tc = data_control(:,1);
            fo_r = data_control(:,19)/8.297;   % oiter freq real
            fi_r = data_control(:,14);   % inner freq real
            
             
            fo = mean((fo_r(tc> t1(i_t) & tc <t2(i_t))));
            fi = mean((fi_r(tc> t1(i_t) & tc <t2(i_t))));
            ro = (fi-fo)/fo;

            % define bias location 
            if tb1 == 0 
                [tb1, tb2] = find_x_hz_bias(day,fo,t2(i_t));
            
                if tb1 < time(1) || tb2 > time(end) 
                    [tb1, tb2] = find_x_hz_bias(day,fo);
                end
            end
            
            for ind_tb1 = 1:length(tb1)
                if ind_tb1 ==2
                    'here'
                end
                i_tb1 = find(time > tb1(ind_tb1)+1, 1, 'first');
                i_tb2 = find(time > tb2(ind_tb1)-1, 1, 'first');

                bias_data = data(i_tb1(ind_tb1):i_tb2(ind_tb1),12:44);

                bias = mean(bias_data,1);
                tb1_r = tb1(ind_tb1)+1;
                tb2_r = tb2(ind_tb1)-1;
                if ~isnan(bias)
                    break
                end
            end
            
            if isnan(bias)
                [tb1, tb2] = find_x_hz_bias(day,fo,t2(i_t));
            
                if tb1 < time(1) || tb2 > time(end) 
                    [tb1, tb2] = find_x_hz_bias(day,fo);
                end
                i_tb1 = find(time > tb1+1, 1, 'first');
                i_tb2 = find(time > tb2-1, 1, 'first');

                bias_data = data(i_tb1:i_tb2,12:44);

                bias = mean(bias_data,1);
                tb1_r=tb1+1;
                tb2_r=tb2-1;
            end
            
            
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
            
            torque_data = importdata(['/data/3m/' day '/torque.dat' ]);
            tt = torque_data(:,1);      % torque times
            t_d = torque_data(:,2);     % torque data
            % index ot t1 and t2 
            itorq1= find(tt > t1(i_t), 1, 'first');
            itorq2= find(tt > t2(i_t), 1, 'first');
            
            % saving torque data
            record{i_t,4}{1,1} = tt(itorq1:itorq2);
            record{i_t,4}{1,2} = t_d(itorq1:itorq2);
            
            % evaluating gauss coefficents 
            data_m12_sph_h = gcoeff33(data_m12,probepos33);
            
            % writing what collected
            record{i_t,3}{1,1} = [B_ext, t1(i_t), t2(i_t), B_ext_std];
            record{i_t,3}{1,2} = time_12;
            record{i_t,3}{1,3} = data_p12;
            record{i_t,3}{1,4} = data_m12;
            record{i_t,3}{1,5} = data12;
            record{i_t,3}{1,6} = data_m12_sph_h;

            %%  now dealing with bias data
            [time_12, data_p12, data_m12, data12] = data_chunk_tpmd(data,time,tb1_r,tb2_r,0*bias);
            
            imag1 = find(data_magnet(:,1) > tb1_r, 1, 'first'); 
            imag2 = find(data_magnet(:,1) > tb2_r, 1, 'first');
            % evaluating mean current and std of it
            B_ext = mean(data_magnet(imag1:imag2,3));
            B_ext_std=std(data_magnet(imag1:imag2,3));
            
            % writing what collected about bias
            record{i_t,3}{2,1} = [B_ext, tb1_r, tb2_r, B_ext_std];
            record{i_t,3}{2,2} = time_12;
            record{i_t,3}{2,3} = data_p12;
            record{i_t,3}{2,4} = data_m12;
            record{i_t,3}{2,5} = data12;
            
            
            
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

