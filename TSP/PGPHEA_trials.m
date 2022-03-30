for study_case=(1:9)
    rng('default')
    disp(['PGPHEA Case: ' num2str(study_case)])
    Testfunctions
    params.ShowIterInfo = 0; % Flag for Showing Iteration Information
    params.SelMethod = 1;       % Breeding Method
    params.CrossMethod = 1;     % Cross Breeding Method
    params.MaxIt = 2000;           % Maximum PSO Interactions
    params.w = 1;               % Intertia Coefficient
    params.wmin=0.01;
    params.c1=2;
    params.c2=2;
    params.MaxInteractions = 2000; % Maximum GA Interactions
    params.nPop = 10;             % Particle Population Size (Swarm Size) / (Choose 0 for pure GA)
    params.PopSize = 10;          % Individual Population Size (GA Size)  / (PopSize=nPop and MaxInteractions=MaxIt for PSO)
    params.CrossPercent = 50;   % Cross Breeding Percentage
    params.MutatPercent = 30;   % Mutatuon Percentage
    params.ElitPercent = 100 - params.CrossPercent - params.MutatPercent;   % Elite population Percentage
    params.CrossNum = round(params.CrossPercent/100*params.PopSize); 
    params.EarlyExit = 0;
    params.MutatNum = round(params.MutatPercent/100*params.PopSize);
    params.ElitNum = params.PopSize - params.CrossNum - params.MutatNum;
    for k=1:100
        [PGPHEA_out(study_case,k),it(k).progress]=PGPHEA(problem,params);
    end
    progress(study_case,:)=it;
end
