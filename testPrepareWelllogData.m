close all;
clc;
% clear;

% the base path of anyue workarea
basePath = 'E:\data\seismic data\lunan\';
% upLinePath = [basePath, 'horizon\T1_T_int.txt'];
% centerLinePath = [basePath, 'horizon\T1_B_int.TXT'];
% downLinePath = [basePath, 'horizon\TIII_int.TXT'];
% centerLinePath = 'E:\data\seismic data\lunan\20200310data\TI_B_smooth.txt';
% upLine = importdata(upLinePath);    upLine = upLine.data;
% centerLine = importdata(centerLinePath);  centerLine = centerLine.data;
% downLine = importdata(downLinePath);      downLine = downLine.data;
% 
% timeLine = cell(1, 3);
% timeLine{1} = upLine;
centerLine = importdata('E:\data\seismic data\lunan\20200337\zhongpintai_t1_t2_t3_horizon.txt');  
centerLine = centerLine.data;
timeLine{1} = centerLine(:, [1,2,3]);
timeLine{2} = centerLine(:, [1,2,4]);
timeLine{3} = centerLine(:, [1,2,5]);
% timeLine{3} = downLine;
% save timeLine;

% allInfo = {
% 'LG1-1', 827, 1820;
% 'LG1-2CH', 976, 1917;
% 'LG1-6', 1012, 2068;
% 'LG1-7', 1035, 1875;
% 'LG202', 859, 1909;
% LN12         15264950.55 4594406.77       m      996    1852;
% LN18         15267461.00 4591224.50       m      841    1983;
% 'LN2-1-17H', 1215, 1978;
% 'LN2-2-6', 1198, 2079;
% LN2-33-H6    15265607.80 4598094.40       m     1181    1878;
% LN2-33-H7    15267128.80 4598090.50       m     1184    1954;
% 'LN2-4-6', 1148, 2080;
% 'LN2-5-14', 1154, 1865;
% 'LN3_2_13X', 1167, 2255;
% 'LN3-2-15X', 1190, 2194;
% 'LN3-3-10', 1132, 2208;
% LN3_3_17H    15272964.40 4594935.70       m     1036    2252;
% LN3-H11      15273833.80 4596672.10       m     1125    2292;
% 'LN30', 1017, 2301;
% LN33         15266253.00 4595186.90       m     1037    1916;
% 'LN33CH', 1083, 1919;
% 'LN203', 1145, 2016;
% 'LN206', 1175, 1783;
% LN211        15270339.00 4594509.00       m     1011    2121;
% 'LN302H', 987, 2311;
% 'LN320', 1073, 2238;
% 'LN41'         1062    2085;   
% 'LN887'        887    2250;   
% };

wellMap = importdata('E:\data\seismic data\lunan\20200327\hrsWellMapTable.txt');
nWell = size(wellMap.data, 1);
allInfo = cell(nWell, 3);
for i = 1 : nWell
    allInfo{i, 1} = wellMap.textdata{i+2};
    allInfo{i, 2} = wellMap.data(i, 3);
    allInfo{i, 3} = wellMap.data(i, 4);
end

% the number of wells
nWell = size(allInfo, 1);
wellLogs = {};
dt = 1;

for i = 1 : nWell
%     fileName = [basePath, sprintf('E:\data\seismic data\lunan\20200315timelog/%s_logs.txt', allInfo{i, 1})];
    fileName = sprintf('E:/data/seismic data/lunan/20200337/%s_logs.txt', allInfo{i, 1});
    t.X = allInfo{i, 2};
    t.Y = allInfo{i, 3};
    t.inline = allInfo{i, 2};
    t.crossline = allInfo{i, 3};
    t.name = allInfo{i, 1};
    
    time = bsGetHorizonTime(timeLine{1}, t.inline, t.crossline, 0);
    
    try
        wellData = bsHandelWellData(fileName, time-180, dt);
    catch
        continue;
    end
    
    time = bsGetHorizonTime(timeLine{2}, t.inline, t.crossline, 0);
    [~, index] = min(abs(wellData(:, 5) - time));
    t.targetDepth = wellData(index, 1);
    t.wellLog = wellData;
%     wellLogs{i} = t;
    
    wellLogs = [wellLogs, t];
end

save wellLogs wellLogs;
save smoothTimeLine timeLine;
% save timeLine timeLine;




