close all;

GTrainDICParam = bsCreateGTrainDICParam(...
        'csr', ...
        'title', 'HF', ...
        'feature_reduction', 1, ...
        'normalizationMode', 'feat_max_min', ...
        'isAddTimeInfo', 1, ...
        'isAddLocInfo', 1, ...
        'sizeAtom', 90, ...
        'sparsity', 5, ...
        'iterNum', 10, ...
        'nAtom', 500, ...
        'isRebuild', 1);
sparsity = 1;


nRes = length(methods);

invResults{nRes + 1} = bsPreRebuildByCSRWithWholeProcess(GInvParam, timeLine, wellLogs, ...
    methods{nRes}, invResults{nRes}, sprintf('%s-高分辨率', methods{nRes}.name), ...
    'trainNum', length(wellLogs), ...
    'gamma', 1, ...
    'mode', 'low_high', ...
    'lowCut', 80/500, ...
    'highCut', 150/500, ...
    'wellFiltCoef', GInvParam.initModel.filtCoef, ...
    'GTrainDICParam', GTrainDICParam, ...
    'sparsity', sparsity);

[newInvResults, GInvParam, newWellLogs] = bsPreGetOtherAttributesByInvResults(invResults, GInvParam, wellLogs);

GShowProfileParam.showLeftTrNumByWells = 500;
GShowProfileParam.showRightTrNumByWells = 500;
GShowProfileParam.range.seismic = [-5 5];
GShowProfileParam.range.vp = [3700 4400];
GShowProfileParam.range.vs = [1850 2450];
GShowProfileParam.range.rho = [2.35 2.55];
GShowProfileParam.range.vpvs_ratio = [1.8 2];
GShowProfileParam.range.possion = [0.295 0.35];
GShowProfileParam.colormap.allTheSame = bsGetColormap('original');
GShowProfileParam.isColorReverse = 1;
GShowProfileParam.showWellFiltCoef = 0.6;

GShowProfileParam.scaleFactor = 2;
GShowProfileParam.showWellOffset = 2;

GShowProfileParam.showPartVert.upTime = 40;
GShowProfileParam.showPartVert.downTime = 70;
GShowProfileParam.showPartVert.mode = 'up_down_time';
GShowProfileParam.showPartVert.mode = 'off';

% GShowProfileParam.showPartVert.mode = 'in_2_horizons';
% GShowProfileParam.showPartVert.horizonIds = [1, 3];

GShowProfileParam.isShowHorizon = 1;

% reOrganizedResults = bsReOrganizeInvResults(NLMResults);

for i = 1 : length(newInvResults)
    newInvResults{i}.showFiltCoef = 1;
end
% reOrganizedResults = bsReOrganizeInvResults(newInvResults);

bsShowPreInvProfiles(GInvParam, GShowProfileParam, newInvResults, newWellLogs, timeLine);
set(gcf, 'position', [ 243         107        1677         670]);

% wellName = 'LN2-4-6';
% wellName = 'LN320';
% id = bsGetIdsFromWelllogs(wellLogs, {wellName});
% % id = 1;
% time = bsGetHorizonTime(timeLine{2}, wellLogs{id}.inline, wellLogs{id}.crossline);
% vp = bsGetWellData(GInvParam, wellLogs(id), time, 2, 1);
% vs = bsGetWellData(GInvParam, wellLogs(id), time, 3, 1);
% vpsvs = vp ./ vs;
% 
% index = find(inIds==wellLogs{id}.inline & crossIds == wellLogs{id}.crossline);
% figure;
% sampNum = GInvParam.upNum + GInvParam.downNum;

% plot(reOrganizedResults{5}.data{2}(:, index), 1:sampNum, 'r-.', 'linewidth', 2);hold on;
% plot(reOrganizedResults{5}.data{4}(:, index), 1:sampNum, 'r', 'linewidth', 2);hold on;
% 
% plot(vpsvs, 1:sampNum, 'k', 'linewidth', 2);
% plot(linspace(1.7, 2, sampNum), GInvParam.upNum*ones(1,sampNum), 'b', 'linewidth', 2);
% 
% 
% legend('反演结果', '反演结果高分辨率', '实际曲线', '层位');
% 
% title(wellName);
% xlabel('VpVs Ratio');
% ylabel('采样点');
% set(gca, 'ydir', 'reverse');
% 
% bsShowFFTResultsComparison(GInvParam.dt, [reOrganizedResults{5}.data{2}(:, index), ...
%     reOrganizedResults{5}.data{4}(:, index), vpsvs], {'反演结果', '反演结果高分辨率', '实际曲线'});
