clear 
close all

PSO_trials
GA_trials
SGA_trials
PGPHEA_trials
HPSOM_trials

filename = 'TSP_fin1.mat';
save (filename, 'PSO_out' ,'GA_out'  ,'SGA_out' ,'PGPHEA_out' ,'HPSOM_out') %%Save variables