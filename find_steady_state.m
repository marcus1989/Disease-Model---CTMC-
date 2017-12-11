function [t_SS] = find_steady_state(data)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

%data = [0 0 0 40 70 65 59 50 38 30 32 33 30 33 37 19 0 0 0 41 73 58 43 34 25 39 33 38 34 31 35 38 19 0];
difs = abs(diff(data)); % differences between consecutive elements
% Use sliding window to find windows of consecutive elements below threshold
% 
steady = nlfilter(difs, [1, 10], @(x)all(x <= 0.5)); %  window size 5: all values need to be less or equal to 10
% Find where steady state starts (1) and ends (-1) ..
% doesn't work somehow TODO
start = diff(steady);
% Return indices of starting steady state
ind = find(start == 1);
t_SS = ind(1); % start of steady state
end

