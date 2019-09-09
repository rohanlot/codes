function [tau, ts, yL, yH,tsLoc] = Project_M4Algorithm_018_08 (timeData, tempData)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This program models predicts the time constant, ts, yL, and yH of a 
% thermocouple data graph
%
% Function Call
% [tau, ts, yL, yH,tsLoc] = Project_M2Algorithm2_018_08 (fileName)
%
% Input Arguments
% fileName 
% This is the name of the csv file imported 
%
% Output Arguments
% tau = time constant
% ts = the time when the slope begins
% yL = minimum y value (temp)
% yH = maximum y value (temp)
% tsLoc = position in time vector of where ts is
%
% Assignment Information
%   Assignment:       	M2, Part 1, Algorithm 2
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

%     data = csvread(fileName);
%     timeData = data(:,1);
%     tempData = data(:,2);

    slope = 0; %slope gradient
    preSlope = 0; %flat 'area' before slope gradient
    SD = 0; %standard deviation
    step = 50; %increment
    count = step; %iteration counter
    change = false;
    
    %find all the outputs through while loop with the condition that the
    %original slope (the flat area preceding the gradient) added with 3
    %standard deviations is smaller than the main slope and when change 
    %becomes true
    
    %speedUp = 1;
    while (round(abs(slope)) <= round(abs(preSlope)) + 3 * SD || change == false)
       
        preTimes = timeData(1:count - 1); %increment time by step-1
        preTemp = tempData(1:count - 1); %increment temp by step-1
        coefs = polyfit(preTimes, preTemp,1); %find the slope and y-intercept
        preSlope = coefs(1); 
        
        SD = std(preTemp); %standard deviation
        times = timeData(count: count + step); %increment time by step
        temps = tempData(count: count + step); %increment temp by step
        coefs = polyfit(times,temps,1); %calculate slope and y intercept
        slope = coefs(1);
        count = count + step;
        % category 1
        if slope > 0 %when heating
             % category 3
            if mean(temps) > (mean(preTemp) + SD) 
                change = true; %change becomes true if the mean of temperature from 
                               %the second increment is larger than the
                               %first increment added with standard deviation
            else
                change = false;
            end
        end
         % category 3
        if slope < 0 %when cooling
           if mean(temps) < (mean(preTemp) - SD)
               change = true;
           else
               change = false;
           end
        end
    end
    ts = timeData(count - step / 2); %ts is assumed to be the middle point when the slope
                                     %of the graph starts to exceed the threshold
    tsLoc = count - step / 2; %position in vector of where ts is 
    a = 0;
     for runStep = count - step: count - 2
         coefs = polyfit(timeData(runStep:count), tempData(runStep:count), 1);
         SD1 = std(tempData(runStep:count));
         if coefs(1) > SD1
             if a == 0
                 ts = timeData(runStep);
                 tsLoc = timeData(runStep);
                 a = 1;
             end
         end
     end
    yL = mean(tempData(1:count - step));
    step = 50; %increment
    oldCount = count; 
    loc = 0; %time location of yTau
    % category 1
    for x = count:step:numel(timeData) - step %finding when the slope becomes zero again
        coefs = polyfit(timeData(x:x+step),tempData(x:x+step),1);
        slope = coefs(1);
        if slope < 0.3
            loc = x;
        end
    end
    yH = mean(tempData(loc + step:end));
    if yL > yH
       temp = yL;
       yL = yH;
       yH = temp;
       yTau = -0.63 * (yH - yL) + yH; 
    else
        yTau = 0.63 * (yH - yL) + yL;
    end
    %yTau = abs(0.63 * (yH - yL)); %value of y during Tau seconds
    
%     if yH < yL %Cooling case, exchanging yH and yL plus the calculation of 
%                %yTau depending on cooling or heating
%         yTau = yL - yTau;
%         temp = yH;
%         yH = yL;
%         yL = temp;
%     else 
%         yTau = yL + yTau;
%     end
% category 1
    spot = oldCount - step / 2;
    min = abs(tempData(spot) - yTau);
    loc = spot;
    for spot = (oldCount - step / 2) : numel(timeData) %find approximate of
                                                       %where tau is in
                                                       %time
        if abs(tempData(spot) - yTau) <= min
            min = abs(tempData(spot) - yTau);
            loc = spot;
        end
    end
    tau = timeData(loc) - ts;
end