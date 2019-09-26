%gains_plot
%uses record matrix from Artur

tim=zeros(1,length(record)); 
ro1=zeros(1,length(record));
re=ones(1,length(record))*((2*pi*(1.05^2))/0.7e-6);
rm=ones(1,length(record))*((2*pi*(1.05^2))/0.079);

torinn=zeros(1,length(record)); 
g=ones(1,length(record))./(((0.7e-6)^2)*(0.45)*927);
gginf=zeros(1,length(record));
fun_G_Re_3M = @(l) (l^1.885)*0.003235;

% torqout=zeros(1,length(record)); no torque out in record yet

bext=zeros(1,length(record));
brad=zeros(1,length(record)); 
bphi=zeros(1,length(record));
 

bdip = zeros(1,length(record));
bcua = zeros(1,length(record));

for i=1:length(record)
    tim(i)=record{i,3}{1,1}(1,2);
    ro1(i)=(1/record{i,2}(1));
    re(i)=abs(-record{i,2}(2) + record{i,2}(3))*re(i);
    rm(i)=abs(-record{i,2}(2) + record{i,2}(3))*rm(i);
    
    torinn(i)=mean(record{i,4}{1,2}(:,1));
    g(i)=torinn(i)*g(i);
    gginf(i)=g(i)/fun_G_Re_3M(re(i));
%     torqout(i)=mean(record{i,4}{1,2}(:,1));
    
    brad(i)=mean(record{i,3}{1,4}(:,32));
    bphi(i)=mean(record{i,3}{1,4}(:,33));
    
    bdip(i) =mean(record{i,3}{1,6}(:,1));
    bcua(i) =mean(record{i,3}{1,6}(:,4));
    
    
    
end
% save([folder '_gain'], 'tim','ro1','re','rm','torinn','gginf', 'g','brad','bphi','bdip','bcua');
    

