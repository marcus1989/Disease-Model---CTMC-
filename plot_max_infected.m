function [] = plot_max_infected(t, max_infected, filename)
% plots the maximum percentage of infected people per time step
f = figure;
plot(t, max_infected, '-');
title('Epidemic Model of Two Diseases');
xlabel('Time t');
ylabel('Population percentage');
legend('Maximum Infection Ratio');
print(f, '-dpdf', filename);
close; % close current figure
end

