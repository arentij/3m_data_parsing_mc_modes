% set to zero if you just want to plot and not to do the math again
recalc = 1;

if recalc
    % amount of different mag field exp's '-1' is to not to plot bias data
    L = size(record{1,3},1)-1;

    % plotting up to this omegas
    upto =2;
    % amount of points to plot UPTO
    Lp = size(pwelch(record{1,3}{2,3}(:,2)),1);
    D = fix(upto*Lp/128*record{1,2}(2)*(-1))+1;

    % preallocating resultive spectrum
    spectrum_m_ph_3d = zeros(L,D,24);

    % mag values
    A_val = zeros(1,L);

    
 
    for ks = 1:24

        for k = 1:L
            % getting current values
            A_val(k) = fix(record{1,3}{k,1}(1));

            %% getting hall probes spherical harmonics spectrum
            a3 = 1;  % 1 - if substracting mean, 0 if not

            channel3 = [ks] ; %*****************************************************************************

            pw_m_sph = pwelch(record{1,3}{k,6}(:,channel3) - a3*mean(record{1,3}{k,6}(:,channel3))) ;
            log_av_pw_m_sph = mean(log(pw_m_sph),2);
            % saving spectrum
            
            
            
            if k == 1 && length(log_av_pw_m_sph) ~=Lp
                
                sptrm_intrp = interp1(1:length(log_av_pw_m_sph),log_av_pw_m_sph,1:1/2:length(log_av_pw_m_sph));
                log_av_pw_m_sph = sptrm_intrp';
            end
            spectrum_m_ph_3d(k,:,ks) = log_av_pw_m_sph(1:D,:);
            
            B_f_val = A_val*8/15;
            f_val = [1:size(spectrum_m_ph_3d,2)]/size(spectrum_m_ph_3d,2)*upto;

        end

    
    end
end

day = record{1,1};
ro = record{1,2}(1);

figure(1)
for ks = 1:24
%     figure(ks)
    subplot(4,6,ks)
    [M,c] = contourf(B_f_val,f_val,10*spectrum_m_ph_3d(:,:,ks)',24);
    set(c,'LineColor','none')
    caxis([-120 -40]);
%     xlabel('B_{ext}, gauss','FontSize',5)
%     ylabel('\omega/\Omega_{out}','FontSize',5)
    [lt, mt] = k2lm(ks);
    title([ ' l=' int2str(lt) ' m=' int2str(mt) '  k= ' int2str(ks)])
%     colorbar
end

for ks = [1:24]
    figure(1+ks)
    [M,c] = contourf(B_f_val,f_val,10*spectrum_m_ph_3d(:,:,ks)',24);
    set(c,'LineColor','none')
    caxis([-120 -40]);
    xlabel('B_{ext}, gauss','FontSize',18)
    ylabel('\omega/\Omega_{out}','FontSize',18)
    [lt, mt] = k2lm(ks);
    title({['Spherical Harmonics PSD ' day ', Ro=' num2str(ro,3) ', dB ']; [ ' l=' int2str(lt) ' m=' int2str(mt) '    k= ' int2str(ks)]})
    colorbar
end


clearvars a1 a2 A_val  c channel1 channel2 clcl D f k L a3 ks lt mt channel3 day ro
clearvars log_av_pw_m log_av_pw_p Lp M pw_m pw_p spectrum_m spectrum_p upto recalc
