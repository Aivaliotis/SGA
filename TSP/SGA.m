function [GlobalBest,progress]=SGA(problem,params)    
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
    MaxVelocity = 0.5*(VarMax-VarMin);
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
    
    X = rand(nPop+PopSize,nVar);
    
    time=cputime;
    % Initialize Population Members
    for i = 1 : PopSize
        individual(i).Position = X(i,:)*(VarMax-VarMin)+VarMin;
        individual(i).Velocity = zeros(1,nVar);
        [~,Index]=sort(individual(i).Position,'descend');
        % Evaluation
        individual(i).Value = problem.function(Index,problem.TSP_EdgeWeight);
        
        individual(i).Best.Position = individual(i).Position;
        individual(i).Best.Value = individual(i).Value;
         % Update Global Best
        if minimize*individual(i).Value<minimize*GlobalBest.Value
            GlobalBest = individual(i);
        end
    end
    
    % Select #nPop random particles from individuals
    ParticleIndexes = SelectParents(PopSize,nPop,SelMethod);
    it = 0;
    GB.Value = minimize*inf;   
    GAstep=-1;
    interaction=0;
    while interaction<MaxInteractions
        interaction = interaction + 1;

        [~, Index]= sort(minimize*[individual(:).Value]);
        
        individual = individual(Index);
        new_individuals = repmat(empty_individual, PopSize, 1);
                
        for i = 1:ElitNum
            ParIndex = randperm(ElitNum,2);
            a = rand(1);
            [~,Index1]=sort(individual(ParIndex(1)).Position,'descend');
            [~,Index2]=sort(individual(ParIndex(2)).Position,'descend'); 
            
            %new_individuals(i).Position = a.*individual(ParIndex(1)).Position + (1-a).*individual(ParIndex(2)).Position;
            new_individuals(i).Velocity= 0*(a.*individual(ParIndex(1)).Velocity + (1-a).*individual(ParIndex(2)).Velocity);
            Index=unique([Index1(1:round(a)*nVar) Index2],'stable');
            %new_individuals(i).Position=[individual(ParIndex(1)).Position(Index(1:round(a)*nVar)) individual(ParIndex(2)).Position(Index(round(a)*nVar+1:nVar))];
            new_individuals(i).Position(Index)=sort(individual(ParIndex(1)).Position,'descend');
            
              
            
            new_individuals(i).Best.Position = new_individuals(i).Position;
            new_individuals(i).Best.Value = minimize*inf; 
            
            %
            if minimize*individual(ParIndex(1)).Best.Value<minimize*individual(ParIndex(2)).Best.Value
                new_individuals(i).Best.Position = individual(ParIndex(1)).Best.Position;
                new_individuals(i).Best.Value = individual(ParIndex(1)).Best.Value;
            else
                new_individuals(i).Best.Position = individual(ParIndex(2)).Best.Position;
                new_individuals(i).Best.Value = individual(ParIndex(2)).Best.Value; 
            end
            %}
        end
        
        %% Cross Over     
        for i = 1:CrossNum
            ParIndex = randperm(PopSize,2);
            a = rand(1);
            [~,Index1]=sort(individual(ParIndex(1)).Position,'descend');
            [~,Index2]=sort(individual(ParIndex(2)).Position,'descend'); 
            Index=unique([Index1(1:round(a)*nVar) Index2],'stable');
            %new_individuals(i+ElitNum).Position = individual(ParIndex(1)).Position;
            %new_individuals(i+ElitNum).Position=[individual(ParIndex(1)).Position(Index(1:round(a)*nVar)) individual(ParIndex(2)).Position(Index(round(a)*nVar+1:nVar))];
            new_individuals(i+ElitNum).Position(Index)=sort(individual(ParIndex(1)).Position,'descend');
            
            
            %new_individuals(i+ElitNum).Position = a.*individual(ParIndex(1)).Position + (1-a).*individual(ParIndex(2)).Position;
            new_individuals(i+ElitNum).Velocity= 0*(a.*individual(ParIndex(1)).Velocity + (1-a).*individual(ParIndex(2)).Velocity);
            
            %new_individuals(i+ElitNum).Position=[individual(ParIndex(1)).Position(Index(1:round(a)*nVar)) individual(ParIndex(2)).Position(Index(round(a)*nVar+1:nVar))];
            %new_individuals(i+ElitNum).Position(Index)=sort(individual(ParIndex(1)).Position,'ascend');
            
            new_individuals(i+ElitNum).Best.Position = new_individuals(i+ElitNum).Position;
            new_individuals(i+ElitNum).Best.Value = minimize*inf;
            
            %
            if minimize*individual(ParIndex(1)).Best.Value<minimize*individual(ParIndex(2)).Best.Value
                new_individuals(i+ElitNum).Best.Position = individual(ParIndex(1)).Best.Position;
                new_individuals(i+ElitNum).Best.Value = individual(ParIndex(1)).Best.Value;
            else
                new_individuals(i+ElitNum).Best.Position = individual(ParIndex(2)).Best.Position;
                new_individuals(i+ElitNum).Best.Value = individual(ParIndex(2)).Best.Value; 
            end
            %}
        end

        %% Mutation
        MutatIndex = SelectParents(MutatNum,MutatNum,SelMethod);
        
        for i=1:MutatNum
            mutPoint=sort(randperm(nVar,2),'ascend');
            temp=individual(MutatIndex(i)).Position(mutPoint(1));
            new_individuals(i+CrossNum+ElitNum).Position = individual(MutatIndex(i)).Position;
            new_individuals(i+CrossNum+ElitNum).Position(mutPoint(1))= new_individuals(i+CrossNum+ElitNum).Position(mutPoint(2));
            new_individuals(i+CrossNum+ElitNum).Position(mutPoint(2))= temp;
            %new_individuals(i+CrossNum+ElitNum).Position = [individual(MutatIndex(i)).Position(1:mutPoint(1)) individual(MutatIndex(i)).Position(mutPoint(2):nVar) individual(MutatIndex(i)).Position(mutPoint(1)+1:mutPoint(2)-1)];
            %new_individuals(i+CrossNum+ElitNum).Position = -individual(MutatIndex(i)).Position+(2*rand(1,nVar)-1)*0.2*(VarMax-VarMin);
            new_individuals(i+CrossNum+ElitNum).Velocity= 0*ones(1,nVar)*MinVelocity+rand(1,nVar)*(MaxVelocity-MinVelocity);
            new_individuals(i+CrossNum+ElitNum).Best.Position = new_individuals(i+CrossNum+ElitNum).Position;%individual(MutatIndex(i)).Best.Position;
            new_individuals(i+CrossNum+ElitNum).Best.Value = minimize*inf;%individual(MutatIndex(i)).Best.Value; 
        end
       
        %% New Population
        if (CrossNum+ElitNum+MutatNum)==PopSize
            individual = new_individuals;
        end
        
        % Apply Circle Restrains
        for i=1:PopSize
            individual(i).Position =max(individual(i).Position,VarMin);
            individual(i).Position =min(individual(i).Position,VarMax);
            [~,Index]=sort(individual(i).Position,'descend');
        
            % Evaluation
            individual(i).Value = problem.function(Index,problem.TSP_EdgeWeight);
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
        ParticleIndexes = SelectParents((PopSize),nPop,SelMethod);
        if mod(GAstep,params.GAstep)==0
            GB.Value = minimize*inf;
            %GB=GlobalBest;
            for i=1:nPop
                if minimize*individual(ParticleIndexes(i)).Value<minimize*GB.Value
                    GB.Value = individual(ParticleIndexes(i)).Value;
                    GB.Position = individual(ParticleIndexes(i)).Position;
                end
            end
        while it<MaxIt
            GAstep=0;
            it=it+1;
            best_value(it)=minimize*inf;
            for i=1:nPop
                % Update Velocity
                individual(ParticleIndexes(i)).Velocity = w*individual(ParticleIndexes(i)).Velocity ...
                    + c1*rand(1).*(individual(ParticleIndexes(i)).Best.Position - individual(ParticleIndexes(i)).Position) ...
                    + c2*rand(1).*(GB.Position - individual(ParticleIndexes(i)).Position);
                
                % Apply Velocity Limits
                individual(ParticleIndexes(i)).Velocity = max(individual(ParticleIndexes(i)).Velocity, MinVelocity);
                individual(ParticleIndexes(i)).Velocity = min(individual(ParticleIndexes(i)).Velocity, MaxVelocity);
                
                % Update Position
                individual(ParticleIndexes(i)).Position = individual(ParticleIndexes(i)).Position + individual(ParticleIndexes(i)).Velocity;
                
                individual(ParticleIndexes(i)).Position = max(individual(ParticleIndexes(i)).Position, VarMin);
                individual(ParticleIndexes(i)).Position = min(individual(ParticleIndexes(i)).Position, VarMax);
                [~,Index]=sort(individual(ParticleIndexes(i)).Position,'descend');
        
                individual(ParticleIndexes(i)).Value = problem.function(Index,problem.TSP_EdgeWeight);

                %individual(ParticleIndexes(i)).Value = problem.function(individual(ParticleIndexes(i)).Position,problem.TSP_EdgeWeight);
                if minimize*individual(ParticleIndexes(i)).Value<minimize*best_value(it)
                    best_value(it)=individual(ParticleIndexes(i)).Value;
                end
                if minimize*individual(ParticleIndexes(i)).Value<minimize*GB.Value
                    GB.Value = individual(ParticleIndexes(i)).Value;
                    GB.Position = individual(ParticleIndexes(i)).Position;
                end
                % Update Personal Best
                if minimize*individual(ParticleIndexes(i)).Value<minimize*individual(ParticleIndexes(i)).Best.Value
                    individual(ParticleIndexes(i)).Best = individual(ParticleIndexes(i));

                    % Update Global Best
                    if minimize*individual(ParticleIndexes(i)).Best.Value<minimize*GlobalBest.Value
                        GlobalBest = individual(ParticleIndexes(i)).Best;
                    end 
                end  
            end

            % Store the Worst FS Value
            BestValue(it) = GlobalBest.Value;
            
            % Damping Inertia Coefficient
            w=params.w-(params.w-params.wmin)*it/MaxIt;
            if it>1&&(floor(it*nPop/PopSize)~=floor((it-1)*nPop/PopSize))
               %w = params.w -(params.w-params.wmin)*(floor(interaction+(it*nPop/PopSize)))/MaxInteractions;
            end
            if params.ShowIterInfo&&(floor(it*nPop/PopSize)~=floor((it-1)*nPop/PopSize))%(floor(it*nPop/PopSize)~=floor((it-1)*nPop/PopSize))%params.ShowIterInfo&&(floor(it*nPop/PopSize)~=floor((it-1)*nPop/PopSize))
                disp(['Iteration :' num2str(floor(interaction+it*nPop/PopSize)) ' Value  = ' num2str(GlobalBest.Value) ' Best_value_it = ' num2str(best_value(it)) ' w = ' num2str(w)]);
                %disp(['Iteration :' num2str(interaction+floor(it*nPop/PopSize)) ' Value  = ' num2str(GlobalBest.Value) ]);
            end
            progress(floor(interaction+(it*nPop/PopSize)),2)=GlobalBest.Value;
            progress(floor(interaction+(it*nPop/PopSize)),1)=cputime-time;
            if floor(interaction+(it*nPop/PopSize))>params.MaxInteractions
                it=MaxIt;
            end
        end
        end
        interaction= interaction+(it*nPop/PopSize);
        progress(floor(interaction),2)=GlobalBest.Value;
        progress(floor(interaction),1)=cputime-time;
       
        if 0%params.ShowIterInfo
            disp(['Iteration :' num2str(floor(interaction)) ' Value  = ' num2str(GlobalBest.Value)]);
        end
        
    end
end

