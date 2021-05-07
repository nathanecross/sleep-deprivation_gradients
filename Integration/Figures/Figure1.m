%% Figure 1.A Connectivity Matrix
addpath(genpath('../code'))

% i. Set Basic Parameters
keyword = 'task-All'; 
NumberOfSubjects=20;
nparc = '400'; nnetw= '17';
times = [{'ses-01','','Control'} 
         {'ses-02','run-01','PreNap'}
         {'ses-02','run-02', 'PostNap'}]; 
contrasts = {'Control','PreNap'};
lut = transpose(table2cell(readtable(sprintf('../../labels/Schaefer2018_%sParcels_%sNetworks_order.txt', ...
                                             nparc,nnetw))));
% ii Load in the GLM: WR -> SD
load(sprintf('../../data/stats/GLM%s_%s_%s.mat',nparc,nnetw,keyword))
matrix = GLM.SDEP_Tmat;

% iii. Unthresholded matrix
[~, matrix_bordered, L] = reorder_matrices(matrix, lut, nparc, nnetw); 
figure; 
cmap = customcolormap([0 0.2 0.4 0.5 0.8 0.9 1], ...
       {'#6b1200','#E23603','#FF8D33',  '#bababa', '#336EFF', '#336EFF', '#033c9e'});
imagesc(matrix_bordered); 
set(gca, 'XTick', 1:length(L)); % center x-axis ticks on bins
set(gca, 'YTick', 1:length(L)); % center y-axis ticks on bins
set(gca, 'XTickLabel', L, 'FontSize', 5); % set x-axis labels
set(gca, 'YTickLabel', L, 'FontSize', 5);
caxis([-7, 7]);
colormap(cmap); 

% iv. Thresholded matrix
SDEP_Pmat_fdr_bordered = [zeros(str2double(nparc),1) GLM.SDEP_Pmat_fdr_bordered zeros(str2double(nparc),1)];
SDEP_Pmat_fdr_bordered = [zeros(1,str2double(nparc)+2); SDEP_Pmat_fdr_bordered; zeros(1,str2double(nparc)+2)];
matrix_bordered(SDEP_Pmat_fdr_bordered>0.05)=0;
figure; 
cmap = customcolormap([0 0.2 0.35 0.5 0.8 0.9 1], ...
       {'#6b1200','#E23603','#FF8D33',  '#000000', '#336EFF', '#336EFF', '#033c9e'});
imagesc(matrix_bordered); 
set(gca, 'XTick', 1:length(L)); % center x-axis ticks on bins
set(gca, 'YTick', 1:length(L)); % center y-axis ticks on bins
set(gca, 'XTickLabel', L, 'FontSize', 5); % set x-axis labels
set(gca, 'YTickLabel', L, 'FontSize', 5);
caxis([-7, 7]);
colormap(cmap); 

%% Figure 1.B. Hierarchical Model Of the Cortex

% i. Load in total integration stats for Cortex, 7 and 17 networks
load('../data/stats/HI_stats.mat');
data(1,1) = ((HI_stats.SDmean(1) - HI_stats.WRmean(1))/HI_stats.WRmean(1))*100; data(2:7,1) = NaN;
data(1:7,2) = ((HI_stats.SDmean(2:8) - HI_stats.WRmean(2:8))./HI_stats.WRmean(2:8))*100; data(8:17,1:2) = NaN;
data(1:17,3) = ((HI_stats.SDmean(9:25) - HI_stats.WRmean(9:25))./HI_stats.WRmean(9:25))*100;

% ii. Reorder networks for visualisation
data(1:7,2) = [data(6,2);data(7,2);data(3,2);data(5,2);data(4,2);data(1,2);data(2,2)];
data(1:17,3) = [data(11,3); data(12,3); data(13,3); data(17,3); data(14,3); data(15,3); ...
            data(16,3); data(5,3);data(6,3);data(9,3);data(10,3);...
            data(7,3); data(8,3);data(3,3);data(4,3);data(1,3);data(2,3)];

% iii. Load in total integration stats for assemblies (clusters)
load('../data/integration/Integration400_17_task-All.mat');
ass_statz = HI.Assemblies.stats_alphabet_order';
ass_statz(ass_statz==0)=NaN;
data = [data [ass_statz; nan(length(data)-size(ass_statz,1),17)]];
i=0;
for c = 1:size(data,2)
    for r = 1:length(data(:,c))
        if isnan(data(r,c)) ~= 1
            i = i+1;
            dat(i,1) = data(r,c);
        end 
    end
end

% iv. PLOT FIGURE 
f = figure;
cmap = customcolormap([0 0.2 0.4 0.5 0.8 0.9 1], ...
    {'#6b1200','#E23603','#FF8D33',  '#bababa', '#336EFF', '#336EFF', '#033c9e'});
clim = [-50 50];

% cortex
a(1) = axes('position', [0.1 0.05 0.1 0.9]);
imagesc(dat(1)); axis off;
colormap(a(1), cmap)
caxis(a(1), clim)

% networks 1:7
for i = 2:8
    if i == 2
        a(i) = axes('position', [0.3 1.01-(0.13*i) 0.1 0.2]);
        imagesc(dat(i)); axis off;
        colormap(a(i), cmap)
        caxis(a(i), clim)
    elseif i == 3
        a(i) = axes('position', [0.3 0.95-(0.13*i) 0.1 0.15]);
        imagesc(dat(i)); axis off;
        colormap(a(i), cmap)
        caxis(a(i), clim)
    else
        a(i) = axes('position', [0.3 0.85-(0.1*i) 0.1 0.08]);
        imagesc(dat(i)); axis off;
        colormap(a(i), cmap)
        caxis(a(i), clim)
    end
end

% networks 1:17
for i = 9:25
    if i < 13
        a(i) = axes('position', [0.47 1.36-(0.05*i) 0.04 0.037]);
        imagesc(dat(i)); axis off;
        colormap(a(i), cmap)
        caxis(a(i), clim)
    elseif i < 16
        a(i) = axes('position', [0.47 1.32-(0.05*i) 0.04 0.04]);
        imagesc(dat(i)); axis off;
        colormap(a(i), cmap)
        caxis(a(i), clim)
    elseif i < 18
        a(i) = axes('position', [0.47 1.215-(0.045*i) 0.04 0.03]);
        imagesc(dat(i)); axis off;
        colormap(a(i), cmap)
        caxis(a(i), clim)
    elseif i < 20
        a(i) = axes('position', [0.47 1.205-(0.045*i) 0.04 0.035]);
        imagesc(dat(i)); axis off;
        colormap(a(i), cmap)
        caxis(a(i), clim)
    elseif i < 22
        a(i) = axes('position', [0.47 1.195-(0.045*i) 0.04 0.03]);
        imagesc(dat(i)); axis off;
        colormap(a(i), cmap)
        caxis(a(i), clim)   
    elseif i < 24
        a(i) = axes('position', [0.47 1.185-(0.045*i) 0.04 0.03]);
        imagesc(dat(i)); axis off;
        colormap(a(i), cmap)
        caxis(a(i), clim)
    else
        a(i) = axes('position', [0.47 1.175-(0.045*i) 0.04 0.03]);
        imagesc(dat(i)); axis off;
        colormap(a(i), cmap)
        caxis(a(i), clim)
        
    end
end

% assemblies 1:57
for i = 26:82
    if i < 38
        if i == 26 || i == 27 || i == 28  
            a(i) = axes('position', [0.6 1.198-(0.01*i) 0.06 0.0045]);
            imagesc(dat(i)); axis off;
            colormap(a(i), cmap)
            caxis(a(i), clim)
        elseif  i == 29 || i == 30 || i == 31 
           a(i) = axes('position', [0.6 1.176-(0.01*i) 0.06 0.0045]);
           imagesc(dat(i)); axis off;
           colormap(a(i), cmap)
           caxis(a(i), clim)
        elseif i == 32 || i == 33 || i == 34 
            a(i) = axes('position', [0.6 1.156-(0.01*i) 0.06 0.0045]);
            imagesc(dat(i)); axis off;
            colormap(a(i), cmap)
            caxis(a(i), clim)
        else
            a(i) = axes('position', [0.6 1.136-(0.01*i) 0.06 0.0045]);
            imagesc(dat(i)); axis off;
            colormap(a(i), cmap)
            caxis(a(i), clim)
        end
    elseif i < 49
        if i == 38 || i == 39 || i == 40 || i == 41 || i == 42
            a(i) = axes('position', [0.6 1.01-(0.008*i) 0.06 0.0045]);
            imagesc(dat(i)); axis off;
            colormap(a(i), cmap)
            caxis(a(i), clim)
        elseif  i == 43 || i == 44 || i == 45
            a(i) = axes('position', [0.6 1.08-(0.01*i) 0.06 0.0045]);
            imagesc(dat(i)); axis off;
            colormap(a(i), cmap)
            caxis(a(i), clim)
        else
            a(i) = axes('position', [0.6 1.06-(0.01*i) 0.06 0.0045]);
            imagesc(dat(i)); axis off;
            colormap(a(i), cmap)
            caxis(a(i), clim)
        end
    elseif i < 55
        if i == 49 || i == 50 ||i == 51 
            a(i) = axes('position', [0.6 1.01-(0.01*i) 0.06 0.0045]);
            imagesc(dat(i)); axis off;
            colormap(a(i), cmap)
            caxis(a(i), clim)
        else
            a(i) = axes('position', [0.6 0.995-(0.01*i) 0.06 0.0045]);
            imagesc(dat(i)); axis off;
            colormap(a(i), cmap)
            caxis(a(i), clim)
        end
    elseif i < 63
        if i == 55 || i == 56 || i == 57
            a(i) = axes('position', [0.6 0.97-(0.01*i) 0.06 0.0045]);
            imagesc(dat(i)); axis off;
            colormap(a(i), cmap)
            caxis(a(i), clim)
        else
            a(i) = axes('position', [0.6 0.785-(0.007*i) 0.06 0.004]);
            imagesc(dat(i)); axis off;
            colormap(a(i), cmap)
            caxis(a(i), clim)
        end
    elseif i < 70
        if i == 63 || i == 64 || i == 65 || i == 66
            a(i) = axes('position', [0.6 0.825-(0.008*i) 0.06 0.0045]);
            imagesc(dat(i)); axis off;
            colormap(a(i), cmap)
            caxis(a(i), clim)
        else
            a(i) = axes('position', [0.6 0.943-(0.01*i) 0.06 0.0045]);
            imagesc(dat(i)); axis off;
            colormap(a(i), cmap)
            caxis(a(i), clim)
        end
    elseif i < 76
        if i == 70 || i == 71 || i == 72
            a(i) = axes('position', [0.6 0.92-(0.01*i) 0.06 0.0045]);
            imagesc(dat(i)); axis off;
            colormap(a(i), cmap)
            caxis(a(i), clim)
        else
            a(i) = axes('position', [0.6 0.903-(0.01*i) 0.06 0.0045]);
            imagesc(dat(i)); axis off;
            colormap(a(i), cmap)
            caxis(a(i), clim)
        end
    else
        if i == 76 || i == 77 || i == 78 || i == 79
            a(i) = axes('position', [0.6 0.729-(0.008*i) 0.06 0.0045]);
            imagesc(dat(i)); axis off;
            colormap(a(i), cmap)
            caxis(a(i), clim)
        else
            a(i) = axes('position', [0.6 0.873-(0.01*i) 0.06 0.0045]);
            imagesc(dat(i)); axis off;
            colormap(a(i), cmap)
            caxis(a(i), clim)
        end
    end
end

j = 70;
a(j) = axes('position', [0.9 0.05 0.05 0.9]);
imagesc((flipud([clim(1):0.01:clim(end)]'))); axis off
colormap(a(j), cmap)
caxis(a(j), clim);

%% Figure 1.C Integration changes on the cortex

% i. Load in surface
SP = SurfStatAvSurf({'../../labels/fsaverage5/surf/lh.pial', ...
                     '../../labels/fsaverage5/surf/rh.pial'});
% ii. Set colormap
cmap = customcolormap([0 0.2 0.4 0.5 0.8 0.9 1], ...
       {'#6b1200','#E23603','#FF8D33',  '#bababa', '#336EFF', '#336EFF', '#033c9e'});
clim = [-40 40];


% iii. 7 NETWORKS

% Load in total integration stats for 7 networks
load('../data/stats/HI_stats.mat');
data(1,1) = ((HI_stats.SDmean(1) - HI_stats.WRmean(1))/HI_stats.WRmean(1))*100; data(2:7,1) = NaN;
data(1:7,2) = ((HI_stats.SDmean(2:8) - HI_stats.WRmean(2:8))./HI_stats.WRmean(2:8))*100; data(8:17,1:2) = NaN;

% Map parcels to networks 
nnetw = '7'; nparc ='400'; NumberOfParcels = str2num(nparc);
load(sprintf('../../labels/fsaverage5/ShfParcels/ShfLabels%s_%s.mat',nparc,nnetw)) 
load(sprintf('../../labels/Yeo%s_Shf%s.mat',nnetw,nparc));
for i = 1:length(lh_labels_Shf)
    lh_labels_Shf_Yeo(i,1) = lh_labels_Shf(i);
    rh_labels_Shf_Yeo(i,1) = rh_labels_Shf(i);
end

% Create vector for mapping
for i = 1:NumberOfParcels
    vec(i,1) = data(Yeo_Shf(i),2);   
end

% Plot to surface
parc = [lh_labels_Shf_Yeo(:,1)' rh_labels_Shf_Yeo(:,1)'];
nonwall = [2:201 203:402];
toMap = zeros(1,length(unique(parc)));
toMap(nonwall) = vec;
OnSurf  = BoSurfStatMakeParcelData(toMap, SP, parc);
OnSurfS = SurfStatSmooth(OnSurf, SP, 4);
figure;
BoSurfStat_calibrate2Views(OnSurfS, SP, ...
            [0.05 0.73 0.3 0.3], [0.05 0.5 0.3 0.3], ...
            1, 2, clim, cmap);
BoSurfStat_calibrate2Views_rh(OnSurfS, SP, ...
            [0.05 0.20 0.3 0.3], [0.05 -0.03 0.3 0.3], ...
            1, 2, clim, cmap);

        
% iv. 17 NETWORKS 

% Load in data
data(1:17,3) = ((HI_stats.SDmean(9:25) - HI_stats.WRmean(9:25))./HI_stats.WRmean(9:25))*100;

% Map parcels to networks 
nnetw = '17'; nparc ='400'; NumberOfParcels = str2num(nparc);
load(sprintf('../../labels/fsaverage5/ShfParcels/ShfLabels%s_%s.mat',nparc,nnetw)) 
load(sprintf('../../labels/Yeo%s_Shf%s.mat',nnetw,nparc));
for i = 1:length(lh_labels_Shf)
    lh_labels_Shf_Yeo(i,1) = lh_labels_Shf(i);
    rh_labels_Shf_Yeo(i,1) = rh_labels_Shf(i);
end

% Create vector for mapping
for i = 1:NumberOfParcels
    vec(i,1) = data(Yeo_Shf(i),3);  
end

% Plot to surface
parc = [lh_labels_Shf_Yeo(:,1)' rh_labels_Shf_Yeo(:,1)'];
nonwall = [2:201 203:402];
toMap = zeros(1,length(unique(parc)));
toMap(nonwall) = vec;
OnSurf  = BoSurfStatMakeParcelData(toMap, SP, parc);
OnSurfS = SurfStatSmooth(OnSurf, SP, 4);
BoSurfStat_calibrate2Views(OnSurfS, SP, ...
            [0.35 0.73 0.3 0.3], [0.35 0.5 0.3 0.3], ...
            1, 2, clim, cmap);
BoSurfStat_calibrate2Views_rh(OnSurfS, SP, ...
            [0.35 0.20 0.3 0.3], [0.35 -0.03 0.3 0.3], ...
            1, 2, clim, cmap);
           
% v. 57 CLUSTERS

% Load in data
load('../data/integration/Integration400_17_task-All.mat');

% Map parcels to networks 
nnetw = '17'; nparc ='400'; NumberOfParcels = str2num(nparc);
load(sprintf('../../labels/fsaverage5/ShfParcels/ShfLabels%s_%s.mat',nparc,nnetw)) 
Yeo_17Clusters_ref = load('../../labels/fsaverage5/YeoNetworks/1000subjects_clusters17_ref.mat');
for i = 1:length(lh_labels_Shf)
    lh_labels_Shf_Yeo(i,1) = lh_labels_Shf(i);
    lh_labels_Shf_Yeo(i,2) = Yeo_17Clusters_ref.lh_labels(i);
end
for i = 1:length(rh_labels_Shf)
    rh_labels_Shf_Yeo(i,1) = rh_labels_Shf(i);
    rh_labels_Shf_Yeo(i,2) = Yeo_17Clusters_ref.rh_labels(i);
end
for i = 1:length(lh_labels_Shf)
    lh_labels_Shf_Yeo(i,1) = lh_labels_Shf(i);
    rh_labels_Shf_Yeo(i,1) = rh_labels_Shf(i);
end

% Create vector for mapping
for i = 1:NumberOfParcels
    x = ShfLabel(i,3);
    y = num2str(ShfLabel(i,2)); y=str2num(y(end));
    vec(i,1) = HI.Assemblies.stats(x,y);
end

% Plot to surface
parc = [lh_labels_Shf_Yeo(:,1)' rh_labels_Shf_Yeo(:,1)'];
nonwall = [2:201 203:402];
toMap = zeros(1,length(unique(parc)));
toMap(nonwall) = vec;
OnSurf  = BoSurfStatMakeParcelData(toMap, SP, parc);
OnSurfS = SurfStatSmooth(OnSurf, SP, 4);
BoSurfStat_calibrate2Views(OnSurfS, SP, ...
            [0.65 0.73 0.3 0.3], [0.65 0.5 0.3 0.3], ...
            1, 2, clim, cmap);
BoSurfStat_calibrate2Views_rh(OnSurfS, SP, ...
            [0.65 0.20 0.3 0.3], [0.65 -0.03 0.3 0.3], ...
            1, 2, clim, cmap);    