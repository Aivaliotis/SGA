for study_case=(1:9)
    rng('default')
    disp(['PSO Case: ' num2str(study_case)])
    Testfunctions
    params.ShowIterInfo = 0; % Flag for Showing Iteration Information
    params.SelMethod = 1;       % Breeding Method
    params.CrossMethod = 1;     % Cross Breeding Method
    params.w = 1;               % Intertia CoefficientP
    params.wmin = 0.4;
    params.wdamp=0.9;
    params.c1 = 2;
    params.c2 = 2;
    params.MaxInteractions = 2000; % Maximum GA Interactions
    params.MaxIt = 2000;           % Maximum PSO Interactions
    params.nPop = 20;             % Particle Population Size (Swarm Size) / (Choose 0 for pure GA)
    params.PopSize = 20;          % Individual Population Size (GA Size)  / (PopSize=nPop and MaxInteractions=MaxIt for PSO)
    params.CrossPercent = 00;   % Cross Breeding Percentage
    params.MutatPercent = 00;   % Mutatuon Percentage
    params.ElitPercent = 0;   % Elite population Percentage
    params.CrossNum = round(params.CrossPercent/100*params.PopSize); 
    params.EarlyExit = 0;
    if mod(params.CrossNum,2)~=0
        params.CrossNum = params.CrossNum - 1; 
    end
    params.MutatNum = round(params.MutatPercent/100*params.PopSize);
    params.ElitNum = params.PopSize - params.CrossNum - params.MutatNum;
    if mod(params.ElitNum,2)~=0
        params.ElitNum = params.ElitNum - 1; 
    end
    params.MaxIt = 2000;           % Maximum PSO Interactions
    params.MaxInteractions = 2000; % Maximum GA Interactions
    params.nPop = 20;             % Particle Population Size (Swarm Size) / (Choose 0 for pure GA)
    params.PopSize = 20;          % Individual Population Size (GA Size)  / (PopSize=nPop and MaxInteractions=0 for PSO)
    params.GAstep = 1;
    for k=1:1
    [PSO_out(study_case,k),it(k).progress]=SGA(problem,params);
    end
progress(study_case,:)=it;
end
