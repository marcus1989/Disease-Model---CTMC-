function output = disease_model(t, y, k_i_1, k_i_2, k_r_1, k_r_2, alpha)
% input to ODE: time t, species (variables) y (vector), further params ..
% species: I_1, I_2, I_12, S
x_I_1 = y(1); % infected with disease 1 (susceptible to disease 2)
x_I_2 = y(2); % infected with disease 2 (susceptible to disease 1)
x_I_12 = y(3); % infected with disease 1 and 2 (not susceptible)
x_S = y(4); % susceptible to both diseases
y_I_1 = x_S * k_i_1 - x_I_1 * k_r_1 - x_I_1 * (1/alpha) * k_i_2 + x_I_12 * k_r_2;
y_I_2 = x_S * k_i_2 - x_I_2 * k_r_2 - x_I_2 * alpha * k_i_1 + x_I_12 * k_r_1; 
y_I_12 = x_I_1 * (1/alpha) * k_i_2 + x_I_2 * alpha * k_i_1 - x_I_12 * (k_r_1 + k_r_2);
y_S = -x_S * k_i_1 - x_S * k_i_2 + x_I_1 * k_r_1 + x_I_2 * k_r_2;
output = [y_I_1; y_I_2; y_I_12; y_S];
end