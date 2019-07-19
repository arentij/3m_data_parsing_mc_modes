if import == 0
    try day = record{1,1};
    catch
        'importing record.mat for you'
        record = importdata('record.mat');
    end
end
L = size(record,1)+1;
upto = 2;
day = record{1,1};

% checking if all std(B) are low
for k=1:L-1
    if record{k, 3}{1, 1}(4)/record{k, 3}{1, 1}(1) > 0.02
        ['******* CHECK MAGNETIC DATA FROM k=' num2str(k) ' dB/B=' num2str(record{k, 3}{1, 1}(4)/record{k, 3}{1, 1}(1),2)  ' ********']
    end
end

if recalc
    for k=1:L-1

        for ks = [1:24]
        %     length(record{i,3}{1,3});

            %% getting gauss coeff spectrum

            pw_gauss = 10/log(10) * log( pwelch( record{k,3}{1,6}(:,ks) - mean(record{k,3}{1,6}(:,ks))));
            
            
            if k == 1 && ks == 1
                Le = zeros(L,1);
                f = [1:size(pw_gauss,1)]/size(pw_gauss,1)*128/abs(record{k,2}(2));
                D = find(f>upto, 1, 'first')+1;
                Lf = length(f);
                ['First chunk pwelch is ' num2str(Lf) ' long'];
                
                spectrum_sp_harm = zeros(24,D,L);
                spectrum_m = zeros(L,D);
                spectrum_p = zeros(L,D);
                
            end
            
            if length(pw_gauss) ~= Lf
                koef = (length(pw_gauss)-1)/(Lf-1);
                pw_gauss = interp1(1:length(pw_gauss),pw_gauss,1:koef:length(pw_gauss));
            end
            spectrum_sp_harm(ks,:,k) = pw_gauss(1:D);
            
            % Le = 8/15*I*10^-4/(1.256e-6*900)^0.5/2/pi/0.95/f_o
            I = max(0,record{k, 3}{1, 1}(1));
            f_o = record{5, 2}(2);
%             Le = 2.657*10^-4*I/abs(f_o);        % Lehnard number 
            Le(k) = 2.657*10^-4*I/abs(f_o);
            
            
            if k == L-1
                Le(L) = 2*Le(L-1)-Le(L-2);
            end

        end
        

        %% getting mag probes spectrum
        a1 = 1;  % 1 - if substracting mean, 0 if not
        channel1 = [1:33] ; 
        pw_m = pwelch(record{k,3}{1,4}(:,channel1) - a1*mean(record{k,3}{1,4}(:,channel1))) ;
        log_av_pw_m = 10/log(10)*mean(log(pw_m),2);
        
        [num2str(k) ' has ' num2str(length(log_av_pw_m)) ' and raw has ' num2str(length(record{k,3}{1,4}(:,1)))];
        
        if length(log_av_pw_m) ~= Lf
            koef = (length(log_av_pw_m)-1)/(Lf-1);
            log_av_pw_m = interp1(1:length(log_av_pw_m),log_av_pw_m,1:koef:length(log_av_pw_m));
            log_av_pw_m = log_av_pw_m';
        end
        
        
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

% B = record{1,3}{1,1}(1);
f_o = record{1,2}(2);
Ro  = record{1,2}(1);
Ek = 7e-7/2/3.14/abs(f_o)/0.95^2;   % Ekmann number


if plotting

    %% HERE COMES THE PLOTTING PART
    %% B probes PSD average waterfall
    figure(1)
    waterfall(f(1:D),Le,spectrum_m)
    title('')
    xlabel('\omega/\Omega_{out}','FontSize',18);
    ylabel('Lehnard number','FontSize',18);
    zlabel('Hall Probes average power density, dB');
%     saveas(gcf,[save_folder 'B_waterfall.png'])


%     saveas(gcf,[save_folder 'B_waterfall.png'])

    %% B probes average
    figure(2)
    s = pcolor(Le,f(1:D),spectrum_m');
    set(s, 'EdgeColor', 'none');
    caxis([-60 -0]);
    xlabel('Lehnard number','FontSize',18)
    ylabel('\omega/\Omega_{out}','FontSize',18)
    title(['Hall Probes PSD ' day  ' Ro=' num2str(Ro,2) ' Ek=' num2str(Ek,'%1.1e') ', dB '])
    colorbar
    saveas(gcf,[save_folder 'B_color.png'])

    %% P probes average
    figure(3)
    s = pcolor(Le,f(1:D),spectrum_p');
    set(s, 'EdgeColor', 'none');
%     caxis([-10 15]);
    xlabel('Lehnard number','FontSize',18)
    ylabel('\omega/\Omega_{out}','FontSize',18)
    title(['Pressure Probes PSD ' day   ' Ro=' num2str(Ro,2) ' Ek=' num2str(Ek,'%1.1e') ', dB '])
    colorbar
    saveas(gcf,[save_folder 'P_color.png'])



    %% all the spherical harmonics
    figure(4)
    set(gcf, 'Position',  [0, 0, 1500, 900])

    for ks = [1:24]
    %     figure(ks)
        [lt, mt] = k2lm(ks);
        if mt < 0
            continue
        end
        subplot(4,5,1+5*(lt-1)+mt)
        
        amp = 10/log(10)*log(fix(ks^0.5));
        s = pcolor(Le,f(1:D),squeeze(amp+spectrum_sp_harm(ks,:,:)));
        set(s, 'EdgeColor', 'none');
        caxis([-60 -10]);
    %     xlabel('B_{ext}, gauss','FontSize',5)
    %     ylabel('\omega/\Omega_{out}','FontSize',5)
        
        title([ ' l=' int2str(lt) ' m=' int2str(mt) '  k= ' int2str(ks)])
    %     colorbar
    end
    saveas(gcf,[save_folder 'lm_all.png'])

    %% plotting some of the spherical coeff PSD
    
    % creating a folder to save lm's
    if ~exist([save_folder 'lm'],'dir')
            mkdir('lm')
    end
    
    for ks = [1:24]
        [lt, mt] = k2lm(ks);
        if mt < 0
            continue
        end
        figure(4+ks)

        s = pcolor( Le, f(1:D),squeeze(spectrum_sp_harm(ks,:,:)));
        set(s, 'EdgeColor', 'none');
        
        title([ ' l=' int2str(lt) ' m=' int2str(mt) '  k= ' int2str(ks)])
        ylabel('\omega/\Omega_{out}','FontSize',18)
        xlabel('Lehnard number','FontSize',16)
        caxis([-60 -20]);
        colorbar
        
        
        
        saveas(gcf,[save_folder 'lm/l' int2str(lt) 'm' int2str(mt) '.png'])
%         close(4+ks)
    end

end 
clearvars  i k ks lt mt upto recalc s a1 a2 channel1 channel2 day Ek save_folder
clearvars log_av_pw_m log_av_pw_p pw_gauss pw_m pw_p koef ans Lf t1 t2 tb1 tb2
