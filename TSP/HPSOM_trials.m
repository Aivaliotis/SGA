for study_case=(1:9)
    rng('default')
    disp(['HPSOM Case: ' num2str(study_case)])
    Testfunctions
    params.ShowIterInfo = 0; % Flag for Showing Iteration Information
    params.SelMethod = 1;       % Breeding Method
    params.CrossMethod = 1;     % Cross Breeding Method
    params.MaxIt = 2000;           % Maximum PSO Interactions
    params.nPop = 20;             % Particle Population Size (Swarm Size) / (Choose 0 for pure GA)
    params.PopSize = params.nPop;          
    params.w = 1;               % Intertia Coefficient
    params.wmin = 0.01;
    params.c1 = 2;              % Personal Acceleration Coefficient
    params.c2 = 2;              % Social Acceleration Coefficient
    params.SelMethod = 1;       % Breeding Method
    params.CrossMethod = 1;     % Cross Breeding Method
    params.MutatPercent = 40;   % Mutatuon Percentage
    params.MutatNum = round(params.MutatPercent/100*params.PopSize);
    for k=1:100
        [HPSOM_out(study_case,k),it(k).progress]=HPSOM(problem,params);
    end
    progress(study_case,:)=it;
end

