for study_case=[1:14]
disp(study_case)
Testfunctions
rng(0)
params.w = 2;               % Intertia Coefficient
params.wmin = 0.01;
params.wdamp = 0.9;
params.c1 = 2;
params.c2 = 2;
params.MaxInteractions = 2000; % Maximum GA Interactions
params.MaxIt = 2000;           % Maximum PSO Interactions
params.nPop = 10;             % Particle Population Size (Swarm Size) / (Choose 0 for pure GA)
params.PopSize = 10;          % Individual Population Size (GA Size)  / (PopSize=nPop and MaxInteractions=0 for PSO)
params.CrossPercent = 50;   % Cross Breeding Percentage
params.MutatPercent = 30;   % Mutatuon Percentage
params.ElitPercent = 20;   % Elite population Percentage
params.CrossNum = round(params.CrossPercent/100*params.PopSize);
params.EarlyExit = 0;
params.GAstep = 90;

params.MutatNum = round(params.MutatPercent/100*params.PopSize);
params.ElitNum = params.PopSize - params.CrossNum - params.MutatNum;

for i=1:100
    disp([num2str(study_case) ' PGPHEA ' num2str(i)])
    [PGPHEA(i,study_case).GB,PGPHEA(i,study_case).progress ]= PGPHEA_2022(problem,params);
end
end
