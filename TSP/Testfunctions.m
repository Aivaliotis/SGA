switch study_case
    
    case 8
        %u1060
        [problem.TSP_DisplayData, problem.TSP_EdgeWeight]=tsp_readlib('u1060');
        problem.nVar = size(problem.TSP_DisplayData,1);   % Number of Variables     
        problem.VarMin =  -100;    % Lower Bound of Decision Variables
        problem.VarMax =  100;    % Upper Bound of Decision Variables
        problem.minimize = 1;
        problem.function = @Custom_tsp_tsplib;  % Function of the Problem
    case 9
        %u1060
        [problem.TSP_DisplayData, problem.TSP_EdgeWeight]=tsp_readlib('u1432');
        problem.nVar = size(problem.TSP_DisplayData,1);   % Number of Variables     
        problem.VarMin =  -100;    % Lower Bound of Decision Variables
        problem.VarMax =  100;    % Upper Bound of Decision Variables
        problem.minimize = 1;
        problem.function = @Custom_tsp_tsplib;  % Function of the Problem
    case 7
        [problem.TSP_DisplayData, problem.TSP_EdgeWeight]=tsp_readlib('rat783');
        problem.nVar = size(problem.TSP_DisplayData,1);   % Number of Variables     
        problem.VarMin =  -100;    % Lower Bound of Decision Variables
        problem.VarMax =  100;    % Upper Bound of Decision Variables
        problem.minimize = 1;
        problem.function = @Custom_tsp_tsplib;  % Function of the Problem
    case 6
        [problem.TSP_DisplayData, problem.TSP_EdgeWeight]=tsp_readlib('d657');
        problem.nVar = size(problem.TSP_DisplayData,1);   % Number of Variables     
        problem.VarMin =  -100;    % Lower Bound of Decision Variables
        problem.VarMax =  100;    % Upper Bound of Decision Variables
        problem.minimize = 1;
        problem.function = @Custom_tsp_tsplib;  % Function of the Problem
    case 5
        [problem.TSP_DisplayData, problem.TSP_EdgeWeight]=tsp_readlib('rd400');
        problem.nVar = size(problem.TSP_DisplayData,1);   % Number of Variables     
        problem.VarMin =  -100;    % Lower Bound of Decision Variables
        problem.VarMax =  100;    % Upper Bound of Decision Variables
        problem.minimize = 1;
        problem.function = @Custom_tsp_tsplib;  % Function of the Problem
    case 4
        [problem.TSP_DisplayData, problem.TSP_EdgeWeight]=tsp_readlib('pr299');
        problem.nVar = size(problem.TSP_DisplayData,1);   % Number of Variables     
        problem.VarMin =  -100;    % Lower Bound of Decision Variables
        problem.VarMax =  100;    % Upper Bound of Decision Variables
        problem.minimize = 1;
        problem.function = @Custom_tsp_tsplib;  % Function of the Problem
    case 3
        [problem.TSP_DisplayData, problem.TSP_EdgeWeight]=tsp_readlib('kroA200');
        problem.nVar = size(problem.TSP_DisplayData,1);   % Number of Variables     
        problem.VarMin =  -100;    % Lower Bound of Decision Variables
        problem.VarMax =  100;    % Upper Bound of Decision Variables
        problem.minimize = 1;
        problem.function = @Custom_tsp_tsplib;  % Function of the Problem
     case 2
        [problem.TSP_DisplayData, problem.TSP_EdgeWeight]=tsp_readlib('kroA100');
        problem.nVar = size(problem.TSP_DisplayData,1);   % Number of Variables     
        problem.VarMin =  -100;    % Lower Bound of Decision Variables
        problem.VarMax =  100;    % Upper Bound of Decision Variables
        problem.minimize = 1;
        problem.function = @Custom_tsp_tsplib;  % Function of the Problem
    case 1
        [problem.TSP_DisplayData, problem.TSP_EdgeWeight]=tsp_readlib('berlin52');
        problem.nVar = size(problem.TSP_DisplayData,1);   % Number of Variables     
        problem.VarMin =  -1;    % Lower Bound of Decision Variables
        problem.VarMax =  1;     % Upper Bound of Decision Variables
        problem.minimize = 1;
        problem.function = @Custom_tsp_tsplib;  % Function of the Problem
end