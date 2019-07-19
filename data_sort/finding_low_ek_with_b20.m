
days_unique_list = unique(str2num(days));

list_ind_with_b20 = [];
list_ro_with_b20 = [];

for i = 1: length(days_unique_list)
    days_unique_list(i);
    ind_of_current_day = (fixed_out_ind(str2num(days) == days_unique_list(i)));
    for k = 1:length(ind_of_current_day)
%         figure(k)
        j = ind_of_current_day(k);
%         time_v = (results{j}{1,2}(4) + (results{j}{1,2}(5)-results{j}{1,2}(4))*[0:length(results{j}{3})-1]/length(results{j}{3})-1)';
%         plot(time_v,results{j}{3})
%         title(['i=' num2str(j) ' f_o= ' num2str(results{1,j}{1,2}(3)) ' Ro= ' num2str(results{1,j}{1,2}(1)) '  '  results{1,j}{1}]);
        
        if abs(mean(results{j}{3}) - 100 ) < 70
            list_ind_with_b20 = [list_ind_with_b20, j];
            list_ro_with_b20  = [list_ro_with_b20, results{1,j}{1,2}(1)];
        end
    end
%     close all
end

length(list_ind_with_b20)