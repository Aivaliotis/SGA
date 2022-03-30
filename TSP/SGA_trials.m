for study_case=[1:9]
    rng('default')
    disp(['SGA Case: ' num2str(study_case)])
    Testfunctions
    params.ShowIterInfo = 0; % Flag for Showing Iteration Information
    params.SelMethod = 1;       % Breeding Method
    params.CrossMethod = 1;     % Cross Breeding Method
    params.w = 0.01;               % Intertia Coefficient
    params.wmin = 0.01;
    params.wdamp=0.01;
    params.c1 = 2;
    params.c2 = 2;
    params.MaxInteractions = 2000; % Maximum GA Interactions
    params.MaxIt = 5;           % Maximum PSO Interactions
    params.nPop = 5;             % Particle Population Size (Swarm Size) / (Choose 0 for pure GA)
    params.PopSize = 20;          % Individual Population Size (GA Size)  / (PopSize=nPop and MaxInteractions=MaxIt for PSO)
    params.CrossPercent = 50;   % Cross Breeding Percentage
    params.MutatPercent = 30;   % Mutatuon Percentage
    params.ElitPercent = 100 - params.CrossPercent - params.MutatPercent;   % Elite population Percentage
    params.CrossNum = round(params.CrossPercent/100*params.PopSize); 
    params.GAstep = 2;
    params.EarlyExit = 0;
    if mod(params.CrossNum,2)~=0
        params.CrossNum = params.CrossNum - 1; 
    end
    params.MutatNum = round(params.MutatPercent/100*params.PopSize);
    params.ElitNum = params.PopSize - params.CrossNum - params.MutatNum;
    if mod(params.ElitNum,2)~=0
        params.ElitNum = params.ElitNum - 1; 
    end

    for k=1:1
        [SGA_out(study_case,k),it(k).progress]=SGA(problem,params);
    end

end