% Get a list of all files and folders in this folder.
way = '/data/3m/';
files = dir(way);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);

% to save results
results = {};
% amount of chunks found
r = 0;

% Going to directories
for k = 3: length(subFolders)
% subFolders(k).name;
    % setting up the name of control.log file with location
    filename_control = [way  subFolders(k).name  '/control.log'];
    % setting up the name of magnet.log file with location
    filename_magnet  = [way  subFolders(k).name  '/magnet.log'];
    
    % if there are logs
    if exist(filename_control, 'file') == 2 && exist(filename_magnet, 'file') == 2

        % Write there is something interesting
        [ subFolders(k).name  ' yes']
        % importing data 
        data_control = importdata(filename_control);
        data_magnet  = importdata(filename_magnet);

        % setting time arrays
        tc = data_control(:,1);
        tm = data_magnet(:,1);

        % setting variables
        fi =  data_control(:,14);   % inner freq
        fo =  data_control(:,20);   % oiter freq
        ro = (fi-fo)./fo;           % rossby
        mg = data_magnet(:,3);      % magnetic field

        tau = 120;
        i = 1;
        toler = 0.75/tau;
        while i < length(data_control)-tau
            % checking if we are in the area where mag field might exist
            if tc(i) > tm(1) && tc(i) < tm(end)
                % checking if Ro is not 0 not - 1 and not inf
                if abs(fo(i)) > 0.3 && abs(ro(i)) < 1000

                    % checking if ro is stable next tau points
                    if abs(mean(ro(i:i+tau))-ro(i)) < toler
                        % setting it as starting point for a chunk
                        i0 = i;
                        j0 = find(tm > tc(i), 1, 'first');
                        ro0 = ro(i);
                        fi0 = fi(i);
                        fo0 = fo(i);

                        for ii = i0+tau : length(data_control)-tau
                            % if it looks like the end of the chunk
                            if abs(mean(ro(ii-tau:ii))-ro0) > toler  || ii == length(data_control)-tau
                                % setting the end pointer to the current
                                i1 = ii;
                                % finding corresponding pointer at mag
                                % field data
                                j1 = find(tm > tc(ii), 1, 'first');

                                % setting mag field data
                                mg0_1 = mg(j0:j1);

                                % plus one amount of chunks
                                r = r + 1;

                                results{r} = {}; 
                                results{r}{1} = subFolders(k).name;                 % saving the name of exp
                                results{r}{2} = [ro0, fi0, fo0, tc(i0), tc(i1)];    % saving the run's parameters rossby, inner rotation rate, outer rr, start end time
                                results{r}{3} = mg0_1;                              % saving vector of the mag data
                                
                                if subFolders(k).name == '111715' | subFolders(k).name == '102315'
                                    figure(1)
                                    plot(ro(i0-tau:i1+tau));
                                    figure(2)
                                    plot(results{r}{3});
                                    r
                                end
                                clearvars ro0 fi0 fo0 i0 i1 mg0_1
                                break
                            end
                        end
                        % set the pointer to the end of the chunk
                        i = ii;
                    end
                end
            end
            i=i+1;
        end
        
    end
end