clc;
clear all;
close all;

rangeInline = [370 1470];
rangeCrossline = [220 1060];

load wellLogs;
% load timeLine.mat;
load smoothTimeLine.mat;
% load newTimeLine.mat;

% basepath of the current work area
basePath = 'E:\data\seismic data\lunan/';
% basePath = '/share/home/stepbystep/seismic_data/lunan/';

% segy information
GSegyInfo = bsCreateGSegyInfo();
GSegyInfo.t0 = 3000;
GSegyInfo.inlineId = 189;
GSegyInfo.crosslineId = 193;

%% set the options for showing the results
GPlotParam = bsGetDefaultPlotSet();
GShowProfileParam = bsCreateGShowProfileParam();
GShowProfileParam.plotParam = GPlotParam;
GShowProfileParam.showWellOffset = 5;
GShowProfileParam.showWellFiltCoef = 0.4;
GShowProfileParam.plotParam.fontsize = 12;
GShowProfileParam.plotParam.fontname = '宋体';

%% set the options for inversion
%% segy information of initial model 
GInvParam = bsCreateGInvParam('prestack');
GInvParam.initModel.filtCoef = 0.12;
GInvParam.initModel.mode = 'filter_from_true_log';

% 初始模型
GInvParam.initModel.mode = 'segy';
GInvParam.initModel.vp.fileName = [basePath, 'modelwyj/Export_Strata_Model_as_Volume0330_P-wave.sgy'];
GInvParam.initModel.vp.segyInfo = bsSetFields(GSegyInfo, {'t0', 3400; 'inlineId', 189; 'crosslineId', 193});
GInvParam.initModel.vs.fileName = [basePath, 'modelwyj/math_0328model_s_wave.sgy'];
GInvParam.initModel.vs.segyInfo = bsSetFields(GSegyInfo, {'t0', 3400; 'inlineId', 181; 'crosslineId', 185});
GInvParam.initModel.rho.fileName = [basePath, 'modelwyj/Export_Strata_Model_as_Volume0330_Density.sgy'];
GInvParam.initModel.rho.segyInfo = bsSetFields(GSegyInfo, {'t0', 3400; 'inlineId', 189; 'crosslineId', 193});
% segy information of poststack file
GInvParam.postSeisData.segyInfo = GSegyInfo;
GInvParam.postSeisData.fileName = sprintf('%s/seismic/stack_org_1ms.sgy', basePath);


% segy information of prestack file
GInvParam.preSeisData.mode = 'offset_one_file';
% GInvParam.preSeisData.fileName = 'E:\data\seismic data\lunan\lunan.prj\seismic.dir\radon_1ms.sgy';
GInvParam.preSeisData.fileName = 'E:\data\seismic data\lunan\seismic\trace_resample_1ms.sgy';
% GInvParam.preSeisData.fileName = [basePath, 'seismic/radon_1ms.sgy'];
GInvParam.preSeisData.segyInfo = GSegyInfo;


% some other information
GInvParam.modelSavePath = [basePath, 'inversion_results/'];
GInvParam.dt = 1;                           
GInvParam.upNum = 80;    
GInvParam.downNum = 70;    

GInvParam.maxAngle = 40;
GInvParam.angleTrNum = 7;
GInvParam.oldSuperTrNum = 9;
GInvParam.newSuperTrNum = 9;

% GInvParam.bound.mode = 'based_on_init';
GInvParam.bound.mode = 'off';
GInvParam.indexInWellData.depth = 1;
GInvParam.indexInWellData.vp = 2;
GInvParam.indexInWellData.vs = 3;
GInvParam.indexInWellData.rho = 4;
GInvParam.indexInWellData.time = 5;

GInvParam.usedTimeLineId = 2;
GInvParam.depth2time.expandNum = 200;
GInvParam.depth2time.isShowCompare = 1;
GInvParam.depth2time.showCompareNum = 20;
GInvParam.depth2time.searchOffsetNum = 0;
GInvParam.isScale = 0;

initModel = GInvParam.initModel;
sampNum = GInvParam.upNum + GInvParam.downNum;

% for id = [22]
%     wellInfo = wellLogs{id};
%     time = bsGetHorizonTime(timeLine{1}, wellInfo.inline, wellInfo.crossline, 0);
%     startTime = time - GInvParam.upNum * GInvParam.dt;
%     
%     initLog = bsReadMultiSegyFiles(...
%                 [initModel.vp, initModel.vs, initModel.rho], ...
%                 wellInfo.inline, wellInfo.crossline, startTime, sampNum, GInvParam.dt);
%             
% %     initLog = wellLogs{15}.wellLog(:, [2:4]);
%     wellData = wellInfo.wellLog;
%     stime = wellData(end, GInvParam.indexInWellData.time);
%     
%     ss = floor((stime - startTime)/GInvParam.dt);
%     n2 = sampNum - ss;
%     
%     n1 = size(wellData, 1);
%     newData = zeros(n1+n2, size(wellData, 2));
%     newData(1:n1, :) = wellData;
%     
%     for i = 1 : n2
%         newData(n1+i, 2:4) = initLog(ss+i, :);
%         newData(n1+i, 5) = newData(n1+i-1, 5) + GInvParam.dt;
%     end
%     
%     wellLogs{id}.wellLog = newData;
% end

% this function will also generate a new wavelet in GInvParam;
% load wavelet.mat;
% GInvParam.wavelet = -wavelet;
% wellData = wellLogs{15}.wellLog;
% time = wellData(end, GInvParam.indexInWellData.time);
% [~, index] = min(abs(time - wellLogs{14}.wellLog(end, GInvParam.indexInWellData.time)));
% num = size(wellLogs{14}.wellLog, 1) - index + 1;
% start = size(wellData, 1);
% wellData = [wellData; wellLogs{14}.wellLog(index+1:end, :)];
% 
% for i = start+1 : size(wellLogs{15}.wellLog, 1)
%     
%     wellData(i, GInvParam.indexInWellData.time) ...
%         = wellData(i, GInvParam.indexInWellData.time) + GInvParam.dt;
%     wellData(i, GInvParam.indexInWellData.depth) ...
%         = wellData(i, GInvParam.indexInWellData.depth) + GInvParam.dt*wellData(i, GInvParam.indexInWellData.vp)*0.5;
% end
% wellLogs{15}.wellLog = wellData;
% wellLogs([6, 11]) = [];
[GInvParam, wellLogs, wavelet] = bsDepth2Time(GInvParam, timeLine, wellLogs, 'ricker');

% GInvParam.wavelet = wavelet * 5;

%% set the options for training dictionary
trainNum = 24;
sizeAtom = 90;
nAtom = 2400;

train_ids = randperm(length(wellLogs), trainNum);
blind_ids = setdiff(1:length(wellLogs), train_ids);

% SSR dictionary
GTrainSSR = bsCreateGTrainDICParam(...
    'ssr', ...
    'sizeAtom', sizeAtom, ...
    'nAtom', nAtom, ...
    'filtCoef', GShowProfileParam.showWellFiltCoef);
% trainNum = length(trainWelllogs);
[DIC, train_ids] = bsTrainDics(GTrainSSR, wellLogs, train_ids, ...
    [   GInvParam.indexInWellData.vp, ...
        GInvParam.indexInWellData.vs, ...
        GInvParam.indexInWellData.rho]);

GSSRSparseParam = bsCreateGSparseInvParam(DIC, GTrainSSR);

% CSR dictionary
GTrainCSR = bsCreateGTrainDICParam(...
    'csr', ...
    'normalizationMode', 'whole_data_max_min', ...
    'sizeAtom', sizeAtom, ...
    'nAtom', nAtom, ...
    'filtCoef', GShowProfileParam.showWellFiltCoef);
% trainNum = length(trainWelllogs);
[MDIC, train_ids, rangeCoef] = bsTrainDics(GTrainCSR, wellLogs, train_ids, ...
    [   GInvParam.indexInWellData.vp, ...
        GInvParam.indexInWellData.vs, ...
        GInvParam.indexInWellData.rho]);

GCSRSparseParam = bsCreateGSparseInvParam(MDIC, GTrainCSR, 'rangeCoef', rangeCoef);


