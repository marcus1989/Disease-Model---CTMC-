function max_infected = get_max_infected(values)
% gets the maximum number of infected people with any disease for each
% point in time
  %  I_1 = values(:,1);
  %  I_2 = values(:, 2);
  %  I_12 = values(:, 3);
  %  total1 = I_1 + I_12;
  %  total2 = I_2 + I_12;
  S = values(:, 4);
  infected = 1 -S; % ratio of infected people (any disease)
  val_size = size(values, 1);
  max_infected = zeros(1, val_size);
  for i = 1:val_size, 
      max_val = max(infected(1:i)); % compute step-wise maximum
      max_infected(i) = max_val;
  end   
end

