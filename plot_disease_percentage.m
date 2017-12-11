function [] = plot_disease_percentage(t, values, filename)
% plots the percentage of infected (disease 1, disease 2, both)
f = figure;
plot(t, values(:, 1), '-', t, values(:,2), '--', t, values(:, 3), ':'); %, t, values(:, 4), '-.');
title('Epidemic Model of Two Diseases');
xlabel('Time t');
ylabel('Population percentage');
legend('Infected w/ disease 1', 'Infected w/ disease 2', 'Infected w/ both diseases'); %, 'Susceptible');
print(f, '-dpdf', filename);
close; % close current figure

end

