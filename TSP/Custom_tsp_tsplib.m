function out=Custom_tsp_tsplib(route,TSP_EdgeWeight)
    n=length(route);
    Index=route;
    out=TSP_EdgeWeight(Index(end),Index(1));
    for i=1:n-1
        out=out+TSP_EdgeWeight(Index(i),Index(i+1));
    end
end