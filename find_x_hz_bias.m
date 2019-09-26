function [tb1, tb2] = find_x_hz_bias(day,f_o,tf1,tf2,t0)
% opens log files and finds tb1 and tb2 that should meet some criteria of
% bias time: tb2-tb1 > 250 (tau) (seconds), mean(B) < 1, abs(fo) > 3.9 
% and after t0
if ~exist('t0','var')
    t0 = 0;
end

[data_control, data_magnet] = import_control_magnet_logs(day);

% figure; plot(data_magnet(:,1),data_magnet(:,3))

% setting time arrays
tc = data_control(:,1);
tm = data_magnet(:,1);

% setting variables
fi =  data_control(:,14);   % inner freq
fo =  data_control(:,19)/8.33;   % oiter freq

mg = data_magnet(:,3);      % magnetic field

% adding zeros to mg on the leaft and on the right sides of the file so
% they could be used as bias too, assuming it is 10 Hz sampling rate
tm_add_before = (tm(1)-200:0.1:tm(1)-0.1)';
tm_add_after = (tm(end) + 0.1:0.1:tm(end)+200)';
tm = [tm_add_before; tm; tm_add_after];
mg = [zeros(size(tm_add_before));mg; zeros(size(tm_add_after))];


contr_log_i0 = find(tc > max(tf1,tm(1)+1), 1, 'first');
contr_log_iend = find(tc > min(tf2-5,tm(end)-5), 1, 'first');



tau = 40;
toler = 0.75/tau;
i_tc = contr_log_i0;

% while we are in the area with mag field data
while i_tc < contr_log_iend
    
    % goal freq of outer space at least
    goal_f = f_o;
    % if the current f_o is almost goal_f
    if abs(fo(i_tc) -   goal_f) < 0.025 && tc(i_tc) > t0
        % if for the next tau points it's close to be the same
        if abs(mean(fo(i_tc:i_tc+tau) - fo(i_tc) )) < toler
            
            % define starting of a chunk index (i0) as the current index (i_tc)
            i0 = i_tc;                
            fo0 = fo(i0+25); % and fix rotation rate 
            
            % lets walk down the ii to almost the end
            for ii = i0+tau:10:length(data_control)-tau
                % if the rotation rate is far from the goal for the next
                % tau points or its the end of the mag data file hence it's
                % the end of fixed fo
                if mean( (fo(ii-tau:ii)-fo0).^2)  > toler^2  || ii > length(data_control)-tau -20
                    
                    % set the control index of the last point
                    i1 = ii-25;
                    % and set t1 and t1 of the chunk with the same fo
                    t_i0 = tc(i0);
                    t_i1 = tc(i1);
                    
                    % find magnetic indexes of the beginning and the end of
                    % the chunk
                    j0 = find(tm > t_i0, 1, 'first');
                    j1 = find(tm > t_i1, 1, 'first');
                    
                    % set the goal length of the bias file
                    bias_l = 650;
                    
                    % lets walk this way to check if for the next some
                    % number of points if the current in the coil/s is zero
                    for jj = j0+10:j1-bias_l
                        % if the all values are close to zero -> return values
                        if abs(mg(jj:jj+bias_l)) < 1 
                           tb1 = tm(jj+150);
                           tb2 = tm(jj+bias_l);
                           return 
                        end
                    end
                    i_tc = ii;
                    break
                end
            end

        end
    end
    i_tc = i_tc+1;
end

if t0~=0
    ['f_o = ' num2str(f_o) ' time without mag field after t0 was not found, trying before t0']

    [tb1, tb2] = find_x_hz_bias(day,f_o,tf1,tf2);
end

['f_o = ' num2str(f_o) ' time without mag field was not found anywhere in time, trying f_o=' num2str(f_o+0.05)]
if f_o > 0
    f_o = f_o-4.1;
    
end

[tb1, tb2] = find_x_hz_bias(day,f_o+0.05,tf1,tf2);

end









