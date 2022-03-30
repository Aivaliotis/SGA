switch study_case
    case 1
        %Rosenbrock
        problem.nVar = 30;   % Number of Variables     
        problem.VarMin =  [-100];    % Lower Bound of Decision Variables
        problem.VarMax =  [100];    % Upper Bound of Decision Variables
        problem.minimize = 1;
        problem.function = @f1;  % Function of the Problem
    case 2
        %Griewank
        problem.nVar = 30;   % Number of Variables     
        problem.VarMin =  [-600];    % Lower Bound of Decision Variables
        problem.VarMax =  [600];    % Upper Bound of Decision Variables
        problem.minimize = 1;
        problem.function = @f2;  % Function of the Problem
    case 3
        %Rastrigin
        problem.nVar = 30;   % Number of Variables     
        problem.VarMin =  [-10];    % Lower Bound of Decision Variables
        problem.VarMax =  [10];    % Upper Bound of Decision Variables
        problem.minimize = 1;
        problem.function = @f3;  % Function of the Problem
    case 4
        %Ackley
        problem.nVar = 30;   % Number of Variables     
        problem.VarMin =  [-32.768];    % Lower Bound of Decision Variables
        problem.VarMax =  [32.768];    % Upper Bound of Decision Variables
        problem.minimize = 1;
        problem.function = @f4;  % Function of the Problem
    case 5
        %fmin=~1
        problem.nVar = 2;   % Number of Variables     
        problem.VarMin =  [-65.536];    % Lower Bound of Decision Variables
        problem.VarMax =  [65.536];    % Upper Bound of Decision Variables
        problem.minimize = 1;
        problem.function = @f5;  % Function of the Problem
    case 6
        %fmin=-3.32
        problem.nVar = 6;   % Number of Variables     
        problem.VarMin =  [0];    % Lower Bound of Decision Variables
        problem.VarMax =  [1];    % Upper Bound of Decision Variables
        problem.minimize = 1;
        problem.function = @f6;  % Function of the Problem
    case 7
        problem.nVar=3;
        problem.VarMin =  [-50];    % Lower Bound of Decision Variables
        problem.VarMax =  [50];    % Upper Bound of Decision Variables
        problem.minimize = -1;
        problem.function = @f7;  % Function of the Problem
    case 8
        problem.nVar=2;
        problem.VarMin =  [-50];    % Lower Bound of Decision Variables
        problem.VarMax =  [50];    % Upper Bound of Decision Variables
        problem.minimize = -1;
        problem.function = @f8;  % Function of the Problem
    case 9
        problem.nVar = 30;   % Number of Variables     
        problem.VarMin =  [-100];    % Lower Bound of Decision Variables
        problem.VarMax =  [100];    % Upper Bound of Decision Variables
        problem.minimize = 1;
        problem.function = @f9;  % Function of the Problem
    case 10
        %LANGERMANN FUNCTION length(x)=2; x?[0,10]
        problem.nVar = 2;   % Number of Variables     
        problem.VarMin =  0;    % Lower Bound of Decision Variables
        problem.VarMax =  10;    % Upper Bound of Decision Variables
        problem.minimize = 1;
        problem.function = @f10;  % Function of the Problem
    case 11
        %EGGHOLDER FUNCTION d=2 [-512, 512]
        problem.nVar = 2;   % Number of Variables     
        problem.VarMin =  -512;    % Lower Bound of Decision Variables
        problem.VarMax =  512;    % Upper Bound of Decision Variables
        problem.minimize = 1;
        problem.function = @f11;  % Function of the Problem
    case 12
        %EASOM FUNCTION d=2 [-100, 100]
        problem.nVar = 2;   % Number of Variables     
        problem.VarMin =  -100;    % Lower Bound of Decision Variables
        problem.VarMax =  100;    % Upper Bound of Decision Variables
        problem.minimize = 1;
        problem.function = @f12;  % Function of the Problem
    case 13
        %SHUBERT FUNCTION d=2 [-10, 10]
        problem.nVar = 2;   % Number of Variables     
        problem.VarMin =  -10;    % Lower Bound of Decision Variables
        problem.VarMax =  10;    % Upper Bound of Decision Variables
        problem.minimize = 1;
        problem.function = @f13;  % Function of the Problem
    case 14
        %SCHWEFEL FUNCTION d=n  [-500, 500]
        problem.nVar = 20;   % Number of Variables     
        problem.VarMin =  -500;    % Lower Bound of Decision Variables
        problem.VarMax =  500;    % Upper Bound of Decision Variables
        problem.minimize = 1;
        problem.function = @f14;  % Function of the Problem
end