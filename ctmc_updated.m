function y=ctmc_updated(pi, Q, tspan)
%CTMC with length n
%pi: initial distribution
%Q: generator matrix
%N: number of individuals to simulate
% output: time vector and state vector
y= zeros(length(tspan),1);
tend = tspan(end);
t=0;
discrete_states = size(pi);
discrete_states = 1:discrete_states(2);
states = pi;
plot_y = pi;
%y=randsample(discrete_states,1,true,pi); % define initial state
x=randsample(discrete_states,1,true,pi);
k=1;
nextOutput=tspan(k);
while t<tend
    i=x;
    %i=y(k);
    q=-Q(i,i);
    if q==0 % cant transition?! 
        break
    else
        s = -log(rand)/q; % waiting time
        while t+s>nextOutput && nextOutput<tend
            y(k) = x;
            k=k+1;
            nextOutput=tspan(k);
            %disp(y');
        end
        t = t+s;
        p = Q(i,:);
        p(i) = 0;
        p = p/sum(p);
        %y=[y randsample(times(states, p),4,true,p)];
        x = randsample(discrete_states, 1, true, p); % next state
        % 
    end
end



%%%%%%%%%%%%