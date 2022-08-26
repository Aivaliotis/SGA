function [GlobalBest,progress]=HPSOM_2022(problem,params)    
%% Problem Definiton
    nVar = problem.nVar;        % Number of Unknown (Decision) Variables    
    VarMin = problem.VarMin;      % Lower Bound of Decision Variables
    VarMax = problem.VarMax;      % Upper Bound of Decision Variables
    minimize = problem.minimize;
    
    %% Parameters of GA
    MaxInteractions = params.MaxInteractions;
    PopSize = params.PopSize;
    SelMethod = params.SelMethod;
    CrossMethod = params.CrossMethod;
    CrossNum = params.CrossNum; 
    MutatNum = params.MutatNum;
    ElitNum = params.ElitNum;

    %% Parameters of PSO
    MaxIt = params.MaxIt;   % Maximum Number of Iterations
    nPop = params.nPop;     % Population Size (Swarm Size)
    w = params.w;           % Intertia Coefficient
    wdamp = params.wdamp;   % Damping Ratio of Inertia Coefficient
    c1 = params.c1;         % Personal Acceleration Coefficient
    c2 = params.c2;         % Social Acceleration Coefficient
    
    % Limit Velocity
    MaxVelocity = params.VelCoe*(VarMax-VarMin);
    MinVelocity = -MaxVelocity;
    
    %% Initialization
    % Particle Template
    empty_individual.Position = [];
    empty_individual.Velocity = [];
    empty_individual.Best.Position = [];
    empty_individual.Value = [];

    % Create Population Arrays
    individual = repmat(empty_individual, PopSize, 1);
    particle = repmat(empty_individual, nPop, 1);
    % Initialize Global Worst
    GlobalBest.Value = minimize*inf;
    
    X = rand(PopSize,nVar);
    time=cputime;
    it = 0;
    count =0;
    
    for i=1:nPop
        particle(i).Position = X(i,:)*(VarMax-VarMin)+VarMin;
        
        % Evaluation
        particle(i).Value = problem.function(particle(i).Position);
        
         % Update Global Best
        if minimize*particle(i).Value < minimize*GlobalBest.Value
            GlobalBest = particle(i);
        end
        
        % Initialize Velocity
        particle(i).Velocity = zeros(1,nVar);

        % Update the Personal Worst
        particle(i).Best.Position = particle(i).Position;
        particle(i).Best.Value = particle(i).Value;
    end
    
    % Main PSO loop
   % MaxIt = ceil(MaxIt*(1-MutatNum/nPop));
    while it<MaxIt
        it = it+1;
        for i=1:nPop              
            % Update Velocity
            particle(i).Velocity = w*particle(i).Velocity ...
                + c1*rand(1,params.randdim).*(particle(i).Best.Position - particle(i).Position) ...
                + c2*rand(1,params.randdim).*(GlobalBest.Position - particle(i).Position);
            
            % Apply Velocity Limits
            particle(i).Velocity = max(particle(i).Velocity, MinVelocity);
            particle(i).Velocity = min(particle(i).Velocity, MaxVelocity);

            % Update Position
            particle(i).Position = particle(i).Position + particle(i).Velocity;

            % Apply Position Limits
            particle(i).Position = max(particle(i).Position, VarMin);
            particle(i).Position = min(particle(i).Position, VarMax);

            particle(i).Value = problem.function(particle(i).Position);

            % Update Personal Best
            if minimize*particle(i).Value < minimize*particle(i).Best.Value
                particle(i).Best = particle(i);

                % Update Global Best
                if minimize*particle(i).Value < minimize*GlobalBest.Value
                    GlobalBest = particle(i).Best;
                end 
            end
        end
        
        % Store the Best Value
        BestValue(it) = GlobalBest.Value;

        % Damping Inertia Coefficient
        w = params.w -(params.w-params.wmin)*it/MaxIt;
        MutatCandidates= randperm(PopSize,MutatNum);
        for kappa=1:MutatNum
            count = count+1;
            particle(MutatCandidates(kappa)).Position = particle(MutatCandidates(kappa)).Position + (2*rand(1,params.randdim)-1)*0.1*(VarMax-VarMin);
            particle(MutatCandidates(kappa)).Position = max(particle(MutatCandidates(kappa)).Position, VarMin);
            particle(MutatCandidates(kappa)).Position = min(particle(MutatCandidates(kappa)).Position, VarMax);

            particle(MutatCandidates(kappa)).Value = problem.function(particle(MutatCandidates(kappa)).Position);

            % Update Personal Best
            if minimize*particle(MutatCandidates(kappa)).Value < minimize*particle(MutatCandidates(kappa)).Best.Value
                particle(MutatCandidates(kappa)).Best = particle(MutatCandidates(kappa));

                % Update Global Best
                if minimize*particle(MutatCandidates(kappa)).Value < minimize*GlobalBest.Value
                    GlobalBest = particle(MutatCandidates(kappa)).Best;
                end 
            end
        end
%         if count>(nPop/MutatNum)
%            progress(it, :)= progress(it-1, :);
%            it = it+1;
%            count=0;
%         end
        progress(it, :) = [cputime-time GlobalBest.Value ];
        % Display Interaction Information
        if MaxInteractions==0&&params.ShowIterInfo
            disp(['Iteration :' num2str(it) ' Value  = ' num2str(BestValue(it))]);
        end

    end
end

