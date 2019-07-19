% % getting data from first Ro ramp with B~120
% 
% t1 = 10+ [53291, 53601, 53902, 54203, 54504, 54806, 55118, 55412, 55716, 56013, 56310, 56611];
% t2 = [53593, 53900, 54201, 54497, 54804, 55104, 55405, 55707, 56008, 56306, 56610, 56911];
% record = grab_3mdata_chunks('100412',t1,t2); 


L = size(record,1);
upto = 2;
day = record{1,1};
recalc = 1;

if recalc
    for k=1:L

        for ks = [1:24]
        %     length(record{i,3}{1,3});

            %% getting gauss coeff spectrum

            pw_gauss = 10/log(10) * log( pwelch( record{k,3}{1,6}(:,ks) - mean(record{k,3}{1,6}(:,ks))));
            
            
            if k == 1 && ks == 1
                ro = zeros(L,1);
                f = [1:size(pw_gauss,1)]/size(pw_gauss,1)*128/abs(record{k,2}(2));
                D = find(f>2, 1, 'first');
                Lf = length(f);
                
                spectrum_sp_harm = zeros(24,D,L);
                spectrum_m = zeros(L,D);
                spectrum_p = zeros(L,D);
                
            end
            
            if length(pw_gauss) ~= Lf
                koef = (length(pw_gauss)-1)/(Lf-1);
                pw_gauss = interp1(1:length(pw_gauss),pw_gauss,1:koef:length(pw_gauss));
            end
            spectrum_sp_harm(ks,:,k) = pw_gauss(1:D);
            ro(k) = record{k,2}(1);


        end


        %% getting mag probes spectrum
        a1 = 1;  % 1 - if substracting mean, 0 if not
        channel1 = [1:33] ; 
        pw_m = pwelch(record{k,3}{1,4}(:,channel1) - a1*mean(record{k,3}{1,4}(:,channel1))) ;
        log_av_pw_m = 10/log(10)*mean(log(pw_m),2);
        
        if length(log_av_pw_m) ~= Lf
            koef = (length(log_av_pw_m)-1)/(Lf-1);
            log_av_pw_m = interp1(1:length(log_av_pw_m),log_av_pw_m,1:koef:length(log_av_pw_m));
            log_av_pw_m = log_av_pw_m';
        end
        
        [num2str(k) ' has ' num2str(length(log_av_pw_m)) 'and raw has ' num2str(length(record{k,3}{1,4}(:,1)))];
        
        spectrum_m(k,:) = log_av_pw_m(1:D,:);
        
        %% getting pressure probes spectrum
        a2 = 1;  % 1 - if substracting mean, 0 if not
        channel2 = [1:3] ; % number 4 appears to be noizy
        pw_p = pwelch(record{k,3}{1,3}(:,channel2) - a2*mean(record{k,3}{1,3}(:,channel2))) ;
        log_av_pw_p = 10/log(10)*mean(log(pw_p),2);
        
        if length(log_av_pw_p) ~= Lf
            koef = (length(log_av_pw_p)-1)/(Lf-1);
            log_av_pw_p = interp1(1:length(log_av_pw_p),log_av_pw_p,1:koef:length(log_av_pw_p));
            log_av_pw_p = log_av_pw_p';
        end
        
        % saving spectrum
        spectrum_p(k,:) = log_av_pw_p(1:D,:);
    end
end
%% PARAMETERS
% Le = 16/15*I*10^-4/(1.256e-6*900)^0.5/2/pi/1.03/f_o
B = record{1,3}{1,1}(1);
f_o = record{1,2}(2);

Le = 4.9*10^-4*B/abs(f_o);        % Lehnard number 

Ek = 7e-7/2/3.14/abs(f_o)/1.03^3;   % Ekmann number
save_folder = '/data/MATLAB/projects/ankit_plus/rossby_ramp/100412_1/';


plotting = 1;
if plotting

    %% HERE COMES THE PLOTTING PART
    %% B probes PSD average waterfall
    figure(1)
    waterfall(f(1:D),ro,spectrum_m)
    title('')
    xlabel('\omega/\Omega_{out}','FontSize',18);
    ylabel('Rossby number','FontSize',18);
    zlabel('Hall Probes average power density, dB');


    saveas(gcf,[save_folder 'B_waterfall.png'])

    %% B probes average
    figure(2)
    s = pcolor(ro,f(1:D),spectrum_m');
    set(s, 'EdgeColor', 'none');
    caxis([-60 -5]);
    xlabel('Rossby number','FontSize',18)
    ylabel('\omega/\Omega_{out}','FontSize',18)
    title(['Hall Probes PSD ' day ', Le=' num2str(Le,'%1.1e')  ' Ek=' num2str(Ek,'%1.1e') ', dB '])
    colorbar
    saveas(gcf,[save_folder 'B_color.png'])

    %% P probes average
    figure(3)
    s = pcolor(ro,f(1:D),spectrum_p');
    set(s, 'EdgeColor', 'none');
%     caxis([-10 15]);
    xlabel('Rossby number','FontSize',18)
    ylabel('\omega/\Omega_{out}','FontSize',18)
    title(['Pressure Probes PSD ' day ', Le=' num2str(Le,'%1.1e')  ' Ek=' num2str(Ek,'%1.1e') ', dB '])
    colorbar
    saveas(gcf,[save_folder 'P_color.png'])



    %% all the spherical harmonics
    figure(4)
    set(gcf, 'Position',  [0, 0, 2100, 1000])

    for ks = 1:24
    %     figure(ks)
        subplot(4,6,ks)
        s = pcolor(ro,f(1:D),squeeze(spectrum_sp_harm(ks,:,:)));
        set(s, 'EdgeColor', 'none');
        caxis([-60 -20]);
    %     xlabel('B_{ext}, gauss','FontSize',5)
    %     ylabel('\omega/\Omega_{out}','FontSize',5)
        [lt, mt] = k2lm(ks);
        title([ ' l=' int2str(lt) ' m=' int2str(mt) '  k= ' int2str(ks)])
    %     colorbar
    end
    saveas(gcf,[save_folder 'lm_all.png'])

    %% plotting some of the spherical coeff PSD
    for ks = []
        figure(4+ks)

        s = pcolor( ro, f(1:D),squeeze(spectrum_sp_harm(ks,:,:)));
        set(s, 'EdgeColor', 'none');
        [lt, mt] = k2lm(ks);
        title([ ' l=' int2str(lt) ' m=' int2str(mt) '  k= ' int2str(ks)])
        ylabel('\omega/\Omega_{out}','FontSize',18)
        xlabel('Rossby number','FontSize',16)
        caxis([-60 -20]);
        colorbar
        saveas(gcf,[save_folder 'l' int2str(lt) 'm' int2str(mt) '.png'])

    end

end 
clearvars  i k ks lt mt upto recalc s a1 a2 channel1 channel2 day Ek save_folder
clearvars log_av_pw_m log_av_pw_p pw_gauss pw_m pw_p koef ans Lf