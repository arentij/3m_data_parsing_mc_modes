if 1
% amount of different mag field exp's
L = size(record{1,3},1)-1;

% plotting up to this omegas
upto = 2;
% amount of points to plot UPTO
D = fix(upto*8193/128*record{1,2}(2)*(-1))+1;
% preallocating resultive spectrum
spectrum = zeros(L,D);
% mag values
A_val = zeros(1,L);


for k = 1:L
    A_val(k) = fix(record{1,3}{k,1}(1));
    % iether substracting bias or not. 
    % record{1,3}{k,3} - pressure
    % record{1,3}{k,4} - mag data
    % 3 is pressure, 4 is mag data
    ch = 4; 
    a = 1;  % 1 - if substracting mean, 0 if not
    channel = [1:33] ;
    pw = pwelch(record{1,3}{k,ch}(:,channel) - a*mean(record{1,3}{k,ch}(:,channel))) ;
    log_av_pw = mean(log(pw),2);
    
    % freq space
    f = [1:size(pw,1)]/size(pw,1)*128/abs(record{1,2}(2));
    % checking all the freq spaces are equal
    length(f)
%     figure
%     plot(f,log_av_pw) %, 
    spectrum(k,:) = log_av_pw(1:D,:);
end

B_f_val = A_val*8/15;
f_val = [1:size(spectrum,2)]/size(spectrum,2)*upto;

end

figure(2)
waterfall(f_val,B_f_val,10*spectrum)
title('Pressure PSD, Ro=-4.3, Ek=3.6e-8 ')
xlabel('\omega/\Omega_{out}','FontSize',18);
ylabel('B_{ext}, gauss','FontSize',18);
zlabel('Power density, dB');
% zlim([-7 1]);
figure(3)
[M,c] = contourf(B_f_val,f_val,10*spectrum',15);
set(c,'LineColor','none')
caxis([-80 -20]);
xlabel('B_{ext}, gauss','FontSize',18)
ylabel('\omega/\Omega_{out}','FontSize',18)
title('Hall Probes PSD, Ro=-4.3, Ek=3.6e-8, dB ')
colorbar

