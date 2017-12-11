function t_SS = find_steady_state_simple(data)
% assumes that the time interval is chosen such that we reach the steady
% state
% in this case: just take last measurement as representative for SS
t_SS = size(data);
t_SS = t_SS(1);
end

