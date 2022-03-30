function [GlobalBest,progress]=PGPHEA(problem,params)    
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
    %wdamp = params.wdamp;   % Damping Ratio of Inertia Coefficient
    c1 = params.c1;         % Personal Acceleration Coefficient
    c2 = params.c2;         % Social Acceleration Coefficient
    
    % Limit Velocity
    MaxVelocity = 1*(VarMax-VarMin);
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
    if minimize==1
        GAGlobalBest.Value = inf;
        PSOGlobalBest.Value = inf;
    else
        GAGlobalBest.Value = -inf;
        PSOGlobalBest.Value = -inf;
    end
    GB.Value = minimize*inf;
    time=cputime;
    
    X = rand(nPop+PopSize,nVar);
    
    % Initialize Population Members
    for i = 1 : PopSize
        individual(i).Position = randperm(nVar);
        % Evaluation
        individual(i).Value = problem.function(individual(i).Position,problem.TSP_EdgeWeight);
        if minimize*individual(i).Value<minimize*GAGlobalBest.Value
            GAGlobalBest=individual(i);  
        end
    end
    
    for i=1:nPop
        particle(i) .Position = X(i+PopSize,:)*(VarMax-VarMin)+VarMin;
        [~,Index]=sort(particle(i) .Position,'descend');
        particle(i).Value = problem.function(Index,problem.TSP_EdgeWeight);
        
        % Initialize Velocity
        particle(i).Velocity = zeros(1,nVar);

        % Update the Personal Worst
        particle(i).Best.Position = particle(i).Position;
        particle(i).Best.Value = particle(i).Value;
        
        if minimize*particle(i).Best.Value<minimize*PSOGlobalBest.Value
            PSOGlobalBest=particle(i).Best;
        end
        if minimize*particle(i).Best.Value<minimize*GB.Value
            GB=particle(i).Best;
        end
    end
    
    %% Main Loop of algorythm
    interaction = 0;
    while interaction<MaxInteractions
        interaction = interaction + 1;
        if mod(interaction,1)==0
            GB.Value = minimize*inf;
            transferindexes=randperm(PopSize,PopSize/2);
            for i=1:PopSize/2
                mem_ind=individual(transferindexes(i));
                [~,individual(transferindexes(i)).Position]=sort(particle(transferindexes(i)).Position,'descend');
                individual(transferindexes(i)).Value=particle(transferindexes(i)).Value;
                if minimize*individual(transferindexes(i)).Value<minimize*GAGlobalBest.Value
                    GAGlobalBest=individual(transferindexes(i));
                end
                particle(transferindexes(i)).Position(mem_ind.Position)= sort(particle(transferindexes(i)).Position,'descend');
                particle(transferindexes(i)).Value = mem_ind.Value;
                particle(transferindexes(i)).Velocity = particle(transferindexes(i)).Velocity*0;
                if minimize*particle(transferindexes(i)).Value<minimize*particle(transferindexes(i)).Best.Value
                    particle(transferindexes(i)).Best=particle(transferindexes(i));
                    if minimize*particle(transferindexes(i)).Best.Value<minimize*PSOGlobalBest.Value
                        PSOGlobalBest=particle(transferindexes(i)).Best;    
                    end
                end
                if minimize*particle(transferindexes(i)).Best.Value<minimize*GB.Value
                    GB=particle(transferindexes(i)).Best;
                end
            end
        end
        %% Main Loop
        [~, tIndex]= sort(minimize*[individual(:).Value]);
        
        individual = individual(tIndex);
        new_individuals = repmat(empty_individual, PopSize, 1);

        for i = 1:ElitNum
            ParIndex = randperm(max(ElitNum,2),2);
            
            crossoverpoint=ceil((nVar-1)*rand);
            a = rand(1);
            if a>0.5
                par=unique([individual(ParIndex(1)).Position(1:crossoverpoint) individual(ParIndex(2)).Position(:)'],'stable');
            else
                par=unique([individual(ParIndex(2)).Position(1:crossoverpoint) individual(ParIndex(1)).Position(:)'],'stable');
            end
            
            new_individuals(i).Position = par;
            new_individuals(i).Velocity= zeros(1,nVar);
            new_individuals(i).Value = minimize*inf;
            
        end

        %% Cross Over     
        for i = 1:CrossNum
            ParIndex = randperm(PopSize,2);
            
            crossoverpoint=ceil((nVar-1)*rand);
            a = rand(1);
            if a>0.5
                par=unique([individual(ParIndex(1)).Position(1:crossoverpoint) individual(ParIndex(2)).Position(:)'],'stable');
            else
                par=unique([individual(ParIndex(2)).Position(1:crossoverpoint) individual(ParIndex(1)).Position(:)'],'stable');
            end
            
            new_individuals(i+ElitNum).Position = par;
            new_individuals(i+ElitNum).Value = minimize*inf;
            
        end

        %% Mutation
        MutatIndex = SelectParents(PopSize,MutatNum,SelMethod);
        
        for i=1:MutatNum
            k=1;round(rand(1)*0.1*nVar);
            mutationPoint1=randperm(nVar,k);
            mutationPoint2=randperm(nVar,k);
            while size(unique([mutationPoint1 mutationPoint2]),2)~=size([mutationPoint1 mutationPoint2],2)
                mutationPoint2=randperm(nVar,k);
            end
            new_individuals(i+CrossNum+ElitNum).Position=individual(MutatIndex(i)).Position;
            temp = new_individuals(i+CrossNum+ElitNum).Position(mutationPoint1);
            new_individuals(i+CrossNum+ElitNum).Position(mutationPoint1) = new_individuals(i+CrossNum+ElitNum).Position(mutationPoint2);
            new_individuals(i+CrossNum+ElitNum).Position(mutationPoint2) = temp;
            new_individuals(i+CrossNum+ElitNum).Velocity= 0*ones(1,nVar)*MinVelocity+(i+ElitNum)*(MaxVelocity-MinVelocity);
            new_individuals(i+CrossNum+ElitNum).Best.Position = new_individuals(i+CrossNum+ElitNum).Position;
            new_individuals(i+CrossNum+ElitNum).Best.Value = minimize*inf;
            new_individuals(i+CrossNum+ElitNum).Value = minimize*inf;
        end

        %% New Population
        individual = new_individuals;        
        for i=1:PopSize
            
            % Evaluation
            individual(i).Value = problem.function(individual(i).Position,problem.TSP_EdgeWeight);
            
            if minimize*individual(i).Value<minimize*GAGlobalBest.Value
                GAGlobalBest=individual(i);  
            end
            
        end
        
        %% Main Loop of PSO       
        for i=1:nPop
            % Update Velocity
            particle(i).Velocity = w*particle(i).Velocity ...
                + c1*rand(1).*(particle(i).Best.Position - particle(i).Position) ...
                + c2*rand(1).*(GB.Position - particle(i).Position);

            % Apply Velocity Limits
            particle(i).Velocity = max(particle(i).Velocity, MinVelocity);
            particle(i).Velocity = min(particle(i).Velocity, MaxVelocity);

            % Update Position
            particle(i).Position = particle(i).Position + particle(i).Velocity;
            particle(i).Position = max(particle(i).Position, VarMin);
            particle(i).Position = min(particle(i).Position, VarMax);
            [~,Index]=sort(particle(i).Position,'descend');
            particle(i).Value = problem.function(Index,problem.TSP_EdgeWeight);

            % Update Personal Best
            if minimize*particle(i).Value<minimize*particle(i).Best.Value
                particle(i).Best=particle(i);
                if minimize*particle(i).Best.Value<minimize*PSOGlobalBest.Value
                    PSOGlobalBest=particle(i).Best;    
                end
                if minimize*particle(i).Best.Value<minimize*GB.Value
                    GB=particle(i).Best;
                end
            end
                
            % Store the Worst FS Value
            if minimize==1
                BestValue(interaction) = min(GAGlobalBest.Value,PSOGlobalBest.Value);
            else
                BestValue(interaction) = max(GAGlobalBest.Value,PSOGlobalBest.Value);
            end
            % Damping Inertia Coefficient
            w = params.w -(params.w-params.wmin)*interaction/2000;     
        end
        progress(interaction,2)=BestValue(interaction);
        progress(interaction,1)=cputime-time;
        if params.ShowIterInfo
            disp(['Iteration :' num2str(interaction) ' Value  = ' num2str(BestValue(interaction))]);
        end
    end
    if minimize*GAGlobalBest.Value<minimize*PSOGlobalBest.Value
        GlobalBest=GAGlobalBest;
    else
        GlobalBest=PSOGlobalBest;
    end
end

