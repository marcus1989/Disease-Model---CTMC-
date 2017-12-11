%%%%%%%%%%%%%%%%%%%%%%
%% Model Parameter Settings
k_i_1 = 1; % infection rate disease 1
k_i_2 = 0.1; % infection rate disease 2
k_r_1 = 0.5; % recovery rate disease 1
k_r_2 = 0.01; % recover rate disease 2
alpha = 0.2; % synergy of disease 1 & 2: positive effect on infection w/ disease 2, inverse effect on infection w/disease 1
% functional rates f_i1 and f_i2 are modeled by the ODEs in 'disease_model.m'
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initial Species Values
% base state of the system: everyone's susceptible, but no infections are present yet
% numbers represent the fraction of each species
% TODO: should we model different scenarios?
x_I_1 = 0;
x_I_2 = 0;
x_I_12 = 0;
x_S = 1; 
no_species = 4;
%% Other Settings
h = 0.005; % step size: at the moment just use one reasonable value
t_max = 10^2; % end of time
tspan = 0:h:t_max; % time points
filename = 'disease_model';
%% Assignment a)
%% i) ODE
% ode45 is ok. problem seems to be non-stiff!
[t,values] = ode45(@(t,y) disease_model(t, y, k_i_1, k_i_2, k_r_1, k_r_2, alpha), tspan, [x_I_1; x_I_2; x_I_12; x_S], []); % non-stiff, medium accuracy
cur_filename = strcat(filename, '_ode45_h=', num2str(h), '.pdf');
plot_disease_percentage(t, values, cur_filename);
%[t,values] = ode15s(@(t,y) disease_model(t, y, k_i_1, k_i_2, k_r_1, k_r_2, alpha), tspan, [x_I_1; x_I_2; x_I_12; x_S], []); % stiff
%cur_filename = strcat(filename, '_ode15s_h=', num2str(h), '.pdf');
%plot_disease_percentage(t, values, cur_filename);
%% i) CTMC
% 1. define the Q matrix
%tspan=1:0.2:100; 
tend=20;
Q = [-1/alpha*k_i_2 - k_r_1 0 1/alpha* k_i_2 k_r_1; 0 -alpha * k_i_1 - k_r_2 alpha * k_i_1 k_r_2; k_r_2 k_r_1 -k_r_2 - k_r_1 0; k_i_1 k_i_2 0 -k_i_1 - k_i_2];
pi = [x_I_1 x_I_2 x_I_12 x_S];
%no_samples = 100; % number of time samples: we don't need 200 ... 
no_samples = 200;
pop_size = 100000; % number of individuals to simulate, pop size 10000 (too long) better?
%MCMC_y = zeros(pop_size, no_samples); % for each individual one row giving current state for each simulation step
%MCMC_t = zeros(pop_size, no_samples); % for each individual one row giving current time for each simulation step
MCMC_y = zeros(no_samples, 1);
%MCMC_t = zeros(no_samples, 1);
%close; % close current figure
% try time sampling
% take no_samples equally-spaced time values up to max time
%max_time = max(MCMC_t(:, end)); % we just limit max_time by reducing by 100 heuristically
%max_time = max_time - 0.2 * max_time; % get enough samples for later time ..
%t_sample = linspace(0, max_time, no_samples);
t_sample = linspace(0, tend, no_samples);
eps = 0.5;
%for i= 1:no_samples,
y = zeros(pop_size,length(t_sample));
for i= 1:pop_size
%     % for each t: find all observations close in time (tdiff < 0.5)
%     t = t_sample(i);
%     plot_t(i) = t;
%     t_diff = abs(MCMC_t - repmat(t,size(MCMC_t,1),size(MCMC_t,2)));
%     idx = t_diff < 0.5; % all observations we consider have 1 others 0
%     sel_vals = MCMC_y(idx);
%     sel_size = size(sel_vals, 1); % TODO: we should stratify on sample sizes ...
%     disp(t);
%     disp(sel_size);
%     state_freqs = tabulate(sel_vals);
%     freq_result = zeros(1, no_species);
%     freq_states = state_freqs(:, 1);
%     %freq_result(freq_states) = state_freqs(:, 3)/100;
%     %plot_y(i, :) = freq_result;
%     plot_y(i, :) = freq_states;
      y(i,:) = ctmc(pi,Q,t_sample);
      
end

for i=1:200
    density_1(i)=length(find(y(:,i)==1));
    density_2(i)=length(find(y(:,i)==2));
    density_3(i)=length(find(y(:,i)==3));
    density_4(i)=length(find(y(:,i)==4));
end

f = figure;
p=plot( t_sample,density_1,t_sample,density_2,t_sample,density_3,t_sample,density_4);
%stairs(plot_t,plot_y(:, 1:3));
legend('Infected w/ disease 1', 'Infected w/ disease 2', 'Infected w/ both diseases');
print(f, '-dpdf', strcat('disease_model_CTMC_', 't=', num2str(no_samples), '_N=', num2str(pop_size), '.pdf'));
% close;
% plot is ok, but does not show the same result for infection with both
% diseases .. longer timeline necessary?
%%%%
break
%% b)
%%%%%
% Choice: ODEs (ode45)
% Define range of alpha values
alpha_step1 = 0.1;
alpha_step2 = 1;
alpha_step3 = 2;
alpha_range1 = 0:alpha_step1:2;
alpha_range2 = 2:alpha_step2:10;
alpha_range3 = 10:alpha_step3:20;
alpha_range = [alpha_range1(2:end) alpha_range2(2:end) alpha_range3(2:end)];
alpha_size = size(alpha_range);
% higher alpha values -> steady state is reached slower -> need more time
t_max = 200; % end of time
h = 0.1; % reduce time step for performance ...
tspan = 0:h:t_max; % time points
SS_infected = zeros(1, alpha_size(2));
SS_healthy = zeros(1, alpha_size(2));
for i = 1:alpha_size(2),
    alpha = alpha_range(i);
    [t,values] = ode45(@(t,y) disease_model(t, y, k_i_1, k_i_2, k_r_1, k_r_2, alpha), tspan, [x_I_1; x_I_2; x_I_12; x_S], []); % non-stiff, medium accuracy
    max_infected = get_max_infected(values);
    cur_filename = strcat(filename, '_ode45_h=', num2str(h), 'alpha=', num2str(alpha), '.pdf');
    plot_max_infected(t, max_infected, cur_filename); % observable 2
    % TODO: for observable 2: is it the way they meant it? how to validate
    % for different alphas?!
    % for steady state: steady state will be reached at different points in
    % time t depending on the parameter alpha -> need a procedure to
    % identify the time t at which we have steady state ..
    % steady state means that species don't change anymore
    data = values(:, 4); % use ratio of susceptible patients to find steady state
    %t_SS_idx = find_steady_state(data);
    t_SS_idx = find_steady_state_simple(data);
    t_SS = 0; % doesnt matter for the simple SS approach
    steady_state_infected = max_infected(t_SS_idx); % any type of infection
    SS_infected(i) = steady_state_infected;
    steady_state_healthy = 1-steady_state_infected; % inverse relationship ..
    SS_healthy(i) = steady_state_healthy;
    cur_filename = strcat(filename, '_ode45_h=', num2str(h), 'alpha=', num2str(alpha), 't_SS=', num2str(t_SS), '.pdf');
    plot_disease_percentage(t, values, cur_filename);
end
cur_filename = strcat(filename, '_steady_state', '.pdf');
plot_infected_alpha(SS_infected, SS_healthy, alpha_range, cur_filename);
