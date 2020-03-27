clear;
close all;

load wellLogs.mat;
t1 = load('LG202.txt');
t2 = importdata('E:\data\seismic data\lunan\20200306logdata\LG202_logs.txt', ' ', 17);
t2 = t2.data;

% figure;
time = 3850;
[~, index] = min(abs(time - t1(:, 1)));
vp1 = t1(index:end, [1, 3]);

[~, index] = min(abs(time - t2(:, 3)));
vp2 = t2(index:end, [3, 5]);

t3 = wellLogs{4}.wellLog;
[~, index] = min(abs(time - t3(:, 5)));
vp3 = t3(index:end, [5, 2]);

figure;
plot(vp1(:, 1), vp1(:, 2), 'r'); hold on;
plot(vp2(:, 1), vp2(:, 2), 'k');
plot(vp3(:, 1), vp3(:, 2), 'b');
legend('王老师采样', '原始数据', '厍斌采样');
