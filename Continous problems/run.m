clear
close all

filename = [datestr(now,'dd_mm_yyyy_HH_MM') 'results.mat'];
    
params.ShowIterInfo = 0; % Flag for Showing Iteration Information
params.SelMethod = 1;       % Breeding Method
params.CrossMethod = 1;     % Cross Breeding Method
params.randdim = 1;
params.VelCoe = 0.5;

Call_PSO
Call_GA
Call_SGA
Call_PGPHEA
Call_HPSOM


save(filename, 'PSO', 'GA', 'SGA', 'PGPHEA', 'HPSOM') %% save output
