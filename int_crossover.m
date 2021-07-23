function xoverKids  = int_crossover(parents,options,GenomeLength,...
    FitnessFcn,~,thisPopulation)


%IntCon constraints
IntCon = 1:GenomeLength; 

% How many children to produce?
nKids = length(parents)/2;
% Allocate space for the kids
xoverKids = zeros(nKids,GenomeLength);
% To move through the parents twice as fast as the kids are
% being produced, a separate index for the parents is needed
index = 1;
% for each kid...
for i=1:nKids
    % get parents
    r1 = parents(index);
    index = index + 1;
    r2 = parents(index);
    index = index + 1;
%     alpha = rand;
%     xoverKids(i,:) = alpha*thisPopulation(r1,:) + ...
%         (1-alpha)*thisPopulation(r2,:);
%  single point crossover
    rng('shuffle');
    beta = randi(GenomeLength);
    for j = 1: GenomeLength
        if j <= beta
        xoverKids(i, j) = thisPopulation(r1,j);
        else
        xoverKids(i, j) = thisPopulation(r2,j);
        end
    end
    
    
end

x = rand;
if x>=0.5
    xoverKids(:, IntCon) = floor(xoverKids(:, IntCon));
else
    xoverKids(:, IntCon) = ceil(xoverKids(:, IntCon));
end

range = options.PopInitRange;
xoverKids = checkboundsIntGA(xoverKids, range);