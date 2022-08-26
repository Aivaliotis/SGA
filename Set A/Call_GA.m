for study_case=[1:14]
disp(study_case)
Testfunctions
rng(0)
params.randdim = problem.nVar;
params.w = 2;               % Intertia Coefficient
params.wmin = 0.01;
params.wdamp = 0.9;
params.c1 = 2;
params.c2 = 2;
params.MaxInteractions = 2000; % Maximum GA Interactions
params.MaxIt = 0;           % Maximum PSO Interactions
params.nPop = 0;             % Particle Population Size (Swarm Size) / (Choose 0 for pure GA)
params.PopSize = 100;          % Individual Population Size (GA Size)  / (PopSize=nPop and MaxInteractions=0 for PSO)
params.CrossPercent = 60;   % Cross Breeding Percentage
params.MutatPercent = 10;   % Mutatuon Percentage
params.ElitPercent = 30;   % Elite population Percentage
params.CrossNum = round(params.CrossPercent/100*params.PopSize);
params.EarlyExit = 0;
params.GAstep = 2000;
if mod(params.CrossNum,2)~=0
params.CrossNum = params.CrossNum - 1;
end
params.MutatNum = round(params.MutatPercent/100*params.PopSize);
params.ElitNum = params.PopSize - params.CrossNum - params.MutatNum;
if mod(params.ElitNum,2)~=0
params.ElitNum = params.ElitNum - 1;
end
disp('GA')
for i=1:params.exenum
    disp([num2str(study_case) ' GA ' num2str(i)])
    [GA(i,study_case).GB,GA(i,study_case).progress ]= SGA_2022(problem,params);
end
end