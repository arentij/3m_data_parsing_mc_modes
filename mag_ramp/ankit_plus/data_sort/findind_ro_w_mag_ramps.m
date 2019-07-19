L = size(results,2);
vector = zeros(5,L);
time = zeros(1,L);
count = 0;
for i = 1:L
%     mmddyy = results{1,i}{1};
%     time(1,i) = str2double(mmddyy(5:6))*365 + str2double(mmddyy(1:2))*31 + str2double(mmddyy(3:4)) + results{1,i}{1,2}(4)/24/3600;
%     [ro0, fi0, fo0, tc(i0), tc(i1)]
    fi = results{1,i}{1,2}(2);
    fo = results{1,i}{1,2}(3);
    ro = results{1,i}{1,2}(1);
    ek = (10^-6)/(abs(fo)*2*pi*1.05^2);
    re = ro/ek;
    rm = abs(fi-fo)*2*pi*(1.05^2)*0.079^-1;
    
    results{1,i}{1,2} = [results{1,i}{1,2}, ek, re, rm];
    
    
    if results{i}{2}(1) >-0.98 && results{i}{2}(1) < -0.02 && results{i}{2}(1) > -50 && std(results{i}{3}) > 10
       plot(results{i}{3})
       title([num2str(results{i}{2}(1)) '  '  results{1,i}{1}]);
       results{i}{2}(1);
       count = count+1
    end
    
end
