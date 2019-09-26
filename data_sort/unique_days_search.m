% unique_days
% Get a list of all files and folders in this folder.
way = '/data/3m/';
files = dir(way);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);

% to save results
exp_days_list = {};

% Going to directories
for k = 3: length(subFolders)
% subFolders(k).name;
    % setting up the name of control.log file with location
    filename_control = [way  subFolders(k).name  '/control.log'];
    % setting up the name of magnet.log file with location
    filename_magnet  = [way  subFolders(k).name  '/magnet.log'];
%     if  subFolders(k).name(6) ~= '6'
%         continue
%     end
    % if there are logs
    if exist(filename_control, 'file') == 2 && exist(filename_magnet, 'file') == 2
        exp_days_list = [exp_days_list, subFolders(k).name];
    end
end