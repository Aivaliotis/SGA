function [GlobalBest,progress]=HPSOM(problem,params)    
%% Problem Definiton
    nVar = problem.nVar;        % Number of Unknown (Decision) Variables    
    VarMin = problem.VarMin;      % Lower Bound of Decision Variables
    VarMax = problem.VarMax;      % Upper Bound of Decision Variables
    
    %% Parameters of GA
    MaxInteractions = params.MaxInteractions;
    PopSize = params.PopSize;
    SelMethod = params.SelMethod;
    MutatNum = params.MutatNum;
    
    %% Parameters of PSO
    MaxIt = params.MaxIt;   % Maximum Number of Iterations
    nPop = params.nPop;     % Population Size (Swarm Size)
    w = params.w;           % Intertia Coefficient
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
    minimize = problem.minimize;
    if minimize==1
        GlobalBest.Value = inf;
    else
        GlobalBest.Value = -inf;
    end
    
    X = rand(PopSize,nVar);
    time=cputime;
    
    % Initialize Population Members
    for i = 1 : PopSize
        individual(i).Position = X(i,:)*(VarMax-VarMin)+VarMin;
        [~,Index]=sort(individual(i).Position,'descend');
        
        % Evaluation
        individual(i).Value = problem.function(Index,problem.TSP_EdgeWeight);
        
         % Update Global Best
        if minimize*individual(i).Value < minimize*GlobalBest.Value
            GlobalBest = individual(i);
        end
    end
    
    % Select #nPop random particles from individuals
    ParticleIndexes = SelectParents(PopSize,nPop,SelMethod);
    it = 0;
    
    for i=1:nPop
        particle(i) = individual(ParticleIndexes(i));
        
        % Initialize Velocity
        particle(i).Velocity = zeros(1,nVar);

        % Update the Personal Worst
        particle(i).Best.Position = particle(i).Position;
        particle(i).Best.Value = particle(i).Value;
    end
    
    % Internal PSO
    while it<MaxIt
        it = it+1;
        for i=1:nPop              
            % Update Velocity
            particle(i).Velocity = w*particle(i).Velocity ...
                + c1*rand(1,nVar).*(particle(i).Best.Position - particle(i).Position) ...
                + c2*rand(1,nVar).*(GlobalBest.Position - particle(i).Position);
            
            % Apply Velocity Limits
            particle(i).Velocity = max(particle(i).Velocity, MinVelocity);
            particle(i).Velocity = min(particle(i).Velocity, MaxVelocity);

            % Update Position
            particle(i).Position = particle(i).Position + particle(i).Velocity;

            % Apply Position Limits
            particle(i).Position = max(particle(i).Position, VarMin);
            particle(i).Position = min(particle(i).Position, VarMax);
            [~,Index] = sort(particle(i).Position,'descend');
            
            particle(i).Value = problem.function(Index,problem.TSP_EdgeWeight);

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

        % Damping Inertia Coefficient
        w = params.w - (params.w-params.wmin)*it/2000;
        MutatCandidates= SelectParents(PopSize,MutatNum,SelMethod);
        %
        for kappa=1:MutatNum
            mutPoint=sort(randperm(nVar,2),'ascend');
            temp=particle(MutatCandidates(kappa)).Position(mutPoint(1));
            particle(MutatCandidates(kappa)).Position = particle(MutatCandidates(kappa)).Position;
            particle(MutatCandidates(kappa)).Position(mutPoint(1))= particle(MutatCandidates(kappa)).Position(mutPoint(2));
            particle(MutatCandidates(kappa)).Position(mutPoint(2))= temp;
            particle(MutatCandidates(kappa)).Velocity= zeros(1,nVar);
            [~,Index]=sort(particle(MutatCandidates(kappa)).Position,'descend');
            particle(MutatCandidates(kappa)).Value = problem.function(Index,problem.TSP_EdgeWeight);
            it=it+1/nPop;
            % Update Personal Best
            if minimize*particle(MutatCandidates(kappa)).Value < minimize*particle(MutatCandidates(kappa)).Best.Value
                particle(MutatCandidates(kappa)).Best = particle(MutatCandidates(kappa));

                % Update Global Best
                if minimize*particle(MutatCandidates(kappa)).Value < minimize*GlobalBest.Value
                    GlobalBest = particle(MutatCandidates(kappa)).Best;
                end 
            end
        end
        %}
        BestValue(round(it)) = GlobalBest.Value;
        % Display Interaction Information
        progress(round(it),2)=BestValue(round(it));
        progress(round(it),1)=cputime-time;
        if MaxInteractions==0&&params.ShowIterInfo
            disp(['Iteration :' num2str(round(it)) ' Value  = ' num2str(BestValue(round(it)))]);
        end

    end
end

