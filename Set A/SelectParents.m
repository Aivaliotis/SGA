function ParIndexes = SelectParents(PopSize,SelectionNum,SelMethod)

switch SelMethod
    case 1
        R = randperm(PopSize); 
        ParIndexes = R(1:SelectionNum);
end
end