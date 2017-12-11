function [] = plot_infected_alpha(SS_infected, SS_healthy, alpha_range, filename)
% for each alpha value, plots the ratio of infected and healthy individuals
% in the steady state
f = figure;
plot(alpha_range, SS_infected, '-', alpha_range, SS_healthy, '--');
title('Steady State Results');
xlabel('Alpha');
ylabel('Population percentage');
legend('Infected Ratio (SS)', 'Healthy Ratio (SS)');
print(f, '-dpdf', filename);
close; % close current figure
end

