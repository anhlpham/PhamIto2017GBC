%% A sample MATLAB code to objective map model and observed dFe data
%% into the same grid point following the GA02 GEOTRACES cruise
close all;clear all;clc;
addpath m_map % Note this script using m_map package for MATLAB to plot figures
%% set smoothing paramters, these parameters can be changed
lx = 3;     % horiz. smoothing scale
lzmax= 300; % max vert. smoothing scale
lzmin=  10; % min vert. smoothing scale
Hlz  = 1000; % transition depth for vert. smoothing
stn  = 0.5;   % signal to noise ratio factor

%% load data 
load('Fe_Full_run.mat'); % Model dFe
load('GA02.mat'); %  GEOTRACES data
%% load model grid formation
x = rdmds('XC');
y = rdmds('YC');
z = rdmds('RC');
z = squeeze(z);
dx = rdmds('DXG');
dy = rdmds('DYG');
dz = rdmds('DRF');
da = rdmds('RAC');
hc = rdmds('hFacC');
dz3d = repmat(dz,[360 160 1]).*hc;
dv = repmat(da,[1 1 23]).*repmat(dz,[360 160 1]).*hc;

x2 = x;
y2 = y;
x2(end+1,:)= x2(end,:)+1;
y2(end+1,:)= y2(1,:);

%% define grid folowing the cruise track GA02 50S - 60N - Atlantic(62W-30W)
ytr = [-50:1:60];   % lat - grid
ztr = [5:10:200 250:50:700 780:80:1100 1200:100:5600]; % dep - grid

% estimate the grid along the cruise track
index = 0;
for j=1:length(ytr);
   yloc = ytr(j);
   g = exp(-((lat0-yloc)/lx).^2); % gaussian weight 
   xtr(j)= sum(g.*log0)/sum(g);  % approximate cruise track
   bot(j)= sum(g.*bot0)/sum(g);  % approximate bottom depth
   for k = 1:length(ztr)
      if bot(j)> abs(ztr(k));
        index = index + 1;
        y1d(index)= yloc;
        z1d(index)= ztr(k);
        jdata(index)= j;
        kdata(index)= k;
      end
   end
end
Ngrid = index;

%% crop the model output
Fe(Fe==0)= NaN;
halo = zeros(360,160);
for j = 1:length(ytr)
  J = find(abs(y-ytr(j))<lx*2&abs(x-xtr(j))<lx*2);
  halo(J)= 1;
end
h3d = repmat(halo,[1 1 23]);
h3d(isnan(Fe))= 0;
J = find(halo==1);
% estimate the grid along the cruise track
for i= 1:length(J)
  xhalo(i)=x(J(i));
  yhalo(i)=y(J(i));
end

%% show the cruise track, dotted region is where I'm extracting 
%  the model data for interpolation later
c = Fe(:,:,1);
c(end+1,:)= c(1,:);
figure(1);
m_proj('miller','lat',[-70 70],'lon',[0 360]);
m_pcolor(x2,y2,c*1e6);
shading flat;
m_coast('patch',[.5 .5 .5]);
m_grid('xaxis','bottom','box','fancy');
caxis([0 1]);
hold on;
p  = m_plot(xhalo,yhalo,'k.');
set(p,'MarkerSize',0.5);
m_plot(xtr,ytr,'k-','linewidth',3);
% m_text(320,41,'GA02','color','r','fontweight','bold');
hold off;
drawnow;
%% make colorbar at the bottom
cmp=colormap('jet');
% cmp(30:33,:) = ones(4,3);
% colormap = cmp;
colorbartype([.1 .05 .8 .025],0:.02:1,51,[0 1],cmp,0);
ax=get(gcf,'currentaxes');
set(ax,'xtick',1:10:51);
set(ax,'xticklabel',{'0' '0.2' '0.4' '0.6' '0.8' '1'},'FontName','Times New Roman','FontSize',12);
% title('Subsurrface ligand anomalies [nM]','FontName', 'Times New Roman', 'fontsize',18); 
title(' Surface dissolved Fe[nM]','FontName', 'Times New Roman','FontName','Times New Roman', 'fontsize',16); 

figure(2)
pcolor(x,y,Fe(:,:,1)*1e6); shading flat;
xlabel('Longitude','FontSize',14);
ylabel('Latitude','FontSize',14);
colorbar;
caxis([0 1]); title('surface Fe(nM)','fontsize',16);
hold on;
p  = plot(xhalo,yhalo,'k.');
set(p,'MarkerSize',1);
plot(xtr,ytr,'k-','linewidth',3);
hold off;


%% objective mapping - setting up 1D array of model values
disp('starting the objective mapping...');
index = 0;
for i = 1:360
   for j = 1:160
      for k = 1:23
         if h3d(i,j,k)==1
            index = index+1;
            y1dm(index) = y(1,j);  % 1D array for model lat
            z1dm(index)= -z(k);   % depth
            data1dm(index)= Fe(i,j,k); % iron
         end
      end
   end
end
Nmodel = index;

%% objective mapping - setting up 1D array of observations
index = 0;
for j = 1:length(lat0);
  K = find(~isnan(Fe0(j,:)));
  for k = 1:length(K)
    index = index+1;
    data1d(index)= Fe0(j,K(k));  % fe  vector
    y1do(index)= lat0(j);        % lat vector
    z1do(index)= dep0(j,K(k));   % dep vector
  end
end
Ndata = index;

disp('construct data-data covariance');
for i = 1:Ndata
   lz = lzmax*(1-exp(-z1do(i)/Hlz))+ lzmin;
   % gaussian 
   A(i,:) = exp(-(((y1do-y1do(i))/lx).^2+((z1do-z1do(i))/lz).^2));
   A(i,:)= A(i,:)/sum(A(i,:),2);
end
tmp = (A*stn+(1.0-stn)*eye(Ndata))\data1d';

disp('construct grid-data covariance');
P = zeros(Ngrid,Ndata);
for i= 1:Ngrid
   lz = lzmax*(1-exp(-z1d(i)/Hlz))+lzmin;
   % gaussian
   P(i,:)= exp(-(((y1do-y1d(i))/lx).^2+((z1do-z1d(i))/lz).^2));
   P(i,:)= P(i,:)/sum(P(i,:),2);  
end

tmp2= P*tmp;

disp('construct grid-model covariance');
P2 = zeros(Ngrid,Nmodel);
for i= 1:Ngrid
   lz = lzmax*(1-exp(-z1d(i)/Hlz))+lzmin;
   % gaussian
   P2(i,:)= exp(-(((y1dm-y1d(i))/lx).^2+((z1dm-z1d(i))/lz).^2));
   P2(i,:)= P2(i,:)/sum(P2(i,:),2); 
end

tmp3= P2*data1dm';

disp('copy the mapped data into a matrix');
for i = 1:Ngrid;
  jloc = jdata(i);
  kloc = kdata(i);
  data2d(jloc,kloc)=tmp2(i);
  data2dm(jloc,kloc)=tmp3(i);
end





