% clear
% close all

kappa=0;

params.exenum = 1;
params.ShowIterInfo = 0; % Flag for Showing Iteration Information
params.SelMethod = 1;       % Breeding Method
params.CrossMethod = 1;     % Cross Breeding Method
params.VelCoe = 0.5;
Call_PSO
Call_GA
Call_SGA
Call_PGPHEA
Call_HPSOM

createplot