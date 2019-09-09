function [] = Project_M4Exec_018_08 ()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This program is an executive function that calls functions from M2 to find 
% tau and SSEs on thermocouple data.
%
% Function Call
% [] = Project_M3Exec_018_08 ()
%
% Input Arguments
% N/A
%
% Output Arguments
% N/A
%
% Assignment Information
%   Assignment:       	M3, Part 3
%   Author:             Brandon Slater, slater16@purdue.edu
%   Team ID:            018-08      
%  	Contributor: 		Name, login@purdue [repeat for each]
%   My contributor(s) helped me:	
%     [ ] understand the assignment expectations without
%         telling me how they will approach it.
%     [ ] understand different ways to think about a solution
%         without helping me plan my solution.
%     [ ] think through the meaning of a specific error or
%         bug present in my code without looking at my code.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tic();
    coolingData = csvread('M3_Data_CoolingTimeHistories.csv'); %Import cooling data
    coolingTemp = coolingData(:,2:end); %Cooling temperature vector
    coolingTime = coolingData(:,1); %Cooling time vector
    
    heatingData = csvread('M3_Data_HeatingTimeHistories.csv'); %Import heating data
    heatingTemp = heatingData(:,2:end); %Heating temperature vector
    heatingTime = heatingData(:,1); %Heating time vector
    
    %Initialization
    taus = zeros(1,100); %units seconds
    tss = zeros(1,100); %units seconds
    yLs = zeros(1,100); %units deg F
    yHs = zeros(1,100); %units deg F
    
     % category 2
%     taus2 = zeros(1,100);
%     tss2 = zeros(1,100);
%     yLs2 = zeros(1,100);
%     yHs2 = zeros(1,100);
    
    %Call M2 UDF to retrieve vector data 
%     for count3 = 1:100
%         if count3 > 50
%          [taus2(count3), tss2(count3), yLs2(count3), yHs2(count3)] = Project_M4Algorithm_018_08(heatingTime, heatingTemp(:,count3 - 50));
%         else
%           [taus2(count3), tss2(count3), yLs2(count3), yHs2(count3)] = Project_M4Algorithm_018_08(coolingTime, coolingTemp(:,count3));
%         end
%     end
    
    %Call M2 UDF to retrieve vector data 
    for row = 1:5
        for col = 1:10
            [tauH, tsH, yLH, yHH] = Project_M4Algorithm_018_08(heatingTime, heatingTemp(:, (row - 1) * 10 + col));
            taus((row - 1) * 20 + col) = tauH;
            tss((row - 1) * 20 + col) = tsH;
            yLs((row - 1) * 20 + col) = yLH;
            yHs((row - 1) * 20 + col) = yHH;
        end
        for col = 11:20
           [tauC, tsC, yLC, yHC] = Project_M4Algorithm_018_08(coolingTime, coolingTemp(:,(row - 1) * 10 + col - 10));
           taus((row - 1) * 20 + col) = tauC;
           tss((row - 1) * 20 + col) = tsC;
           yLs((row - 1) * 20 + col) = yLC;
           yHs((row - 1) * 20 + col) = yHC;
        end
    end
    tauMeans = zeros(1,5);
    tauSTDs = zeros(1,5);
    yLMeansC = zeros(1,5);
    yLMeansH = zeros(1,5);
    TSMeansC = zeros(1,5);
    TSMeansH = zeros(1,5);
    yHMeansC = zeros(1,5);
    tauMeansC = zeros(1,5);
    tauMeansH = zeros(1,5);
    yHMeansH = zeros(1,5);
    
    %Taking means for all data
    for count = 1:5
       tauMeans(count) = mean(taus(1 + 20 * (count - 1) : count * 20));
       yLMeansC(count) = mean(yLs(1 + 20 * (count - 1) + 10: count * 20));
       yLMeansH(count) = mean(yLs(1 + 20 * (count - 1): count * 20 - 10));
       TSMeansC(count) = mean(tss(1 + 20 * (count - 1) + 10: count * 20));
       TSMeansH(count) = mean(tss(1 + 20 * (count - 1): count * 20 - 10));
       yHMeansC(count) = mean(yHs(1 + 20 * (count - 1) + 10: count * 20));
       yHMeansH(count) = mean(yHs(1 + 20 * (count - 1): count * 20 - 10));
       tauSTDs(count) = std(taus(1 + 20 * (count - 1) : count * 20));
       tauMeansC(count) = mean(taus(1 + 20 * (count - 1) + 10: count * 20));
       tauMeansH(count) = mean(taus(1 + 20 * (count - 1) : count * 20 - 10));
    end
    
   disp(tauMeans);
   disp(tauSTDs);
   
   preOutCooling = zeros(50,numel(coolingTime));
%    len = numel(coolingTime);
   
   %Calibrate cooling data using yL, tS, yH, and tau 
   for num = 1:5
        for z = 1:numel(coolingTime)
            if coolingTime(z) < TSMeansC(num)
               preOutCooling(num,z) = yHMeansC(num);
            else
               preOutCooling(num,z) =  yLMeansC(num) + (yHMeansC(num) - yLMeansC(num)) * exp (-(coolingTime(z) - TSMeansC(num)) / tauMeansC(num)); %units deg F
            end
        end
   end
   
   preOutHeating = zeros(5,numel(heatingTime));
   
   %Calibrate heating data using yL, tS, yH, and tau
   for num = 1:5
    for z = 1:numel(heatingTime)
        if heatingTime(z) < TSMeansH(num)
            preOutHeating(num,z) = yLMeansH(num);
        else
            temp = 1 - exp(-(heatingTime(z) - TSMeansH(num)) / tauMeansH(num));
           preOutHeating(num,z) =  yLMeansH(num) + (yHMeansH(num) - yLMeansH(num)) * temp;
        end
     end
   end
   
%    length = len + numel(heatingTime);
   SSETotValues = zeros(20,5); %deg F^2
   SSEValues = zeros(20,5); %deg F^2 
   
   %Calculate SSE
   %faster code to find SSE values
   for num = 1:5
       for p = 1:10
        for count = 1:numel(heatingTime)
            tempA = (preOutHeating(num,count) - heatingTemp(count, p + 10 * (num - 1))) ^ 2;
            SSETotValues(p, num) = SSETotValues(p, num) + tempA;
            tempB = (preOutCooling(num,count) - coolingTemp(count, p + 10 * (num - 1))) ^ 2;
            SSETotValues(p + 10, num) = SSETotValues(p + 10, num) + tempB;  
        end
%         totLen = len + length;
        SSEValues(p ,num) = SSETotValues(p, num) / numel(heatingTime);
        SSEValues(p + 10, num) = SSETotValues(p + 10, num) / numel(coolingTime);
       end
   end
   %unneeded code
    % category 2
%    preValues = zeros(100,numel(heatingTime));
%    for k = 1:100
%        if k <= 50
%            for run = 1:numel(coolingTime)
%               if coolingTime(run) < tss2(k)
%                   preValues(k,run) = yHs2(k);
%               else
%                   preValues(k,run) = yLs2(k) + (yHs2(k) - yLs2(k)) * exp(-(coolingTime(run) - tss2(k)) / taus2(k));
%               end
%            end
%        else
%             for run = 1:numel(heatingTime)
%               if heatingTime(run) < tss2(k)
%                   preValues(k,run) = yLs2(k);
%               else
%                   preValues(k,run) = yLs2(k) + (yHs2(k) - yLs2(k)) * exp(-(heatingTime(run) - tss2(k)) / taus2(k));
%               end
%            end
%        end
%    end
   
%    disp(SSETotValues);
%    disp(SSEValues);
    SSEValuesAvg = zeros(1,5); %SSE Average
    
    %Calculate SSE average - new code
    for k = 1:5
       SSEValuesAvg(k) = mean(SSEValues(:,k)); 
    end
    disp(SSEValuesAvg);
    
%     %Calculate total SSE
% unneed code
%     SSEValuesTot = zeros(1,100);
%     for y = 1:100
%        total = 0;
%        if y > 50
%           for n = 1:numel(heatingTime)
%               total = total + (preValues(y,n) - heatingTemp(n,y - 50)) ^ 2;
%           end
%        else
%            for n = 1:numel(coolingTime)
%                total = total + (preValues(y,n) - coolingTemp(n,y)) ^ 2;
%            end
%        end
%        SSEValuesTot(y) = total;
%     end
%     SSEValues = SSEValuesTot ./ numel(coolingTime);
%     SSEAvg = zeros(1,5);
%     for g = 1:5
%         SSEAvg(g) = (mean(SSEValues(1 + 10 * (g - 1): 10 * g)) + mean(SSEValues(51 + 10 * (g - 1):10 * g + 50))) / 2;
%     end
% %     disp(SSEAvg);
    toc();
    Project_M4Regression_018_08(taus);
end