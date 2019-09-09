function [] = Project_M4Regression_018_08(taus)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This program models a regression model for all 100 tau values against 
% the price of the thermocouple. 
%
% Function Call
% function [] = Project_M3Regression_018_08 (taus) 
%
% Input Arguments
% taus 
% This is a vector for all 100 taus 
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

tauPrice = zeros(1,100); %vector initialization

price = 15.83; %Starting at FOS-1

%Vector for prices of FOS-1 to FOS-5
for k = 1:100
   tauPrice(k) = price; %units dollars
   if k == 20
      price = 8.52; %units dollars
   end
   if k == 40
      price = 3.5; %units dollars
   end
   if k == 60
       price = 2.03; %units dollars
   end
   if k == 80
      price = 0.63;  %units dollars
   end
end

%sorting tau in increasing order per FOS
for i = 1:5
    taus(i * 20 - 19:i*20) = sort(taus(i * 20 - 19:i*20));
end

%plotting tau and the non-linear regression
plot(taus, tauPrice, "*k");
hold on;
grid on;
tauPriceLog = log10(tauPrice);

coefs = polyfit(taus, tauPriceLog, 1);
preVals = polyval(coefs, taus);
SSE = sum((tauPriceLog - preVals) .^ 2); %SSE $^2
SST = sum((mean(tauPriceLog) - tauPriceLog).^2); %SST $^2
R2 = 1 - SSE / SST; %R^2 value

disp(R2);
disp(SST); %$^2
disp(SSE); %$^2

B = 10 ^ coefs(2);
M = coefs(1);

genValues = B * 10 .^ (M .* taus);

title('Non-linear regression of tau values against price')
ylabel('Price ($)')
xlabel('Tau (s)')
legend("Raw data", "Logarithmic")
axis([0 2 0 18])
str = sprintf("price ($) = %.3f * e^{%.3f * t (sec)}", B, M);
text(1, 10, str, 'FontSize', 10);
grid off
end