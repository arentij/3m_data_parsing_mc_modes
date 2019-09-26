% 
import = 1;
if import 
    
    t2 = [54167, 55072, 55972, 56861, 57771, 58664, 59570, 60600];
    t1 = t2 - 700;
    tb1 = 60645;
    tb2 = 60700;
    record = grab_3mdata_chunks('101012',t1,t2,tb1,tb2); 
end

L = size(record,1);
upto = 2;
day = record{1,1};
recalc = 1;
plotting = 1;

%% PARAMETERS

% B = record{1,3}{1,1}(1);
% f_o = record{1,2}(2);
Ro  = record{1,2}(1);
% Ek = 7e-7/2/3.14/abs(f_o)/0.95^2;   % Ekmann number
save_folder = '/data/MATLAB/projects/ankit_plus/reynolds_ramp/n1d2_101012/';


if recalc
    for k=L:-1:1

        for ks = [1:24]
        %     length(record{i,3}{1,3});

            %% getting gauss coeff spectrum

            pw_gauss = 10/log(10) * log( pwelch( record{k,3}{1,6}(:,ks) - mean(record{k,3}{1,6}(:,ks))));
            
            
            if k == L && ks == 1
                Le = zeros(L+1,1);
                f = [0:(size(pw_gauss,1)-1)]/size(pw_gauss,1)*128/abs(record{k,2}(2));
                D = find(f>2, 1, 'first');
                Lf = length(f);
                ['First chunk pwelch is ' num2str(Lf) ' long']
                
                spectrum_sp_harm = zeros(24,D+1,L+1);
                spectrum_m = zeros(L+1,D+1);
                spectrum_p = zeros(L+1,D+1);
                
            end
            
%             if length(pw_gauss) ~= Lf
%                 koef = (length(pw_gauss)-1)/(Lf-1);
%                 pw_gauss = interp1(1:length(pw_gauss),pw_gauss,1:koef:length(pw_gauss));
%             end

            fi = [0:(size(pw_gauss,1)-1)]/size(pw_gauss,1)*128/abs(record{k,2}(2));
            Di = find(fi>2, 1, 'first'); 
%             if k~=8
%                 k
%             end
            temp = interp1(1:Di,pw_gauss(1:Di),1:(Di-1)/(D-1):Di);
            
            
            spectrum_sp_harm(ks,1:D,k) = temp';
            
            % Le = 8/15*I*10^-4/(1.256e-6*900)^0.5/2/pi/0.95/f_o
            I = record{k, 3}{1, 1}(1);
            f_o = record{k, 2}(2);
%             Le = 2.657*10^-4*I/abs(f_o);        % Lehnard number 
            Le(k) = 2.657*10^-4*I/abs(f_o);
            

        end


        %% getting mag probes spectrum
        a1 = 1;  % 1 - if substracting mean, 0 if not
        channel1 = [1:33] ; 
        pw_m = pwelch(record{k,3}{1,4}(:,channel1) - a1*mean(record{k,3}{1,4}(:,channel1))) ;
        log_av_pw_m = 10/log(10)*mean(log(pw_m),2);
        
        [num2str(k) ' has ' num2str(length(log_av_pw_m)) ' and raw has ' num2str(length(record{k,3}{1,4}(:,1)))]
        
        fi = [0:(size(log_av_pw_m,1)-1)]/size(log_av_pw_m,1)*128/abs(record{k,2}(2));
        Di = find(fi>2, 1, 'first'); 
        temp = interp1(1:Di,log_av_pw_m(1:Di),1:(Di-1)/(D-1):Di);
        
        spectrum_m(k,1:D) = temp;
        
        %% getting pressure probes spectrum
        a2 = 1;  % 1 - if substracting mean, 0 if not
        channel2 = [1:3] ; % number 4 appears to be noizy
        pw_p = pwelch(record{k,3}{1,3}(:,channel2) - a2*mean(record{k,3}{1,3}(:,channel2))) ;
        log_av_pw_p = 10/log(10)*mean(log(pw_p),2);
        
        fi = [0:(size(log_av_pw_p,1)-1)]/size(log_av_pw_p,1)*128/abs(record{k,2}(2));
        Di = find(fi>2, 1, 'first'); 
        temp = interp1(1:Di,log_av_pw_p(1:Di),1:(Di-1)/(D-1):Di);
        
        % saving spectrum
        spectrum_p(k,1:D) = temp;
    end
    
end

Le(L+1) = 2*Le(L) -Le(L-1);

if plotting

    %% HERE COMES THE PLOTTING PART
    %% B probes PSD average waterfall
%     figure(1)
% %     waterfall(f,Le,spectrum_m)
%     title('')
%     xlabel('\omega/\Omega_{out}','FontSize',18);
%     ylabel('Lehman number','FontSize',18);
%     zlabel('Hall Probes average power density, dB');


%     saveas(gcf,[save_folder 'B_waterfall.png'])

    %% B probes average
    figure(2)
    s = pcolor( Le, f(1:D+1),spectrum_m');
    set(s, 'EdgeColor', 'none');
    caxis([-60 -5]);
    xlabel('Lehman number','FontSize',18)
    ylabel('\omega/\Omega_{out}','FontSize',18)
    title(['Hall Probes PSD ' day  ' Ro=' num2str(Ro,2)  ', dB '])
    colorbar
    saveas(gcf,[save_folder 'B_color.png'])

    %% P probes average
    figure(3)
    s = pcolor(Le,f(1:D+1),spectrum_p');
    set(s, 'EdgeColor', 'none');
    caxis([-10 15]);
    xlabel('Lehman number','FontSize',18)
    ylabel('\omega/\Omega_{out}','FontSize',18)
    title(['Pressure Probes PSD ' day   'Ro=' num2str(Ro,2) ' , dB '])
    colorbar
    saveas(gcf,[save_folder 'P_color.png'])



    %% all the spherical harmonics
%     figure(4)
%     set(gcf, 'Position',  [0, 0, 2100, 1000])

    for ks = []
    %     figure(ks)
        subplot(4,6,ks)
        amp = 10/log(10)*log(fix(ks^0.5));
        s = pcolor(Le,f(1:D),squeeze(amp+spectrum_sp_harm(ks,:,:)));
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
        amp = 10/log(10)*log(fix(ks^0.5));
        s = pcolor( Le, f(1:D),squeeze(amp+spectrum_sp_harm(ks,:,:)));
        set(s, 'EdgeColor', 'none');
        [lt, mt] = k2lm(ks);
        title([ ' l=' int2str(lt) ' m=' int2str(mt) '  k= ' int2str(ks)])
        ylabel('\omega/\Omega_{out}','FontSize',18)
        xlabel('Lehman number','FontSize',16)
        caxis([-60 -20]);
        colorbar
        saveas(gcf,[save_folder 'l' int2str(lt) 'm' int2str(mt) '.png'])

    end

end 
clearvars  i k ks lt mt upto recalc s a1 a2 channel1 channel2 day Ek save_folder
clearvars log_av_pw_m log_av_pw_p pw_gauss pw_m pw_p koef ans Lf t1 t2 tb1 tb2
