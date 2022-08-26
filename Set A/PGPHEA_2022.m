function [GlobalBest,progress]=PGPHEA_2022(problem,params)    
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
    % Particle Templater
    empty_individual.Position = [];
    empty_individual.Velocity = [];
    empty_individual.Best.Position = [];
    empty_individual.Value = [];

    % Create Population Arrays
    individual = repmat(empty_individual, PopSize, 1);
    particle = repmat(empty_individual, nPop, 1);
    % Initialize Global Worst
    GAGlobalBest.Value = minimize*inf;
    PSOGlobalBest.Value = minimize*inf;
    GlobalBest.Value = minimize*inf;
    
    Xga = rand(PopSize,nVar);
    Xpso = rand(PopSize,nVar);
    time=cputime;
    % Initialize Population Members
    for i = 1 : PopSize
        individual(i).Position =Xga(i,:)*(VarMax-VarMin)+VarMin;
        
        % Evaluation
        individual(i).Value = problem.function(individual(i).Position);
        if minimize*individual(i).Value<minimize*GAGlobalBest.Value
            GAGlobalBest=individual(i);  
        end
    end
    
    for i=1:nPop
        particle(i) .Position = Xpso(i,:)*(VarMax-VarMin)+VarMin;
        particle(i).Value = problem.function(particle(i).Position);
        
        % Initialize Velocity
        particle(i).Velocity = zeros(1,nVar);

        % Update the Personal Worst
        particle(i).Best.Position = particle(i).Position;
        particle(i).Best.Value = particle(i).Value;
        
        if minimize*particle(i).Best.Value<minimize*PSOGlobalBest.Value
            PSOGlobalBest=particle(i).Best;
        end
    end
    
    if minimize*GAGlobalBest.Value<minimize*PSOGlobalBest.Value
        GlobalBest=GAGlobalBest;
    else
        GlobalBest=PSOGlobalBest;
    end
        
    %% Main Loop of algorythm
    interaction = 0;
    while interaction<MaxInteractions
        
        interaction = interaction + 1;
        
        if mod(interaction,100)==0
            transferindexes = randperm(PopSize,PopSize/2);
            for i=1:PopSize/2
                mem_ind=individual(transferindexes(i));
                individual(transferindexes(i)).Position=particle(transferindexes(i)).Position;
                individual(transferindexes(i)).Value=particle(transferindexes(i)).Value;              
                particle(transferindexes(i)).Position = mem_ind.Position;
                particle(transferindexes(i)).Value = mem_ind.Value;
            end
            
            for i=1:PopSize
                 particle(i).Best.Position = particle(i).Position;
                 particle(i).Best.Value =particle(i).Value;
                 particle(i).Velocity = particle(i).Velocity * 0;
               
                if minimize*particle(i).Best.Value<minimize*PSOGlobalBest.Value
                    PSOGlobalBest=particle(i).Best;
                end               
                if minimize*individual(i).Value<minimize*GAGlobalBest.Value
                    GAGlobalBest=individual(i);
                end                
            end
        end
        %% GA Main Loop
        
        [~, Index] = sort([individual(:).Value]);
        individual = individual(Index);
        new_individuals = repmat(empty_individual, PopSize, 1);

        for i = 1:ElitNum
            ParIndex = randperm(max(ElitNum,2),2);
            a = rand(1,params.randdim);
            
            new_individuals(i).Position = a.*individual(ParIndex(1)).Position + (1-a).*individual(ParIndex(2)).Position;           
        end
        
        %% Cross Over

        for i = 1:CrossNum
            ParIndex = randperm(PopSize,2);
            a = rand(1,params.randdim);
            new_individuals(ElitNum+i).Position = a.*individual(ParIndex(1)).Position + (1-a).*individual(ParIndex(2)).Position;
        end

        %% Mutation
        MutatIndex = randperm(PopSize,MutatNum);
        
        for i=1:MutatNum
            new_individuals(i+CrossNum+ElitNum).Position = individual(MutatIndex(i)).Position + (2*rand(1,params.randdim)-1)*(0.2)*(VarMax-VarMin);
        end
        
        individual = new_individuals;
        
        for i = 1 : PopSize
            individual(i).Position = max(individual(i).Position, VarMin);
            individual(i).Position = min(individual(i).Position, VarMax);
            % Evaluation
            individual(i).Value = problem.function(individual(i).Position);
            if minimize*individual(i).Value<minimize*GAGlobalBest.Value
                GAGlobalBest=individual(i);  
            end
        end
        %% Main Loop of PSO
       
        for i=1:nPop
            % Update Velocity
            particle(i).Velocity = w*particle(i).Velocity ...
                + c1*rand(1,params.randdim).*(particle(i).Best.Position - particle(i).Position) ...
                + c2*rand(1,params.randdim).*(PSOGlobalBest.Position - particle(i).Position);

            % Apply Velocity Limits
            particle(i).Velocity = max(particle(i).Velocity, MinVelocity);
            particle(i).Velocity = min(particle(i).Velocity, MaxVelocity);

            % Update Position
            particle(i).Position = particle(i).Position + particle(i).Velocity;
            
            particle(i).Position = max(particle(i).Position, VarMin);
            particle(i).Position = min(particle(i).Position, VarMax);

            particle(i).Value = problem.function(particle(i).Position);

            % Update Personal Best
            if minimize*particle(i).Value<minimize*particle(i).Best.Value
                particle(i).Best=particle(i);
                if minimize*particle(i).Best.Value<minimize*PSOGlobalBest.Value
                    PSOGlobalBest=particle(i).Best;    
                end
            end
                

            % Damping Inertia Coefficient
            w=params.w-(params.w-params.wmin)*interaction/MaxInteractions;    
        end
        
        if minimize*GAGlobalBest.Value<minimize*PSOGlobalBest.Value
            GlobalBest=GAGlobalBest;
        else
            GlobalBest=PSOGlobalBest;
        end
        progress(interaction,:) = [cputime-time GlobalBest.Value ];
    end
end

