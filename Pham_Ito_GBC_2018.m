%%  A sample MATLAB script to plot the figures of Fe distribution along the a certain GEOTRACES transect
%%  reported in Pham and Ito 2018, GBC
close all;clear all;clc;
% load the data
load('GI04_obs.mat'); % observations along the GI04 Indian Ocean transect
load('GI04_model.mat');% Full run
%% define grid along the cruise track GI04 62S - 17N - Indian Ocean
ytr = [-62:1:17]; % lat - grid
ztr = [5:10:200 250:50:700 780:80:1100 1200:100:5200]; % dep - grid


figure(1);
subplot('position',[.20 .38 .65 .50]);
pcolor(ytr,-ztr,GI04_Fe_obs');
shading flat;
% colorbar;
caxis([0 1.6]);
axis([-62 17 -1000 0]);
%xlabel('Latitude','fontsize',14);
%ylabel('Depth (meters)','fontsize',14);
title('GEOTRACES, GI04 cruise','fontsize',20);
ax=get(gcf,'currentaxes');
set(ax,'xtick',[]);
set(ax,'fontsize',16);
ylabel('Depth (meters)','fontsize',20);


subplot('position',[.20 .10 .65 .25]);
pcolor(ytr,-ztr,GI04_Fe_obs');
shading flat;
% colorbar;
caxis([0 1.6]);
axis([-62 17 -5200 -1000]);
ax=get(gcf,'currentaxes');
months = ['60S';
          '50S';
            '40S';
            '30S';
            '20S';
            '10S';
            'Eq.';
            '10N'];
set(gca,'XTickLabel',months)
set(ax,'fontsize',16);
xlabel('Latitude','fontsize',20);

figure(2);
subplot('position',[.20 .38 .65 .50]);
pcolor(ytr,-ztr,GI04_Fe_obs');
shading flat;
% colorbar;
caxis([0 1.6]);
axis([-62 17 -1000 0])
title('Full run','fontsize',24);
ax=get(gcf,'currentaxes');
set(ax,'xtick',[]);
set(ax,'fontsize',16);
ylabel('Depth (meters)','fontsize',20);



subplot('position',[.20 .10 .65 .25]);
pcolor(ytr,-ztr,GI04_Fe_model');
shading flat;
% colorbar;
caxis([0 1.6]);
axis([-62 17 -5200 -1000])
ax=get(gcf,'currentaxes');
months = ['60S';
          '50S';
            '40S';
            '30S';
            '20S';
            '10S';
            'Eq.';
            '10N'];
set(gca,'XTickLabel',months)
set(ax,'fontsize',16);
xlabel('Latitude','fontsize',20);