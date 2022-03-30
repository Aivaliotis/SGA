function [GlobalBest, progress]=SGA_2022(problem,params)    
%% Problem Definiton
    nVar = problem.nVar;        % Number of Unknown (Decision) Variables    
    VarMin = problem.VarMin;      % Lower Bound of Decision Variables
    VarMax = problem.VarMax;      % Upper Bound of Decision Variables
    
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
    minimize=problem.minimize;
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
   
    % Initialize Global Worst
    GlobalBest.Value = minimize*inf;
    
    X = rand(PopSize,nVar);
    time=cputime;
    % Initialize Population Members
    for i = 1 : PopSize
        individual(i).Position = X(i,:)*(VarMax-VarMin)+VarMin;
       individual(i).Velocity = zeros(1,nVar);
        
        % Evaluation
        individual(i).Value = problem.function(individual(i).Position);
        
        individual(i).Best.Position = individual(i).Position;
        individual(i).Best.Value = individual(i).Value;
         % Update Global Best
        if minimize*individual(i).Value<minimize*GlobalBest.Value
            GlobalBest = individual(i);
        end
    end
    
    %% Main Loop of algorythm
    interaction=0;
    GAstep=-1;
    while interaction<MaxInteractions
        interaction = interaction + 1;

        [~, Index]= sort(minimize*[individual(:).Value]);
        individual = individual(Index);
        new_individuals = repmat(empty_individual, PopSize, 1);
                
        for i = 1:ElitNum
            ParIndex = randperm(ElitNum,2);
            a = rand(1,params.randdim);
            
            new_individuals(i).Position = a.*individual(ParIndex(1)).Position + (1-a).*individual(ParIndex(2)).Position;
            new_individuals(i).Velocity= zeros(1,nVar);
            
            new_individuals(i).Best.Position = new_individuals(i).Position;
            new_individuals(i).Best.Value = minimize*inf; 
            
        end
        
        %% Cross Over     
        for i = 1:CrossNum
            ParIndex = randperm(PopSize,2);
            a = rand(1,params.randdim);
            new_individuals(i+ElitNum).Position = a.*individual(ParIndex(1)).Position + (1-a).*individual(ParIndex(2)).Position;
            new_individuals(i+ElitNum).Velocity= zeros(1,nVar);
            
            new_individuals(i+ElitNum).Best.Position = new_individuals(i+ElitNum).Position;
            new_individuals(i+ElitNum).Best.Value = minimize*inf;
        end

        %% Mutation
        MutatIndex = SelectParents(PopSize,MutatNum,SelMethod);
        
        for i=1:MutatNum
            new_individuals(i+CrossNum+ElitNum).Position = individual(MutatIndex(i)).Position + (2*rand(1,params.randdim)-1)*(0.2)*(VarMax-VarMin);
            new_individuals(i+CrossNum+ElitNum).Velocity= zeros(1,nVar);
            new_individuals(i+CrossNum+ElitNum).Best.Position = new_individuals(i+CrossNum+ElitNum).Position;
            new_individuals(i+CrossNum+ElitNum).Best.Value = minimize*inf;
        end
       
        %% New Population
       individual = new_individuals;
        
        % Apply Circle Restrains
        for i=1:PopSize
            individual(i).Position =max(individual(i).Position,VarMin);
            individual(i).Position =min(individual(i).Position,VarMax);
                        
            % Evaluation
            individual(i).Value = problem.function(individual(i).Position);

            % Update the Personal Worst   
            if minimize*individual(i).Value<minimize*individual(i).Best.Value
                individual(i).Best.Value=individual(i).Value;
                individual(i).Best.Position=individual(i).Position;
                if minimize*individual(i).Value<minimize*GlobalBest.Value
                    GlobalBest = individual(i);
                end
            end
        end
        Best_Value_inter(floor(interaction))=GlobalBest.Value;
        
    %% Internal PSO
        GAstep=GAstep+1;
        %% Main Loop of PSO
        it = 0;
        % Select #nPop random particles from individuals
        if mod(GAstep,params.GAstep)==0
            ParticleIndexes = SelectParents((PopSize),nPop,SelMethod);
            GB.Value = minimize*inf;
            for i=1:nPop
                if minimize*individual(ParticleIndexes(i)).Value<minimize*GB.Value
                    GB.Value = individual(ParticleIndexes(i)).Value;
                    GB.Position = individual(ParticleIndexes(i)).Position;
                end
            end
            
        while it<MaxIt
            it=it+1;
            for i=1:nPop
                % Update Velocity
                individual(ParticleIndexes(i)).Velocity = w*individual(ParticleIndexes(i)).Velocity ...
                    + c1*rand(1,params.randdim).*(individual(ParticleIndexes(i)).Best.Position - individual(ParticleIndexes(i)).Position) ...
                    + c2*rand(1,params.randdim).*(GB.Position - individual(ParticleIndexes(i)).Position);
                
                % Apply Velocity Limits
                individual(ParticleIndexes(i)).Velocity = max(individual(ParticleIndexes(i)).Velocity, MinVelocity);
                individual(ParticleIndexes(i)).Velocity = min(individual(ParticleIndexes(i)).Velocity, MaxVelocity);
                
                % Update Position
                individual(ParticleIndexes(i)).Position = individual(ParticleIndexes(i)).Position + individual(ParticleIndexes(i)).Velocity;
                
                individual(ParticleIndexes(i)).Position = max(individual(ParticleIndexes(i)).Position, VarMin);
                individual(ParticleIndexes(i)).Position = min(individual(ParticleIndexes(i)).Position, VarMax);

                individual(ParticleIndexes(i)).Value = problem.function(individual(ParticleIndexes(i)).Position);

                % Update Personal Best
                if minimize*individual(ParticleIndexes(i)).Value<minimize*individual(ParticleIndexes(i)).Best.Value
                    individual(ParticleIndexes(i)).Best = individual(ParticleIndexes(i));

                    % Update Global Best
                    if minimize*individual(ParticleIndexes(i)).Value<minimize*GB.Value
                        GB.Value = individual(ParticleIndexes(i)).Value;
                        GB.Position = individual(ParticleIndexes(i)).Position;
                    end
                end  
            end
            
            if minimize*GB.Value<minimize*GlobalBest.Value
                GlobalBest = GB;
            end
            % Damping Inertia Coefficient
            w=params.w-(params.w-params.wmin)*it/MaxIt;
            if MaxInteractions>1
                progress(floor(interaction+(it*nPop/PopSize)),:) = [cputime-time GlobalBest.Value];
            else
                progress(it,:) = [cputime-time GlobalBest.Value];
            end
        end
        end
        interaction = interaction+(it*nPop/PopSize);
        progress(floor(interaction),2)=GlobalBest.Value;
        progress(floor(interaction),1)=cputime-time;
        
    end
end

