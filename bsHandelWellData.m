function [wellData] = bsHandelWellData(fileName, t0, dt)
    tmp = importdata(fileName, ' ', 18);
    tmp = tmp.data;
    depthIndex = 1;
    rhoIndex = 2;
    pImpIndex = 4;
    sImpIndex = 6;
    timeIndex = 3;
    dataIndex = [depthIndex, pImpIndex, sImpIndex, rhoIndex, timeIndex];
    
    data = tmp(:, dataIndex);
%     data(:, 2) = data(:, 2) .* data(:, 3);
    
    [~, index] = min(abs(data(:, 5) - t0));
    data = data(index+1:end, :);
    
    nzIndexs = zeros(2, 5);
    
    for i = 1 : 5
        nzs = find(data(:, i) ~= -999.2500);
        nzIndexs(1, i) = min(nzs);
        nzIndexs(2, i) = max(nzs);
    end
    
    spos = max(nzIndexs(1, :));
    epos = min(nzIndexs(2, :));
    
%     wellData = data(spos:epos, :);
    
    if (data(1, 2) < 1000)
        data(:, 2) = 1 ./ data(:, 2) * 0.3048 / 1e-6;
    end
    
    data(:, 3) = data(:, 2) ./ data(:, 3);
    wellData = bsResampleWellData(data, 2:4, 2, 1, 5, dt);
    
end