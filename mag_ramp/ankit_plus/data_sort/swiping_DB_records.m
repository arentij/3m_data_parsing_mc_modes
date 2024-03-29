% script made to swipe through a DB with information about 3M experiments 

L = size(results,2);    % amount of all runs in the DB
list_ind = [];          % list of indexes of runs passing your criteria
rossbys = [];           % list of rossbys of the runs passing your criteria 
days = [];              % list of days of the runs passing your criteria 

% going throug all the runs
for i = 1:L
    %     A hint to know which 
    %     results{1,i}{1,2}(k) corresponds to what
    %     [ro0, fi0, fo0, t0, t1, ek, re, rm]
    %  k=  1    2    3    4   5   6   7   8
    ro = results{1,i}{1,2}(1);
    fi = results{1,i}{1,2}(2);
    fo = results{1,i}{1,2}(3);

    if fo  > -5  && fo  < -0.1  && ro < -0.1 && ro > -5 && abs(ro+1) > 0.01 % if it passes two first criterias and it's not -1
        
        if 1 %results{1,i}{1,1} == '100412'    % put an additional criteria here if you want
            mag_data = results{1,i}{1,3};   % saving I(t) 
            Lm = length(mag_data);          % length of mag data
            gap = 30*10;                    % minimum amount of points to satisfy criteria of 30 seconds of stable mag field x10 (sampling rate)
            gap = min(Lm,gap);              % making sure gap is no longer than size of the data

            for j = 1:100:Lm-gap             % checking only every second

                goal_I = 100; % the mag field we want to find in the record
                if 1 %mean(abs(mag_data(j:j+gap) - goal_I)) < 30  % if average error is less than one => pass criteria

                    days = [days;  results{1,i}{1}];            % adding the day of the run to our list
                    rossbys = [rossbys, results{1,i}{1,2}(1)];  % adding Ro
                    list_ind = [list_ind, i];                   % adding index of the run to the list
                    break % exiting the loop cuz we found what we were looking for
                end
            end
        end
    end
end

% plotting the rossbys in ascending order
figure
scatter(1:size(rossbys,2), sort(rossbys(:)),'.')
title('Found Rossby numbers');
xlabel('Counter')
ylabel('Rossby number, 1')

% making a list of unique days
days_unique = unique(string(days));

% amount of runs on each day
N_ro_per_day = zeros(size(days_unique));
for i=1:length(days_unique)
    % counting how many records there are in each day
    N_ro_per_day(i) = sum(string(days) == days_unique(i));
    [char(days_unique(i)) ' has ' num2str(N_ro_per_day(i)) ' runs']
end

clearvars gap goal_I i j L Lm mag_data days2 ans



