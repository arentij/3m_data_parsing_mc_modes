function [data_control, data_magnet] = import_control_magnet_logs(folder)
% import_control_magnet_logs fast import control.log and magnet.log
%   going to data folder and importing logs
way = ['/data/3m/' folder];

% Going to directories
% setting up the name of control.log file with location
filename_control = [way  '/control.log'];
% setting up the name of magnet.log file with location
filename_magnet  = [way  '/magnet.log'];

% if there are logs
if exist(filename_control, 'file') == 2 && exist(filename_magnet, 'file') == 2

% importing data 
data_control = importdata(filename_control);
%% control.log 
% 1-time, 2:3 - Tna, 4-12 oil, 
% IS 13-f_rep, 14-f_req, 15-torque, 16-power, 17-current, 18-status
% OS 19-f_rep, 20-f_req, 21-torque, 22-power, 23-current, 24-status

data_magnet  = importdata(filename_magnet);
%% magnet.log
% 1-time, 2-?, 3-magnet data

end

