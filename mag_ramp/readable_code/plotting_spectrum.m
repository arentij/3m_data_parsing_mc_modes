% set to zero if you just want to plot and not to do the math again
recalc = 1;

if recalc
    % amount of different mag field exp's
    L = size(record{1,3},1)-1;

    % plotting up to this omegas
    upto =2;
    % amount of points to plot UPTO
    Lp = size(pwelch(record{1,3}{2,3}(:,2)),1);
    D = fix(upto*Lp/128*record{1,2}(2)*(-1))+1;
    % preallocating resultive spectrum
    spectrum_m = zeros(L,D);
    spectrum_p = zeros(L,D);
    spectrum_m_ph = zeros(L,D);

    % mag values
    A_val = zeros(1,L);


    for k = 1:L
        % getting current values
        A_val(k) = fix(record{1,3}{k,1}(1));

        %% getting mag probes spectrum
        a1 = 1;  % 1 - if substracting mean, 0 if not
        channel1 = [1:33] ; %******************************************************************************
        pw_m = pwelch(record{1,3}{k,4}(:,channel1) - a1*mean(record{1,3}{k,4}(:,channel1))) ;
        log_av_pw_m = mean(log(pw_m),2);

        % freq space
        f = [1:size(pw_m,1)]/size(pw_m,1)*128/abs(record{1,2}(2));
        length(f);
        % saving spectrum
        spectrum_m(k,:) = log_av_pw_m(1:D,:);

        %% getting pressure probes spectrum
        a2 = 1;  % 1 - if substracting mean, 0 if not
        channel2 = [1:3] ; % number 4 appears to be noizy
        pw_p = pwelch(record{1,3}{k,3}(:,channel2) - a2*mean(record{1,3}{k,3}(:,channel2))) ;
        log_av_pw_p = mean(log(pw_p),2);
        % saving spectrum
        spectrum_p(k,:) = log_av_pw_p(1:D,:);

       
    end

    B_f_val = A_val*8/15;
    f_val = [1:size(spectrum_m,2)]/size(spectrum_m,2)*upto;
    

end

day = record{1, 1};
ro = record{1,2}(1);


figure(2)
waterfall(f_val,B_f_val,10*spectrum_m)
title('')
xlabel('\omega/\Omega_{out}','FontSize',18);
ylabel('B_{ext}, gauss','FontSize',18);
zlabel('Power density, dB');
% zlim([-7 1]);


figure(3)
[M,c] = contourf(B_f_val,f_val,10*spectrum_m',20);
set(c,'LineColor','none')
% caxis([-60 -5]);
xlabel('B_{ext}, gauss','FontSize',18)
ylabel('\omega/\Omega_{out}','FontSize',18)
title(['Hall Probes PSD ' day ', Ro=' num2str(ro,3) ', dB '])
colorbar




figure(4)
[M,c] = contourf(B_f_val,f_val,10*spectrum_p',22);
set(c,'LineColor','none')
% caxis([-70 0]);
xlabel('B_{ext}, gauss','FontSize',18)
ylabel('\omega/\Omega_{out}','FontSize',18)
title(['Pressure PSD ' day ', Ro=' num2str(ro,3)  ', dB '])
colorbar




clearvars a1 a2 A_val  c channel1 channel2 clcl D f k L 
clearvars log_av_pw_m log_av_pw_p Lp M pw_m pw_p   upto ans ro day
