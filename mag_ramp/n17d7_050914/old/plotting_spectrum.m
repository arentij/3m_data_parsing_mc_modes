% amount of different mag field exp's
L = size(record{1,3},1);
% one way to order output, but better to do it in the plotting 
k_ordered_list = [1, 2,3,4,5];
% amount of plotted data
k2 = 0;
% plotting up to this omegas
upto = 2;
% amount of points to plot UPTO
D = fix(upto*32769/128*record{1,2}(2)*(-1))+1;
% preallocating resultive spectrum
spectrum = zeros(size(k_ordered_list,2),D);

for k = k_ordered_list
    k2 = k2+1;
    % iether substracting bias or not. 
    % record{1,3}{k,3} - pressure
    % record{1,3}{k,4} - mag data
    % 3 is pressure, 4 is mag data
    ch = 4; 
    a = 0;  % 1 - if substracting mean, 0 if not
    pw = pwelch(record{1,3}{k,ch}(:,:) - a*mean(record{1,3}{k,ch}(:,:))) ;
    log_av_pw = mean(log(pw),2);
    
    % freq space
    f = [1:size(pw,1)]/size(pw,1)*128/record{1,2}(2)*(-1);
    % cehcking all the freq spaces are equal
    length(f)
%     figure
%     plot(f,log_av_pw) %, 
    spectrum(k2,:) = log_av_pw(1:D,:);
end
figure(2)
waterfall([1:size(spectrum,2)]/size(spectrum,2)*upto,[20,40,60,80,100],spectrum)
title('Spectral power density')
xlabel('2pif/w_o');
ylabel('B field');
zlabel('Power density, dB');
% zlim([-7 1]);
figure(3)
imagesc(spectrum')
% caxis([-6 0]);
% xlabel('2pif/w_o');
% ylabel('B field');